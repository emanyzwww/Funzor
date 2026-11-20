<#
.SYNOPSIS
    校验 Funzor 设计系统: 语义层, 视图引用, WinUI 桥接.

.DESCRIPTION
    只用文本解析, 不依赖第三方库, 不要求 Windows.
    Windows 上本地运行: pwsh scripts/check-design-system.ps1
    CI 中运行:          pwsh scripts/check-design-system.ps1 -Format Text

.PARAMETER RepoRoot
    仓库根目录. 默认为脚本所在目录的上一级.

.PARAMETER Format
    控制台输出格式: Text 或 Json.

.PARAMETER ReportPath
    可选. 写入机器可读的 JSON 报告, 供 CI 归档.

.EXAMPLE
    pwsh scripts/check-design-system.ps1

.EXAMPLE
    pwsh scripts/check-design-system.ps1 -Format Json -ReportPath design-system-report.json
#>
[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [ValidateSet("Text", "Json")][string]$Format = "Text",
    [string]$ReportPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}
$RepoRoot = [System.IO.Path]::GetFullPath($RepoRoot)
if (-not (Test-Path -LiteralPath $RepoRoot)) {
    Write-Error "仓库根目录不存在: $RepoRoot"
    exit 2
}

$ThemeLightPath = Join-Path $RepoRoot "Funzor/Themes/Theme.Light.xaml"
$ThemeDarkPath = Join-Path $RepoRoot "Funzor/Themes/Theme.Dark.xaml"
$TokensPath = Join-Path $RepoRoot "Funzor/Themes/Tokens.xaml"
$ControlsPath = Join-Path $RepoRoot "Funzor/Themes/Controls.xaml"
$ViewsPath = Join-Path $RepoRoot "Funzor/Views"

foreach ($required in @($ThemeLightPath, $ThemeDarkPath, $TokensPath)) {
    if (-not (Test-Path -LiteralPath $required)) {
        Write-Error "缺少必需文件: $required"
        exit 2
    }
}

$RegionManifest = @(
    "Foundation", "TitleBar", "PrimaryNav", "SecondaryNav", "Content", "Page", "Card",
    "Button", "Form", "Setting", "Status", "Dialog", "ContextMenu", "Tooltip",
    "EmptyState", "Bridge"
)
$ProductRegions = @($RegionManifest | Where-Object { $_ -ne "Bridge" })
$ComponentRegions = @("Button", "Form", "Status", "Tooltip")
$ColorTokenPattern = "^A\.(Neutral|Coral|Blue|Purple|Cyan|Magenta|Green|Amber|Red|White|Black)\."
$MetricTokenPattern = "^A\.(Space|Pad|Stroke|Size|Radius|FontSize|LineHeight|FontWeight|Duration)\."
$PropertySegments = @(
    "Background", "Foreground", "Border", "Fill", "Indicator", "Separator",
    "Shadow", "Thumb", "Track", "Ring", "Offset", "OnSolid", "On"
)
$StateSegments = @(
    "Hover", "Pressed", "Selected", "Focus", "Disabled", "Error", "Checked",
    "Default", "Subtle", "Strong"
)
$NamingExceptions = @(
    "^Foundation\.Text\.",
    "^Foundation\.Border\.",
    "^Status\.[A-Za-z]+\.(Solid|OnSolid)$"
)
$WinUIThemeResourceAllow = @(
    "SymbolThemeFontFamily", "ContentControlThemeFontFamily",
    "BodyTextBlockStyle", "BodyStrongTextBlockStyle", "BodyLargeTextBlockStyle",
    "BodyLargeStrongTextBlockStyle", "CaptionTextBlockStyle",
    "SubtitleTextBlockStyle", "TitleTextBlockStyle", "TitleLargeTextBlockStyle",
    "DisplayTextBlockStyle", "BaseTextBlockStyle",
    "ApplicationPageBackgroundThemeBrush"
)

# 视图 -> 允许的区域. 新增视图时在这里加一行, 不要放宽默认规则.
$ViewRegionMap = @(
    @{ Prefix = "Funzor/Views/Shell/TitleBar.xaml"; Regions = @("TitleBar", "Foundation", "Tooltip") },
    @{ Prefix = "Funzor/Views/Shell/NavigationRail.xaml"; Regions = @("PrimaryNav", "Foundation", "Tooltip") },
    @{ Prefix = "Funzor/Views/Shell/SectionPanel.xaml"; Regions = @("SecondaryNav", "Foundation", "Tooltip") },
    @{ Prefix = "Funzor/Views/MainWindow.xaml"; Regions = @("Foundation", "Content") },
    @{ Prefix = "Funzor/Views/Pages/"; Regions = @("Foundation", "Content", "Page", "Card", "Button", "Form", "Setting", "Status", "Dialog", "ContextMenu", "Tooltip", "EmptyState") }
)

$script:Findings = New-Object System.Collections.Generic.List[object]

function New-Finding {
    param(
        [string]$Rule,
        [ValidateSet("error", "warning")][string]$Severity,
        [string]$File,
        [int]$Line,
        [string]$Message
    )
    $script:Findings.Add([pscustomobject]@{
        Rule     = $Rule
        Severity = $Severity
        File     = $File
        Line     = $Line
        Message  = $Message
    })
}

function Get-RepoRelativePath {
    param([string]$FullPath)
    $root = $RepoRoot.TrimEnd([char[]]@('\', '/'))
    $full = [System.IO.Path]::GetFullPath($FullPath)
    if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($root.Length).TrimStart([char[]]@('\', '/')).Replace('\', '/')
    }
    return $full.Replace('\', '/')
}

function Read-XamlFile {
    param([string]$Path)
    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
    return [pscustomobject]@{
        Path = $Path
        Rel  = Get-RepoRelativePath $Path
        Lines = $lines
        Code  = Get-CodeLines $lines
    }
}

# 去掉 XML 注释, 保留行号 (注释字符替换为空格).
function Get-CodeLines {
    param([string[]]$Lines)
    $result = New-Object System.Collections.Generic.List[string]
    $inComment = $false
    foreach ($line in $Lines) {
        $builder = New-Object System.Text.StringBuilder
        $i = 0
        while ($i -lt $line.Length) {
            if ($inComment) {
                if ($i + 2 -lt $line.Length -and $line[$i] -eq "-" -and $line[$i + 1] -eq "-" -and $line[$i + 2] -eq ">") {
                    $inComment = $false
                    $i += 3
                } else {
                    $i++
                }
            } else {
                if ($i + 3 -lt $line.Length -and $line[$i] -eq "<" -and $line[$i + 1] -eq "!" -and $line[$i + 2] -eq "-" -and $line[$i + 3] -eq "-") {
                    $inComment = $true
                    $i += 4
                } else {
                    [void]$builder.Append($line[$i])
                    $i++
                }
            }
        }
        $result.Add($builder.ToString())
    }
    return ,$result.ToArray()
}

function Get-KeyEntries {
    param([string[]]$CodeLines)
    $entries = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $CodeLines.Length; $i++) {
        $match = [regex]::Match($CodeLines[$i], 'x:Key="([^"]+)"')
        if ($match.Success) {
            $entries.Add([pscustomobject]@{
                Key  = $match.Groups[1].Value
                Line = $i + 1
            })
        }
    }
    return ,$entries.ToArray()
}

function Get-ResourceRefs {
    param(
        [string[]]$CodeLines,
        [string]$Kind
    )
    $refs = New-Object System.Collections.Generic.List[object]
    $pattern = "\{" + $Kind + '\s+([A-Za-z0-9\.\-]+)\s*\}'
    for ($i = 0; $i -lt $CodeLines.Length; $i++) {
        foreach ($match in [regex]::Matches($CodeLines[$i], $pattern)) {
            $refs.Add([pscustomobject]@{
                Name = $match.Groups[1].Value
                Line = $i + 1
            })
        }
    }
    return ,$refs.ToArray()
}

function Test-KeyShape {
    param([string]$Key)
    $segments = $Key.Split(".")
    if ($segments.Length -lt 2) { return $false }
    foreach ($segment in $segments) {
        if ($segment -in @("Bg", "Fg", "Color", "Brush", "Light", "Dark")) { return $false }
    }
    $last = $segments[$segments.Length - 1]
    if (($PropertySegments -contains $last) -or ($StateSegments -contains $last)) { return $true }
    foreach ($pattern in $NamingExceptions) {
        if ($Key -match $pattern) { return $true }
    }
    return $false
}

function Get-AllowedRegions {
    param([string]$RelativePath)
    if ($RelativePath -eq "Funzor/Themes/Controls.xaml") {
        return [pscustomobject]@{ Regions = $ProductRegions; Known = $true }
    }
    foreach ($map in $ViewRegionMap) {
        if ($RelativePath.Equals($map.Prefix, [System.StringComparison]::OrdinalIgnoreCase) -or
            $RelativePath.StartsWith($map.Prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return [pscustomobject]@{ Regions = $map.Regions; Known = $true }
        }
    }
    return [pscustomobject]@{ Regions = @(); Known = $false }
}

function Test-RegionAllowed {
    param(
        [string]$Key,
        [string[]]$Allowed
    )
    if ($Key -notmatch "^([A-Za-z][A-Za-z0-9]*)\.") { return $true }
    $region = $Matches[1]
    if ($ProductRegions -notcontains $region) { return $true }
    if ($ComponentRegions -contains $region) { return $true }
    return ($Allowed -contains $region)
}

 # ---------------------------------------------------------------- Tokens (DR-01)
$tokensFile = Read-XamlFile -Path $TokensPath
$tokenEntries = Get-KeyEntries -CodeLines $tokensFile.Code
$tokenKeys = New-Object System.Collections.Generic.HashSet[string]
foreach ($entry in $tokenEntries) {
    [void]$tokenKeys.Add($entry.Key)
    if (-not $entry.Key.StartsWith("A.")) {
        New-Finding -Rule "DR-01" -Severity "error" -File $tokensFile.Rel -Line $entry.Line -Message "token 必须以 A. 开头: $($entry.Key)"
    }
    if ($tokensFile.Code[$entry.Line - 1] -match "<Color\b") {
        $valueMatch = [regex]::Match($tokensFile.Code[$entry.Line - 1], ">([^<]*)</Color>")
        $value = $valueMatch.Groups[1].Value.Trim()
        if ($value -notmatch "^#[0-9A-Fa-f]{6,8}$") {
            New-Finding -Rule "DR-01" -Severity "error" -File $tokensFile.Rel -Line $entry.Line -Message "颜色 token 的值必须是十六进制: $($entry.Key)"
        }
    }
}

# ------------------------------------------------------- 主题文件: key 集与顺序 (DR-02, DR-03)
$light = Read-XamlFile -Path $ThemeLightPath
$dark = Read-XamlFile -Path $ThemeDarkPath
$lightKeys = Get-KeyEntries -CodeLines $light.Code
$darkKeys = Get-KeyEntries -CodeLines $dark.Code
$lightKeyNames = @($lightKeys | ForEach-Object { $_.Key })
$darkKeyNames = @($darkKeys | ForEach-Object { $_.Key })

foreach ($name in @($lightKeyNames)) {
    if ($darkKeyNames -notcontains $name) {
        New-Finding -Rule "DR-02" -Severity "error" -File $light.Rel -Line ($lightKeys | Where-Object { $_.Key -eq $name } | Select-Object -First 1).Line -Message "Dark 主题缺少 key: $name"
    }
}
foreach ($name in @($darkKeyNames)) {
    if ($lightKeyNames -notcontains $name) {
        New-Finding -Rule "DR-02" -Severity "error" -File $dark.Rel -Line ($darkKeys | Where-Object { $_.Key -eq $name } | Select-Object -First 1).Line -Message "Light 主题缺少 key: $name"
    }
}
if ($lightKeyNames.Count -ne $darkKeyNames.Count) {
    New-Finding -Rule "DR-02" -Severity "error" -File $light.Rel -Line 1 -Message "Light 与 Dark 的 key 数量不一致: $($lightKeyNames.Count) vs $($darkKeyNames.Count)"
}
$duplicates = $lightKeyNames | Group-Object | Where-Object { $_.Count -gt 1 }
foreach ($duplicate in @($duplicates)) {
    New-Finding -Rule "DR-02" -Severity "error" -File $light.Rel -Line 1 -Message "Light 主题存在重复 key: $($duplicate.Name)"
}
$duplicates = $darkKeyNames | Group-Object | Where-Object { $_.Count -gt 1 }
foreach ($duplicate in @($duplicates)) {
    New-Finding -Rule "DR-02" -Severity "error" -File $dark.Rel -Line 1 -Message "Dark 主题存在重复 key: $($duplicate.Name)"
}

$minCount = [Math]::Min($lightKeyNames.Count, $darkKeyNames.Count)
for ($i = 0; $i -lt $minCount; $i++) {
    if ($lightKeyNames[$i] -ne $darkKeyNames[$i]) {
        New-Finding -Rule "DR-03" -Severity "error" -File $dark.Rel -Line ($i + 2) -Message "第 $($i + 1) 个 key 顺序不一致: Light=$($lightKeyNames[$i]) Dark=$($darkKeyNames[$i])"
        break
    }
}

# 区块顺序与归属
function Get-RegionBlocks {
    param([object]$XamlFile)
    $blocks = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $XamlFile.Lines.Length; $i++) {
        $match = [regex]::Match($XamlFile.Lines[$i], '^\s+([A-Za-z][A-Za-z0-9]*)\s+-\s+.+$')
        if ($match.Success) {
            $blocks.Add([pscustomobject]@{
                Region = $match.Groups[1].Value
                Line   = $i + 1
            })
        }
    }
    return ,$blocks.ToArray()
}

foreach ($theme in @($light, $dark)) {
    $blocks = Get-RegionBlocks -XamlFile $theme
    $blockNames = @($blocks | ForEach-Object { $_.Region })
    if (($blockNames -join "|") -ne ($RegionManifest -join "|")) {
        New-Finding -Rule "DR-03" -Severity "error" -File $theme.Rel -Line 1 -Message "区块顺序不是批准顺序: $($blockNames -join ', ')"
    }
    $keys = Get-KeyEntries -CodeLines $theme.Code
    foreach ($entry in $keys) {
        $block = $null
        foreach ($candidate in $blocks) {
            if ($candidate.Line -lt $entry.Line) { $block = $candidate }
        }
        if ($null -eq $block) { continue }
        if ($block.Region -ne "Bridge") {
            if (-not $entry.Key.StartsWith($block.Region + ".")) {
                New-Finding -Rule "DR-03" -Severity "error" -File $theme.Rel -Line $entry.Line -Message "key 不在所属区块: $($entry.Key) 位于 $($block.Region) 区块"
            }
        }
    }
}

# ------------------------------------------------ 主题文件: 十六进制 / A.* 引用 (DR-04, DR-05)
foreach ($theme in @($light, $dark)) {
    for ($i = 0; $i -lt $theme.Code.Length; $i++) {
        if ($theme.Code[$i] -match "#[0-9A-Fa-f]{3,8}\b") {
            New-Finding -Rule "DR-04" -Severity "error" -File $theme.Rel -Line ($i + 1) -Message "主题文件不允许十六进制颜色"
        }
        if ($theme.Code[$i] -match "\{ThemeResource\s+([A-Za-z0-9\.\-]+)") {
            New-Finding -Rule "DR-05" -Severity "error" -File $theme.Rel -Line ($i + 1) -Message "主题文件只能用 StaticResource A.*, 不允许 ThemeResource"
        }
        foreach ($match in [regex]::Matches($theme.Code[$i], "\{StaticResource\s+([A-Za-z0-9\.\-]+)\s*\}")) {
            $token = $match.Groups[1].Value
            if (-not $token.StartsWith("A.")) {
                New-Finding -Rule "DR-05" -Severity "error" -File $theme.Rel -Line ($i + 1) -Message "主题文件只能引用 A.*: $token"
            } elseif (-not $tokenKeys.Contains($token)) {
                New-Finding -Rule "DR-05" -Severity "error" -File $theme.Rel -Line ($i + 1) -Message "A.* token 不存在: $token"
            }
        }
    }
}

# ------------------------------------ 主题文件: 命名与 Bridge owner (DR-10, DR-12)
$themeKeyMeta = @{}
foreach ($theme in @($light, $dark)) {
    $blocks = Get-RegionBlocks -XamlFile $theme
    $keys = Get-KeyEntries -CodeLines $theme.Code
    $codeByKey = @{}
    foreach ($entry in $keys) {
        $codeByKey[$entry.Key] = $theme.Code[$entry.Line - 1]
    }
    foreach ($entry in $keys) {
        $block = $null
        foreach ($candidate in $blocks) {
            if ($candidate.Line -lt $entry.Line) { $block = $candidate }
        }
        if ($null -eq $block) { continue }
        if ($block.Region -eq "Bridge") {
            $ownerMatch = [regex]::Match($theme.Lines[$entry.Line - 1], "owner:\s*([A-Za-z][A-Za-z0-9\.]*)")
            if (-not $ownerMatch.Success) {
                New-Finding -Rule "DR-12" -Severity "error" -File $theme.Rel -Line $entry.Line -Message "Bridge 键缺少 owner 注释: $($entry.Key)"
            } else {
                $owner = $ownerMatch.Groups[1].Value
                $ownerRegion = $owner.Split(".")[0]
                if ($ProductRegions -notcontains $ownerRegion) {
                    New-Finding -Rule "DR-12" -Severity "error" -File $theme.Rel -Line $entry.Line -Message "Bridge owner 不是已知区域: $owner"
                } else {
                    $resolved = ($owner -eq $ownerRegion) -or ($lightKeyNames -contains $owner) -or (@($lightKeyNames | Where-Object { $_.StartsWith($owner + ".") }).Count -gt 0)
                    if (-not $resolved) {
                        New-Finding -Rule "DR-12" -Severity "warning" -File $theme.Rel -Line $entry.Line -Message "Bridge owner 找不到对应的区域键或键族: $owner"
                    }
                }
            }
        } else {
            if (-not (Test-KeyShape -Key $entry.Key)) {
                New-Finding -Rule "DR-10" -Severity "error" -File $theme.Rel -Line $entry.Line -Message "命名不符合 {Region}.{Part}.{Property}.{State}: $($entry.Key)"
            }
        }
    }
    $themeKeyMeta[$theme.Rel] = @{ Keys = $keys; Blocks = $blocks }
}

# ------------------------------------------------------------ 视图与控件样式 (DR-06, DR-07, DR-08, DR-09)
$viewFiles = New-Object System.Collections.Generic.List[string]
if (Test-Path -LiteralPath $ViewsPath) {
    foreach ($file in Get-ChildItem -Path $ViewsPath -Recurse -Filter "*.xaml" -File) {
        $viewFiles.Add($file.FullName)
    }
}
if (Test-Path -LiteralPath $ControlsPath) {
    $viewFiles.Add($ControlsPath)
}
if ($viewFiles.Count -eq 0) {
    New-Finding -Rule "DR-06" -Severity "warning" -File "Funzor/Views" -Line 0 -Message "没有找到视图 XAML"
}

$themeKeySet = New-Object System.Collections.Generic.HashSet[string]
foreach ($name in $lightKeyNames) { [void]$themeKeySet.Add($name) }
foreach ($name in $darkKeyNames) { [void]$themeKeySet.Add($name) }

foreach ($viewPath in $viewFiles) {
    $view = Read-XamlFile -Path $viewPath
    $allowed = Get-AllowedRegions -RelativePath $view.Rel
    if (-not $allowed.Known) {
        New-Finding -Rule "DR-11" -Severity "warning" -File $view.Rel -Line 0 -Message "视图没有区域映射, 请在脚本 ViewRegionMap 中登记"
    }
    for ($i = 0; $i -lt $view.Code.Length; $i++) {
        $line = $view.Code[$i]
        $lineNumber = $i + 1

        if ($line -match "#[0-9A-Fa-f]{3,8}\b") {
            New-Finding -Rule "DR-07" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图不允许十六进制颜色"
        }
        if ($line -match '="[^"]*\bTransparent\b[^"]*"') {
            New-Finding -Rule "DR-08" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图不允许 Transparent 字面量, 请用区域键"
        }
        if ($line -match "<(SolidColorBrush|LinearGradientBrush)\b") {
            New-Finding -Rule "DR-06" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图不允许定义画刷; 只允许局部 StaticResource 别名"
        }
        if ($line -match '\bColor\s*=') {
            New-Finding -Rule "DR-06" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图不允许直接设置 Color"
        }

        foreach ($match in [regex]::Matches($line, "\{(ThemeResource|StaticResource)\s+([A-Za-z0-9\.\-]+)\s*\}")) {
            $kind = $match.Groups[1].Value
            $name = $match.Groups[2].Value
            if ($name -match $ColorTokenPattern -or $name -eq "A.Transparent") {
                New-Finding -Rule "DR-06" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图引用颜色 token: $name"
                continue
            }
            if ($name.StartsWith("A.")) {
                if (-not $tokenKeys.Contains($name)) {
                    New-Finding -Rule "DR-05" -Severity "error" -File $view.Rel -Line $lineNumber -Message "A.* token 不存在: $name"
                } elseif ($name -notmatch $MetricTokenPattern) {
                    New-Finding -Rule "DR-06" -Severity "error" -File $view.Rel -Line $lineNumber -Message "视图只允许引用度量 token, 不允许: $name"
                }
                continue
            }
            if ($kind -eq "ThemeResource") {
                $region = ""
                if ($name -match "^([A-Za-z][A-Za-z0-9]*)\.") { $region = $Matches[1] }
                if ($region -and ($ProductRegions -contains $region)) {
                    if (-not $themeKeySet.Contains($name)) {
                        New-Finding -Rule "DR-09" -Severity "error" -File $view.Rel -Line $lineNumber -Message "ThemeResource 未在 Light/Dark 定义: $name"
                    } elseif (-not (Test-RegionAllowed -Key $name -Allowed $allowed.Regions)) {
                        New-Finding -Rule "DR-11" -Severity "error" -File $view.Rel -Line $lineNumber -Message "跨区域引用: $name, 本文件允许 $(@($allowed.Regions) -join ', ')"
                    }
                } elseif (-not ($WinUIThemeResourceAllow -contains $name)) {
                    New-Finding -Rule "DR-09" -Severity "error" -File $view.Rel -Line $lineNumber -Message "ThemeResource 未定义且不在 WinUI 白名单: $name"
                }
            } else {
                $region = ""
                if ($name -match "^([A-Za-z][A-Za-z0-9]*)\.") { $region = $Matches[1] }
                if ($region -and ($ProductRegions -contains $region)) {
                    if (-not $themeKeySet.Contains($name)) {
                        New-Finding -Rule "DR-09" -Severity "error" -File $view.Rel -Line $lineNumber -Message "StaticResource 未在 Light/Dark 定义: $name"
                    } elseif (-not (Test-RegionAllowed -Key $name -Allowed $allowed.Regions)) {
                        New-Finding -Rule "DR-11" -Severity "error" -File $view.Rel -Line $lineNumber -Message "跨区域引用: $name, 本文件允许 $(@($allowed.Regions) -join ', ')"
                    }
                }
            }
        }

        foreach ($match in [regex]::Matches($line, 'ResourceKey="([A-Za-z0-9\.\-]+)"')) {
            $target = $match.Groups[1].Value
            if ($target.StartsWith("A.")) {
                New-Finding -Rule "DR-06" -Severity "error" -File $view.Rel -Line $lineNumber -Message "局部别名不能指向颜色 token: $target"
                continue
            }
            $region = ""
            if ($target -match "^([A-Za-z][A-Za-z0-9]*)\.") { $region = $Matches[1] }
            if ($region -and ($ProductRegions -contains $region)) {
                if (-not $themeKeySet.Contains($target)) {
                    New-Finding -Rule "DR-09" -Severity "error" -File $view.Rel -Line $lineNumber -Message "局部别名目标未定义: $target"
                } elseif (-not (Test-RegionAllowed -Key $target -Allowed $allowed.Regions)) {
                    New-Finding -Rule "DR-11" -Severity "error" -File $view.Rel -Line $lineNumber -Message "局部别名跨区域: $target"
                }
            }
        }
    }
}

# --------------------------------------------------------------------- 输出
$errors = @($script:Findings | Where-Object { $_.Severity -eq "error" })
$warnings = @($script:Findings | Where-Object { $_.Severity -eq "warning" })
$ruleSummary = @{}
foreach ($finding in $script:Findings) {
    if (-not $ruleSummary.ContainsKey($finding.Rule)) {
        $ruleSummary[$finding.Rule] = 0
    }
    $ruleSummary[$finding.Rule]++
}

$report = [ordered]@{
    generatedAt = (Get-Date).ToString("o")
    repoRoot    = $RepoRoot
    themeFiles  = @((Get-RepoRelativePath $ThemeLightPath), (Get-RepoRelativePath $ThemeDarkPath))
    tokens      = $tokenKeys.Count
    lightKeys   = $lightKeyNames.Count
    darkKeys    = $darkKeyNames.Count
    errors      = $errors.Count
    warnings    = $warnings.Count
    ruleCounts  = $ruleSummary
    findings    = $script:Findings.ToArray()
}

if (-not [string]::IsNullOrWhiteSpace($ReportPath)) {
    $reportJson = $report | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText([System.IO.Path]::GetFullPath($ReportPath), $reportJson, [System.Text.UTF8Encoding]::new($false))
}

if ($Format -eq "Json") {
    $report | ConvertTo-Json -Depth 5
} else {
    Write-Host ""
    Write-Host "Funzor 设计系统校验"
    Write-Host "  仓库: $RepoRoot"
    Write-Host "  主题: $($lightKeyNames.Count) 个 Light key, $($darkKeyNames.Count) 个 Dark key"
    Write-Host "  视图: $($viewFiles.Count) 个文件"
    Write-Host ""
    foreach ($finding in $script:Findings) {
        $location = if ($finding.Line -gt 0) { "$($finding.File):$($finding.Line)" } else { $finding.File }
        Write-Host ("[{0}] {1} {2} {3}" -f $finding.Severity, $finding.Rule, $location, $finding.Message)
    }
    Write-Host ""
    Write-Host ("汇总: errors={0}, warnings={1}" -f $errors.Count, $warnings.Count)
    if ($errors.Count -gt 0) {
        Write-Host "结果: 未通过"
    } else {
        Write-Host "结果: 通过"
    }
}

if ($errors.Count -gt 0) { exit 1 }
exit 0
