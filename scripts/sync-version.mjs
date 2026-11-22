#!/usr/bin/env zx

// 以 package.json 的 version 为唯一事实源, 同步 Tauri 与 Cargo 侧的版本号.
// 用法:
//   pnpm sync:version              # 读取 package.json 并同步其余文件
//   pnpm sync:version 0.2.0        # 先把 package.json 改写为指定版本, 再同步

import { readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";

import { argv, chalk } from "zx";

const ROOT = process.cwd();
const SEMVER_RE =
  /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$/;

const read = (file) => readFile(join(ROOT, file), "utf8");

// 只替换第一处顶层 "version" 行, 避免 JSON.stringify 重排整个文件.
function replaceJsonVersion(text, version) {
  const pattern = /^([ \t]*)"version"(\s*:\s*)"[^"]*"/m;
  if (!pattern.test(text)) return null;
  return text.replace(pattern, `$1"version"$2"${version}"`);
}

// 读取 Cargo.toml 的 [package] 段, 只认该段内的 name/version.
function readCargoPackage(text) {
  const lines = text.split(/\r?\n/);
  let section = "";
  let name = "";
  let version = "";

  for (const line of lines) {
    const header = line.match(/^\s*\[([^\]]+)\]\s*$/);
    if (header) {
      section = header[1];
      continue;
    }
    if (section !== "package") continue;

    const nameMatch = line.match(/^\s*name\s*=\s*"([^"]*)"\s*$/);
    if (nameMatch) name = nameMatch[1];

    const versionMatch = line.match(/^\s*version\s*=\s*"([^"]*)"\s*$/);
    if (versionMatch) version = versionMatch[1];
  }

  return { name, version };
}

// 只替换 [package] 段内的 version 行, 不触碰依赖版本.
function writeCargoPackageVersion(text, version) {
  const eol = text.includes("\r\n") ? "\r\n" : "\n";
  const lines = text.split(/\r?\n/);
  let section = "";
  let replaced = 0;

  for (let i = 0; i < lines.length; i++) {
    const header = lines[i].match(/^\s*\[([^\]]+)\]\s*$/);
    if (header) {
      section = header[1];
      continue;
    }
    if (section !== "package") continue;

    const versionMatch = lines[i].match(/^(\s*version\s*=\s*")[^"]*(".*)$/);
    if (!versionMatch) continue;

    replaced++;
    lines[i] = versionMatch[1] + version + versionMatch[2];
  }

  if (replaced !== 1) {
    throw new Error(
      `src-tauri/Cargo.toml 的 [package] 段应有且仅有一个 version, 实际 ${replaced} 个`,
    );
  }
  return lines.join(eol);
}

// 在 Cargo.lock 中定位 name 匹配的 [[package]] 块, 只改该块的 version.
function writeCargoLockVersion(text, crateName, version) {
  const eol = text.includes("\r\n") ? "\r\n" : "\n";
  const lines = text.split(/\r?\n/);

  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() !== "[[package]]") continue;

    let name = "";
    let versionIndex = -1;
    for (let j = i + 1; j < lines.length && lines[j].trim() !== "[[package]]"; j++) {
      const nameMatch = lines[j].match(/^name\s*=\s*"([^"]*)"\s*$/);
      if (nameMatch) name = nameMatch[1];
      if (/^version\s*=\s*"[^"]*"\s*$/.test(lines[j])) versionIndex = j;
    }

    if (name !== crateName) continue;
    if (versionIndex === -1) {
      throw new Error(`src-tauri/Cargo.lock 中 ${crateName} 的 [[package]] 块缺少 version`);
    }

    const from = lines[versionIndex].match(/"([^"]*)"/)[1];
    lines[versionIndex] = lines[versionIndex].replace(
      /(version\s*=\s*")[^"]*(")/,
      `$1${version}$2`,
    );
    return { text: lines.join(eol), from };
  }

  return null;
}

async function sync() {
  const packageText = await read("package.json");
  const packageJson = JSON.parse(packageText);

  const requested = argv._[0] === undefined ? undefined : String(argv._[0]);
  if (requested !== undefined && !SEMVER_RE.test(requested)) {
    throw new Error(`版本号不合法: ${requested}, 需要形如 1.2.3`);
  }

  const version = requested ?? packageJson.version;
  if (!SEMVER_RE.test(version)) {
    throw new Error(`package.json 的 version 不合法: ${version}, 需要形如 1.2.3`);
  }

  const results = [];

  // 1. package.json: 仅在显式传版本时改写, 否则它就是事实源.
  if (requested !== undefined && requested !== packageJson.version) {
    const from = packageJson.version;
    const nextText = replaceJsonVersion(packageText, version);
    if (nextText === null) throw new Error("package.json 中未找到 version 字段");
    await writeFile(join(ROOT, "package.json"), nextText, "utf8");
    results.push({ file: "package.json", from, changed: true });
  } else {
    results.push({ file: "package.json", from: packageJson.version, changed: false });
  }

  // 2. tauri.conf.json
  const tauriFile = "src-tauri/tauri.conf.json";
  const tauriText = await read(tauriFile);
  const tauriConfig = JSON.parse(tauriText);
  if (tauriConfig.version === undefined) {
    results.push({ file: tauriFile, skipped: "没有 version 字段" });
  } else if (tauriConfig.version !== version) {
    const from = tauriConfig.version;
    const nextText = replaceJsonVersion(tauriText, version);
    if (nextText === null) throw new Error(`${tauriFile} 中未找到 version 字段`);
    await writeFile(join(ROOT, tauriFile), nextText, "utf8");
    results.push({ file: tauriFile, from, changed: true });
  } else {
    results.push({ file: tauriFile, from: version, changed: false });
  }

  // 3. Cargo.toml: 只改 [package] 段
  const cargoFile = "src-tauri/Cargo.toml";
  const cargoText = await read(cargoFile);
  const cargoPackage = readCargoPackage(cargoText);
  if (!cargoPackage.name) {
    throw new Error("src-tauri/Cargo.toml 的 [package] 段缺少 name");
  }
  if (cargoPackage.version !== version) {
    const nextText = writeCargoPackageVersion(cargoText, version);
    await writeFile(join(ROOT, cargoFile), nextText, "utf8");
    results.push({ file: cargoFile, from: cargoPackage.version, changed: true });
  } else {
    results.push({ file: cargoFile, from: version, changed: false });
  }

  // 4. Cargo.lock: 根 crate 的版本必须与 Cargo.toml 一致, 否则 --locked 会失败.
  const lockFile = "src-tauri/Cargo.lock";
  let lockText = null;
  try {
    lockText = await read(lockFile);
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
  }

  if (lockText === null) {
    results.push({ file: lockFile, skipped: "文件不存在" });
  } else {
    const lockResult = writeCargoLockVersion(lockText, cargoPackage.name, version);
    if (lockResult === null) {
      results.push({ file: lockFile, skipped: `没有 ${cargoPackage.name} 的 package 块` });
    } else if (lockResult.text !== lockText) {
      await writeFile(join(ROOT, lockFile), lockResult.text, "utf8");
      results.push({ file: lockFile, from: lockResult.from, changed: true });
    } else {
      results.push({ file: lockFile, from: lockResult.from, changed: false });
    }
  }

  // 输出
  const width = Math.max(...results.map((item) => item.file.length));
  const line = (file, message) => `  ${file.padEnd(width)}  ${message}`;

  console.log(chalk.bold(`版本: ${version} (来源: package.json)`));
  for (const item of results) {
    if (item.skipped) {
      console.log(chalk.yellow(line(item.file, `跳过: ${item.skipped}`)));
    } else if (item.changed) {
      console.log(chalk.green(line(item.file, `${item.from} -> ${version}`)));
    } else {
      console.log(chalk.dim(line(item.file, `${item.from} (已一致)`)));
    }
  }

  const changedCount = results.filter((item) => item.changed).length;
  if (changedCount === 0) {
    console.log(chalk.green("所有版本号已一致, 无需修改"));
  } else {
    console.log(chalk.green(`已更新 ${changedCount} 个文件`));
  }
}

sync().catch((error) => {
  console.error(chalk.red(`版本同步失败: ${error.message}`));
  process.exitCode = 1;
});
