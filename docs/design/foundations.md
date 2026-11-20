# 设计基础

> 适用范围: 整个设计系统 (主题, 视图, 控件样式, 图标)  
> 事实来源: `Funzor/Themes/*.xaml`, `scripts/check-design-system.ps1`  
> 维护方式: 手写. 具体键与值见 [全量参考](reference.md), 不在此重复.  
> 更新触发: 设计语言, 分层方式, 主题模型或校验机制发生变化时.

## 1. 设计语言

Funzor 是桌面工具型应用, 视觉上以安静的暖灰骨架加一个明确的强调色为主.

- **暖灰而不是冷灰**: 中性色带轻微暖调, 从近白到近黑以半档递进, 避免纯黑纯白造成的生硬边界.
- **两级导航**: 顶部 48px 标题栏只覆盖二级菜单和内容区; 左侧 56px 墨色导轨只承载分区图标, 通高; 紧邻的 240px 二级菜单承载条目, 内容区自适应.
- **高对比中性主按钮**: 浅色主题是近黑底白字, 深色主题是近白底近黑字. 主按钮不承担品牌表达.
- **珊瑚只做强调**: 珊瑚红用于重点文字, 图标, 选中指示和少量品牌时刻, 不铺大面积背景, 也不做实心按钮. `A.Coral.500`
  对白字对比度约 3.28, 达不到正文和实心按钮的要求.
- **原生优先**: 控件的交互, 焦点, 滚动, 无障碍语义沿用 WinUI; 本项目只调整尺寸, 圆角, 排版和配色, 不重写控件模板.
- **克制的密度**: 常用控件高 32, 菜单项高 36, 导航项 40; 间距以 4 为基本步长, 个别场景用 2 做微调.

颜色, 尺寸和字号的精确值见 [原子 Token](tokens.md); 某个键在当前主题下的实际值见 [全量参考](reference.md).

## 2. 分层与装配

```
Views / Controls.xaml                 视图与控件样式: 只引用本区域语义键和度量 token
        │
        ▼
Theme.Light.xaml / Theme.Dark.xaml    语义层: 按区域定义用途, 并按主题给值
        │
        ▼
Tokens.xaml                          原子层: 色阶, 间距, 尺寸, 字号, 圆角, 动效
```

| 层       | 文件                                                | 职责                                 | 不允许                                                                   |
|----------|-----------------------------------------------------|--------------------------------------|--------------------------------------------------------------------------|
| 原子     | `Funzor/Themes/Tokens.xaml`                         | 定义值与量级, 使用色相名             | 使用 `Success`, `Danger` 这类语义名                                      |
| 语义     | `Funzor/Themes/Theme.Light.xaml`, `Theme.Dark.xaml` | 按 UI 区域定义用途, 映射到 `A.*`     | 十六进制颜色, `ThemeResource`, 引用其他区域键                            |
| 装配     | `Funzor/Themes/Theme.xaml`, `Funzor/App.xaml`       | 合并字典, 接主题字典                 | 存放任何色值或尺寸                                                       |
| 控件样式 | `Funzor/Themes/Controls.xaml`                       | 排版样式, 按钮尺寸与圆角             | 重写模板, 写颜色字面量                                                   |
| 图标     | `Funzor/Themes/Icons.xaml`                          | 把 SVG path 包装成 `ControlTemplate` | 在模板内写死颜色                                                         |
| 使用     | `Funzor/Views/**/*.xaml`                            | 页面与外壳布局                       | 颜色 token, 画刷定义, `Color=`, 十六进制, `Transparent` 字面量, 跨区域键 |

`App.xaml` 的合并顺序是固定的:

1. `XamlControlsResources`: WinUI 原生资源与控件模板;
2. `Tokens.xaml`: 主题层的 `{StaticResource A.*}` 要求它先于主题文件合并;
3. `Theme.xaml`: 注册 Light, Dark, Default 三套主题字典;
4. `Controls.xaml`: 项目排版与按钮样式;
5. `Icons.xaml`: 导航通过 `ResourceKeyToTemplateConverter` 按 key 取图标模板.

`Theme.xaml` 只做接线, 不放值: `Default` 与 `Dark` 都指向 `Theme.Dark.xaml`, `Light` 指向 `Theme.Light.xaml`. WinUI
在无法判定主题, 或缺少对应高对比度字典时使用 `Default`, 因此默认回退到深色.

## 3. 主题模型

- **跟随系统**: 应用没有设置 `RequestedTheme`, 也没有应用内主题切换; Light/Dark 由 Windows 当前应用模式决定.
- **双主题同构**: 两个主题文件的键集合, 数量和顺序必须完全一致, 区块顺序也必须一致. 颜色不同, 结构相同.
- **浅色结构**: 墨色导轨, 暖灰桌面, 白色卡片, 深色正文.
- **深色结构**: 墨色导轨, 深色桌面, 抬起一级的菜单与卡片, 浅色正文.
- **高对比度未实现**: 目前没有 `HighContrast` 主题字典, Windows 高对比度模式会回退到 `Default` (深色). 这是已知缺口,
  不是完成态.
- **颜色必须走 `ThemeResource`**: 视图里引用语义键时用 `ThemeResource`, 主题切换才会重新解析; 尺寸, 圆角, 排版样式用
  `StaticResource`.
- **局部别名**: 两个导航视图在自身的 `ThemeDictionaries` 里用 `StaticResource ResourceKey=` 把 WinUI 的 `ListViewItem*`
  键映射到本区域语义键. 这是唯一允许的"改写原生键"方式, 且只作用于当前控件.

## 4. 为什么这样设计

- **值集中**: 所有颜色和尺度在 `Tokens.xaml` 一处维护, 调整色板不需要改页面.
- **色相与用途分离**: token 只承诺"这是珊瑚色的哪一档", 语义层才承诺"这是危险按钮的悬停底色". 换主题只改语义映射,
  色板本身可以整体替换.
- **区域即访问边界**: 页面无法随手引用别的区域的键, 评审时能直接判断"这个引用该不该出现", 而不是靠命名习惯.
- **组件区域例外**: `Button`, `Form`, `Status`, `Tooltip` 是跨页面复用的组件语言, 任何视图都可以引用, 避免每个页面复制一套按钮配色.
- **Bridge 让原生控件跟随主题**: WinUI 模板只认 `TextFillColor*`, `ButtonBackground*` 这类原生键, Bridge 把这些键按
  owner 映射回项目语义, 原生控件才能随 Light/Dark 切换.
- **校验前移**: XAML 编译器不检查资源键是否存在, 错误通常要到运行时才以"找不到资源"暴露; 脚本在没有 UI 的 CI 上先拦截.
- **不重写模板**: 模板一旦重写, WinUI 后续的模板修复和可访问性改进就吃不到了; 项目只通过样式改尺寸, 圆角与排版, 用
  Bridge 改配色.

## 5. 边界

设计系统拥有:

- 原子 token 与语义键;
- 页面排版样式, 按钮样式, 图标模板;
- 外壳 (三栏结构) 的视觉规格;
- 主题, 桥接, 视图区域映射的规则与校验.

设计系统不拥有:

- 业务逻辑, 数据模型, 导航栈的业务语义;
- 页面信息架构与功能取舍;
- 本地化文案与文案风格;
- 安装, 发版与升级流程;
- WinUI 控件自身的行为与键盘规范.

## 6. 术语

| 术语          | 含义                                                                                |
|---------------|-------------------------------------------------------------------------------------|
| 原子 token    | `A.*` 资源, 只定义值, 例如 `A.Space.16`, `A.Neutral.200`                            |
| 语义键        | 区域前缀资源, 只定义用途, 例如 `Card.Background`, `Button.Primary.Background.Hover` |
| 区域 (Region) | 语义键的第一段, 代表一个 UI 部位及其访问边界                                        |
| Owner         | 区域或 Bridge 键的归属说明; Bridge 键用注释 `owner:` 指向区域键                     |
| 组件区域      | `Button`, `Form`, `Status`, `Tooltip`, 任何视图都可引用                             |
| Bridge 键     | 语义层里 WinUI 原生模板使用的键, 如 `TextFillColorPrimaryBrush`                     |
| 视图别名      | 视图内用 `StaticResource ResourceKey=` 把原生键映射到本区域键                       |
| DR            | `check-design-system.ps1` 的规则编号, DR-01 至 DR-12                                |
| reserved      | 语义键上的注释标记, 表示该键为尚未实现的能力预留                                    |

## 7. 当前已知限制

这些限制是现状的一部分, 文档不假装它们不存在:

- `HighContrast` 主题字典未定义, 高对比度模式回退到深色.
- 没有应用内主题切换, 也没有主题预览入口.
- 校验是文本级的: 不验证运行时资源解析, 不计算对比度, 也不检查视图内 Light/Dark 两个别名字典的键是否同步.
- 大量语义键只有定义, 还没有对应的组件实现 (见[组件与用法](components.md)).
- 布局结构尺寸仍有字面量, 脚本只约束颜色和画刷, 不约束尺寸.
- 校验脚本的度量匹配包含 `FontWeight`, 但 token 层还没有 `FontWeight` 族, 引用 `A.FontWeight.*` 会报 DR-05.
- Bridge 键名依赖 WinUI 资源; 升级 Windows App SDK 后需要重新审计,
  见[维护手册](maintenance.md#13-升级-windows-app-sdk-时).
- `Controls.xaml` 定义了与 WinUI 同名的 `BodyTextBlockStyle` 和 `CaptionTextBlockStyle`. 应用级合并顺序中它们在
  `XamlControlsResources` 之后, 因此项目版本覆盖同名 WinUI 样式; 后续如果希望恢复 WinUI 默认, 删除项目里的同名定义即可.

