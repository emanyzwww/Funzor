# 设计体系

> 适用范围: Funzor 的视觉与主题系统, 包括令牌, 语义键, 控件样式, 图标和原生控件桥接.  
> 事实来源: `Funzor/Themes/*.xaml` 和 `scripts/check-design-system.ps1`.  
> 维护方式: 本目录文档解释设计与流程; 全量键值见 [全量参考](reference.md), 由脚本生成.  
> 更新触发: 设计语言, 分层, 主题模型或校验规则发生变化时.

Funzor 的设计系统把"值"和"用途"分开. 原子 token 只定义颜色和尺度, 语义层按 UI 区域定义用途, 视图只能引用本区域语义键和度量
token. 规则由 `scripts/check-design-system.ps1` 在本地和 PR CI 中校验, 全量键值由脚本从 XAML 生成.

## 一页看结构

```text
Views / Controls.xaml              只引用本区域语义键和度量 token
        |
        v
Theme.Light.xaml / Theme.Dark.xaml 按区域定义用途, 双主题同构
        |
        v
Tokens.xaml                        色阶, 间距, 尺寸, 字号, 圆角, 动效
```

- **原子层**: `Tokens.xaml` 只定义值, 颜色按色相命名, 度量按类型和档位命名.
- **语义层**: 两个主题文件按 16 个固定区域定义用途, 键集合与顺序必须一致.
- **使用层**: 视图和 `Controls.xaml` 只引用本区域语义键和度量 token, 不写颜色字面量.
- **桥接**: `Bridge` 区块把 WinUI 原生键映射回区域键, 让原生控件跟随主题; `Icons.xaml` 提供图标模板.

## 文档地图

| 文档                        | 内容                                             | 什么时候读         |
|-----------------------------|--------------------------------------------------|--------------------|
| [设计基础](foundations.md)  | 设计语言, 分层装配, 主题模型, 边界, 已知限制     | 第一次接触设计系统 |
| [原子 Token](tokens.md)     | 色族, 度量族, 类型约束, 引用边界                 | 选值或新增 token   |
| [语义层](semantic-layer.md) | 区域, 命名, 主题同构, 视图别名, Bridge, 区域权限 | 新增或查找语义键   |
| [组件与用法](components.md) | 排版, 按钮, 外壳, 图标, 状态, 弹层               | 写页面或新增样式   |
| [维护手册](maintenance.md)  | 键的生命周期, 验证矩阵, DR 排查, 文档同步        | 修改设计系统       |
| [全量参考](reference.md)    | 全部 token, 语义键, 样式, 图标, 白名单           | 查具体值           |

## 快速上手

1. 写页面前: 读[语义层](semantic-layer.md)和[组件与用法](components.md), 再从[全量参考](reference.md)查本区域已有的键.
2. 改键或区域前: 读[维护手册](maintenance.md), 按对应流程操作.
3. 提交前: 跑规则校验和参考文档校验.

```powershell
pwsh scripts/check-design-system.ps1
pwsh scripts/gen-design-reference.ps1 -Check
```

## 规则速览

- 语义键以区域开头, 命名形状是 `{Region}.{Part}.{Property}.{State}`.
- Light 和 Dark 的键集合, 数量和顺序必须一致; 改一个键要同时改两个文件.
- 主题文件只能引用存在的 `A.*` token, 不允许十六进制和 `ThemeResource`.
- 视图不允许写颜色, 画刷, `Transparent` 或 `Color=`, 只能引用本区域键和度量 token.
- `Bridge` 键必须有 `owner` 注释; 视图不直接引用 Bridge 键.
- 规则失败会带 DR 编号, 在[维护手册](maintenance.md#9-dr-排查表)中查原因和修法.
- `reference.md` 是生成物, 不手工编辑.

## 当前状态

外壳和基础样式已经落地: 顶部 48px 自定义标题栏 (应用名 + 最小化/关闭), 三栏导航, 5 个排版样式, 主/次按钮样式, 图标模板. `Card`, `Form`, `Setting`, `Status`, `Dialog`,
`ContextMenu`, `Tooltip`, `EmptyState` 等区域已有语义键, 但组件尚未实现,
预留项见[组件与用法](components.md#10-预留与未实现清单).

高对比度主题尚未实现; 对比度自动检查和视图内 Light/Dark 别名字典一致性仍属于人工检查范围,
详见[设计基础](foundations.md#7-当前已知限制).

