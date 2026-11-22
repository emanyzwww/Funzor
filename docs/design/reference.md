# 设计系统全量参考

> 生成物, 请勿手改.  
> 重新生成: <code>pwsh scripts/gen-design-reference.ps1</code>  
> 校验: <code>pwsh scripts/gen-design-reference.ps1 -Check</code> (PR CI 会执行)  
> 事实来源: <code>Funzor/Themes/Tokens.xaml</code>, <code>Theme.Light.xaml</code>, <code>Theme.Dark.xaml</code>, <code>Controls.xaml</code>, <code>Icons.xaml</code>, <code>scripts/check-design-system.ps1</code>.  

说明: 本文件由脚本从上述源文件解析生成, 不包含生成时间, 便于在 PR 中做无差异比对.  

## 统计

| 项 | 数量 |
| --- | --- |
| 原子 token | 208 |
| 语义键 (Light / Dark) | 306 / 306 |
| 区域 | 16 |
| 组件区域 | 4 |
| 受检 XAML 文件 | 8 (含 Controls.xaml) |
| 控件样式 | 7 |
| 图标模板 | 3 |

## 1. 原子 Token

### 1.1 颜色

| 键 | 值 |
| --- | --- |
| <code>A.Neutral.0</code> | #FFFFFF |
| <code>A.Neutral.25</code> | #FDFCFA |
| <code>A.Neutral.50</code> | #FBFAF6 |
| <code>A.Neutral.75</code> | #F8F6F2 |
| <code>A.Neutral.100</code> | #F4F3EE |
| <code>A.Neutral.125</code> | #F2F0EB |
| <code>A.Neutral.150</code> | #F0EDE8 |
| <code>A.Neutral.175</code> | #EEEAE5 |
| <code>A.Neutral.200</code> | #EBE8E2 |
| <code>A.Neutral.225</code> | #E5E2DC |
| <code>A.Neutral.250</code> | #DFDCD5 |
| <code>A.Neutral.275</code> | #D9D6CF |
| <code>A.Neutral.300</code> | #D3D0C9 |
| <code>A.Neutral.325</code> | #CAC8C0 |
| <code>A.Neutral.350</code> | #C2BFB8 |
| <code>A.Neutral.375</code> | #BAB7B0 |
| <code>A.Neutral.400</code> | #B2AFA7 |
| <code>A.Neutral.425</code> | #A9A69E |
| <code>A.Neutral.450</code> | #A09D95 |
| <code>A.Neutral.475</code> | #98948C |
| <code>A.Neutral.500</code> | #8F8C84 |
| <code>A.Neutral.525</code> | #86847C |
| <code>A.Neutral.550</code> | #7E7C74 |
| <code>A.Neutral.575</code> | #76746C |
| <code>A.Neutral.600</code> | #6E6C65 |
| <code>A.Neutral.625</code> | #66645E |
| <code>A.Neutral.650</code> | #5F5C56 |
| <code>A.Neutral.675</code> | #57544E |
| <code>A.Neutral.700</code> | #4F4D47 |
| <code>A.Neutral.725</code> | #484640 |
| <code>A.Neutral.750</code> | #403F39 |
| <code>A.Neutral.775</code> | #393832 |
| <code>A.Neutral.800</code> | #32312C |
| <code>A.Neutral.825</code> | #2C2A26 |
| <code>A.Neutral.850</code> | #262421 |
| <code>A.Neutral.875</code> | #201E1C |
| <code>A.Neutral.900</code> | #1A1916 |
| <code>A.Neutral.925</code> | #141310 |
| <code>A.Neutral.950</code> | #0E0D0B |
| <code>A.Neutral.975</code> | #070606 |
| <code>A.Neutral.1000</code> | #000000 |
| <code>A.Coral.50</code> | #FFF1ED |
| <code>A.Coral.100</code> | #FFE0D7 |
| <code>A.Coral.200</code> | #FFC2B2 |
| <code>A.Coral.300</code> | #FF9C82 |
| <code>A.Coral.400</code> | #FF6F52 |
| <code>A.Coral.500</code> | #FF4F2E |
| <code>A.Coral.600</code> | #E03A1B |
| <code>A.Coral.700</code> | #B82B12 |
| <code>A.Coral.800</code> | #8C1F0C |
| <code>A.Coral.900</code> | #5E1408 |
| <code>A.Magenta.50</code> | #FDF0F7 |
| <code>A.Magenta.100</code> | #FBDCEB |
| <code>A.Magenta.200</code> | #F6B7D6 |
| <code>A.Magenta.300</code> | #EF8ABD |
| <code>A.Magenta.400</code> | #EF4BA6 |
| <code>A.Magenta.500</code> | #E33D9A |
| <code>A.Magenta.600</code> | #C22480 |
| <code>A.Magenta.700</code> | #9C1663 |
| <code>A.Magenta.800</code> | #741049 |
| <code>A.Magenta.900</code> | #4B0A2F |
| <code>A.Blue.50</code> | #EEF2FF |
| <code>A.Blue.100</code> | #DDE6FF |
| <code>A.Blue.200</code> | #C2D1FF |
| <code>A.Blue.300</code> | #9FB4FF |
| <code>A.Blue.400</code> | #6F8CFF |
| <code>A.Blue.500</code> | #2F5CFF |
| <code>A.Blue.600</code> | #1F43C9 |
| <code>A.Blue.700</code> | #16339C |
| <code>A.Blue.800</code> | #102470 |
| <code>A.Blue.900</code> | #0A1845 |
| <code>A.Purple.50</code> | #F3EFFF |
| <code>A.Purple.100</code> | #E7DCFF |
| <code>A.Purple.200</code> | #D0BDFF |
| <code>A.Purple.300</code> | #B295FF |
| <code>A.Purple.400</code> | #9673FF |
| <code>A.Purple.500</code> | #7A4DFF |
| <code>A.Purple.600</code> | #5C30D6 |
| <code>A.Purple.700</code> | #4721A8 |
| <code>A.Purple.800</code> | #33167A |
| <code>A.Purple.900</code> | #210E4D |
| <code>A.Cyan.50</code> | #E6FAFD |
| <code>A.Cyan.100</code> | #C2F3F9 |
| <code>A.Cyan.200</code> | #8AE8F2 |
| <code>A.Cyan.300</code> | #4DD8E8 |
| <code>A.Cyan.400</code> | #1AC8DC |
| <code>A.Cyan.500</code> | #00BCD4 |
| <code>A.Cyan.600</code> | #0099AD |
| <code>A.Cyan.700</code> | #007586 |
| <code>A.Cyan.800</code> | #005460 |
| <code>A.Cyan.900</code> | #00343C |
| <code>A.Green.50</code> | #E8F6EE |
| <code>A.Green.100</code> | #D0EDDD |
| <code>A.Green.200</code> | #A2DBBD |
| <code>A.Green.300</code> | #6FD39C |
| <code>A.Green.400</code> | #3FB379 |
| <code>A.Green.500</code> | #177245 |
| <code>A.Green.600</code> | #125C38 |
| <code>A.Green.700</code> | #0D452A |
| <code>A.Green.800</code> | #0D3423 |
| <code>A.Green.900</code> | #12291E |
| <code>A.Amber.50</code> | #FFF3E2 |
| <code>A.Amber.100</code> | #FFE6C7 |
| <code>A.Amber.200</code> | #FFD08F |
| <code>A.Amber.300</code> | #F7BD6C |
| <code>A.Amber.400</code> | #F0B45E |
| <code>A.Amber.500</code> | #D18A1E |
| <code>A.Amber.600</code> | #9A5B00 |
| <code>A.Amber.700</code> | #7A4700 |
| <code>A.Amber.800</code> | #573200 |
| <code>A.Amber.900</code> | #2C2111 |
| <code>A.Red.50</code> | #FDECEC |
| <code>A.Red.100</code> | #FBD9D9 |
| <code>A.Red.200</code> | #F5B5B5 |
| <code>A.Red.300</code> | #F08A8A |
| <code>A.Red.400</code> | #E56A6A |
| <code>A.Red.500</code> | #CF3F3F |
| <code>A.Red.600</code> | #A72F2F |
| <code>A.Red.700</code> | #802222 |
| <code>A.Red.800</code> | #591717 |
| <code>A.Red.900</code> | #2E1616 |
| <code>A.Transparent</code> | #00000000 |
| <code>A.White.A04</code> | #0AFFFFFF |
| <code>A.White.A08</code> | #14FFFFFF |
| <code>A.White.A12</code> | #1FFFFFFF |
| <code>A.White.A16</code> | #29FFFFFF |
| <code>A.White.A24</code> | #3DFFFFFF |
| <code>A.White.A40</code> | #66FFFFFF |
| <code>A.White.A64</code> | #A3FFFFFF |
| <code>A.White.A80</code> | #CCFFFFFF |
| <code>A.Black.A04</code> | #0A000000 |
| <code>A.Black.A08</code> | #14000000 |
| <code>A.Black.A12</code> | #1F000000 |
| <code>A.Black.A16</code> | #29000000 |
| <code>A.Black.A24</code> | #3D000000 |
| <code>A.Black.A40</code> | #66000000 |
| <code>A.Black.A64</code> | #A3000000 |
| <code>A.Black.A80</code> | #CC000000 |

### 1.2 度量

| 键 | 类型 | 值 |
| --- | --- | --- |
| <code>A.Space.0</code> | Double | 0 |
| <code>A.Space.2</code> | Double | 2 |
| <code>A.Space.4</code> | Double | 4 |
| <code>A.Space.8</code> | Double | 8 |
| <code>A.Space.12</code> | Double | 12 |
| <code>A.Space.16</code> | Double | 16 |
| <code>A.Space.20</code> | Double | 20 |
| <code>A.Space.24</code> | Double | 24 |
| <code>A.Space.32</code> | Double | 32 |
| <code>A.Space.40</code> | Double | 40 |
| <code>A.Space.48</code> | Double | 48 |
| <code>A.Space.64</code> | Double | 64 |
| <code>A.Space.96</code> | Double | 96 |
| <code>A.Pad.2</code> | Thickness | 2 |
| <code>A.Pad.4</code> | Thickness | 4 |
| <code>A.Pad.8</code> | Thickness | 8 |
| <code>A.Pad.12</code> | Thickness | 12 |
| <code>A.Pad.16</code> | Thickness | 16 |
| <code>A.Pad.20</code> | Thickness | 20 |
| <code>A.Pad.24</code> | Thickness | 24 |
| <code>A.Pad.32</code> | Thickness | 32 |
| <code>A.Stroke.1</code> | Thickness | 1 |
| <code>A.Stroke.2</code> | Thickness | 2 |
| <code>A.Size.1</code> | Double | 1 |
| <code>A.Size.2</code> | Double | 2 |
| <code>A.Size.4</code> | Double | 4 |
| <code>A.Size.8</code> | Double | 8 |
| <code>A.Size.12</code> | Double | 12 |
| <code>A.Size.16</code> | Double | 16 |
| <code>A.Size.20</code> | Double | 20 |
| <code>A.Size.24</code> | Double | 24 |
| <code>A.Size.32</code> | Double | 32 |
| <code>A.Size.40</code> | Double | 40 |
| <code>A.Size.48</code> | Double | 48 |
| <code>A.Size.56</code> | Double | 56 |
| <code>A.Size.64</code> | Double | 64 |
| <code>A.Size.72</code> | Double | 72 |
| <code>A.Size.80</code> | Double | 80 |
| <code>A.Size.96</code> | Double | 96 |
| <code>A.Size.128</code> | Double | 128 |
| <code>A.Radius.0</code> | CornerRadius | 0 |
| <code>A.Radius.2</code> | CornerRadius | 2 |
| <code>A.Radius.4</code> | CornerRadius | 4 |
| <code>A.Radius.6</code> | CornerRadius | 6 |
| <code>A.Radius.8</code> | CornerRadius | 8 |
| <code>A.Radius.12</code> | CornerRadius | 12 |
| <code>A.Radius.16</code> | CornerRadius | 16 |
| <code>A.Radius.20</code> | CornerRadius | 20 |
| <code>A.Radius.24</code> | CornerRadius | 24 |
| <code>A.Radius.Full</code> | CornerRadius | 9999 |
| <code>A.FontSize.11</code> | Double | 11 |
| <code>A.FontSize.12</code> | Double | 12 |
| <code>A.FontSize.14</code> | Double | 14 |
| <code>A.FontSize.16</code> | Double | 16 |
| <code>A.FontSize.20</code> | Double | 20 |
| <code>A.FontSize.24</code> | Double | 24 |
| <code>A.FontSize.32</code> | Double | 32 |
| <code>A.FontSize.40</code> | Double | 40 |
| <code>A.LineHeight.16</code> | Double | 16 |
| <code>A.LineHeight.20</code> | Double | 20 |
| <code>A.LineHeight.24</code> | Double | 24 |
| <code>A.LineHeight.28</code> | Double | 28 |
| <code>A.LineHeight.32</code> | Double | 32 |
| <code>A.LineHeight.36</code> | Double | 36 |
| <code>A.Duration.0</code> | Double | 0 |
| <code>A.Duration.100</code> | Double | 100 |
| <code>A.Duration.150</code> | Double | 150 |
| <code>A.Duration.200</code> | Double | 200 |
| <code>A.Duration.300</code> | Double | 300 |
| <code>A.Duration.400</code> | Double | 400 |

## 2. 语义键

### 2.1 区域汇总

| 区域 | Owner | Light 键 | Dark 键 |
| --- | --- | --- | --- |
| Foundation | 所有视图与原生控件 | 30 | 30 |
| TitleBar | Views/Shell/TitleBar.xaml | 7 | 7 |
| PrimaryNav | Views/Shell/NavigationRail.xaml | 22 | 22 |
| SecondaryNav | Views/Shell/SectionPanel.xaml | 23 | 23 |
| Content | Views/MainWindow.xaml, Views/Pages/* | 1 | 1 |
| Page | Views/Pages/* | 12 | 12 |
| Card | 内容页 | 8 | 8 |
| Button | Themes/Controls.xaml, 内容页 | 30 | 30 |
| Form | 内容页, Themes/Controls.xaml | 17 | 17 |
| Setting | 内容页 | 14 | 14 |
| Status | 内容页 | 25 | 25 |
| Dialog | ContentDialog 调用方 | 5 | 5 |
| ContextMenu | MenuFlyout 调用方 | 9 | 9 |
| Tooltip | ToolTip 调用方 | 3 | 3 |
| EmptyState | 内容页 | 3 | 3 |
| Bridge | Windows App SDK 2.6.5 原生模板 | 97 | 97 |

### 2.2 区域明细

#### Foundation

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Foundation.Canvas.Background</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Foundation.Surface.Base.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.875</code> #201E1C |  |
| <code>Foundation.Track.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Foundation.Scrim.Background</code> | <code>A.Black.A40</code> #66000000 | <code>A.Black.A64</code> #A3000000 |  |
| <code>Foundation.Text.Primary</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Foundation.Text.Secondary</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Foundation.Text.Tertiary</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>Foundation.Text.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Foundation.Text.Link</code> | <code>A.Blue.600</code> #1F43C9 | <code>A.Blue.300</code> #9FB4FF |  |
| <code>Foundation.Text.Link.Hover</code> | <code>A.Blue.700</code> #16339C | <code>A.Blue.200</code> #C2D1FF |  |
| <code>Foundation.Text.Emphasis</code> | <code>A.Coral.700</code> #B82B12 | <code>A.Coral.300</code> #FF9C82 |  |
| <code>Foundation.Text.Code</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>Foundation.Border.Default</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.800</code> #32312C |  |
| <code>Foundation.Border.Subtle</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Foundation.Border.Strong</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>Foundation.Border.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Foundation.Focus.Ring</code> | <code>A.Blue.500</code> #2F5CFF | <code>A.Blue.300</code> #9FB4FF |  |
| <code>Foundation.Focus.Offset</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Foundation.Scroll.Thumb</code> | <code>A.Black.A24</code> #3D000000 | <code>A.White.A24</code> #3DFFFFFF |  |
| <code>Foundation.Scroll.Thumb.Hover</code> | <code>A.Black.A40</code> #66000000 | <code>A.White.A40</code> #66FFFFFF |  |
| <code>Foundation.Scroll.Thumb.Pressed</code> | <code>A.Black.A64</code> #A3000000 | <code>A.White.A64</code> #A3FFFFFF |  |
| <code>Foundation.Scroll.Thumb.Disabled</code> | <code>A.Black.A12</code> #1F000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>Foundation.Scroll.Track</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Foundation.Accent.Default.Background</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Foundation.Accent.Hover.Background</code> | <code>A.Neutral.750</code> #403F39 | <code>A.Neutral.0</code> #FFFFFF |  |
| <code>Foundation.Accent.Pressed.Background</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>Foundation.Accent.Disabled.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Foundation.Accent.On.Foreground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Foundation.Accent.OnDisabled.Foreground</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Foundation.Selection.Background</code> | <code>A.Neutral.225</code> #E5E2DC | <code>A.Neutral.750</code> #403F39 |  |

#### TitleBar

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>TitleBar.Background</code> | <code>A.Neutral.50</code> #FBFAF6 | <code>A.Neutral.875</code> #201E1C |  |
| <code>TitleBar.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.800</code> #32312C |  |
| <code>TitleBar.Title.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>TitleBar.Button.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>TitleBar.Button.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>TitleBar.Button.Background.Pressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>TitleBar.Button.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |

#### PrimaryNav

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>PrimaryNav.Background</code> | <code>A.Neutral.925</code> #141310 | <code>A.Neutral.925</code> #141310 |  |
| <code>PrimaryNav.Item.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>PrimaryNav.Item.Background.Hover</code> | <code>A.White.A12</code> #1FFFFFFF | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>PrimaryNav.Item.Background.Pressed</code> | <code>A.White.A16</code> #29FFFFFF | <code>A.White.A16</code> #29FFFFFF |  |
| <code>PrimaryNav.Item.Background.Selected</code> | <code>A.White.A16</code> #29FFFFFF | <code>A.White.A16</code> #29FFFFFF |  |
| <code>PrimaryNav.Item.Foreground</code> | <code>A.Neutral.400</code> #B2AFA7 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>PrimaryNav.Item.Foreground.Hover</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>PrimaryNav.Item.Foreground.Selected</code> | <code>A.Neutral.100</code> #F4F3EE | <code>A.Neutral.100</code> #F4F3EE |  |
| <code>PrimaryNav.Item.Foreground.Disabled</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>PrimaryNav.Focus.Ring</code> | <code>A.Blue.300</code> #9FB4FF | <code>A.Blue.300</code> #9FB4FF |  |
| <code>PrimaryNav.Focus.Offset</code> | <code>A.Neutral.925</code> #141310 | <code>A.Neutral.925</code> #141310 |  |
| <code>PrimaryNav.Separator</code> | <code>A.Neutral.800</code> #32312C | <code>A.Neutral.800</code> #32312C | reserved |
| <code>PrimaryNav.Badge.Background</code> | <code>A.Coral.500</code> #FF4F2E | <code>A.Coral.500</code> #FF4F2E |  |
| <code>PrimaryNav.Badge.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.900</code> #1A1916 |  |
| <code>PrimaryNav.Tooltip.Background</code> | <code>A.Neutral.100</code> #F4F3EE | <code>A.Neutral.100</code> #F4F3EE |  |
| <code>PrimaryNav.Tooltip.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.900</code> #1A1916 |  |
| <code>PrimaryNav.Tooltip.Border</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.250</code> #DFDCD5 |  |
| <code>PrimaryNav.Scroll.Thumb</code> | <code>A.White.A24</code> #3DFFFFFF | <code>A.White.A24</code> #3DFFFFFF |  |
| <code>PrimaryNav.Scroll.Thumb.Hover</code> | <code>A.White.A40</code> #66FFFFFF | <code>A.White.A40</code> #66FFFFFF |  |
| <code>PrimaryNav.Scroll.Thumb.Pressed</code> | <code>A.White.A64</code> #A3FFFFFF | <code>A.White.A64</code> #A3FFFFFF |  |
| <code>PrimaryNav.Scroll.Track</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>PrimaryNav.Empty.Foreground</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.450</code> #A09D95 |  |

#### SecondaryNav

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>SecondaryNav.Background</code> | <code>A.Neutral.100</code> #F4F3EE | <code>A.Neutral.850</code> #262421 |  |
| <code>SecondaryNav.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.800</code> #32312C |  |
| <code>SecondaryNav.Header.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>SecondaryNav.Header.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 | reserved |
| <code>SecondaryNav.Item.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>SecondaryNav.Item.Background.Hover</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>SecondaryNav.Item.Background.Pressed</code> | <code>A.Black.A12</code> #1F000000 | <code>A.White.A16</code> #29FFFFFF |  |
| <code>SecondaryNav.Item.Background.Selected</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.800</code> #32312C |  |
| <code>SecondaryNav.Item.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>SecondaryNav.Item.Foreground.Hover</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>SecondaryNav.Item.Foreground.Selected</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>SecondaryNav.Item.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>SecondaryNav.Item.Secondary.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>SecondaryNav.Group.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>SecondaryNav.Group.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>SecondaryNav.Badge.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.825</code> #2C2A26 |  |
| <code>SecondaryNav.Badge.Foreground</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>SecondaryNav.Focus.Ring</code> | <code>A.Blue.500</code> #2F5CFF | <code>A.Blue.300</code> #9FB4FF |  |
| <code>SecondaryNav.Focus.Offset</code> | <code>A.Neutral.100</code> #F4F3EE | <code>A.Neutral.850</code> #262421 |  |
| <code>SecondaryNav.Tooltip.Background</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.800</code> #32312C | reserved |
| <code>SecondaryNav.Tooltip.Foreground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.50</code> #FBFAF6 | reserved |
| <code>SecondaryNav.Tooltip.Border</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.700</code> #4F4D47 | reserved |
| <code>SecondaryNav.Empty.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |

#### Content

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Content.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.900</code> #1A1916 |  |

#### Page

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Page.Title.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Page.Description.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Page.SectionTitle.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Page.SectionDescription.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Page.Breadcrumb.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>Page.Breadcrumb.Foreground.Hover</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Page.Breadcrumb.Separator</code> | <code>A.Neutral.400</code> #B2AFA7 | <code>A.Neutral.650</code> #5F5C56 |  |
| <code>Page.Tab.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Page.Tab.Foreground.Selected</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Page.Tab.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>Page.Tab.Indicator</code> | <code>A.Coral.600</code> #E03A1B | <code>A.Coral.400</code> #FF6F52 |  |
| <code>Page.Tab.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 |  |

#### Card

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Card.Background</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.875</code> #201E1C |  |
| <code>Card.Border</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.800</code> #32312C |  |
| <code>Card.Background.Hover</code> | <code>A.Neutral.50</code> #FBFAF6 | <code>A.Neutral.850</code> #262421 |  |
| <code>Card.Border.Hover</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>Card.Header.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Card.Description.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Card.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 |  |
| <code>Card.Footer.Background</code> | <code>A.Neutral.50</code> #FBFAF6 | <code>A.Neutral.900</code> #1A1916 |  |

#### Button

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Button.Primary.Background</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Button.Primary.Background.Hover</code> | <code>A.Neutral.750</code> #403F39 | <code>A.Neutral.0</code> #FFFFFF |  |
| <code>Button.Primary.Background.Pressed</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>Button.Primary.Background.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Button.Primary.Foreground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Button.Primary.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Button.Primary.Border</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Button.Secondary.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Button.Secondary.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>Button.Secondary.Background.Pressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>Button.Secondary.Background.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Button.Secondary.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Button.Secondary.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Button.Secondary.Border</code> | <code>A.Neutral.500</code> #8F8C84 | <code>A.Neutral.600</code> #6E6C65 |  |
| <code>Button.Secondary.Border.Hover</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>Button.Secondary.Border.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Button.Ghost.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Button.Ghost.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>Button.Ghost.Background.Pressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>Button.Ghost.Background.Disabled</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Button.Ghost.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Button.Ghost.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Button.Ghost.Border</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Button.Danger.Background</code> | <code>A.Red.500</code> #CF3F3F | <code>A.Red.500</code> #CF3F3F |  |
| <code>Button.Danger.Background.Hover</code> | <code>A.Red.600</code> #A72F2F | <code>A.Red.600</code> #A72F2F |  |
| <code>Button.Danger.Background.Pressed</code> | <code>A.Red.700</code> #802222 | <code>A.Red.700</code> #802222 |  |
| <code>Button.Danger.Background.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Button.Danger.Foreground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.0</code> #FFFFFF |  |
| <code>Button.Danger.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Button.Danger.Border</code> | <code>A.Red.500</code> #CF3F3F | <code>A.Red.500</code> #CF3F3F |  |

#### Form

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Form.Input.Background</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.925</code> #141310 |  |
| <code>Form.Input.Background.Hover</code> | <code>A.Neutral.50</code> #FBFAF6 | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Form.Input.Background.Focus</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Form.Input.Background.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Form.Input.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Form.Input.Placeholder.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>Form.Input.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>Form.Input.Border</code> | <code>A.Neutral.500</code> #8F8C84 | <code>A.Neutral.600</code> #6E6C65 |  |
| <code>Form.Input.Border.Hover</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>Form.Input.Border.Focus</code> | <code>A.Blue.500</code> #2F5CFF | <code>A.Blue.300</code> #9FB4FF |  |
| <code>Form.Input.Border.Disabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 |  |
| <code>Form.Input.Border.Error</code> | <code>A.Red.500</code> #CF3F3F | <code>A.Red.500</code> #CF3F3F |  |
| <code>Form.Label.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Form.Help.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>Form.Error.Foreground</code> | <code>A.Red.600</code> #A72F2F | <code>A.Red.300</code> #F08A8A |  |
| <code>Form.Choice.Background.Checked</code> | <code>A.Coral.500</code> #FF4F2E | <code>A.Coral.500</code> #FF4F2E | reserved |
| <code>Form.Choice.Foreground.Checked</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.900</code> #1A1916 | reserved |

#### Setting

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Setting.Row.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>Setting.Row.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>Setting.Row.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 |  |
| <code>Setting.Row.Title.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Setting.Row.Description.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Setting.Group.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>Setting.Danger.Background</code> | <code>A.Red.50</code> #FDECEC | <code>A.Red.900</code> #2E1616 |  |
| <code>Setting.Danger.Border</code> | <code>A.Red.200</code> #F5B5B5 | <code>A.Red.700</code> #802222 |  |
| <code>Setting.Danger.Title.Foreground</code> | <code>A.Red.600</code> #A72F2F | <code>A.Red.300</code> #F08A8A |  |
| <code>Setting.Danger.Description.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Setting.Toggle.Background</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | reserved |
| <code>Setting.Toggle.Background.Checked</code> | <code>A.Coral.500</code> #FF4F2E | <code>A.Coral.500</code> #FF4F2E | reserved |
| <code>Setting.Toggle.Thumb.Checked</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.900</code> #1A1916 | reserved |
| <code>Setting.Toggle.Border.Checked</code> | <code>A.Coral.500</code> #FF4F2E | <code>A.Coral.500</code> #FF4F2E | reserved |

#### Status

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Status.Success.Foreground</code> | <code>A.Green.500</code> #177245 | <code>A.Green.300</code> #6FD39C |  |
| <code>Status.Success.Background</code> | <code>A.Green.50</code> #E8F6EE | <code>A.Green.900</code> #12291E |  |
| <code>Status.Success.Border</code> | <code>A.Green.200</code> #A2DBBD | <code>A.Green.700</code> #0D452A |  |
| <code>Status.Success.Solid</code> | <code>A.Green.500</code> #177245 | <code>A.Green.300</code> #6FD39C |  |
| <code>Status.Success.OnSolid</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Status.Warn.Foreground</code> | <code>A.Amber.600</code> #9A5B00 | <code>A.Amber.400</code> #F0B45E |  |
| <code>Status.Warn.Background</code> | <code>A.Amber.50</code> #FFF3E2 | <code>A.Amber.900</code> #2C2111 |  |
| <code>Status.Warn.Border</code> | <code>A.Amber.200</code> #FFD08F | <code>A.Amber.700</code> #7A4700 |  |
| <code>Status.Warn.Solid</code> | <code>A.Amber.600</code> #9A5B00 | <code>A.Amber.400</code> #F0B45E |  |
| <code>Status.Warn.OnSolid</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Status.Danger.Foreground</code> | <code>A.Red.600</code> #A72F2F | <code>A.Red.300</code> #F08A8A |  |
| <code>Status.Danger.Background</code> | <code>A.Red.50</code> #FDECEC | <code>A.Red.900</code> #2E1616 |  |
| <code>Status.Danger.Border</code> | <code>A.Red.200</code> #F5B5B5 | <code>A.Red.700</code> #802222 |  |
| <code>Status.Danger.Solid</code> | <code>A.Red.500</code> #CF3F3F | <code>A.Red.300</code> #F08A8A |  |
| <code>Status.Danger.OnSolid</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Status.Info.Foreground</code> | <code>A.Blue.600</code> #1F43C9 | <code>A.Blue.300</code> #9FB4FF |  |
| <code>Status.Info.Background</code> | <code>A.Blue.50</code> #EEF2FF | <code>A.Blue.900</code> #0A1845 |  |
| <code>Status.Info.Border</code> | <code>A.Blue.200</code> #C2D1FF | <code>A.Blue.700</code> #16339C |  |
| <code>Status.Info.Solid</code> | <code>A.Blue.600</code> #1F43C9 | <code>A.Blue.300</code> #9FB4FF |  |
| <code>Status.Info.OnSolid</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |
| <code>Status.Neutral.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.300</code> #D3D0C9 |  |
| <code>Status.Neutral.Background</code> | <code>A.Neutral.100</code> #F4F3EE | <code>A.Neutral.850</code> #262421 |  |
| <code>Status.Neutral.Border</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 |  |
| <code>Status.Neutral.Solid</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Status.Neutral.OnSolid</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 |  |

#### Dialog

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Dialog.Background</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.825</code> #2C2A26 |  |
| <code>Dialog.Border</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 |  |
| <code>Dialog.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Dialog.Content.Foreground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 |  |
| <code>Dialog.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 |  |

#### ContextMenu

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>ContextMenu.Background</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.825</code> #2C2A26 |  |
| <code>ContextMenu.Border</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 |  |
| <code>ContextMenu.Item.Background</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 |  |
| <code>ContextMenu.Item.Background.Hover</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF |  |
| <code>ContextMenu.Item.Background.Pressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF |  |
| <code>ContextMenu.Item.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>ContextMenu.Item.Foreground.Disabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E |  |
| <code>ContextMenu.Item.Secondary.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |
| <code>ContextMenu.Separator</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 |  |

#### Tooltip

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>Tooltip.Background</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.775</code> #393832 |  |
| <code>Tooltip.Foreground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>Tooltip.Border</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.700</code> #4F4D47 |  |

#### EmptyState

| 键 | Light | Dark | 备注 |
| --- | --- | --- | --- |
| <code>EmptyState.Icon.Foreground</code> | <code>A.Neutral.400</code> #B2AFA7 | <code>A.Neutral.650</code> #5F5C56 |  |
| <code>EmptyState.Title.Foreground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 |  |
| <code>EmptyState.Description.Foreground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 |  |

### 2.3 Bridge

| 键 | Light | Dark | Owner |
| --- | --- | --- | --- |
| <code>TextFillColorPrimaryBrush</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Foundation.Text.Primary |
| <code>TextFillColorSecondaryBrush</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 | Foundation.Text.Secondary |
| <code>TextFillColorTertiaryBrush</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 | Foundation.Text.Tertiary |
| <code>TextFillColorDisabledBrush</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Foundation.Text.Disabled |
| <code>FocusStrokeColorOuterBrush</code> | <code>A.Blue.500</code> #2F5CFF | <code>A.Blue.300</code> #9FB4FF | Foundation.Focus.Ring |
| <code>FocusStrokeColorInnerBrush</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Foundation.Focus.Offset |
| <code>ControlStrokeColorDefaultBrush</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.800</code> #32312C | Foundation.Border.Default |
| <code>ControlStrokeColorSecondaryBrush</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Foundation.Border.Subtle |
| <code>ControlStrongStrokeColorDefaultBrush</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 | Foundation.Border.Strong |
| <code>ControlStrongStrokeColorDisabledBrush</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Foundation.Border.Disabled |
| <code>DividerStrokeColorDefaultBrush</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Foundation.Border.Subtle |
| <code>AccentFillColorDefaultBrush</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Foundation.Accent.Default.Background |
| <code>AccentFillColorSecondaryBrush</code> | <code>A.Neutral.750</code> #403F39 | <code>A.Neutral.0</code> #FFFFFF | Foundation.Accent.Hover.Background |
| <code>AccentFillColorTertiaryBrush</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 | Foundation.Accent.Pressed.Background |
| <code>AccentFillColorDisabledBrush</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Foundation.Accent.Disabled.Background |
| <code>TextOnAccentFillColorPrimaryBrush</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Foundation.Accent.On.Foreground |
| <code>TextOnAccentFillColorSecondaryBrush</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Foundation.Accent.On.Foreground |
| <code>TextOnAccentFillColorDisabledBrush</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Foundation.Accent.OnDisabled.Foreground |
| <code>AccentFillColorSelectedTextBackgroundBrush</code> | <code>A.Neutral.225</code> #E5E2DC | <code>A.Neutral.750</code> #403F39 | Foundation.Selection.Background |
| <code>TextOnAccentFillColorSelectedTextBrush</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Foundation.Text.Primary |
| <code>ButtonBackground</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Secondary.Background |
| <code>ButtonBackgroundPointerOver</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF | Button.Secondary.Background.Hover |
| <code>ButtonBackgroundPressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF | Button.Secondary.Background.Pressed |
| <code>ButtonBackgroundDisabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Button.Secondary.Background.Disabled |
| <code>ButtonForeground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Button.Secondary.Foreground |
| <code>ButtonForegroundPointerOver</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Button.Secondary.Foreground |
| <code>ButtonForegroundPressed</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Button.Secondary.Foreground |
| <code>ButtonForegroundDisabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Button.Secondary.Foreground.Disabled |
| <code>ButtonBorderBrush</code> | <code>A.Neutral.500</code> #8F8C84 | <code>A.Neutral.600</code> #6E6C65 | Button.Secondary.Border |
| <code>ButtonBorderBrushPointerOver</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 | Button.Secondary.Border.Hover |
| <code>ButtonBorderBrushPressed</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 | Button.Secondary.Border.Hover |
| <code>ButtonBorderBrushDisabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Button.Secondary.Border.Disabled |
| <code>AccentButtonBackground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Button.Primary.Background |
| <code>AccentButtonBackgroundPointerOver</code> | <code>A.Neutral.750</code> #403F39 | <code>A.Neutral.0</code> #FFFFFF | Button.Primary.Background.Hover |
| <code>AccentButtonBackgroundPressed</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.300</code> #D3D0C9 | Button.Primary.Background.Pressed |
| <code>AccentButtonBackgroundDisabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Button.Primary.Background.Disabled |
| <code>AccentButtonForeground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Button.Primary.Foreground |
| <code>AccentButtonForegroundPointerOver</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Button.Primary.Foreground |
| <code>AccentButtonForegroundPressed</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Button.Primary.Foreground |
| <code>AccentButtonForegroundDisabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Button.Primary.Foreground.Disabled |
| <code>AccentButtonBorderBrush</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Primary.Border |
| <code>AccentButtonBorderBrushPointerOver</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Primary.Border |
| <code>AccentButtonBorderBrushPressed</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Primary.Border |
| <code>AccentButtonBorderBrushDisabled</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Primary.Border |
| <code>SubtleButtonBackground</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Background |
| <code>SubtleButtonBackgroundPointerOver</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF | Button.Ghost.Background.Hover |
| <code>SubtleButtonBackgroundPressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF | Button.Ghost.Background.Pressed |
| <code>SubtleButtonBackgroundDisabled</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Background.Disabled |
| <code>SubtleButtonForeground</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 | Button.Ghost.Foreground |
| <code>SubtleButtonForegroundPointerOver</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 | Button.Ghost.Foreground |
| <code>SubtleButtonForegroundPressed</code> | <code>A.Neutral.650</code> #5F5C56 | <code>A.Neutral.400</code> #B2AFA7 | Button.Ghost.Foreground |
| <code>SubtleButtonForegroundDisabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Button.Ghost.Foreground.Disabled |
| <code>SubtleButtonBorderBrush</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Border |
| <code>SubtleButtonBorderBrushPointerOver</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Border |
| <code>SubtleButtonBorderBrushPressed</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Border |
| <code>SubtleButtonBorderBrushDisabled</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Button.Ghost.Border |
| <code>TextControlBackground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.925</code> #141310 | Form.Input.Background |
| <code>TextControlBackgroundPointerOver</code> | <code>A.Neutral.50</code> #FBFAF6 | <code>A.Neutral.900</code> #1A1916 | Form.Input.Background.Hover |
| <code>TextControlBackgroundFocused</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.900</code> #1A1916 | Form.Input.Background.Focus |
| <code>TextControlBackgroundDisabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Form.Input.Background.Disabled |
| <code>TextControlBorderBrush</code> | <code>A.Neutral.500</code> #8F8C84 | <code>A.Neutral.600</code> #6E6C65 | Form.Input.Border |
| <code>TextControlBorderBrushPointerOver</code> | <code>A.Neutral.300</code> #D3D0C9 | <code>A.Neutral.700</code> #4F4D47 | Form.Input.Border.Hover |
| <code>TextControlBorderBrushFocused</code> | <code>A.Blue.500</code> #2F5CFF | <code>A.Blue.300</code> #9FB4FF | Form.Input.Border.Focus |
| <code>TextControlBorderBrushDisabled</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Form.Input.Border.Disabled |
| <code>TextControlForeground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Form.Input.Foreground |
| <code>TextControlForegroundPointerOver</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Form.Input.Foreground |
| <code>TextControlForegroundFocused</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Form.Input.Foreground |
| <code>TextControlForegroundDisabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | Form.Input.Foreground.Disabled |
| <code>TextControlPlaceholderForeground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 | Form.Input.Placeholder.Foreground |
| <code>TextControlPlaceholderForegroundFocused</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 | Form.Input.Placeholder.Foreground |
| <code>ScrollBarThumbFill</code> | <code>A.Black.A24</code> #3D000000 | <code>A.White.A24</code> #3DFFFFFF | Foundation.Scroll.Thumb |
| <code>ScrollBarThumbFillPointerOver</code> | <code>A.Black.A40</code> #66000000 | <code>A.White.A40</code> #66FFFFFF | Foundation.Scroll.Thumb.Hover |
| <code>ScrollBarThumbFillPressed</code> | <code>A.Black.A64</code> #A3000000 | <code>A.White.A64</code> #A3FFFFFF | Foundation.Scroll.Thumb.Pressed |
| <code>ScrollBarThumbFillDisabled</code> | <code>A.Black.A12</code> #1F000000 | <code>A.White.A12</code> #1FFFFFFF | Foundation.Scroll.Thumb.Disabled |
| <code>ScrollBarTrackFill</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Foundation.Scroll.Track |
| <code>ScrollBarTrackFillPointerOver</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | Foundation.Scroll.Track |
| <code>ToolTipBackgroundBrush</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.775</code> #393832 | Tooltip.Background |
| <code>ToolTipForegroundBrush</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.50</code> #FBFAF6 | Tooltip.Foreground |
| <code>ToolTipBorderBrush</code> | <code>A.Neutral.700</code> #4F4D47 | <code>A.Neutral.700</code> #4F4D47 | Tooltip.Border |
| <code>ContentDialogBackground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.825</code> #2C2A26 | Dialog.Background |
| <code>ContentDialogBorderBrush</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 | Dialog.Border |
| <code>ContentDialogForeground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Dialog.Foreground |
| <code>ContentDialogSeparatorBorderBrush</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 | Dialog.Separator |
| <code>ContentDialogSmokeFill</code> | <code>A.Black.A40</code> #66000000 | <code>A.Black.A64</code> #A3000000 | Foundation.Scrim.Background |
| <code>MenuFlyoutPresenterBackground</code> | <code>A.Neutral.0</code> #FFFFFF | <code>A.Neutral.825</code> #2C2A26 | ContextMenu.Background |
| <code>MenuFlyoutPresenterBorderBrush</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.850</code> #262421 | ContextMenu.Border |
| <code>MenuFlyoutItemBackground</code> | <code>A.Transparent</code> #00000000 | <code>A.Transparent</code> #00000000 | ContextMenu.Item.Background |
| <code>MenuFlyoutItemBackgroundPointerOver</code> | <code>A.Black.A04</code> #0A000000 | <code>A.White.A08</code> #14FFFFFF | ContextMenu.Item.Background.Hover |
| <code>MenuFlyoutItemBackgroundPressed</code> | <code>A.Black.A08</code> #14000000 | <code>A.White.A12</code> #1FFFFFFF | ContextMenu.Item.Background.Pressed |
| <code>MenuFlyoutItemForeground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | ContextMenu.Item.Foreground |
| <code>MenuFlyoutItemForegroundPointerOver</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | ContextMenu.Item.Foreground |
| <code>MenuFlyoutItemForegroundDisabled</code> | <code>A.Neutral.450</code> #A09D95 | <code>A.Neutral.625</code> #66645E | ContextMenu.Item.Foreground.Disabled |
| <code>MenuFlyoutItemKeyboardAcceleratorTextForeground</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 | ContextMenu.Item.Secondary.Foreground |
| <code>MenuFlyoutItemKeyboardAcceleratorTextForegroundDisabled</code> | <code>A.Neutral.625</code> #66645E | <code>A.Neutral.450</code> #A09D95 | ContextMenu.Item.Secondary.Foreground |
| <code>MenuFlyoutSeparatorThemeBrush</code> | <code>A.Neutral.250</code> #DFDCD5 | <code>A.Neutral.700</code> #4F4D47 | ContextMenu.Separator |
| <code>ProgressBarForeground</code> | <code>A.Neutral.900</code> #1A1916 | <code>A.Neutral.50</code> #FBFAF6 | Foundation.Accent.Default.Background |
| <code>ProgressBarBackground</code> | <code>A.Neutral.200</code> #EBE8E2 | <code>A.Neutral.850</code> #262421 | Foundation.Track.Background |

## 3. 视图与区域权限

| 文件 | 允许区域 |
| --- | --- |
| <code>Funzor/Views/MainWindow.xaml</code> | Foundation, Content |
| <code>Funzor/Views/Pages/PlaceholderPage.xaml</code> | Foundation, Content, Page, Card, Button, Form, Setting, Status, Dialog, ContextMenu, Tooltip, EmptyState |
| <code>Funzor/Views/Shell/NavigationRail.xaml</code> | PrimaryNav, Foundation, Tooltip |
| <code>Funzor/Views/Shell/SectionPanel.xaml</code> | SecondaryNav, Foundation, Tooltip |
| <code>Funzor/Views/Shell/TitleBar.xaml</code> | TitleBar, Foundation, Tooltip |
| <code>Funzor/Controls/Navigation/PrimaryNavList.xaml</code> | PrimaryNav, Foundation |
| <code>Funzor/Controls/Navigation/SecondaryNavList.xaml</code> | SecondaryNav, Foundation |
| <code>Funzor/Themes/Controls.xaml</code> | Foundation, TitleBar, PrimaryNav, SecondaryNav, Content, Page, Card, Button, Form, Setting, Status, Dialog, ContextMenu, Tooltip, EmptyState |

### 3.1 区域映射规则

| 路径前缀 | 允许区域 |
| --- | --- |
| <code>Funzor/Controls/Navigation/PrimaryNavList.xaml</code> | PrimaryNav, Foundation |
| <code>Funzor/Controls/Navigation/SecondaryNavList.xaml</code> | SecondaryNav, Foundation |
| <code>Funzor/Views/Shell/TitleBar.xaml</code> | TitleBar, Foundation, Tooltip |
| <code>Funzor/Views/Shell/NavigationRail.xaml</code> | PrimaryNav, Foundation, Tooltip |
| <code>Funzor/Views/Shell/SectionPanel.xaml</code> | SecondaryNav, Foundation, Tooltip |
| <code>Funzor/Views/MainWindow.xaml</code> | Foundation, Content |
| <code>Funzor/Views/Pages/</code> | Foundation, Content, Page, Card, Button, Form, Setting, Status, Dialog, ContextMenu, Tooltip, EmptyState |

## 4. WinUI 资源白名单

视图可直接引用的 WinUI 原生键:

| 键 |
| --- |
| <code>SymbolThemeFontFamily</code> |
| <code>ContentControlThemeFontFamily</code> |
| <code>BodyTextBlockStyle</code> |
| <code>BodyStrongTextBlockStyle</code> |
| <code>BodyLargeTextBlockStyle</code> |
| <code>BodyLargeStrongTextBlockStyle</code> |
| <code>CaptionTextBlockStyle</code> |
| <code>SubtitleTextBlockStyle</code> |
| <code>TitleTextBlockStyle</code> |
| <code>TitleLargeTextBlockStyle</code> |
| <code>ControlFasterAnimationDuration</code> |
| <code>DisplayTextBlockStyle</code> |
| <code>BaseTextBlockStyle</code> |
| <code>ApplicationPageBackgroundThemeBrush</code> |

## 5. 控件样式

| 样式 | TargetType | BasedOn | 设置 |
| --- | --- | --- | --- |
| <code>PageTitleTextBlockStyle</code> | TextBlock | (无) | FontSize=A.FontSize.24; LineHeight=A.LineHeight.32; FontWeight=SemiBold; TextWrapping=NoWrap; Foreground=Foundation.Text.Primary |
| <code>PageDescriptionTextBlockStyle</code> | TextBlock | (无) | FontSize=A.FontSize.14; LineHeight=A.LineHeight.20; FontWeight=Normal; TextWrapping=Wrap; Foreground=Foundation.Text.Secondary |
| <code>SectionTitleTextBlockStyle</code> | TextBlock | (无) | FontSize=A.FontSize.20; LineHeight=A.LineHeight.28; FontWeight=SemiBold; TextWrapping=NoWrap; Foreground=Foundation.Text.Primary |
| <code>BodyTextBlockStyle</code> | TextBlock | (无) | FontSize=A.FontSize.14; LineHeight=A.LineHeight.20; FontWeight=Normal; TextWrapping=Wrap; Foreground=Foundation.Text.Primary |
| <code>CaptionTextBlockStyle</code> | TextBlock | (无) | FontSize=A.FontSize.12; LineHeight=A.LineHeight.16; FontWeight=Normal; TextWrapping=Wrap; Foreground=Foundation.Text.Secondary |
| <code>PrimaryButtonStyle</code> | Button | AccentButtonStyle | MinHeight=A.Size.32; Padding=14,0; CornerRadius=A.Radius.6; FontSize=A.FontSize.14; FontWeight=SemiBold |
| <code>SecondaryButtonStyle</code> | Button | DefaultButtonStyle | MinHeight=A.Size.32; Padding=14,0; CornerRadius=A.Radius.6; FontSize=A.FontSize.14; FontWeight=Normal |

## 6. 图标

| 模板 | TargetType |
| --- | --- |
| <code>Icon.Settings</code> | ContentControl |
| <code>Icon.Minimize</code> | ContentControl |
| <code>Icon.Close</code> | ContentControl |

源文件:

- <code>Funzor/Assets/Icons/Source/close_256_regular.svg</code>
- <code>Funzor/Assets/Icons/Source/minimize_256_regular.svg</code>
- <code>Funzor/Assets/Icons/Source/settings_256_regular.svg</code>

## 7. 校验清单

区域顺序 (<code>RegionManifest</code>):

    Foundation -> TitleBar -> PrimaryNav -> SecondaryNav -> Content -> Page -> Card -> Button -> Form -> Setting -> Status -> Dialog -> ContextMenu -> Tooltip -> EmptyState -> Bridge

组件区域 (<code>ComponentRegions</code>):

    Button, Form, Status, Tooltip

