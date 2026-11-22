# Funzor

Funzor 是一个处于开发初期的 Windows 桌面应用, 使用 Tauri 2 与 Vue 3 + TypeScript 构建.

## 开发

```powershell
pnpm install
pnpm tauri dev      # 启动开发窗口
pnpm build          # 前端类型检查与构建
pnpm tauri build    # 打包 NSIS 安装器
```

## 发版

开始写下一版说明前, 先重置模板:

```powershell
pnpm release:notes --init
```

模板写在根目录的 `NEXT_RELEASE.md`, 分为 `亮点 / 新功能 / 优化 / 修复` 四节, 手动填写; 默认模板在 `scripts/templates/NEXT_RELEASE.md`. 发版时脚本会原样保留这些内容, 并在下面平铺两个 tag 之间的所有提交.

预览以 `HEAD` 为提交终点, `--tag` 只决定标题和链接里的版本.

```powershell
pnpm release:notes --preview                  # 预览, 版本取 package.json
pnpm release:notes --preview --tag v0.1.1     # 预览指定版本
```

`--init` 发现 `NEXT_RELEASE.md` 已存在且与默认模板不同时, 会询问是否覆盖; 输入 `Y` 回车覆盖, 其他输入取消.
