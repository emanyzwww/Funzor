# 语义层

> 适用范围: `Funzor/Themes/Theme.Light.xaml`, `Funzor/Themes/Theme.Dark.xaml`, `Funzor/Views/**/*.xaml`,
> `Funzor/Themes/Controls.xaml`  
> 事实来源: 两个主题文件; 规则见 `scripts/check-design-system.ps1` 的 DR-02 至 DR-05, DR-09 至 DR-12  
> 维护方式: 手写. 区域键全量清单见 [全量参考](reference.md).  
> 更新触发: 新增/删除区域, 修改命名语法, 修改引用规则或 Bridge 约定时.

## 1. 为什么需要语义层

原子 token 只回答"这个值是多少", 语义层回答"这个值用在哪里".

- 视图引用的是用途, 不是色相. 页面写 `Card.Background`, 而不是 `A.Neutral.0`;
- 切换主题只需要换一套语义映射, 视图和控件样式不动;
- 区域前缀同时是**访问边界**: 页面不该引用别的部位的颜色, 评审时能直接判断;
- 语义键是 Light/Dark 两个主题的公共契约, 结构必须一致, 否则运行时会缺资源.

## 2. 区域模型

语义键的第一段就是区域. 区域不是命名前缀, 而是所有权和引用权限.

| 区域           | Owner                             | 覆盖内容                                          |
|----------------|-----------------------------------|---------------------------------------------------|
| `Foundation`   | 所有视图与原生控件                | 画布, 表面, 正文, 边框, 焦点, 滚动, 强调, 选区    |
| `TitleBar`     | `Views/Shell/TitleBar.xaml`       | 标题栏背景, 分隔线, 标题文字, 图标按钮            |
| `PrimaryNav`   | `Views/Shell/NavigationRail.xaml` | 一级导航背景, 条目, 选中, 徽标, 滚动, 提示        |
| `SecondaryNav` | `Views/Shell/SectionPanel.xaml`   | 二级菜单背景, 分组, 条目, 选中, 徽标, 滚动, 提示  |
| `Content`      | `Views/MainWindow.xaml`, 页面     | 内容区背景                                        |
| `Page`         | 页面                              | 页面标题, 描述, 小节标题, 面包屑, 标签页          |
| `Card`         | 内容页                            | 卡片背景, 边框, 页头, 描述, 分隔, 页脚            |
| `Button`       | `Themes/Controls.xaml`, 页面      | 主按钮, 次按钮, 幽灵按钮, 危险按钮                |
| `Form`         | 页面, `Controls.xaml`             | 输入框, 占位符, 标签, 帮助, 错误, 选择控件        |
| `Setting`      | 页面                              | 设置行, 危险设置区, 开关                          |
| `Status`       | 页面                              | 成功, 警告, 危险, 信息, 中性的底色/文字/实心/反白 |
| `Dialog`       | `ContentDialog` 调用方            | 对话框背景, 前景, 内容, 分隔                      |
| `ContextMenu`  | `MenuFlyout` 调用方               | 菜单背景, 条目, 悬停, 快捷键文本, 分隔            |
| `Tooltip`      | `ToolTip` 调用方                  | 工具提示背景, 文字, 边框                          |
| `EmptyState`   | 内容页                            | 空状态图标, 标题, 描述                            |
| `Bridge`       | WinUI 原生模板                    | 原生键到区域键的桥接, 不是应用代码的 API          |

区域顺序是固定的, 定义在 `scripts/check-design-system.ps1` 的 `RegionManifest` 中:

```
Foundation → TitleBar → PrimaryNav → SecondaryNav → Content → Page → Card → Button →
Form → Setting → Status → Dialog → ContextMenu → Tooltip → EmptyState → Bridge
```

调整顺序, 插入新区块都属于结构变更, 必须同步脚本, 两个主题文件和文档, 见[维护手册](maintenance.md#47-新增区域).

### 2.1 组件区域

`Button`, `Form`, `Status`, `Tooltip` 是**组件区域**, 任何视图都可以引用, 不受视图区域映射限制. 原因很直接: 按钮, 输入框,
状态提示会出现在每个页面, 如果按页面复制一套配色, 主题和状态会迅速分叉.

代价是: 页面不能拥有自己的按钮配色. 需要新的按钮变体时, 加在 `Button` 区域并补控件样式, 而不是在页面区域新建.

### 2.2 区块头

主题文件用注释分块, 区块头必须写成 `区域 - 描述`:

```xml
<!-- ============================================================
     Button - 按钮
     Owner: Themes/Controls.xaml, 内容页
     允许: A.*
     禁止: 其他区域键
     ============================================================ -->
```

校验脚本用 `^\s+([A-Za-z][A-Za-z0-9]*)\s+-\s+.+$` 识别区块头. 不要在注释里写其他同形状的行, 否则会被误判成新区块.
`Owner` 行是给人看的, 脚本只校验 `Bridge` 区块的 owner.

## 3. 命名语法

语义键的形状是:

```
{Region}.{Part}.{Property}.{State}
```

这不是严格的四段: 至少两段, 最后一段必须是属性段或状态段. 段名使用 PascalCase, 点分隔.

| 类别   | 允许的段                                                                                                                              |
|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| 属性段 | `Background`, `Foreground`, `Border`, `Fill`, `Indicator`, `Separator`, `Shadow`, `Thumb`, `Track`, `Ring`, `Offset`, `OnSolid`, `On` |
| 状态段 | `Hover`, `Pressed`, `Selected`, `Focus`, `Disabled`, `Error`, `Checked`, `Default`, `Subtle`, `Strong`                                |

任何一段都不能是 `Bg`, `Fg`, `Color`, `Brush`, `Light`, `Dark`.

合法示例:

```
Card.Background
Card.Footer.Background
Button.Primary.Background.Hover
Button.Secondary.Border.Disabled
Foundation.Focus.Ring
Foundation.Focus.Offset
Page.Tab.Indicator
Status.Warn.OnSolid
Setting.Row.Background.Hover
```

非法示例与原因:

| 键                     | 原因                                                         |
|------------------------|--------------------------------------------------------------|
| `Card.Bg`              | 使用了禁止段 `Bg`                                            |
| `Button.Primary.Brush` | 使用了禁止段 `Brush`, 且最后一段不是属性/状态                |
| `PrimaryNav.Light`     | 使用了禁止段 `Light`, 主题不该进键名                         |
| `Foundation.Color`     | 使用了禁止段 `Color`, 且语义不明确                           |
| `Card.Padding`         | 最后一段不是属性/状态, 尺寸属于 token 或样式, 不属于颜色语义 |

三个命名例外:

- `Foundation.Text.*`: 正文层级 (Primary / Secondary / Tertiary / Disabled / Link / Emphasis / Code);
- `Foundation.Border.*`: 边框层级 (Default / Subtle / Strong / Disabled);
- `Status.{状态}.Solid` 与 `Status.{状态}.OnSolid`: 实心底与反白内容.

`Bridge` 区块不受命名形状约束, 键名必须与 WinUI 原生键一致.

## 4. 主题文件结构

两个主题文件结构完全同构:

1. 文件头注释说明主题方向和基本规则;
2. 按 `RegionManifest` 的顺序排列 16 个区块;
3. 每个区块内先写本区域的键, 键的顺序在两个文件中必须一致;
4. `Bridge` 区块最后, 键的 owner 注释写在行尾.

硬规则:

- **键集合相同**: Light 有的键 Dark 必须有, 反之亦然 (DR-02);
- **键顺序相同**: 第 N 个键在两个文件里必须是同一个键 (DR-03);
- **区块归属正确**: `Card.*` 必须位于 `Card` 区块, `Bridge` 除外 (DR-03);
- **不允许十六进制**: 颜色只能引用 `A.*` (DR-04);
- **只允许 `StaticResource`**: 主题文件里不能出现 `ThemeResource`, 且引用必须是存在的 `A.*` (DR-05);
- **键不重复** (DR-02).

键不需要按字母排序. 需要的是**两个文件的位置对齐**: 新增键时, 在 Light 的某个相邻键之后插入, 就在 Dark 的同一个相邻键之后插入.

`Theme.xaml` 把 `Default` 和 `Dark` 指向 `Theme.Dark.xaml`, `Light` 指向 `Theme.Light.xaml`. 没有 `HighContrast` 字典,
高对比度模式回退 `Default`.

## 5. 引用规则

### 5.1 谁能引用什么

| 使用方          | 允许引用                                                                                 | 说明                                                 |
|-----------------|------------------------------------------------------------------------------------------|------------------------------------------------------|
| 主题文件        | 本区块键 + `A.*`                                                                         | 不允许引用其他区域键                                 |
| 视图            | 本区域键, `Foundation`, `Content` 等按映射允许的区域, 组件区域, 度量 token, WinUI 白名单 | 颜色用 `ThemeResource`, 尺寸/样式用 `StaticResource` |
| `Controls.xaml` | 组件区域, `Foundation`, 度量 token                                                       | 不写画刷和颜色字面量                                 |
| `Icons.xaml`    | 不引用颜色                                                                               | 颜色由使用方的 `Foreground` 传入                     |
| 应用代码        | 不直接引用 `Bridge` 键                                                                   | Bridge 只服务原生模板; 脚本不拦这条, 靠评审          |

视图的区域权限由 `ViewRegionMap` 决定, 见第 7 节. `Foundation` 在所有视图映射中都有, 实际是公共基础层; `Content`
只给主窗口和页面.

### 5.2 视图里的主题资源

- 颜色: `{ThemeResource Card.Background}`. 主题切换时重新解析;
- 尺寸, 圆角, 排版样式: `{StaticResource A.Space.16}`, `{StaticResource BodyTextBlockStyle}`;
- 引用不存在的语义键: DR-09;
- 引用未登记区域: DR-11;
- 直接引用颜色 token: DR-06;
- 视图里写 `Color=`, 十六进制, `Transparent` 字面量, `SolidColorBrush`/`LinearGradientBrush`: DR-06 至 DR-08.

WinUI 原生键白名单 (视图可直接引用):

```
SymbolThemeFontFamily                  ContentControlThemeFontFamily
BaseTextBlockStyle                     BodyTextBlockStyle
BodyStrongTextBlockStyle               BodyLargeTextBlockStyle
BodyLargeStrongTextBlockStyle          CaptionTextBlockStyle
SubtitleTextBlockStyle                 TitleTextBlockStyle
TitleLargeTextBlockStyle               DisplayTextBlockStyle
ApplicationPageBackgroundThemeBrush
```

白名单之外的 WinUI 键会报 DR-09. 需要新的原生键时, 先判断是否应该走 `Bridge`, 并同步更新脚本白名单.

注意: `Controls.xaml` 重新定义了 `BodyTextBlockStyle` 和 `CaptionTextBlockStyle`, 键名与 WinUI 同名; 应用级合并顺序把它们排在
`XamlControlsResources` 之后, 项目版本覆盖同名样式.

### 5.3 视图别名

WinUI 的 `ListViewItem` 模板只认 `ListViewItemBackgroundPointerOver` 这类固定键.
导航视图在自己的资源里把它们映射到本区域语义键:

```xml
<ResourceDictionary.ThemeDictionaries>
    <ResourceDictionary x:Key="Light">
        <StaticResource x:Key="ListViewItemBackgroundPointerOver"
                        ResourceKey="PrimaryNav.Item.Background.Hover"/>
    </ResourceDictionary>
    <ResourceDictionary x:Key="Dark">
        <StaticResource x:Key="ListViewItemBackgroundPointerOver"
                        ResourceKey="PrimaryNav.Item.Background.Hover"/>
    </ResourceDictionary>
</ResourceDictionary.ThemeDictionaries>
```

规则:

- 只允许 `StaticResource ResourceKey=` 形式的别名, 不允许在视图里定义画刷;
- 别名目标必须是已存在, 且本视图有权引用的区域键 (DR-09, DR-11);
- 平台模板使用的原生键 (如 `ListViewItem*`) **在元素级覆盖无效**: 放进 `ThemeDictionaries` 或写成直接条目都试过, 模板都不采纳.
  需要不同外观时, 不要覆盖原生键, 改为在 `Funzor/Controls/` 里给该控件写**项目自持的模板**, 圆角和状态色写在模板内; 应用级 `Theme.Light/Dark.xaml` 的 `Bridge` 仍是全局覆盖的正规位置, 且需要 `Default` 兜底;
- 别名只作用于当前控件, 不要覆盖应用级 `ListViewItem*` 键;
- 别名只改变状态颜色和圆角这类主题资源, 不改变控件结构;
- 需要复用又需要不同于平台默认的控件外观时, 在 `Funzor/Controls/` 下写**自持模板的样式**, 视图用 `ItemContainerStyle` 之类的
  属性指向该样式; 视图不重复写模板. 示例见 `Controls/Navigation/PrimaryNavList.xaml`.

## 6. Bridge (原生控件桥接)

`Bridge` 区块把 WinUI 模板使用的原生键映射到项目语义. 没有它, 原生控件的文字, 边框, 按钮底色不会跟随项目主题.

覆盖范围:

| 类别 | 典型原生键                                              | owner 指向                                      |
|------|---------------------------------------------------------|-------------------------------------------------|
| 文本 | `TextFillColorPrimaryBrush` 等                          | `Foundation.Text.*`                             |
| 描边 | `ControlStrokeColor*`, `DividerStrokeColorDefaultBrush` | `Foundation.Border.*`                           |
| 强调 | `AccentFillColor*`, `TextOnAccentFillColor*`            | `Foundation.Accent.*`, `Foundation.Selection.*` |
| 按钮 | `ButtonBackground*`, `AccentButton*`, `SubtleButton*`   | `Button.*`                                      |
| 输入 | `TextControl*`                                          | `Form.Input.*`                                  |
| 滚动 | `ScrollBar*`                                            | `Foundation.Scroll.*`                           |
| 弹层 | `ToolTip*`, `ContentDialog*`, `MenuFlyout*`             | `Tooltip.*`, `Dialog.*`, `ContextMenu.*`        |
| 进度 | `ProgressBar*`                                          | `Foundation.Accent.*`, `Foundation.Track.*`     |

规则:

- 每个 Bridge 键必须有行尾注释 `<!-- owner: 区域键 -->`, owner 的区域必须是产品区域 (DR-12);
- owner 可以是一个具体键, 也可以是键族前缀; 无法对应到区域键时会给警告;
- 先有语义键, 再有 Bridge 键. 不要为一个尚不存在的用途直接写原生键;
- 视图不直接引用 Bridge 键; 需要原生控件跟随主题时, 改 Bridge 映射;
- 原生键名以当前 Windows App SDK (2.6.5) 的模板资源为准, 不要凭记忆猜; 升级 SDK 后重新核对;
- Bridge 键同样要满足 Light/Dark 键集合与顺序一致.

## 7. 视图区域映射

`scripts/check-design-system.ps1` 的 `ViewRegionMap` 按路径前缀分配权限:

| 视图                                     | 允许的区域                                                                                                                       |
|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `Funzor/Views/MainWindow.xaml`           | `Foundation`, `Content`                                                                                                          |
| `Funzor/Views/Shell/TitleBar.xaml`       | `TitleBar`, `Foundation`, `Tooltip`                                                                                              |
| `Funzor/Views/Shell/NavigationRail.xaml` | `PrimaryNav`, `Foundation`, `Tooltip`                                                                                            |
| `Funzor/Views/Shell/SectionPanel.xaml`   | `SecondaryNav`, `Foundation`, `Tooltip`                                                                                          |
| `Funzor/Views/Pages/` 下所有页面         | `Foundation`, `Content`, `Page`, `Card`, `Button`, `Form`, `Setting`, `Status`, `Dialog`, `ContextMenu`, `Tooltip`, `EmptyState` |
| `Funzor/Controls/Navigation/PrimaryNavList.xaml` | `PrimaryNav`, `Foundation`                                                                                              |
| `Funzor/Controls/Navigation/SecondaryNavList.xaml` | `SecondaryNav`, `Foundation`                                                                                          |
| `Funzor/Themes/Controls.xaml`            | 所有产品区域                                                                                                                     |

补充:

- `Button`, `Form`, `Status`, `Tooltip` 是组件区域, 任何视图都可以引用, 不受上表限制;
- 新增视图目录或前缀时, 必须在脚本里加一行, 否则 DR-11 只给警告, 且该视图没有区域权限;
- 未知视图仍会被检查键存在性和颜色字面量, 但区域权限为空;
- 页面新增 `Card` 之类的引用, 不需要改脚本, 因为页面前缀已经包含这些区域;
- `Funzor/Controls/` 下的资源字典是组件级资源 (类似前端的组件目录), 脚本会一并扫描, 因此新文件同样要登记 `ViewRegionMap`.

## 8. 规则索引

| 规则  | 约束                                             | 本文对应章节 |
|-------|--------------------------------------------------|--------------|
| DR-02 | Light/Dark 键集合, 数量, 重复                    | 4            |
| DR-03 | 键顺序, 区块顺序, 键归属                         | 2.2, 4       |
| DR-04 | 主题文件禁止十六进制                             | 4            |
| DR-05 | 主题文件只引用存在的 `A.*`, 禁止 `ThemeResource` | 4, 5         |
| DR-06 | 视图禁止画刷, `Color=`, 颜色 token               | 5.2          |
| DR-07 | 视图禁止十六进制                                 | 5.2          |
| DR-08 | 视图禁止 `Transparent` 字面量                    | 5.2          |
| DR-09 | 引用的键必须在两主题中存在, WinUI 键必须在白名单 | 5.2          |
| DR-10 | 语义键命名形状                                   | 3            |
| DR-11 | 视图区域登记与跨区域引用                         | 5, 7         |
| DR-12 | Bridge 键必须有有效 owner                        | 6            |

## 9. 常见错误

| 现象                       | 根因                                       | 修正                                 |
|----------------------------|--------------------------------------------|--------------------------------------|
| 应用启动或切页时找不到资源 | 键只加在了一个主题, 或视图引用了不存在的键 | 两个主题同位置补齐; 跑 DR-02/DR-09   |
| 主题切换后只有部分控件变色 | 视图用了 `StaticResource` 引用语义键       | 颜色改为 `ThemeResource`             |
| 两个主题顺序不一致         | 在 Light 中间插了键, Dark 追加在末尾       | 在 Dark 的同一相邻键后插入           |
| 页面引用了导航的颜色       | 跨区域引用                                 | 改为本区域键, 或把该键提升为组件区域 |
| 原生按钮不跟随主题         | 缺 Bridge 键或 owner 不对                  | 补 Bridge 映射并跑 DR-12             |
| 新增页面提示 DR-11         | 视图前缀没登记                             | 在 `ViewRegionMap` 加一行            |

具体修复步骤见[维护手册](maintenance.md).

