# 组件与用法

> 适用范围: `Funzor/Themes/Controls.xaml`, `Funzor/Themes/Icons.xaml`, `Funzor/Views/**/*.xaml`  
> 事实来源: 上述文件; 键的存在性由校验脚本检查  
> 维护方式: 手写. 样式与区域键全量清单见 [全量参考](reference.md).  
> 更新触发: 新增控件样式, 图标, 外壳规格, 或把预留键变成实际组件时.

## 1. 现状

仓库已经落地的视觉组件:

- 标题栏 + 三栏外壳: 顶部 48px 标题栏, 56px 一级导航, 240px 二级菜单, 自适应内容区;
- 标题栏: 应用名 + 最小化/关闭两个图标按钮; 空白区可拖动;
- 一级导航: 图标 + ToolTip, 单选, 无选择指示条;
- 二级菜单: 标题行 + 可滚动条目列表;
- 占位页面: 页面标题, 页面描述, 主按钮;
- 排版样式 5 个, 按钮样式 2 个, 图标模板 3 个.

有语义键, 但还没有组件实现的: `Card`, `Form`, `Setting`, `Status`, `Dialog`, `ContextMenu`, `Tooltip`, `EmptyState`, 以及
`Page` 的面包屑与标签页, 幽灵/危险按钮, 开关与选择控件.

组件策略是**原生控件 + 项目样式**: 不改模板, 只通过样式改尺寸, 圆角, 排版, 通过 Bridge 改原生配色.

## 2. 排版

`Controls.xaml` 定义 5 个文本样式:

| 样式                            | 字号 / 行高 | 字重     | 换行   | 前景                        | 用途                     |
|---------------------------------|-------------|----------|--------|-----------------------------|--------------------------|
| `PageTitleTextBlockStyle`       | 24 / 32     | SemiBold | NoWrap | `Foundation.Text.Primary`   | 页面标题, 每页一个       |
| `PageDescriptionTextBlockStyle` | 14 / 20     | Normal   | Wrap   | `Foundation.Text.Secondary` | 标题下的页面说明         |
| `SectionTitleTextBlockStyle`    | 20 / 28     | SemiBold | NoWrap | `Foundation.Text.Primary`   | 页面内小节标题           |
| `BodyTextBlockStyle`            | 14 / 20     | Normal   | Wrap   | `Foundation.Text.Primary`   | 正文                     |
| `CaptionTextBlockStyle`         | 12 / 16     | Normal   | Wrap   | `Foundation.Text.Secondary` | 辅助说明, 单位, 次要信息 |

排版规则:

- 一个页面只有一个 `PageTitleTextBlockStyle`;
- 正文用 `BodyTextBlockStyle`, 不要用 `FontSize` 在页面上临时调字号;
- 12 号是最小正文档, 11 号只用于角标和单位, 不进入 token 的常用档;
- 中文正文需要行高, 不要只设字号;
- 标题默认不换行, 长标题需要换行时在页面局部覆盖 `TextWrapping`, 并在评审里说明;
- `BodyTextBlockStyle` 和 `CaptionTextBlockStyle` 与 WinUI 同名, 项目定义排在 `XamlControlsResources` 之后, 实际生效的是项目版本.

视图也可以使用白名单里的 WinUI 文本样式 (`BodyStrongTextBlockStyle`, `SubtitleTextBlockStyle` 等), 例如二级菜单标题就用了
`BodyStrongTextBlockStyle`. 选型优先级: 项目样式 > WinUI 白名单样式 > 局部排版 (需说明理由).

## 3. 按钮

语义层定义了四种按钮语言:

| 变体               | 语义                     | 当前状态                  |
|--------------------|--------------------------|---------------------------|
| `Button.Primary`   | 页面主操作               | 有 `PrimaryButtonStyle`   |
| `Button.Secondary` | 次要操作, 默认按钮外观   | 有 `SecondaryButtonStyle` |
| `Button.Ghost`     | 低强调, 工具栏, 行内操作 | 只有语义键, 没有样式      |
| `Button.Danger`    | 破坏性操作               | 只有语义键, 没有样式      |

已实现样式的规格: `MinHeight` 32, `Padding` 14,0, `CornerRadius` 6, `FontSize` 14; 主按钮 SemiBold, 次按钮 Normal. 主按钮
`BasedOn` WinUI 的 `AccentButtonStyle`, 次按钮 `BasedOn` `DefaultButtonStyle`.

使用规则:

- 一个视图最多一个主按钮; 其余操作降级为次按钮或幽灵按钮;
- 不要用 `Foreground`, `Background` 在按钮上临时改色; 需要新变体时在 `Controls.xaml` 加样式, 并在 `Button` 区域补语义键;
- 危险操作不要在页面上手写红底; 先补 `Button.Danger` 样式, 再使用;
- 原生 `Button` 不套样式时, 外观由 Bridge 的 `Button*` 键决定, 等于次按钮观感; 不要把它当主按钮用;
- 图标按钮需要有可读的 `AutomationProperties.Name` 或 ToolTip.
- 标题栏的最小化/关闭按钮是外壳局部样式: 32×32, 圆角 6, 只引用 `TitleBar.*`; 不套 Primary/Secondary 变体.

## 4. 外壳

主窗口顶部是 48 高标题栏, 下方固定三列:

| 区域     | 宽度 / 高度 | 背景                      | 说明                                      |
|----------|-------------|---------------------------|-------------------------------------------|
| 标题栏   | 跨二级菜单和内容区, 48 高 | `TitleBar.Background`     | 左侧应用名, 右侧最小化/关闭; 空白区拖动   |
| 一级导航 | 56          | `PrimaryNav.Background`   | 只放分区图标, ToolTip 显示名称; 通高      |
| 二级菜单 | 240         | `SecondaryNav.Background` | 标题行 56 + 条目列表, 右侧 1px 分隔       |
| 内容区   | 自适应      | `Content.Background`      | `Frame` 承载页面                          |

标题栏规格:

- 标题栏只覆盖二级菜单和内容区, 一级导航 `Grid.RowSpan=2`, 仍然从窗口顶端到底端;
- 背景 `TitleBar.Background`, 底部 1px `TitleBar.Separator`;
- 左侧应用名 `Margin=16,0,0,0`, 使用 `BodyStrongTextBlockStyle` + `TitleBar.Title.Foreground`;
- 右侧两个 32×32 图标按钮, 间距 8, 右边距 12, 圆角 6; 按钮空白区不参与拖动;
- 两个按钮使用 `Icon.Minimize` / `Icon.Close`; 图标源是 256 viewBox 的 stroke SVG;
- 窗口禁用最大化, 不提供全屏; 双击标题栏不会最大化.

一级导航规格:

- `ListView` 宽 56, `Padding` 0,8,0,8;
- 条目 40×40, `Margin` 8,2, 圆角 8;
- 图标 20×20, 颜色跟随条目 `Foreground`;
- 单选, 隐藏选择指示条; 选中只改变背景和前景;
- 每个条目有 ToolTip 和 `AutomationProperties.Name`.

二级菜单规格:

- 背景 `SecondaryNav.Background`, 右侧 1px 分隔线;
- 标题行高 56, 标题 `Margin` 16,0, 使用 `BodyStrongTextBlockStyle` + `SecondaryNav.Header.Foreground`;
- 列表 `Padding` 0,4,0,8;
- 条目最小高 36, `Margin` 8,1, `Padding` 12,0, 圆角 6;
- 文本单行, 超出用省略号.

交互约定: 当前一级与二级状态只由 `MainWindow` 持有; 子控件的 `SelectSection` / `SelectEntry` 是静默的, 事件只上报用户意图.
切换一级时默认选中该区第一项; 一级/二级切换不写入返回栈.

外壳里的 56, 240, 48, 40, 8 等数字属于布局结构常量, 允许直接写; 组件内部尺寸优先 token,
边界见[原子 Token](tokens.md#7-硬编码尺寸的边界).

## 5. 图标

图标是 `ControlTemplate`, 不是图片资源:

- 源文件放在 `Funzor/Assets/Icons/Source/`, 统一使用 256 viewBox;
- `Icons.xaml` 里一个 `Icon.{名称}` 模板, 根 `Viewbox` 不写固定尺寸, 内部使用 256×256 的坐标空间; 显示尺寸由使用方的 `ContentControl` 决定;
- fill 图标用 `Fill`, stroke 图标用 `Stroke`, 颜色都通过 `TemplateBinding Foreground` 绑定, 由使用方决定;
- 导航模型只保存图标 key (`NavSection.IconKey`), 不持有 UI 对象;
- `ResourceKeyToTemplateConverter` 在应用资源 (含合并字典) 里按 key 取 `ControlTemplate`; key 不存在时返回 `null`,
  图标区为空, 不会抛异常.

新增图标:

1. 准备 256 viewBox 的 SVG, 路径与命名放到 `Assets/Icons/Source/`;
2. 在 `Icons.xaml` 新增 `Icon.{名称}`, 内部保持 256×256 坐标空间; fill 或 stroke 都可以, 颜色统一走 `Foreground`;
3. 需要导航入口时, 把 key 写进 `NavigationCatalog`;
4. 不要在图标的 path 或模板里写死颜色; 选中/未选中只改 `Foreground`.

## 6. 状态与反馈

`Status` 区域为五种语义提供五种笔触:

| 语义    | 色相    | 主要键                                                                          |
|---------|---------|---------------------------------------------------------------------------------|
| Success | Green   | `Status.Success.Background` / `.Border` / `.Foreground` / `.Solid` / `.OnSolid` |
| Warn    | Amber   | `Status.Warn.*`                                                                 |
| Danger  | Red     | `Status.Danger.*`                                                               |
| Info    | Blue    | `Status.Info.*`                                                                 |
| Neutral | Neutral | `Status.Neutral.*`                                                              |

用法:

- 页内提示条用 `Background` + `Border` + `Foreground` 组合;
- 状态点, 徽标底, 图表标记用 `Solid`;
- `OnSolid` 只用于实心底上的文字或图标;
- 不要用状态色做装饰, 也不要把成功绿当品牌色;
- 目前没有状态组件实现; 新增组件时用现有键, 不要新造颜色.

## 7. 弹层

`Dialog`, `ContextMenu`, `Tooltip` 都有完整的语义键和 Bridge 映射, 目标是让原生 `ContentDialog`, `MenuFlyout`, `ToolTip`
自动跟随主题.

- 对话: 阻塞式决策用 `ContentDialog`, 不自定义模板;
- 菜单: 上下文操作与溢出操作用 `MenuFlyout`;
- 提示: 图标按钮, 截断文本, 导航分区用 `ToolTip`;
- 弹层背景, 边框, 分隔, 快捷键文本颜色来自对应区域键, 不手写;
- 不要为单个页面创建自定义 Popup 来复制这些弹层.

`PrimaryNav.Tooltip.*` 与 `SecondaryNav.Tooltip.*` 是导航内部的提示键; `SecondaryNav.Tooltip.*` 目前标记为 reserved,
尚未使用.

## 8. 表单与设置 (预留)

`Form` 区域覆盖输入框的默认/悬停/焦点/禁用/错误, 占位符, 标签, 帮助文本, 以及选择控件的选中态. `Setting` 区域覆盖设置行,
分隔线, 危险设置区和开关.

现状:

- 没有任何表单或设置样式; 仓库里只有占位页面;
- `Form.Choice.*` 与 `Setting.Toggle.*` 标记为 reserved;
- 实现时优先使用 WinUI 原生 `TextBox`, `CheckBox`, `ToggleSwitch`, 用 Bridge 负责配色, 用 `Controls.xaml` 负责尺寸与排版;
- 不要用页面级 `Style` 复制一套输入框外观.

## 9. 页面模式 (预留)

已实现: 页面标题, 页面描述, 页面内边距 32, 纵向间距 16.

有键未实现:

- `Page.Breadcrumb.*`: 面包屑文字, 悬停, 分隔符;
- `Page.Tab.*`: 标签文字, 选中, 悬停, 指示条, 分隔线;
- `Card.*`: 卡片背景, 边框, 悬停, 页头, 描述, 分隔, 页脚;
- `EmptyState.*`: 空状态图标, 标题, 描述.

页面实现时优先复用这些键; 如果发现缺键, 按[维护手册](maintenance.md)新增, 不要在页面里写颜色.

## 10. 预留与未实现清单

以 [全量参考](reference.md)里的 `reserved` 标记为准确清单. 当前预留的键组:

| 键组                            | 预留用途               |
|---------------------------------|------------------------|
| `PrimaryNav.Separator`          | 一级导航分隔线         |
| `SecondaryNav.Header.Separator` | 二级菜单标题分隔线     |
| `SecondaryNav.Tooltip.*`        | 二级菜单内部提示       |
| `Form.Choice.*`                 | 选择控件选中态         |
| `Setting.Toggle.*`              | 开关的轨道, 滑块, 边框 |

预留键的处理规则见[维护手册](maintenance.md#46-删除或废弃语义键): 可以保留, 但删除前必须确认零引用, 并同步两个主题.

## 11. 使用清单

做:

- 用现成样式和本区域键;
- 颜色用 `ThemeResource`, 尺寸用 `StaticResource`;
- 需要新外观时先补语义键和样式, 再在页面使用;
- 保持原生控件的交互与无障碍语义;
- 长中文, 空数据, 禁用态, 焦点态都要实际看一眼.

不做:

- 在页面里写十六进制, `Transparent`, `Color=` 或自定义画刷;
- 重写原生控件模板;
- 用页面局部 `Style` 复制按钮/输入框;
- 把品牌珊瑚当按钮底色或正文色;
- 为单个页面临时改字号, 圆角, 间距而不沉淀到样式或 token.

