#!/usr/bin/env zx

// 初始化模板: pnpm release:notes --init
// 预览: pnpm release:notes --preview [--tag v0.1.2]
// 发版: pnpm release:notes --tag v0.1.2 --repo owner/repo

import { execFile } from "node:child_process";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { createInterface } from "node:readline/promises";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";

import { argv, chalk } from "zx";

const execFileAsync = promisify(execFile);
const SCRIPT_DIR = dirname(fileURLToPath(import.meta.url));
const TEMPLATE_PATH = join(SCRIPT_DIR, "templates", "NEXT_RELEASE.md");
const SOURCE = argv.source ?? "NEXT_RELEASE.md";
const OUTPUT = argv.output ?? "dist/release-notes.md";
const PREVIEW = Boolean(argv.preview);

const SEMVER_RE = /^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$/;
const BREAKING_RE = /^[a-zA-Z]+(?:\([^)]*\))?!:/;

async function run(command, args) {
  const { stdout } = await execFileAsync(command, args, {
    maxBuffer: 10 * 1024 * 1024,
  });
  return stdout.replace(/\r\n/g, "\n");
}

async function git(args) {
  return run("git", args);
}

async function gitOrNull(args) {
  try {
    return await git(args);
  } catch {
    return null;
  }
}

async function initTemplate() {
  const template = await readFile(TEMPLATE_PATH);
  let current = null;

  try {
    current = await readFile(SOURCE);
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
  }

  if (current !== null && current.equals(template)) {
    console.log(chalk.dim(`${SOURCE} 已是默认模板`));
    return;
  }

  if (current !== null) {
    const rl = createInterface({ input: process.stdin, output: process.stdout });
    const answer = (
      await rl.question(`${SOURCE} 已存在且内容与默认模板不同. 输入 Y 覆盖, 其他键取消: `)
    ).trim();
    rl.close();

    if (answer.toLowerCase() !== "y") {
      console.log(chalk.yellow("已取消, 未修改"));
      return;
    }
  }

  await writeFile(SOURCE, template);
  console.log(chalk.green(`已写入默认模板: ${SOURCE}`));
}

async function detectRepo() {
  if (argv.repo) return String(argv.repo);
  if (process.env.GITHUB_REPOSITORY) return process.env.GITHUB_REPOSITORY;

  const remote = await gitOrNull(["remote", "get-url", "origin"]);
  if (remote === null) return null;

  const match = remote.trim().match(/github\.com[:/]([^/]+)\/(.+?)(?:\.git)?$/);
  return match ? `${match[1]}/${match[2]}` : null;
}

async function findPreviousTag(ref) {
  if (argv.previous !== undefined) return String(argv.previous) || null;

  const target = PREVIEW ? ref : `${ref}^`;
  const tag = await gitOrNull(["describe", "--tags", "--abbrev=0", target]);
  return tag ? tag.trim() : null;
}

async function readSource() {
  let text;
  try {
    text = await readFile(SOURCE, "utf8");
  } catch {
    throw new Error(`找不到 ${SOURCE}`);
  }

  text = text.replace(/\r\n/g, "\n").trim();
  if (!text) throw new Error(`${SOURCE} 为空`);
  if (/^#\s/m.test(text)) throw new Error(`${SOURCE} 不要写一级标题, 版本标题由脚本生成`);
  if (!/^\s*-\s+\S/m.test(text))
    throw new Error(`${SOURCE} 还没有填写内容, 至少写一条 '- ' 列表项`);
  return text;
}

async function getCommits(range) {
  const out = await git(["log", range, "--reverse", "--format=%H%x1f%h%x1f%an%x1f%ae%x1f%s"]);
  return out
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [sha, short, name, email, subject] = line.split("\x1f");
      return { sha, short, name, email, subject };
    });
}

async function ghCompare(repo, base, head) {
  try {
    const out = await run("gh", [
      "api",
      `repos/${repo}/compare/${base}...${head}`,
      "--paginate",
      "--jq",
      ".commits[] | [.sha, .author.login, .commit.author.name] | @tsv",
    ]);

    const logins = new Map();
    for (const line of out.split("\n")) {
      if (!line) continue;
      const [sha, login] = line.split("\t");
      if (sha && login && login !== "null") logins.set(sha, login);
    }
    return logins;
  } catch {
    return null;
  }
}

async function restCompare(repo, base, head) {
  try {
    const headers = {
      Accept: "application/vnd.github+json",
      "User-Agent": "funzor-release-notes",
    };
    const token = process.env.GH_TOKEN || process.env.GITHUB_TOKEN;
    if (token) headers.Authorization = `Bearer ${token}`;

    const response = await fetch(`https://api.github.com/repos/${repo}/compare/${base}...${head}`, {
      headers,
    });
    if (!response.ok) return null;

    const data = await response.json();
    const logins = new Map();
    for (const commit of data.commits ?? []) {
      if (commit.sha && commit.author?.login) logins.set(commit.sha, commit.author.login);
    }
    return logins;
  } catch {
    return null;
  }
}

async function currentGitHubLogin() {
  try {
    const login = (await run("gh", ["api", "user", "--jq", ".login"])).trim();
    const email = (await git(["config", "user.email"])).trim();
    if (!login || !email) return null;
    return { login, email };
  } catch {
    return null;
  }
}

async function resolveAuthors(repo, previous, ref, commits) {
  const logins = new Map();
  let apiFailed = false;

  if (repo && previous) {
    const base = await gitOrNull(["rev-parse", `${previous}^{commit}`]);
    const head = await gitOrNull(["rev-parse", `${ref}^{commit}`]);

    if (base !== null && head !== null) {
      const compared =
        (await ghCompare(repo, base.trim(), head.trim())) ??
        (await restCompare(repo, base.trim(), head.trim()));

      if (compared === null) {
        apiFailed = true;
      } else {
        for (const [sha, login] of compared) logins.set(sha, login);
      }
    }
  }

  const self = repo ? await currentGitHubLogin() : null;
  if (self) {
    for (const commit of commits) {
      if (!logins.has(commit.sha) && commit.email === self.email) {
        logins.set(commit.sha, self.login);
      }
    }
  }

  const unresolved = commits.some((commit) => !logins.has(commit.sha));
  if (apiFailed && unresolved) {
    console.error(chalk.yellow("提示: 部分提交无法获取 GitHub 登录名, 已回退到 git 作者名"));
  }
  return logins;
}

function formatCommit(commit, repo, logins) {
  const login = logins.get(commit.sha);
  const author = login ? `[@${login}](https://github.com/${login})` : commit.name;
  const hash = repo
    ? `[\`${commit.short}\`](https://github.com/${repo}/commit/${commit.sha})`
    : `\`${commit.short}\``;
  const parts = [`\`${commit.subject}\``, `— ${author}`, `· ${hash}`];

  if (BREAKING_RE.test(commit.subject)) parts.push("· **破坏性变更**");
  return `- ${parts.join(" ")}`;
}

async function main() {
  if (argv.init) {
    await initTemplate();
    return;
  }

  const packageJson = JSON.parse(await readFile("package.json", "utf8"));
  const tag = argv.tag ? String(argv.tag) : `v${packageJson.version}`;
  const version = tag.replace(/^v/, "");
  if (!SEMVER_RE.test(version)) throw new Error(`版本号不合法: ${tag}`);

  const ref = PREVIEW ? String(argv.ref ?? "HEAD") : tag;
  if (!PREVIEW) {
    const exists = await gitOrNull(["rev-parse", "--verify", `refs/tags/${tag}`]);
    if (exists === null) throw new Error(`tag 不存在: ${tag}`);
  }

  const repo = await detectRepo();
  const previous = await findPreviousTag(ref);
  const source = await readSource();
  const range = previous ? `${previous}..${ref}` : ref;
  const commits = await getCommits(range);
  const logins = await resolveAuthors(repo, previous, ref, commits);

  const lines = [`# Funzor ${version}`, "", source, "", "## 全部提交", ""];
  for (const commit of commits) {
    lines.push(formatCommit(commit, repo, logins));
  }

  let linkRef = ref;
  if (PREVIEW) {
    const branch = await gitOrNull(["rev-parse", "--abbrev-ref", "HEAD"]);
    if (branch && branch.trim() !== "HEAD") linkRef = branch.trim();
  }

  if (repo) {
    const url =
      previous && previous !== ref
        ? `https://github.com/${repo}/compare/${previous}...${linkRef}`
        : `https://github.com/${repo}/commits/${linkRef}`;
    lines.push("", "---", "", `[查看全部提交](${url})`, "");
  }

  const markdown = `${lines.join("\n").trimEnd()}\n`;

  if (PREVIEW) {
    console.error(chalk.dim(`预览: ${range} (${commits.length} 个提交)`));
    process.stdout.write(markdown);
    return;
  }

  await mkdir(dirname(OUTPUT), { recursive: true });
  await writeFile(OUTPUT, markdown, "utf8");
  console.log(chalk.green(`发行说明已生成: ${OUTPUT}`));
}

main().catch((error) => {
  console.error(chalk.red(`发版说明脚本失败: ${error.message}`));
  process.exitCode = 1;
});
