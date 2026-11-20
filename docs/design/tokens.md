# 原子 Token

> 适用范围: `Funzor/Themes/Tokens.xaml`  
> 事实来源: `Tokens.xaml`; 规则见 `scripts/check-design-system.ps1` 的 DR-01, DR-05, DR-06  
> 维护方式: 手写. 全量键与值见 [全量参考](reference.md), 不在此重复.  
> 更新触发: 新增或删除 token 族, 改变类型约定, 调整色阶或尺度时.

## 1. 定位

原子 token 只定义值, 不定义用途.

- 颜色以**色相**命名 (`A.Coral.500`), 不出现 `Success`, `Danger`, `Hover` 这类语义名;
- 度量以**类型和档位**命名 (`A.Space.16`, `A.Radius.8`), 不出现 `CardPadding` 这类用途名;
- 只有 [语义层](semantic-layer.md)才承诺用途;
- 视图不直接引用颜色 token, 只允许引用度量 token.

这层被 `Theme.Light.xaml` / `Theme.Dark.xaml` 引用, 并在 `App.xaml` 中先于主题文件合并, 保证主题里的
`{StaticResource A.*}` 可以解析.

## 2. 颜色族

| 族              | 档位                      | 用途                                             |
|-----------------|---------------------------|--------------------------------------------------|
| `A.Neutral`     | 0 至 1000, 步长 25 的半档 | 暖灰骨架: 画布, 表面, 正文, 边框, 焦点, 遮罩     |
| `A.Coral`       | 50 至 900                 | 主品牌色: 强调文字, 图标, 选中指示, 少量品牌时刻 |
| `A.Blue`        | 50 至 900                 | 信息, 链接, 焦点环, 选中反馈                     |
| `A.Green`       | 50 至 900                 | 成功状态                                         |
| `A.Amber`       | 50 至 900                 | 警告状态                                         |
| `A.Red`         | 50 至 900                 | 危险, 破坏性操作, 错误                           |
| `A.Purple`      | 50 至 900                 | 辅助色相: 应用, 隐私, 性能                       |
| `A.Cyan`        | 50 至 900                 | 辅助色相: 网格, 数据可视化                       |
| `A.Magenta`     | 50 至 900                 | 辅助色相: 音频, 媒体                             |
| `A.White`       | `A04` 至 `A80` 的透明叠加 | 深色背景上的悬停, 按下, 选中, 描边               |
| `A.Black`       | `A04` 至 `A80` 的透明叠加 | 浅色背景上的悬停, 按下, 选中, 遮罩               |
| `A.Transparent` | `#00000000`               | 透明; 只允许在主题层使用                         |

颜色值统一使用十六进制. 八位写法是 `#AARRGGBB` (Alpha 在前), 例如 `A.White.A08` 的值是 `#14FFFFFF`.

## 3. 颜色使用规则

- **色阶共享档位**: 色相族统一 50 至 900; 浅底取 50 至 200, 实心取 500 至 600, 文字取 600 至 700. 具体映射由语义层决定.
- **中性色是骨架**: 0 是白色端点, 900 至 975 是近黑端点, 1000 是纯黑. 主题文件实际使用 0 与 900, 925 等深端, 纯黑 1000
  目前没有进入主题.
- **珊瑚不做实心按钮, 不做正文**: `A.Coral.500` 对白字对比度约 3.28, 只用于强调文字, 图标, 渐变, 图表和小面积重点.
- **状态色不在 token 层出现**: `Success`, `Warn`, `Danger`, `Info` 到色相的映射在语义层完成 (Green, Amber, Red, Blue).
- **叠加色不是固定填充**: `A.White.A*` / `A.Black.A*` 用于叠在任意底色之上的状态反馈; 64 至 80 档用于遮罩和背板,
  不当作普通背景色.
- **不要为了一个页面新增颜色**: 优先使用现有档位或已有语义键. 新增颜色族属于设计语言变更, 要走评审与完整维护流程.

## 4. 度量族

| 族             | XAML 类型      | 档位                                           | 用途                                        |
|----------------|----------------|------------------------------------------------|---------------------------------------------|
| `A.Space`      | `x:Double`     | 0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96 | 间距, `Spacing`, `RowDefinition` 之外的间隔 |
| `A.Pad`        | `Thickness`    | 2 至 32                                        | `Padding`                                   |
| `A.Stroke`     | `Thickness`    | 1, 2                                           | `BorderThickness`                           |
| `A.Size`       | `x:Double`     | 1 至 128                                       | 控件固定尺寸: 图标, 控件高度, 导航栏宽度    |
| `A.Radius`     | `CornerRadius` | 0 至 24, 另有 `Full`                           | 圆角; `Full` 是 9999, 用于胶囊和圆形        |
| `A.FontSize`   | `x:Double`     | 11, 12, 14, 16, 20, 24, 32, 40                 | 字号; 中文正文最小 12, 11 只用于角标和单位  |
| `A.LineHeight` | `x:Double`     | 16, 20, 24, 28, 32, 36                         | 只用于 `TextBlock.LineHeight`               |
| `A.Duration`   | `x:Double`     | 0, 100, 150, 200, 300, 400                     | 动效时长, 单位毫秒                          |

补充约定:

- 间距不是严格的 4 的倍数表, 2 用于微调; 新增间距优先复用现有档位, 不引入新的孤立值.
- `A.Size` 只放组件固定尺寸; 窗口和页面的具体宽高属于布局常量, 不进 token 层.
- `LineHeight` 只赋给 `TextBlock.LineHeight`; 不要拿它当字号或间距.
- `A.Duration` 只服务代码侧和 Composition. `Storyboard.Duration` 是 `TimeSpan`, 不能直接引用 `x:Double`, 需要换算;
  缓动曲线目前没有 token 化.
- 目前没有 `FontWeight` token. 字重直接在样式里写 `Normal` 或 `SemiBold`. 校验脚本的度量匹配虽然包含 `FontWeight`, 但
  token 层没有对应键, 引用 `A.FontWeight.*` 会报 DR-05.

## 5. 类型约束

| Token 类型           | 只能赋给                                                   | 不能赋给                                               |
|----------------------|------------------------------------------------------------|--------------------------------------------------------|
| `Color`              | 颜色类型的属性, 例如 `SolidColorBrush.Color`, `Color` 属性 | `Background`, `Fill`, `BorderBrush` 等 Brush 属性      |
| Brush (由语义层提供) | `Background`, `Fill`, `BorderBrush`, `Foreground`          | 颜色属性, `Thickness` 属性                             |
| `x:Double`           | 数值属性, 例如 `FontSize`, `Width`, `Height`, `Spacing`    | `Margin`, `Padding`, `BorderThickness`, `CornerRadius` |
| `Thickness`          | `Margin`, `Padding`, `BorderThickness`                     | 数值属性                                               |
| `CornerRadius`       | `CornerRadius`                                             | 数值属性, `Thickness` 属性                             |

典型写法:

```xml
<Setter Property="FontSize" Value="{StaticResource A.FontSize.14}"/>
<Setter Property="Padding" Value="{StaticResource A.Pad.12}"/>
<Setter Property="CornerRadius" Value="{StaticResource A.Radius.6}"/>
<Setter Property="Foreground" Value="{ThemeResource Foundation.Text.Primary}"/>
```

## 6. 引用边界

| 使用方                | 可以引用                                                                                      | 不可以引用                                          |
|-----------------------|-----------------------------------------------------------------------------------------------|-----------------------------------------------------|
| 主题文件              | 任意 `A.*`                                                                                    | 十六进制, `ThemeResource`, 其他区域键               |
| `Controls.xaml`, 视图 | 度量 token (`Space`, `Pad`, `Stroke`, `Size`, `Radius`, `FontSize`, `LineHeight`, `Duration`) | 颜色 token, `A.Transparent`, 任何画刷定义, `Color=` |
| 图标模板              | 无颜色 token; 颜色由使用方的 `Foreground` 传入                                                | 模板内写死颜色                                      |

视图里写 `Background="{StaticResource A.Neutral.0}"` 或 `Background="{ThemeResource A.Coral.500}"` 都会被 DR-06 拦截.
需要颜色时引用本区域的语义键.

## 7. 硬编码尺寸的边界

校验脚本只禁止颜色和画刷, 不禁止尺寸字面量. 尺寸是否使用 token 靠约定:

| 类别               | 现有例子                                                                                                                                            | 约定                                                                                         |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| 布局结构常量       | 主窗口 56 / 240 两列, 二级菜单 56 高标题行, 页面 `Padding="32"`, `Spacing="16"`                                                                     | 可以写死. 写在同一行或紧邻的注释里说明结构用途; 能自然换成 `A.Space.*` / `A.Size.*` 时优先换 |
| 组件尺寸与内部间距 | 导航项 40×40, `Margin="8,2"`, `CornerRadius="8"`, 图标 20, 菜单项 `MinHeight="36"`, `Padding="12,0"`, 按钮 `MinHeight="{StaticResource A.Size.32}"` | 优先 token. 新增代码不要再引入新的字面量; 改动现有组件时顺手收敛, 不要为此单独重构整个外壳   |
| 颜色, 画刷, 透明   | 任何 `#RRGGBB`, `Transparent`, `SolidColorBrush`, `LinearGradientBrush`                                                                             | 视图禁止. 只能来自语义层                                                                     |

这条边界的目的不是让所有数字都变成 token, 而是让"哪些数字属于设计系统, 哪些属于布局结构"可以被评审判断.

## 8. 何时新增 token

满足以下条件之一再新增:

- 现有色阶或尺度无法表达需要的层级, 且这个值会被多个语义键复用;
- 新增一个色相族或新增一档字号, 行高, 圆角, 属于整体尺度调整;
- 新的动效时长或新的组件尺寸档位, 且不是单页一次性的值.

不应该新增的情况:

- 只为一个页面, 一个按钮的某次微调新增值; 先用现有档位或调整语义键;
- 想用 token 表达用途 (例如 `A.Card.Padding`); 用途属于语义层;
- 为了绕过视图禁止颜色 token 的规则而新增"度量化"的颜色.

新增流程见[维护手册](maintenance.md#41-新增原子-token).

