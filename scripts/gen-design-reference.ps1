<#
.SYNOPSIS
    生成 Funzor 设计系统全量参考文档.

.DESCRIPTION
    纯文本解析, 不依赖 Windows 运行时.
    读取 Tokens.xaml, Theme.Light.xaml, Theme.Dark.xaml, Controls.xaml, Icons.xaml
    以及 check-design-system.ps1 中的区域清单与视图映射, 输出
    docs/design/reference.md.

    -Check 只比对现有文件, 不写盘; 有差异时退出码 1, 供 PR / CI 使用.

.EXAMPLE
    pwsh scripts/gen-design-reference.ps1

.EXAMPLE
    pwsh scripts/gen-design-reference.ps1 -Check
#>
[CmdletBinding()]
param(
    [string]$RepoRoot = "",
    [string]$OutputPath = "docs/design/reference.md",
    [switch]$Check
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

if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $Output = $OutputPath
} else {
    $Output = Join-Path $RepoRoot $OutputPath
}

$TokensPath = Join-Path $RepoRoot "Funzor/Themes/Tokens.xaml"
$LightPath = Join-Path $RepoRoot "Funzor/Themes/Theme.Light.xaml"
$DarkPath = Join-Path $RepoRoot "Funzor/Themes/Theme.Dark.xaml"
$ControlsPath = Join-Path $RepoRoot "Funzor/Themes/Controls.xaml"
$IconsPath = Join-Path $RepoRoot "Funzor/Themes/Icons.xaml"
$CheckScriptPath = Join-Path $RepoRoot "scripts/check-design-system.ps1"
$ViewsRoot = Join-Path $RepoRoot "Funzor/Views"
$IconSourceRoot = Join-Path $RepoRoot "Funzor/Assets/Icons/Source"

foreach ($required in @($TokensPath, $LightPath, $DarkPath, $ControlsPath, $IconsPath, $CheckScriptPath)) {
    if (-not (Test-Path -LiteralPath $required)) {
        Write-Error "缺少必需文件: $required"
        exit 2
    }
}

$NewLine = [string][char]13 + [string][char]10
$LineFeed = [string][char]10

function Get-RelativePath {
    param([string]$Path)
    $root = $RepoRoot.TrimEnd([char[]]@('\', '/'))
    $full = [System.IO.Path]::GetFullPath($Path)
    if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($root.Length).TrimStart([char[]]@('\', '/')).Replace('\', '/')
    }
    return $full.Replace('\', '/')
}

function Read-Utf8Lines {
    param([string]$Path)
    return [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
}

# 去掉 XML 注释, 保留行号 (注释字符替换为空格), 与校验脚本保持一致.
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

function Read-Theme {
    param([string]$Path)
    $lines = Read-Utf8Lines $Path
    $code = Get-CodeLines $lines

    $blocks = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $match = [regex]::Match($lines[$i], '^\s+([A-Za-z][A-Za-z0-9]*)\s+-\s+.+$')
        if ($match.Success) {
            $owner = ""
            for ($j = $i + 1; $j -lt $lines.Length; $j++) {
                if ([regex]::IsMatch($lines[$j], '^\s+[A-Za-z][A-Za-z0-9]*\s+-\s+.+$')) { break }
                $ownerMatch = [regex]::Match($lines[$j], 'Owner:\s*(.+?)\s*(?:-->)?\s*$')
                if ($ownerMatch.Success) { $owner = $ownerMatch.Groups[1].Value.Trim(); break }
            }
            $blocks.Add([pscustomobject]@{
                Region = $match.Groups[1].Value
                Line   = $i + 1
                Owner  = $owner
            })
        }
    }

    $entries = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $code.Length; $i++) {
        $match = [regex]::Match($code[$i], 'x:Key="([^"]+)"')
        if (-not $match.Success) { continue }

        $block = $null
        foreach ($candidate in $blocks) {
            if ($candidate.Line -lt ($i + 1)) { $block = $candidate }
        }
        $region = ""
        if ($null -ne $block) { $region = $block.Region }

        $raw = $lines[$i]
        $valueMatch = [regex]::Match($code[$i], 'Color="\{StaticResource\s+([A-Za-z0-9\.]+)\}"')
        $ownerMatch = [regex]::Match($raw, 'owner:\s*([A-Za-z0-9\.]+)')
        $reference = ""
        if ($valueMatch.Success) { $reference = $valueMatch.Groups[1].Value }
        $owner = ""
        if ($ownerMatch.Success) { $owner = $ownerMatch.Groups[1].Value }

        $entries.Add([pscustomobject]@{
            Key        = $match.Groups[1].Value
            Line       = $i + 1
            Region     = $region
            Ref        = $reference
            Reserved   = ($raw -match 'reserved')
            Deprecated = ($raw -match 'deprecated')
            Owner      = $owner
        })
    }

    return [pscustomobject]@{
        Lines   = $lines
        Blocks  = $blocks
        Entries = $entries
    }
}

function Get-QuotedArray {
    param([string]$Text, [string]$Name)
    $values = New-Object System.Collections.Generic.List[string]
    $pattern = '\$' + [regex]::Escape($Name) + '\s*=\s*@\((?<body>[^)]*)\)'
    $options = [System.Text.RegularExpressions.RegexOptions]::Singleline
    $match = [regex]::Match($Text, $pattern, $options)
    if (-not $match.Success) { return $values.ToArray() }
    foreach ($item in [regex]::Matches($match.Groups['body'].Value, '"([^"]+)"')) {
        $values.Add($item.Groups[1].Value)
    }
    return $values.ToArray()
}

function Get-ViewRegionMap {
    param([string]$Text)
    $result = New-Object System.Collections.Generic.List[object]
    $options = [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::Multiline
    $block = [regex]::Match($Text, '\$ViewRegionMap\s*=\s*@\((.*?)^\)', $options)
    if (-not $block.Success) { return $result.ToArray() }
    foreach ($entry in [regex]::Matches($block.Groups[1].Value, '(?s)@\{\s*Prefix\s*=\s*"([^"]+)"\s*;\s*Regions\s*=\s*@\(([^)]*)\)\s*\}')) {
        $regions = New-Object System.Collections.Generic.List[string]
        foreach ($region in [regex]::Matches($entry.Groups[2].Value, '"([^"]+)"')) {
            $regions.Add($region.Groups[1].Value)
        }
        $result.Add([pscustomobject]@{
            Prefix  = $entry.Groups[1].Value
            Regions = $regions.ToArray()
        })
    }
    return $result.ToArray()
}

function Format-Cell {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    return $Text.Replace([string][char]13, " ").Replace([string][char]10, " ").Replace('|', '\|')
}

# ---------------------------------------------------------------- 解析

$tokenEntries = New-Object System.Collections.Generic.List[object]
$tokenValues = @{}
foreach ($line in (Get-CodeLines (Read-Utf8Lines $TokensPath))) {
    $match = [regex]::Match($line, '<(Color|x:Double|Thickness|CornerRadius)\s+x:Key="([^"]+)">([^<]*)</')
    if (-not $match.Success) { continue }
    $type = $match.Groups[1].Value
    if ($type -eq 'x:Double') { $type = 'Double' }
    $entry = [pscustomobject]@{
        Key   = $match.Groups[2].Value
        Type  = $type
        Value = $match.Groups[3].Value
    }
    $tokenEntries.Add($entry)
    $tokenValues[$entry.Key] = $entry
}

$light = Read-Theme $LightPath
$dark = Read-Theme $DarkPath

$checkScriptText = [System.IO.File]::ReadAllText($CheckScriptPath, [System.Text.Encoding]::UTF8)
$regionManifest = @(Get-QuotedArray -Text $checkScriptText -Name 'RegionManifest')
$componentRegions = @(Get-QuotedArray -Text $checkScriptText -Name 'ComponentRegions')
$winuiAllow = @(Get-QuotedArray -Text $checkScriptText -Name 'WinUIThemeResourceAllow')
$viewRegionMap = @(Get-ViewRegionMap -Text $checkScriptText)
$productRegions = @($regionManifest | Where-Object { $_ -ne 'Bridge' })

$viewFiles = @()
if (Test-Path -LiteralPath $ViewsRoot) {
    $viewFiles = @(Get-ChildItem -Path $ViewsRoot -Recurse -Filter '*.xaml' -File |
        ForEach-Object { Get-RelativePath $_.FullName } |
        Sort-Object)
}

$controlsText = [string]::Join($LineFeed, (Get-CodeLines (Read-Utf8Lines $ControlsPath)))
$styles = New-Object System.Collections.Generic.List[object]
$optionsSingle = [System.Text.RegularExpressions.RegexOptions]::Singleline
foreach ($styleMatch in [regex]::Matches($controlsText, '<Style\s+x:Key="([^"]+)"\s+TargetType="([^"]+)"([^>]*)>(.*?)</Style>', $optionsSingle)) {
    $basedOn = ""
    $basedOnMatch = [regex]::Match($styleMatch.Groups[3].Value, 'BasedOn="\{StaticResource\s+([^}]+)\}"')
    if ($basedOnMatch.Success) { $basedOn = $basedOnMatch.Groups[1].Value }

    $keep = @('FontSize', 'LineHeight', 'FontWeight', 'Foreground', 'MinHeight', 'Padding', 'CornerRadius', 'TextWrapping')
    $settings = New-Object System.Collections.Generic.List[string]
    foreach ($setter in [regex]::Matches($styleMatch.Groups[4].Value, '<Setter\s+Property="([^"]+)"\s+Value="([^"]+)"')) {
        $property = $setter.Groups[1].Value
        if ($keep -notcontains $property) { continue }
        $value = [regex]::Replace($setter.Groups[2].Value, '\{(?:StaticResource|ThemeResource)\s+([^}]+)\}', '$1')
        $settings.Add($property + "=" + $value)
    }

    $styles.Add([pscustomobject]@{
        Key      = $styleMatch.Groups[1].Value
        Target   = $styleMatch.Groups[2].Value
        BasedOn  = $basedOn
        Settings = ($settings -join '; ')
    })
}

$iconsText = [string]::Join($LineFeed, (Get-CodeLines (Read-Utf8Lines $IconsPath)))
$icons = New-Object System.Collections.Generic.List[object]
foreach ($iconMatch in [regex]::Matches($iconsText, '<ControlTemplate\s+x:Key="([^"]+)"\s+TargetType="([^"]+)"')) {
    $icons.Add([pscustomobject]@{
        Key    = $iconMatch.Groups[1].Value
        Target = $iconMatch.Groups[2].Value
    })
}
$iconSources = @()
if (Test-Path -LiteralPath $IconSourceRoot) {
    $iconSources = @(Get-ChildItem -Path $IconSourceRoot -Recurse -Filter '*.svg' -File |
        ForEach-Object { Get-RelativePath $_.FullName } |
        Sort-Object)
}

function Get-DarkEntry {
    param([string]$Key)
    foreach ($entry in $dark.Entries) {
        if ($entry.Key -eq $Key) { return $entry }
    }
    return $null
}

function Format-SemanticValue {
    param([string]$Reference)
    if ([string]::IsNullOrWhiteSpace($Reference)) { return "(无)" }
    if ($tokenValues.ContainsKey($Reference)) {
        return "<code>" + $Reference + "</code> " + $tokenValues[$Reference].Value
    }
    return "<code>" + $Reference + "</code>"
}

function Format-Remark {
    param([object]$Entry)
    $parts = New-Object System.Collections.Generic.List[string]
    if ($Entry.Reserved) { $parts.Add('reserved') }
    if ($Entry.Deprecated) { $parts.Add('deprecated') }
    if (-not [string]::IsNullOrWhiteSpace($Entry.Owner)) { $parts.Add('owner: ' + $Entry.Owner) }
    return ($parts -join '; ')
}

function Get-RegionsForView {
    param([string]$RelativePath)
    if ($RelativePath -eq 'Funzor/Themes/Controls.xaml') { return $productRegions }
    foreach ($map in $viewRegionMap) {
        $prefix = $map.Prefix
        if ($RelativePath.Equals($prefix, [System.StringComparison]::OrdinalIgnoreCase)) { return $map.Regions }
        if ($RelativePath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) { return $map.Regions }
    }
    return @()
}

# ---------------------------------------------------------------- 输出

$out = New-Object System.Collections.Generic.List[string]
function Add-Out {
    param([string]$Text = "")
    [void]$script:out.Add($Text)
}

Add-Out "# 设计系统全量参考"
Add-Out ""
Add-Out "> 生成物, 请勿手改.  "
Add-Out "> 重新生成: <code>pwsh scripts/gen-design-reference.ps1</code>  "
Add-Out "> 校验: <code>pwsh scripts/gen-design-reference.ps1 -Check</code> (PR CI 会执行)  "
Add-Out "> 事实来源: <code>Funzor/Themes/Tokens.xaml</code>, <code>Theme.Light.xaml</code>, <code>Theme.Dark.xaml</code>, <code>Controls.xaml</code>, <code>Icons.xaml</code>, <code>scripts/check-design-system.ps1</code>.  "
Add-Out ""
Add-Out "说明: 本文件由脚本从上述源文件解析生成, 不包含生成时间, 便于在 PR 中做无差异比对.  "
Add-Out ""
Add-Out "## 统计"
Add-Out ""
Add-Out "| 项 | 数量 |"
Add-Out "| --- | --- |"
Add-Out ("| 原子 token | " + $tokenEntries.Count + " |")
Add-Out ("| 语义键 (Light / Dark) | " + $light.Entries.Count + " / " + $dark.Entries.Count + " |")
Add-Out ("| 区域 | " + $regionManifest.Count + " |")
Add-Out ("| 组件区域 | " + $componentRegions.Count + " |")
Add-Out ("| 受检 XAML 文件 | " + ($viewFiles.Count + 1) + " (含 Controls.xaml) |")
Add-Out ("| 控件样式 | " + $styles.Count + " |")
Add-Out ("| 图标模板 | " + $icons.Count + " |")
Add-Out ""

Add-Out "## 1. 原子 Token"
Add-Out ""
Add-Out "### 1.1 颜色"
Add-Out ""
Add-Out "| 键 | 值 |"
Add-Out "| --- | --- |"
foreach ($entry in $tokenEntries) {
    if ($entry.Type -ne 'Color') { continue }
    Add-Out ("| <code>" + $entry.Key + "</code> | " + $entry.Value + " |")
}
Add-Out ""
Add-Out "### 1.2 度量"
Add-Out ""
Add-Out "| 键 | 类型 | 值 |"
Add-Out "| --- | --- | --- |"
foreach ($entry in $tokenEntries) {
    if ($entry.Type -eq 'Color') { continue }
    Add-Out ("| <code>" + $entry.Key + "</code> | " + $entry.Type + " | " + $entry.Value + " |")
}
Add-Out ""

Add-Out "## 2. 语义键"
Add-Out ""
Add-Out "### 2.1 区域汇总"
Add-Out ""
Add-Out "| 区域 | Owner | Light 键 | Dark 键 |"
Add-Out "| --- | --- | --- | --- |"
foreach ($region in $regionManifest) {
    $lightBlock = $null
    foreach ($block in $light.Blocks) {
        if ($block.Region -eq $region) { $lightBlock = $block }
    }
    $owner = ""
    if ($null -ne $lightBlock) { $owner = $lightBlock.Owner }
    if ([string]::IsNullOrWhiteSpace($owner)) {
        foreach ($block in $dark.Blocks) {
            if ($block.Region -eq $region) { $owner = $block.Owner }
        }
    }
    if ([string]::IsNullOrWhiteSpace($owner)) { $owner = "(未标注)" }
    $lightCount = @($light.Entries | Where-Object { $_.Region -eq $region }).Count
    $darkCount = @($dark.Entries | Where-Object { $_.Region -eq $region }).Count
    Add-Out ("| " + $region + " | " + (Format-Cell $owner) + " | " + $lightCount + " | " + $darkCount + " |")
}
Add-Out ""
Add-Out "### 2.2 区域明细"
Add-Out ""
foreach ($region in $regionManifest) {
    if ($region -eq 'Bridge') { continue }
    $entries = @($light.Entries | Where-Object { $_.Region -eq $region })
    if ($entries.Count -eq 0) { continue }
    Add-Out ("#### " + $region)
    Add-Out ""
    Add-Out "| 键 | Light | Dark | 备注 |"
    Add-Out "| --- | --- | --- | --- |"
    foreach ($entry in $entries) {
        $darkEntry = Get-DarkEntry -Key $entry.Key
        $darkValue = "(缺失)"
        $remark = Format-Remark -Entry $entry
        if ($null -ne $darkEntry) {
            $darkValue = Format-SemanticValue -Reference $darkEntry.Ref
            if ([string]::IsNullOrWhiteSpace($remark)) { $remark = Format-Remark -Entry $darkEntry }
        }
        Add-Out ("| <code>" + $entry.Key + "</code> | " + (Format-SemanticValue -Reference $entry.Ref) + " | " + $darkValue + " | " + (Format-Cell $remark) + " |")
    }
    Add-Out ""
}
Add-Out "### 2.3 Bridge"
Add-Out ""
Add-Out "| 键 | Light | Dark | Owner |"
Add-Out "| --- | --- | --- | --- |"
foreach ($entry in $light.Entries) {
    if ($entry.Region -ne 'Bridge') { continue }
    $darkEntry = Get-DarkEntry -Key $entry.Key
    $darkValue = "(缺失)"
    if ($null -ne $darkEntry) { $darkValue = Format-SemanticValue -Reference $darkEntry.Ref }
    $owner = $entry.Owner
    if ([string]::IsNullOrWhiteSpace($owner) -and $null -ne $darkEntry) { $owner = $darkEntry.Owner }
    Add-Out ("| <code>" + $entry.Key + "</code> | " + (Format-SemanticValue -Reference $entry.Ref) + " | " + $darkValue + " | " + (Format-Cell $owner) + " |")
}
Add-Out ""

Add-Out "## 3. 视图与区域权限"
Add-Out ""
Add-Out "| 文件 | 允许区域 |"
Add-Out "| --- | --- |"
foreach ($viewFile in $viewFiles) {
    $regions = @(Get-RegionsForView -RelativePath $viewFile)
    $text = "(未登记)"
    if ($regions.Count -gt 0) { $text = ($regions -join ', ') }
    Add-Out ("| <code>" + $viewFile + "</code> | " + (Format-Cell $text) + " |")
}
$controlRegions = @(Get-RegionsForView -RelativePath 'Funzor/Themes/Controls.xaml')
Add-Out ("| <code>Funzor/Themes/Controls.xaml</code> | " + (Format-Cell ($controlRegions -join ', ')) + " |")
Add-Out ""
Add-Out "### 3.1 区域映射规则"
Add-Out ""
Add-Out "| 路径前缀 | 允许区域 |"
Add-Out "| --- | --- |"
foreach ($map in $viewRegionMap) {
    Add-Out ("| <code>" + $map.Prefix + "</code> | " + (Format-Cell ($map.Regions -join ', ')) + " |")
}
Add-Out ""
Add-Out "## 4. WinUI 资源白名单"
Add-Out ""
Add-Out "视图可直接引用的 WinUI 原生键:"
Add-Out ""
Add-Out "| 键 |"
Add-Out "| --- |"
foreach ($name in $winuiAllow) {
    Add-Out ("| <code>" + $name + "</code> |")
}
Add-Out ""
Add-Out "## 5. 控件样式"
Add-Out ""
Add-Out "| 样式 | TargetType | BasedOn | 设置 |"
Add-Out "| --- | --- | --- | --- |"
foreach ($style in $styles) {
    $basedOn = $style.BasedOn
    if ([string]::IsNullOrWhiteSpace($basedOn)) { $basedOn = "(无)" }
    Add-Out ("| <code>" + $style.Key + "</code> | " + $style.Target + " | " + (Format-Cell $basedOn) + " | " + (Format-Cell $style.Settings) + " |")
}
Add-Out ""
Add-Out "## 6. 图标"
Add-Out ""
Add-Out "| 模板 | TargetType |"
Add-Out "| --- | --- |"
foreach ($icon in $icons) {
    Add-Out ("| <code>" + $icon.Key + "</code> | " + $icon.Target + " |")
}
if ($icons.Count -eq 0) {
    Add-Out "| (无) |  |"
}
Add-Out ""
Add-Out "源文件:"
Add-Out ""
if ($iconSources.Count -eq 0) {
    Add-Out "- (无)"
} else {
    foreach ($source in $iconSources) {
        Add-Out ("- <code>" + $source + "</code>")
    }
}
Add-Out ""

Add-Out "## 7. 校验清单"
Add-Out ""
Add-Out "区域顺序 (<code>RegionManifest</code>):"
Add-Out ""
Add-Out ("    " + ($regionManifest -join " -> "))
Add-Out ""
Add-Out "组件区域 (<code>ComponentRegions</code>):"
Add-Out ""
Add-Out ("    " + ($componentRegions -join ", "))
Add-Out ""

$content = ($out -join $NewLine) + $NewLine

if ($Check) {
    if (-not (Test-Path -LiteralPath $Output)) {
        Write-Host "参考文档不存在: $(Get-RelativePath $Output)"
        Write-Host "运行 pwsh scripts/gen-design-reference.ps1 生成后提交."
        exit 1
    }
    $existing = [System.IO.File]::ReadAllText($Output, [System.Text.Encoding]::UTF8)
    $existingNormalized = $existing.Replace([string][char]13, "").TrimEnd()
    $contentNormalized = $content.Replace([string][char]13, "").TrimEnd()
    if ($existingNormalized -ne $contentNormalized) {
        $existingLines = $existingNormalized -split $LineFeed
        $contentLines = $contentNormalized -split $LineFeed
        $max = [Math]::Max($existingLines.Length, $contentLines.Length)
        for ($i = 0; $i -lt $max; $i++) {
            $left = ""
            $right = ""
            if ($i -lt $existingLines.Length) { $left = $existingLines[$i] }
            if ($i -lt $contentLines.Length) { $right = $contentLines[$i] }
            if ($left -ne $right) {
                Write-Host ("首个差异在第 " + ($i + 1) + " 行")
                Write-Host ("  现有: " + $left)
                Write-Host ("  应为: " + $right)
                break
            }
        }
        Write-Host "参考文档与源文件不一致: $(Get-RelativePath $Output)"
        Write-Host "运行 pwsh scripts/gen-design-reference.ps1 重新生成后提交."
        exit 1
    }
    Write-Host "参考文档已是最新: $(Get-RelativePath $Output)"
    exit 0
}

$outputDirectory = [System.IO.Path]::GetDirectoryName($Output)
if (-not [System.IO.Directory]::Exists($outputDirectory)) {
    [void][System.IO.Directory]::CreateDirectory($outputDirectory)
}
[System.IO.File]::WriteAllText($Output, $content, [System.Text.UTF8Encoding]::new($false))

Write-Host "已生成参考文档: $(Get-RelativePath $Output)"
Write-Host ("  token: " + $tokenEntries.Count + ", 语义键: " + $light.Entries.Count + " / " + $dark.Entries.Count)
Write-Host ("  视图: " + $viewFiles.Count + " + Controls.xaml, 样式: " + $styles.Count + ", 图标: " + $icons.Count)
exit 0
