param(
  [ValidateSet('Windows', 'Unix')]
  [string] $LauncherPlatform = 'Windows',
  [string] $WindowTitleSuffix = '',
  [string] $StudentName = '',
  [string] $StudentId = ''
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'

$root = Split-Path -Parent $PSScriptRoot
$bin = Join-Path $root 'bin'
$builderClasses = Join-Path $bin (Join-Path 'build' 'builder-classes')
$imageGeneratorClasses = Join-Path $bin (Join-Path 'build' 'image-generator')
$generatedRoot = Join-Path $bin 'generated'
$simulationsRoot = Join-Path $bin 'simulations'
$packageWorkRoot = Join-Path ([System.IO.Path]::GetTempPath()) "simse-vn-package-$PID"
$modelsRoot = Join-Path $root 'res\models'

$javacArgs = @('-encoding', 'UTF-8', '-nowarn')

function Test-BuildMessageLine($line) {
  if ($null -eq $line) { return $false }
  $text = if ($line -is [System.Management.Automation.ErrorRecord]) { $line.ToString() } else { [string]$line }
  return $text -notmatch '^(Note:|warning:)'
}

function Invoke-QuietJavac {
  param([string[]] $Arguments)
  $previousErrorAction = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $output = @(javac @Arguments 2>&1)
    $exitCode = $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $previousErrorAction
  }
  $output | Where-Object { Test-BuildMessageLine $_ } | ForEach-Object {
    if ($_ -is [System.Management.Automation.ErrorRecord]) { Write-Host $_.ToString() } else { Write-Host $_ }
  }
  if ($exitCode -ne 0) {
    throw "javac failed with exit code $exitCode"
  }
}

function Invoke-QuietJava {
  param([string[]] $Arguments)
  $previousErrorAction = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $output = @(java @Arguments 2>&1)
    $exitCode = $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $previousErrorAction
  }
  $output | Where-Object { Test-BuildMessageLine $_ } | ForEach-Object {
    if ($_ -is [System.Management.Automation.ErrorRecord]) { Write-Host $_.ToString() } else { Write-Host $_ }
  }
  if ($exitCode -ne 0) {
    throw "java failed with exit code $exitCode"
  }
}

function Get-JavaHomeFromRuntime {
  $previousErrorAction = $ErrorActionPreference
  try {
    $ErrorActionPreference = 'Continue'
    $settings = @(java -XshowSettings:properties -version 2>&1)
  } finally {
    $ErrorActionPreference = $previousErrorAction
  }
  foreach ($line in $settings) {
    $text = if ($line -is [System.Management.Automation.ErrorRecord]) { $line.ToString() } else { [string]$line }
    if ($text -match '^\s*java\.home\s*=\s*(.+)\s*$') {
      return $Matches[1].Trim()
    }
  }
  return $null
}

function Resolve-JdkJarPath($javaHome) {
  $binDir = Join-Path $javaHome 'bin'
  foreach ($name in @('jar.exe', 'jar')) {
    $candidate = Join-Path $binDir $name
    if (Test-Path -LiteralPath $candidate) { return $candidate }
  }
  return $null
}

function Resolve-JarExe {
  if (Get-Command jar -ErrorAction SilentlyContinue) {
    return (Get-Command jar).Source
  }
  if ($env:JAVA_HOME) {
    $fromHome = Resolve-JdkJarPath $env:JAVA_HOME
    if ($fromHome) { return $fromHome }
  }
  $runtimeHome = Get-JavaHomeFromRuntime
  if ($runtimeHome) {
    $fromRuntime = Resolve-JdkJarPath $runtimeHome
    if ($fromRuntime) { return $fromRuntime }
  }
  if ($IsWindows) {
    $searchRoots = @(
      'C:\Program Files\Java',
      'C:\Program Files\Eclipse Adoptium',
      'C:\Program Files\Microsoft',
      'C:\Program Files\Amazon Corretto',
      'C:\Program Files\Zulu'
    )
    foreach ($rootDir in $searchRoots) {
      if (-not (Test-Path -LiteralPath $rootDir)) { continue }
      $candidateJar = Get-ChildItem -LiteralPath $rootDir -Recurse -Filter 'jar.exe' -ErrorAction SilentlyContinue |
        Sort-Object FullName -Descending |
        Select-Object -First 1
      if ($candidateJar) { return $candidateJar.FullName }
    }
  }
  throw 'Could not find jar. Add JDK bin to PATH or set JAVA_HOME.'
}

$jarExe = Resolve-JarExe

function Reset-Directory($path) {
  if (Test-Path -LiteralPath $path) {
    $removed = $false
    $lastError = $null
    for ($attempt = 1; $attempt -le 12; $attempt++) {
      try {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
        $removed = $true
        break
      } catch {
        $lastError = $_
        Start-Sleep -Milliseconds ([Math]::Min(500 * $attempt, 3000))
      }
    }
    if (-not $removed -and (Test-Path -LiteralPath $path)) {
      $parent = Split-Path -Parent $path
      $leaf = Split-Path -Leaf $path
      $staleName = "$leaf.stale.$PID.$([DateTime]::Now.ToString('yyyyMMddHHmmssfff'))"
      try {
        Rename-Item -LiteralPath $path -NewName $staleName -Force -ErrorAction Stop
      } catch {
        throw $lastError
      }
    }
  }
  New-Item -ItemType Directory -Force -Path $path | Out-Null
}

function Get-ClassPath($libDir) {
  $jars = Get-ChildItem -LiteralPath $libDir -Filter '*.jar' -ErrorAction SilentlyContinue
  if ($jars.Count -eq 0) {
    return ''
  }
  return ($jars | ForEach-Object { $_.FullName }) -join [IO.Path]::PathSeparator
}

function Copy-Resources($sourceRoot, $classRoot) {
  Get-ChildItem -LiteralPath $sourceRoot -Recurse -File |
    Where-Object { $_.Extension -ne '.java' } |
    ForEach-Object {
      $relative = $_.FullName.Substring($sourceRoot.Length).TrimStart('\', '/')
      $target = Join-Path $classRoot $relative
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
      Copy-Item -LiteralPath $_.FullName -Destination $target -Force
    }
}

function Copy-BuilderResources($sourceRoot, $classRoot) {
  Get-ChildItem -LiteralPath $sourceRoot -Recurse -Directory -Filter 'res' |
    ForEach-Object {
      $relative = $_.FullName.Substring($sourceRoot.Length).TrimStart('\', '/')
      $target = Join-Path $classRoot $relative
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
      Copy-Item -LiteralPath $_.FullName -Destination (Split-Path -Parent $target) -Recurse -Force
    }
}

function Write-Utf8NoBom($path, $value) {
  $parent = Split-Path -Parent $path
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $value, $utf8NoBom)
}

function Convert-JavaUnicodeEscapes($value) {
  return [regex]::Replace($value, '\\u([0-9A-Fa-f]{4})', {
    param($match)
    [string][char][Convert]::ToInt32($match.Groups[1].Value, 16)
  })
}

function ConvertTo-JavaStringLiteral($value) {
  $escaped = $value.Replace('\', '\\').Replace('"', '\"')
  $escaped = $escaped.Replace("`r", '\r').Replace("`n", '\n')
  return '"' + $escaped + '"'
}

function Resolve-WindowTitleSuffix($studentName, $studentId, $fallbackSuffix) {
  $parts = @()
  if (-not [string]::IsNullOrWhiteSpace($studentName)) {
    $parts += $studentName.Trim()
  }
  if (-not [string]::IsNullOrWhiteSpace($studentId)) {
    $parts += $studentId.Trim()
  }
  if ($parts.Count -gt 0) {
    return ($parts -join ' - ')
  }
  if (-not [string]::IsNullOrWhiteSpace($fallbackSuffix)) {
    return $fallbackSuffix.Trim()
  }
  return ''
}

function Apply-GeneratedWindowTitleSuffix($generatedRoot, $suffix) {
  if ([string]::IsNullOrWhiteSpace($suffix)) {
    return
  }
  $titleLiteral = ConvertTo-JavaStringLiteral ("SimSE - " + $suffix.Trim())
  Get-ChildItem -LiteralPath $generatedRoot -Recurse -Filter 'SimSEGUI.java' -ErrorAction SilentlyContinue |
    ForEach-Object {
      $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName
      $updated = $text.Replace('String title = "SimSE";', "String title = $titleLiteral;")
      if ($updated -ne $text) {
        Write-Utf8NoBom $_.FullName $updated
      }
    }
}

function Get-GeneralVisibleStringReplacements {
  $u = { param($s) Convert-JavaUnicodeEscapes $s }
  $pairs = @(
    ,@('Change pay rate', (& $u '\u0110\u1ED5i l\u01B0\u01A1ng gi\u1EDD'))
    ,@('Give bonus', (& $u 'Th\u01B0\u1EDFng th\u00EAm'))
    ,@('Tool(s) have been purchased!', (& $u 'C\u00F4ng c\u1EE5 \u0111\u00E3 \u0111\u01B0\u1EE3c mua!'))
    ,@('Review t\u00E0i li\u1EC7u', (& $u 'R\u00E0 so\u00E1t t\u00E0i li\u1EC7u'))
    ,@('Review k\u1EBF ho\u1EA1ch', (& $u 'R\u00E0 so\u00E1t k\u1EBF ho\u1EA1ch'))
    ,@('Inspection code', (& $u 'Ki\u1EC3m tra code'))
    ,@('Purchase c\u00F4ng c\u1EE5(s)', (& $u 'Mua c\u00F4ng c\u1EE5'))
    ,@('Purchase C\u00F4ng c\u1EE5(s)', (& $u 'Mua c\u00F4ng c\u1EE5'))
    ,@('Purchase tool(s)', (& $u 'Mua c\u00F4ng c\u1EE5'))
    ,@('Purchase Tool(s)', (& $u 'Mua c\u00F4ng c\u1EE5'))
    ,@('Tool(s)', (& $u 'C\u00F4ng c\u1EE5'))
    ,@('FiredPerson(s): ', (& $u 'Nh\u00E2n vi\u00EAn b\u1ECB cho ngh\u1EC9: '))
    ,@('I''m not doing anything right now', (& $u 'T\u00F4i hi\u1EC7n kh\u00F4ng l\u00E0m g\u00EC'))
    ,@('Choose ', (& $u 'Ch\u1ECDn '))
    ,@('Composite Graph', (& $u '\u0110\u1ED3 th\u1ECB t\u1ED5ng h\u1EE3p'))
    ,@(' Attributes', (& $u ' - Thu\u1ED9c t\u00EDnh'))
    ,@('an object to graph', (& $u '\u0111\u1ED1i t\u01B0\u1EE3ng \u0111\u1EC3 v\u1EBD \u0111\u1ED3 th\u1ECB'))
    ,@('tong hop', (& $u 't\u1ED5ng h\u1EE3p'))
    ,@('va cac', (& $u 'v\u00E0 c\u00E1c'))
    ,@('which attributes to show', (& $u 'thu\u1ED9c t\u00EDnh c\u1EA7n hi\u1EC3n th\u1ECB'))
    ,@('which actions to show', (& $u 'h\u00E0nh \u0111\u1ED9ng c\u1EA7n hi\u1EC3n th\u1ECB'))
    ,@('which trigger show', (& $u '\u0111i\u1EC1u ki\u1EC7n k\u00EDch ho\u1EA1t c\u1EA7n hi\u1EC3n th\u1ECB'))
    ,@('which destroyer to show', (& $u '\u0111i\u1EC1u ki\u1EC7n k\u1EBFt th\u00FAc c\u1EA7n hi\u1EC3n th\u1ECB'))
    ,@('T\u00F4i \u0111ang review t\u00E0i li\u1EC7u y\u00EAu c\u1EA7u \u0111\u1EC3 t\u00ECm l\u1ED7i.', (& $u 'T\u00F4i \u0111ang r\u00E0 so\u00E1t t\u00E0i li\u1EC7u y\u00EAu c\u1EA7u \u0111\u1EC3 t\u00ECm l\u1ED7i.'))
    ,@('T\u00F4i \u0111ang review t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF \u0111\u1EC3 t\u00ECm l\u1ED7i.', (& $u 'T\u00F4i \u0111ang r\u00E0 so\u00E1t t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF \u0111\u1EC3 t\u00ECm l\u1ED7i.'))
    ,@('T\u00F4i \u0111\u00E3 review xong t\u00E0i li\u1EC7u y\u00EAu c\u1EA7u.', (& $u 'T\u00F4i \u0111\u00E3 r\u00E0 so\u00E1t xong t\u00E0i li\u1EC7u y\u00EAu c\u1EA7u.'))
    ,@('T\u00F4i \u0111\u00E3 review xong t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF.', (& $u 'T\u00F4i \u0111\u00E3 r\u00E0 so\u00E1t xong t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF.'))
    ,@('T\u00F4i \u0111\u00E3 review xong k\u1EBF ho\u1EA1ch ki\u1EC3m th\u1EED h\u1EC7 th\u1ED1ng.', (& $u 'T\u00F4i \u0111\u00E3 r\u00E0 so\u00E1t xong k\u1EBF ho\u1EA1ch ki\u1EC3m th\u1EED h\u1EC7 th\u1ED1ng.'))
    ,@('T\u00F4i \u0111\u00E3 d\u1EEBng review t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF.', (& $u 'T\u00F4i \u0111\u00E3 d\u1EEBng r\u00E0 so\u00E1t t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF.'))
    ,@('T\u00F4i \u0111ang inspection code \u0111\u1EC3 t\u00ECm l\u1ED7i.', (& $u 'T\u00F4i \u0111ang ki\u1EC3m tra code \u0111\u1EC3 t\u00ECm l\u1ED7i.'))
    ,@('T\u00F4i \u0111\u00E3 inspection code xong.', (& $u 'T\u00F4i \u0111\u00E3 ki\u1EC3m tra code xong.'))
    ,@('T\u00F4i \u0111\u00E3 d\u1EEBng inspection code.', (& $u 'T\u00F4i \u0111\u00E3 d\u1EEBng ki\u1EC3m tra code.'))
    ,@('T\u00F4i \u0111ang fired?! Waaahhh!', (& $u 'T\u00F4i b\u1ECB cho ngh\u1EC9 vi\u1EC7c r\u1ED3i?!'))
    ,@('I QUIT!', (& $u 'T\u00F4i ngh\u1EC9 vi\u1EC7c!'))
    ,@('Aaaa-CHOO! T\u00F4i \u0111ang sick!', (& $u 'H\u1EAFt x\u00EC! T\u00F4i b\u1ECB b\u1EC7nh!'))
    ,@('T\u00F4i \u0111ang not sick anymore -- back to work!', (& $u 'T\u00F4i \u0111\u00E3 kh\u1ECFi b\u1EC7nh, quay l\u1EA1i l\u00E0m vi\u1EC7c!'))
    ,@('Thanks for the bonus!', (& $u 'C\u1EA3m \u01A1n kho\u1EA3n th\u01B0\u1EDFng!'))
    ,@('The kh\u00E1ch h\u00E0ng just gave us some new y\u00EAu c\u1EA7u!', (& $u 'Kh\u00E1ch h\u00E0ng v\u1EEBa \u0111\u01B0a th\u00EAm y\u00EAu c\u1EA7u m\u1EDBi!'))
    ,@('T\u00F4i \u0111\u00E3 d\u1EEBng unit testing and fixing', (& $u 'T\u00F4i \u0111\u00E3 d\u1EEBng ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa l\u1ED7i'))
    ,@('T\u00F4i \u0111\u00E3 d\u1EEBng refactoring the code', (& $u 'T\u00F4i \u0111\u00E3 d\u1EEBng t\u00E1i c\u1EA5u tr\u00FAc code'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 d\u1EEBng integrating.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 d\u1EEBng t\u00EDch h\u1EE3p.'))
    ,@('T\u00F4i \u0111\u00E3 d\u1EEBng integrating', (& $u 'T\u00F4i \u0111\u00E3 d\u1EEBng t\u00EDch h\u1EE3p'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 halted acceptance testing', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 d\u1EEBng ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh creating user stories.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh t\u1EA1o c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng.'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh creating the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh t\u1EA1o ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh creating ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh t\u1EA1o ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB.'))
    ,@('T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh programming!', (& $u 'T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh l\u1EADp tr\u00ECnh!'))
    ,@('T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh unit testing and fixing', (& $u 'T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa l\u1ED7i'))
    ,@('T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh refactoring the code', (& $u 'T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh t\u00E1i c\u1EA5u tr\u00FAc code'))
    ,@('T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh learning the coding standard, and feel comfortable enough to start using it now.', (& $u 'T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n v\u00E0 \u0111\u1EE7 t\u1EF1 tin \u0111\u1EC3 b\u1EAFt \u0111\u1EA7u s\u1EED d\u1EE5ng.'))
    ,@('T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh integrating', (& $u 'T\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh t\u00EDch h\u1EE3p'))
    ,@('D\u1EEBng integrating - ', (& $u 'D\u1EEBng t\u00EDch h\u1EE3p - '))
    ,@('Nam and H\u01B0\u01A1ng', (& $u 'Nam v\u00E0 H\u01B0\u01A1ng'))
    ,@('Minh and Lan', (& $u 'Minh v\u00E0 Lan'))
    ,@('Trang and Quang', (& $u 'Trang v\u00E0 Quang'))
    ,@('Ch\u00FAng t\u00F4i \u0111ang now choosing which stories will be developed in this iteration.', (& $u 'Ch\u00FAng t\u00F4i \u0111ang ch\u1ECDn c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng s\u1EBD ph\u00E1t tri\u1EC3n trong v\u00F2ng l\u1EB7p n\u00E0y.'))
    ,@('Ch\u00FAng t\u00F4i \u0111ang now breaking down the user stories into programming tasks and signing up for who will ho\u00E0n th\u00E0nh each one.', (& $u 'Ch\u00FAng t\u00F4i \u0111ang chia c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng th\u00E0nh t\u00E1c v\u1EE5 l\u1EADp tr\u00ECnh v\u00E0 \u0111\u0103ng k\u00FD ng\u01B0\u1EDDi ho\u00E0n th\u00E0nh t\u1EEBng t\u00E1c v\u1EE5.'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh the release planning meeting, and produced a release plan, which specifies which user stories are going to be implemented for each system release and dates for those releases.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh v\u00E0 t\u1EA1o k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh, trong \u0111\u00F3 x\u00E1c \u0111\u1ECBnh c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng s\u1EBD \u0111\u01B0\u1EE3c hi\u1EC7n th\u1EF1c cho t\u1EEBng b\u1EA3n ph\u00E1t h\u00E0nh v\u00E0 ng\u00E0y ph\u00E1t h\u00E0nh.'))
    ,@('We have ho\u00E0n th\u00E0nhd the iteration plan and adjourned the meeting.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p v\u00E0 k\u1EBFt th\u00FAc cu\u1ED9c h\u1ECDp.'))
    ,@('Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh k\u1EBF ho\u1EA1ch iteration v\u00E0 k\u1EBFt th\u00FAc cu\u1ED9c h\u1ECDp. It took longer than expected because the kh\u00E1ch h\u00E0ng was not involved in the release planning meeting, so we had a lot of issues to hash out in this meeting.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ho\u00E0n th\u00E0nh k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p v\u00E0 k\u1EBFt th\u00FAc cu\u1ED9c h\u1ECDp. Vi\u1EC7c n\u00E0y m\u1EA5t nhi\u1EC1u th\u1EDDi gian h\u01A1n d\u1EF1 ki\u1EBFn v\u00EC kh\u00E1ch h\u00E0ng kh\u00F4ng tham gia h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh, n\u00EAn c\u00F3 nhi\u1EC1u v\u1EA5n \u0111\u1EC1 ph\u1EA3i th\u1ED1ng nh\u1EA5t trong cu\u1ED9c h\u1ECDp n\u00E0y.'))
    ,@('We have chosen about 20 user stories to be ho\u00E0n th\u00E0nhd in this iteration.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 ch\u1ECDn kho\u1EA3ng 20 c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng \u0111\u1EC3 ho\u00E0n th\u00E0nh trong v\u00F2ng l\u1EB7p n\u00E0y.'))
    ,@('We have finished creating and signing up for programming tasks.', (& $u 'Ch\u00FAng t\u00F4i \u0111\u00E3 t\u1EA1o v\u00E0 \u0111\u0103ng k\u00FD c\u00E1c t\u00E1c v\u1EE5 l\u1EADp tr\u00ECnh.'))
    ,@('Hooray! All ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn passed! We can release the code and end this iteration.', (& $u 'Tuy\u1EC7t! T\u1EA5t c\u1EA3 ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn \u0111\u00E3 th\u00E0nh c\u00F4ng. Ch\u00FAng ta c\u00F3 th\u1EC3 ph\u00E1t h\u00E0nh code v\u00E0 k\u1EBFt th\u00FAc v\u00F2ng l\u1EB7p n\u00E0y.'))
    ,@('Some of the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn failed because there are some bug in the code. The kh\u00E1ch h\u00E0ng wants us to fix them before we move on.', (& $u 'M\u1ED9t s\u1ED1 ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn kh\u00F4ng pass v\u00EC code c\u00F3 bug. Kh\u00E1ch h\u00E0ng mu\u1ED1n ch\u00FAng ta s\u1EEDa tr\u01B0\u1EDBc khi ti\u1EBFp t\u1EE5c.'))
    ,@('About half of the accpetance tests failed because the kh\u00E1ch h\u00E0ng said they were the wrong tests to run. We have revised the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn cases, but we now have some work to do correcting the incorrect functionality.', (& $u 'Kho\u1EA3ng m\u1ED9t n\u1EEDa ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn kh\u00F4ng pass v\u00EC kh\u00E1ch h\u00E0ng n\u00F3i ch\u00FAng ta ch\u1EA1y sai test. Ch\u00FAng ta \u0111\u00E3 c\u1EADp nh\u1EADt c\u00E1c test case ch\u1EA5p nh\u1EADn, nh\u01B0ng v\u1EABn c\u1EA7n s\u1EEDa c\u00E1c ch\u1EE9c n\u0103ng ch\u01B0a \u0111\u00FAng.'))
    ,@('Not only did the kh\u00E1ch h\u00E0ng say we had the wrong acceptance test cases and a lot of incorrect functionality, but the tests also revealed a number of bug in the code! We have to go back and fix these problems before the kh\u00E1ch h\u00E0ng will accept this release.', (& $u 'Kh\u00E1ch h\u00E0ng kh\u00F4ng ch\u1EC9 n\u00F3i ca ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn b\u1ECB sai v\u00E0 nhi\u1EC1u ch\u1EE9c n\u0103ng ch\u01B0a \u0111\u00FAng, m\u00E0 c\u00E1c ca ki\u1EC3m th\u1EED c\u00F2n ph\u00E1t hi\u1EC7n th\u00EAm nhi\u1EC1u l\u1ED7i trong code. Ch\u00FAng ta ph\u1EA3i quay l\u1EA1i s\u1EEDa c\u00E1c v\u1EA5n \u0111\u1EC1 n\u00E0y tr\u01B0\u1EDBc khi kh\u00E1ch h\u00E0ng ch\u1EA5p nh\u1EADn b\u1EA3n ph\u00E1t h\u00E0nh.'))
    ,@('T\u00F4i \u0111ang bored... I''ll just sit here and play solitaire ''til you tell me what to do.', (& $u 'T\u00F4i \u0111ang r\u1EA3nh... t\u00F4i s\u1EBD ng\u1ED3i \u0111\u1EE3i \u0111\u1EBFn khi b\u1EA1n giao vi\u1EC7c.'))
    ,@('Management found out that we held the release planning meeting without them. They say our release plan is all wrong, and we must be redone immediately, before any more progress is made!', (& $u 'Qu\u1EA3n l\u00FD ph\u00E1t hi\u1EC7n ch\u00FAng ta \u0111\u00E3 h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh m\u00E0 kh\u00F4ng c\u00F3 h\u1ECD. H\u1ECD n\u00F3i k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh sai v\u00E0 ph\u1EA3i l\u00E0m l\u1EA1i ngay tr\u01B0\u1EDBc khi ti\u1EBFp t\u1EE5c.'))
    ,@('WHAT''S GOING ON?? I expected to see a new release of the code by now. Where is it??', (& $u 'CHUY\u1EC6N G\u00CC \u0110ANG X\u1EA2Y RA? T\u00F4i mong \u0111\u1EE3i c\u00F3 b\u1EA3n ph\u00E1t h\u00E0nh code m\u1EDBi r\u1ED3i. N\u00F3 \u0111\u00E2u?'))
    ,@('WARNING: The final deadline for the d\u1EF1 \u00E1n is only 100 ticks away! At the deadline, we have to deliver whatever we have so far to the kh\u00E1ch h\u00E0ng!', (& $u 'C\u1EA2NH B\u00C1O: Deadline cu\u1ED1i c\u1EE7a d\u1EF1 \u00E1n ch\u1EC9 c\u00F2n 100 nh\u1ECBp! \u0110\u1EBFn deadline, ch\u00FAng ta ph\u1EA3i b\u00E0n giao nh\u1EEFng g\u00EC \u0111ang c\u00F3 cho kh\u00E1ch h\u00E0ng!'))
    ,@('TIME IS UP! The kh\u00E1ch h\u00E0ng demands the product right now!', (& $u 'H\u1EBET GI\u1EDC! Kh\u00E1ch h\u00E0ng y\u00EAu c\u1EA7u s\u1EA3n ph\u1EA9m ngay b\u00E2y gi\u1EDD!'))
  )
  $map = [ordered]@{}
  foreach ($pair in $pairs) {
    $map[(& $u $pair[0])] = $pair[1]
  }
  return $map
}

function Resolve-JavaReplacementText($value) {
  if ($null -eq $value) {
    return $value
  }
  return Convert-JavaUnicodeEscapes $value
}

function Resolve-JavaReplacementMap($replacements) {
  if ($replacements -is [System.Collections.IDictionary]) {
    $resolved = [ordered]@{}
    foreach ($key in $replacements.Keys) {
      $resolved[(Resolve-JavaReplacementText $key)] = (Resolve-JavaReplacementText $replacements[$key])
    }
    return $resolved
  }

  $resolved = [System.Collections.ArrayList]@()
  for ($i = 0; $i -lt $replacements.Count; $i++) {
    $replacement = $replacements[$i]
    if ($replacement -is [string]) {
      if (($i + 1) -lt $replacements.Count) {
        [void]$resolved.Add((Resolve-JavaReplacementText $replacement))
        [void]$resolved.Add((Resolve-JavaReplacementText $replacements[$i + 1]))
        $i++
      }
    } else {
      [void]$resolved.Add(@(
          (Resolve-JavaReplacementText $replacement[0])
          (Resolve-JavaReplacementText $replacement[1])
        ))
    }
  }
  return @($resolved)
}

function Replace-InJavaStringLiterals($text, $replacements) {
  return [regex]::Replace($text, '"(?:\\.|[^"\\])*"', {
    param($match)
    $literal = $match.Value
    # Do not rename employees inside icon resource paths (e.g. Emilyv2.gif for Trang).
    if ($literal -match '/simse/gui/icons/') {
      return $literal
    }
    if ($replacements -is [System.Collections.IDictionary]) {
      foreach ($key in $replacements.Keys) {
        $literal = $literal.Replace($key, $replacements[$key])
      }
    } else {
      for ($i = 0; $i -lt $replacements.Count; $i++) {
        $replacement = $replacements[$i]
        if ($replacement -is [string]) {
          if (($i + 1) -lt $replacements.Count) {
            $literal = $literal.Replace($replacement, $replacements[$i + 1])
            $i++
          }
        } else {
          $literal = $literal.Replace($replacement[0], $replacement[1])
        }
      }
    }
    $literal
  })
}

function Get-XpExactStringReplacements {
  $u = { param($s) Convert-JavaUnicodeEscapes $s }
  $pairs = @(
    ,@((& $u '"Design"'), (& $u '"Thi\u1EBFt k\u1EBF"'))
    ,@((& $u '"Program"'), (& $u '"L\u1EADp tr\u00ECnh"'))
    ,@((& $u '"Integrate"'), (& $u '"T\u00EDch h\u1EE3p"'))
    ,@('"Stories"', (& $u '"C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng"'))
    ,@((& $u '"Release Plan"'), (& $u '"K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh"'))
    ,@((& $u '"IterationPlan"'), (& $u '"K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p"'))
    ,@((& $u '"Test cases that kh\u00E1ch h\u00E0ngs and developers agree will be the criteria for acceptance of the software"'), (& $u '"B\u1ED9 ca ki\u1EC3m th\u1EED m\u00E0 kh\u00E1ch h\u00E0ng v\u00E0 l\u1EADp tr\u00ECnh vi\u00EAn th\u1ED1ng nh\u1EA5t d\u00F9ng l\u00E0m ti\u00EAu ch\u00ED ch\u1EA5p nh\u1EADn ph\u1EA7n m\u1EC1m"'))
    ,@((& $u '"Class Responsibility Collaborator Cards, a brainstorming c\u00F4ng c\u1EE5 for thi\u1EBFt k\u1EBF object-oriented software"'), (& $u '"Th\u1EBB CRC, c\u00F4ng c\u1EE5 brainstorm cho thi\u1EBFt k\u1EBF ph\u1EA7n m\u1EC1m h\u01B0\u1EDBng \u0111\u1ED1i t\u01B0\u1EE3ng"'))
    ,@((& $u '"CRC cards for this iteration''s stories"'), (& $u '"Th\u1EBB CRC cho c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng c\u1EE7a v\u00F2ng l\u1EB7p n\u00E0y"'))
    ,@((& $u '"Java-based unit testing framework"'), (& $u '"Framework ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB n\u1EC1n Java"'))
    ,@((& $u '"Test cases for individual pieces of source code"'), (& $u '"Ca ki\u1EC3m th\u1EED cho t\u1EEBng ph\u1EA7n m\u00E3 ngu\u1ED3n"'))
    ,@((& $u '"Code cho c\u00E1c user story c\u1EE7a iteration hi\u1EC7n t\u1EA1i"'), (& $u '"M\u00E3 ngu\u1ED3n cho c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng c\u1EE7a v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i"'))
    ,@((& $u '"A standard style and format for source code"'), (& $u '"Chu\u1EA9n ki\u1EC3u d\u00E1ng v\u00E0 \u0111\u1ECBnh d\u1EA1ng cho m\u00E3 ngu\u1ED3n"'))
    ,@((& $u '"Acceptance testing"'), (& $u '"Ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn"'))
    ,@('"Pair Program (Minh and Lan)"', (& $u '"L\u1EADp tr\u00ECnh c\u1EB7p (Minh v\u00E0 Lan)"'))
    ,@((& $u '"Pair program (Nam and H\u01B0\u01A1ng)"'), (& $u '"L\u1EADp tr\u00ECnh c\u1EB7p (Nam v\u00E0 H\u01B0\u01A1ng)"'))
    ,@('"Pair program (Trang and Quang)"', (& $u '"L\u1EADp tr\u00ECnh c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@((& $u '"Pair integrate (Nam and H\u01B0\u01A1ng)"'), (& $u '"T\u00EDch h\u1EE3p c\u1EB7p (Nam v\u00E0 H\u01B0\u01A1ng)"'))
    ,@('"Pair integrate (Minh and Lan)"', (& $u '"T\u00EDch h\u1EE3p c\u1EB7p (Minh v\u00E0 Lan)"'))
    ,@('"Pair integrate (Trang and Quang)"', (& $u '"T\u00EDch h\u1EE3p c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@((& $u '"Deliver final product to kh\u00E1ch h\u00E0ng"'), (& $u '"Giao s\u1EA3n ph\u1EA9m cu\u1ED1i cho kh\u00E1ch h\u00E0ng"'))
    ,@((& $u '"D\u1EEBng thi\u1EBFt k\u1EBFing"'), (& $u '"D\u1EEBng thi\u1EBFt k\u1EBF"'))
    ,@((& $u '"D\u1EEBng creating ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB"'), (& $u '"D\u1EEBng t\u1EA1o ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB"'))
    ,@((& $u '"D\u1EEBng learning coding standard"'), (& $u '"D\u1EEBng h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n"'))
    ,@((& $u '"D\u1EEBng programming"'), (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh"'))
    ,@('"Stop pair programming (Nam and H\u01B0\u01A1ng)"', (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Nam v\u00E0 H\u01B0\u01A1ng)"'))
    ,@((& $u '"D\u1EEBng pair programming (Nam and H\u01B0\u01A1ng)"'), (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Nam v\u00E0 H\u01B0\u01A1ng)"'))
    ,@('"Stop pair programming (Minh and Lan)"', (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Minh v\u00E0 Lan)"'))
    ,@((& $u '"D\u1EEBng pair programming (Minh and Lan)"'), (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Minh v\u00E0 Lan)"'))
    ,@('"Stop pair programming (Trang & Quang)"', (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@((& $u '"D\u1EEBng pair programming (Trang & Quang)"'), (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@('"Stop pair programming (Trang and Quang)"', (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@((& $u '"D\u1EEBng pair programming (Trang and Quang)"'), (& $u '"D\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p (Trang v\u00E0 Quang)"'))
    ,@((& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng thi\u1EBFt k\u1EBFing."'), (& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng thi\u1EBFt k\u1EBF."'))
    ,@((& $u '"D\u1EEBng unit testing and fixing"'), (& $u '"D\u1EEBng ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa l\u1ED7i"'))
    ,@((& $u '"D\u1EEBng refactoring"'), (& $u '"D\u1EEBng t\u00E1i c\u1EA5u tr\u00FAc code"'))
    ,@((& $u '"D\u1EEBng integrating - Nam and H\u01B0\u01A1ng"'), (& $u '"D\u1EEBng t\u00EDch h\u1EE3p - Nam v\u00E0 H\u01B0\u01A1ng"'))
    ,@((& $u '"D\u1EEBng integrating - Minh and Lan"'), (& $u '"D\u1EEBng t\u00EDch h\u1EE3p - Minh v\u00E0 Lan"'))
    ,@((& $u '"D\u1EEBng integrating - Trang and Quang"'), (& $u '"D\u1EEBng t\u00EDch h\u1EE3p - Trang v\u00E0 Quang"'))
    ,@((& $u '"D\u1EEBng integrating"'), (& $u '"D\u1EEBng t\u00EDch h\u1EE3p"'))
    ,@((& $u '"D\u1EEBng acceptance testing"'), (& $u '"D\u1EEBng ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn"'))
    ,@('"Are you sure you want everyone to stop what they''re doing?"', (& $u '"B\u1EA1n c\u00F3 ch\u1EAFc mu\u1ED1n m\u1ECDi ng\u01B0\u1EDDi d\u1EEBng vi\u1EC7c \u0111ang l\u00E0m kh\u00F4ng?"'))
    ,@('"Confirm Activities Ending"', (& $u '"X\u00E1c nh\u1EADn k\u1EBFt th\u00FAc ho\u1EA1t \u0111\u1ED9ng"'))
    ,@('"Are you sure you want to end the game?"', (& $u '"B\u1EA1n c\u00F3 ch\u1EAFc mu\u1ED1n k\u1EBFt th\u00FAc tr\u00F2 ch\u01A1i kh\u00F4ng?"'))
    ,@('"Confirm Game Ending"', (& $u '"X\u00E1c nh\u1EADn k\u1EBFt th\u00FAc tr\u00F2 ch\u01A1i"'))
    ,@((& $u '"Chao mung!"'), (& $u '"Ch\u00E0o m\u1EEBng!"'))
    ,@('"We have started a new iteration. What would you like us to do now??"', (& $u '"Ch\u00FAng t\u00F4i \u0111\u00E3 b\u1EAFt \u0111\u1EA7u v\u00F2ng l\u1EB7p m\u1EDBi. B\u1EA1n mu\u1ED1n ch\u00FAng t\u00F4i l\u00E0m g\u00EC ti\u1EBFp theo?"'))
    ,@('"We have released the current system and ended this iteration. What next???"', (& $u '"Ch\u00FAng t\u00F4i \u0111\u00E3 ph\u00E1t h\u00E0nh h\u1EC7 th\u1ED1ng hi\u1EC7n t\u1EA1i v\u00E0 k\u1EBFt th\u00FAc v\u00F2ng l\u1EB7p n\u00E0y. Ti\u1EBFp theo l\u00E0m g\u00EC?"'))
    ,@((& $u '"T\u00F4i \u0111ang off to familiarize myself with the coding standard now."'), (& $u '"T\u00F4i \u0111ang h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n."'))
    ,@((& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng programming."'), (& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng l\u1EADp tr\u00ECnh."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111\u00E3 d\u1EEBng pair programming."'), (& $u '"Ch\u00FAng t\u00F4i \u0111\u00E3 d\u1EEBng l\u1EADp tr\u00ECnh c\u1EB7p."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang pair programming now. H\u00E3y theo d\u00F5i code artifact \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang l\u1EADp tr\u00ECnh c\u1EB7p. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m code \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang starting the release planning meeting, in which we prioritize user stories and determine how long each one will take to develop. View the release plan artifact \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang b\u1EAFt \u0111\u1EA7u h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh, trong \u0111\u00F3 ch\u00FAng t\u00F4i \u01B0u ti\u00EAn c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng v\u00E0 \u01B0\u1EDBc l\u01B0\u1EE3ng th\u1EDDi gian ph\u00E1t tri\u1EC3n. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang beginning the iteration planning meeting. H\u00E3y theo d\u00F5i current iteration plan artifact to view our progress."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang b\u1EAFt \u0111\u1EA7u h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang creating the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn now. H\u00E3y theo d\u00F5i ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn artifact to see our progress."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang t\u1EA1o ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang thi\u1EBFt k\u1EBFing the user stories for this iteration. H\u00E3y theo d\u00F5i thi\u1EBFt k\u1EBF artifact to see how we''re progressing."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang thi\u1EBFt k\u1EBF c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng cho v\u00F2ng l\u1EB7p n\u00E0y. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m thi\u1EBFt k\u1EBF \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang creating ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB for each class we thi\u1EBFt k\u1EBFed. You can track our progress by viewing the ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB artifact."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang t\u1EA1o ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB cho t\u1EEBng l\u1EDBp \u0111\u00E3 thi\u1EBFt k\u1EBF. B\u1EA1n c\u00F3 th\u1EC3 theo d\u00F5i ti\u1EBFn \u0111\u1ED9 qua s\u1EA3n ph\u1EA9m ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB."'))
    ,@((& $u '"T\u00F4i \u0111ang t\u00EDch h\u1EE3p code now.  You can monitor our progress by viewing the code artifact."'), (& $u '"T\u00F4i \u0111ang t\u00EDch h\u1EE3p code. B\u1EA1n c\u00F3 th\u1EC3 theo d\u00F5i ti\u1EBFn \u0111\u1ED9 qua s\u1EA3n ph\u1EA9m code."'))
    ,@((& $u '"T\u00F4i \u0111ang running the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn with the kh\u00E1ch h\u00E0ng now, to see if this release meets their expectations. You can monitor the progress of these tests by looking at the ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn artifact."'), (& $u '"T\u00F4i \u0111ang ch\u1EA1y ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn v\u1EDBi kh\u00E1ch h\u00E0ng \u0111\u1EC3 xem b\u1EA3n ph\u00E1t h\u00E0nh n\u00E0y c\u00F3 \u0111\u00E1p \u1EE9ng k\u1EF3 v\u1ECDng kh\u00F4ng. B\u1EA1n c\u00F3 th\u1EC3 theo d\u00F5i ti\u1EBFn \u0111\u1ED9 qua s\u1EA3n ph\u1EA9m ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn."'))
    ,@((& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng creating ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB."'), (& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng t\u1EA1o ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB."'))
    ,@((& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng learning the coding standard"'), (& $u '"T\u00F4i \u0111\u00E3 d\u1EEBng h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n"'))
    ,@((& $u '"Ch\u00FAng t\u00F4i s\u1EAFp t\u1EA1o user story--c\u00E1c m\u00F4 t\u1EA3 ng\u1EAFn v\u1EC1 \u0111i\u1EC1u h\u1EC7 th\u1ED1ng n\u00EAn l\u00E0m. H\u00E3y theo d\u00F5i artifact user stories \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'), (& $u '"Ch\u00FAng t\u00F4i s\u1EAFp t\u1EA1o c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng, c\u00E1c m\u00F4 t\u1EA3 ng\u1EAFn v\u1EC1 \u0111i\u1EC1u h\u1EC7 th\u1ED1ng n\u00EAn l\u00E0m. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"T\u00F4i \u0111ang b\u1EAFt \u0111\u1EA7u l\u1EADp tr\u00ECnh ph\u1EA7n user story c\u1EE7a m\u00ECnh cho iteration n\u00E0y. H\u00E3y theo d\u00F5i artifact code \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'), (& $u '"T\u00F4i \u0111ang b\u1EAFt \u0111\u1EA7u l\u1EADp tr\u00ECnh ph\u1EA7n c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng c\u1EE7a m\u00ECnh cho v\u00F2ng l\u1EB7p n\u00E0y. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m code \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"T\u00F4i s\u1EBD ch\u1EA1y ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa m\u1ECDi bug t\u00ECm th\u1EA5y. B\u1EA1n c\u00F3 th\u1EC3 theo d\u00F5i artifact code \u0111\u1EC3 th\u1EA5y ch\u1EA5t l\u01B0\u1EE3ng code \u0111ang c\u1EA3i thi\u1EC7n."'), (& $u '"T\u00F4i s\u1EBD ch\u1EA1y ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa m\u1ECDi bug t\u00ECm th\u1EA5y. B\u1EA1n c\u00F3 th\u1EC3 theo d\u00F5i s\u1EA3n ph\u1EA9m code \u0111\u1EC3 th\u1EA5y ch\u1EA5t l\u01B0\u1EE3ng code \u0111ang c\u1EA3i thi\u1EC7n."'))
    ,@((& $u '"T\u00F4i \u0111ang refactor code \u0111\u1EC3 c\u1EA3i thi\u1EC7n c\u1EA5u tr\u00FAc, t\u00EDnh nh\u1EA5t qu\u00E1n v\u00E0 \u0111\u1ED9 r\u00F5 r\u00E0ng. H\u00E3y theo d\u00F5i artifact code \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'), (& $u '"T\u00F4i \u0111ang t\u00E1i c\u1EA5u tr\u00FAc code \u0111\u1EC3 c\u1EA3i thi\u1EC7n c\u1EA5u tr\u00FAc, t\u00EDnh nh\u1EA5t qu\u00E1n v\u00E0 \u0111\u1ED9 r\u00F5 r\u00E0ng. H\u00E3y theo d\u00F5i s\u1EA3n ph\u1EA9m code \u0111\u1EC3 xem ti\u1EBFn \u0111\u1ED9."'))
    ,@((& $u '"Ch\u00FAng t\u00F4i \u0111ang t\u00EDch h\u1EE3p code v\u1EDBi ph\u1EA7n c\u00F2n l\u1EA1i c\u1EE7a h\u1EC7 th\u1ED1ng. H\u00E3y xem artifact code \u0111\u1EC3 theo d\u00F5i ti\u1EBFn \u0111\u1ED9."'), (& $u '"Ch\u00FAng t\u00F4i \u0111ang t\u00EDch h\u1EE3p code v\u1EDBi ph\u1EA7n c\u00F2n l\u1EA1i c\u1EE7a h\u1EC7 th\u1ED1ng. H\u00E3y xem s\u1EA3n ph\u1EA9m code \u0111\u1EC3 theo d\u00F5i ti\u1EBFn \u0111\u1ED9."'))
  )
  $map = [ordered]@{}
  foreach ($pair in $pairs) {
    if ($pair.Count -ge 2 -and $pair[0] -and $pair[1]) {
      $map[$pair[0]] = $pair[1]
    }
  }
  return $map
}

function Apply-GeneratedVietnameseTextFixups($generatedRoot) {
  $u = { param($s) Convert-JavaUnicodeEscapes $s }
  $xpExactStrings = Get-XpExactStringReplacements
  $generalVisibleStringReplacements = Get-GeneralVisibleStringReplacements
  $replacements = [ordered]@{
    'Your score is ' = 'Diem cua ban la '
    'Game over!' = 'Tro choi ket thuc!'
    'Current Activities:' = 'Hoat dong hien tai:'
    'Invalid Input -- Please try again!' = 'Du lieu nhap khong hop le -- vui long thu lai!'
    'You must enter input -- Please try again!' = 'Ban phai nhap du lieu -- vui long thu lai!'
    'Invalid Input' = 'Du lieu nhap khong hop le'
    'You must choose at least one action' = 'Ban phai chon it nhat mot action'
    'You must choose at least ' = 'Ban phai chon it nhat '
    'You may only choose at most ' = 'Ban chi duoc chon toi da '
    '" participants"' = '" nguoi tham gia"'
    'Please enter a positive integer number of clock ticks' = 'Vui long nhap so nguyen duong cho so nhip dong ho'
    'Please select at least one attribute' = 'Vui long chon it nhat mot attribute'
    'Please select at least one action' = 'Vui long chon it nhat mot action'
    '"Error"' = '"Loi"'
    '"Warning"' = '"Canh bao"'
    '"Analyze"' = '"Phan tich"'
    '"Analyze Simulation"' = '"Phan tich mo phong"'
    'Start new game from here' = 'Bat dau luot choi moi tu day'
    'Start new branch from here' = 'Bat dau nhanh moi tu day'
    'Please name this new game:' = 'Vui long dat ten luot choi moi nay:'
    'Name New Game' = 'Dat ten luot choi moi'
    'Clock Ticks' = 'Nhip dong ho'
    'Potential Employees' = 'Nhan vien tiem nang'
    'Stop at events' = 'Dung tai su kien'
    'Everyone stop what you''re doing' = 'M\u1ECDi ng\u01B0\u1EDDi d\u1EEBng vi\u1EC7c \u0111ang l\u00E0m'
    '"Requirements"' = '"T\u00E0i li\u1EC7u y\u00EAu c\u1EA7u"'
    '"TestPlan"' = '"K\u1EBF ho\u1EA1ch test"'
    '"Groceries@Home"' = '"T\u1EA1p h\u00F3a t\u1EA1i nh\u00E0"'
    '"Grocery Home Delivery Service"' = '"D\u1ECBch v\u1EE5 giao h\u00E0ng t\u1EA1p h\u00F3a t\u1EA1i nh\u00E0"'
    'Hire Employee - ' = 'Thue nhan vien - '
    'Fire Employee - ' = 'Cho nhan vien nghi - '
    'topPane.add(new JLabel("Choose which " + actionName + " Action to stop:"));' = 'topPane.add(new JLabel("Chon hanh dong de dung:"));'
    'topPane.add(new JLabel("Choose which " + actionName + " Action to join:"));' = 'topPane.add(new JLabel("Chon hanh dong de tham gia:"));'
    '": click for Action info"' = '": bam de xem thong tin hanh dong"'
    '" and Selected Actions"' = '" va cac hanh dong da chon"'
    '" from all of their other actions."' = '" khoi tat ca hanh dong khac."'
    'This action occurs when the user chooses the menu item' = 'H\u00E0nh \u0111\u1ED9ng n\u00E0y x\u1EA3y ra khi ng\u01B0\u1EDDi d\u00F9ng ch\u1ECDn m\u1EE5c menu'
    'This action occurs when the following conditions are met:' = 'H\u00E0nh \u0111\u1ED9ng n\u00E0y x\u1EA3y ra khi c\u00E1c \u0111i\u1EC1u ki\u1EC7n sau \u0111\u01B0\u1EE3c th\u1ECFa m\u00E3n:'
    'and when the following conditions are met:' = 'v\u00E0 khi c\u00E1c \u0111i\u1EC1u ki\u1EC7n sau \u0111\u01B0\u1EE3c th\u1ECFa m\u00E3n:'
  }

  $displayTerms = [ordered]@{
    'AcceptanceTests' = 'Kiem thu chap nhan'
    'Accuracy' = 'Do chinh xac'
    'aCustomer' = 'Khach hang'
    'ArchitecturalPrototype' = 'Prototype kien truc'
    'ArchitectureSkill' = 'Ky nang kien truc'
    'AutomatedTestingTool' = 'Cong cu test tu dong'
    'AutomatedTestingTools' = 'Cong cu test tu dong'
    'AllottedTime' = 'Thoi gian du kien'
    'BeingInspected' = 'Dang duoc inspection'
    'BeingUsed' = 'Dang duoc su dung'
    'Budget' = 'Ngan sach'
    'Changability' = 'Kha nang thay doi'
    'Checklist' = 'Checklist'
    'Checklists' = 'Checklist'
    'ChangeTicks' = 'So nhip thay doi'
    'ChosenForImplementation' = 'Duoc chon de lap trinh'
    'ChosenForPrototyping' = 'Duoc chon de prototype'
    'Code' = 'Ma nguon'
    'CodingExperience' = 'Kinh nghiem coding'
    'CodingStandard' = 'Chuan ma nguon'
    'CompanyName' = 'Ten cong ty'
    'Completeness' = 'Do hoan thien'
    'ConfigurationManagementTool' = 'Cong cu quan ly cau hinh'
    'Cost' = 'Chi ph\u00ED'
    'CRCCards' = 'CRC card'
    'CurrentIteration' = 'Vong lap hien tai'
    'CurrentIterationPlan' = 'Ke hoach vong lap hien tai'
    'CurrentPhase' = 'Pha hien tai'
    'CurrentTime' = 'Thoi gian hien tai'
    'CustomerRep' = 'Dai dien khach hang'
    'CustomerRepresentative' = 'Dai dien khach hang'
    'CustomerSatisfactionLevel' = 'Muc hai long khach hang'
    'Description' = 'Mo ta'
    'Design' = 'Thiet ke'
    'DesignAndDevelopmentSkill' = 'Ky nang thiet ke va phat trien'
    'DesignDifficulty' = 'Do kho thiet ke'
    'DesignDocument' = 'Tai lieu thiet ke'
    'DesignEnvironment' = 'Moi truong thiet ke'
    'DesignExperience' = 'Kinh nghiem thiet ke'
    'DesignProgress' = 'Tien do thiet ke'
    'DesignTool' = 'Cong cu thiet ke'
    'DifficultyAnalysisProgress' = 'Tien do phan tich do kho'
    'Energy' = 'Nang luong'
    'ErrorRateDecreaseFactor' = 'He so giam loi'
    'EstimatedTotalUseCases' = 'Tong use case uoc tinh'
    'IDE' = 'IDE'
    'Idle' = 'Ranh'
    'Implementation' = 'Lap trinh'
    'ImplementationCompleteness' = 'Do hoan thien lap trinh'
    'ImplementationDifficulty' = 'Do kho lap trinh'
    'ImplementationErrorModifier' = 'He so loi lap trinh'
    'ImplementationProgress' = 'Tien do lap trinh'
    'ImplementationSkill' = 'Ky nang lap trinh'
    'ImplementationSpeedModifier' = 'He so toc do lap trinh'
    'ImplementationTool' = 'Cong cu lap trinh'
    'Inflexibility' = 'Do kem linh hoat'
    'InitialDesignDifficulty' = 'Do kho thiet ke ban dau'
    'InitialImplementationDifficulty' = 'Do kho lap trinh ban dau'
    'InitialIntegrationDifficulty' = 'Do kho tich hop ban dau'
    'InitialRequirementsDifficulty' = 'Do kho yeu cau ban dau'
    'Initialized' = 'Da khoi tao'
    'InspectionExperience' = 'Kinh nghiem inspection'
    'IntegrationDifficulty' = 'Do kho tich hop'
    'IntegrationProgress' = 'Tien do tich hop'
    'KnownChangability' = 'Kha nang thay doi da biet'
    'KnownDesignDifficulty' = 'Do kho thiet ke da biet'
    'KnownImplementationDifficulty' = 'Do kho lap trinh da biet'
    'KnownInflexibility' = 'Do kem linh hoat da biet'
    'KnownIntegrationDifficulty' = 'Do kho tich hop da biet'
    'KnownRequirementsDifficulty' = 'Do kho yeu cau da biet'
    'KnownValue' = 'Gia tri da biet'
    'KnowsCodingStandard' = 'Bi\u1EBFt chu\u1EA9n m\u00E3 ngu\u1ED3n'
    'LanguageTool' = 'Cong cu ngon ngu'
    'Manager' = 'Quan ly'
    'MaximumMeetingProductivity' = 'Nang suat meeting toi da'
    'MeetingProductivity' = 'Nang suat meeting'
    'Modifiability' = 'Kha nang sua doi'
    'Module' = 'Module'
    'MoneySpent' = 'Tien da chi'
    'MoneySpentConstructionPhase' = 'Tien da chi pha Xay dung'
    'MoneySpentElaborationPhase' = 'Tien da chi pha Lam ro'
    'MoneySpentInceptionPhase' = 'Tien da chi pha Khoi dau'
    'MoneySpentOnTools' = 'Tien da chi cho cong cu'
    'Mood' = 'Tam trang'
    'Name' = 'Ten'
    'NumberOfDiscoveredDefects' = 'So defect da phat hien'
    'NumberOfLines' = 'So dong'
    'NumberOfPages' = 'So trang'
    'NumberOfUndiscoveredDefects' = 'So defect chua phat hien'
    'NumCRCCardsCompleted' = 'So CRC card da xong'
    'NumKnownErrors' = 'So loi da biet'
    'NumRequirementsDiscovered' = 'So yeu cau da tim ra'
    'NumRequirementsNotDiscovered' = 'So yeu cau chua tim ra'
    'NumRequirementsSpecified' = 'So yeu cau da dac ta'
    'NumRequirementsTotal' = 'Tong so yeu cau'
    'NumUnknownErrors' = 'So loi ch\u01B0a bi\u1EBFt'
    'NumUseCasesContainedAtSubmission' = 'So use case khi nop'
    'NumUseCasesCurrentlyContained' = 'So use case hien co'
    'NumUserStoriesImplemented' = 'So cau chuyen da hien thuc'
    'NumUserStoriesIntegrated' = 'So cau chuyen da tich hop'
    'NumUserStoriesSpecified' = 'So cau chuyen da dac ta'
    'OverBudget' = 'Vuot ngan sach'
    'OverTime' = 'Vuot thoi gian'
    'PayRate' = 'Luong gio'
    'PercentComplete' = 'Ph\u1EA7n tr\u0103m ho\u00E0n th\u00E0nh'
    'PercentDiscoveredRequirementsPrototyped' = 'Ph\u1EA7n tr\u0103m yeu cau da prototype'
    'PercentErroneous' = 'Ph\u1EA7n tr\u0103m sai'
    'PercentEvaluated' = 'Ph\u1EA7n tr\u0103m da danh gia'
    'PercentImplemented' = 'Phan tram da hien thuc'
    'PercentIntegrated' = 'Phan tram da tich hop'
    'PercentRefactored' = 'Phan tram da tai cau truc'
    'PercentTested' = 'Phan tram da kiem thu'
    'Phase' = 'Pha'
    'PhasePlan' = 'Ke hoach pha'
    'Prioritized' = 'Da uu tien'
    'PriorityRiskLevel' = 'Muc rui ro uu tien'
    'ProductCompletenessScore' = 'Diem hoan thien san pham'
    'ProductCorrectnessScore' = 'Diem dung san pham'
    'ProductivityIncreaseFactor' = 'He so tang nang suat'
    'ProjectExperience' = 'Kinh nghiem du an'
    'ProjectManagementSkill' = 'Ky nang quan ly du an'
    'ProjectPlan' = 'Ke hoach du an'
    'Prototype' = 'Prototype'
    'PrototypingSpeedModifier' = 'He so toc do prototype'
    'Purchased' = 'Da mua'
    'RefactoringTool' = 'Cong cu tai cau truc'
    'ReleasePlan' = 'Ke hoach phat hanh'
    'Requirements' = 'Yeu cau'
    'RequirementsCaptureTool' = 'Cong cu thu thap yeu cau'
    'RequirementsDifficulty' = 'Do kho yeu cau'
    'RequirementsDocument' = 'Tai lieu yeu cau'
    'RequirementsExperience' = 'Kinh nghiem yeu cau'
    'RequirementsProgress' = 'Tien do yeu cau'
    'RequirementsSkill' = 'Ky nang yeu cau'
    'RequirementsTool' = 'Cong cu yeu cau'
    'RiskAnalysis' = 'Phan tich rui ro'
    'RiskAnalysisExperience' = 'Kinh nghiem phan tich rui ro'
    'RiskAnalysisProgress' = 'Tien do phan tich rui ro'
    'Satisfaction' = 'Hai long'
    'ScheduleScore' = 'Diem lich trinh'
    'ScootieSoftwareProject' = 'Du an phan mem Scootie'
    'Score' = 'Diem'
    'SEProject' = 'Du an phan mem'
    'SoftwareDeveloper' = 'Lap trinh vien'
    'SoftwareDevelopmentExperience' = 'Kinh nghiem phat trien phan mem'
    'SoftwareEngineer' = 'Ky su phan mem'
    'SoftwareProject' = 'Du an phan mem'
    'SpecificationCompleteness' = 'Do hoan thien dac ta'
    'SuggestedBudgetConstructionPhase' = 'Ngan sach goi y pha Xay dung'
    'SuggestedBudgetElaborationPhase' = 'Ngan sach goi y pha Lam ro'
    'SuggestedBudgetInceptionPhase' = 'Ngan sach goi y pha Khoi dau'
    'SuggestedToolBudget' = 'Ngan sach cong cu goi y'
    'SystemTestPlan' = 'Ke hoach test he thong'
    'TestingExperience' = 'Kinh nghiem testing'
    'TestingTool' = 'Cong cu testing'
    'TestsFailed' = 'So test that bai'
    'TestSkill' = 'Ky nang test'
    'TestsRun' = 'So test da chay'
    'TheCustomer' = 'Khach hang'
    'TheProject' = 'Du an'
    'TimeAllotted' = 'Thoi gian duoc cap'
    'TimeElapsed' = 'Thoi gian da qua'
    'TimeUsed' = 'Thoi gian da dung'
    'TotalSatisfaction' = 'Tong hai long'
    'UnitTestingFramework' = 'Framework test don vi'
    'UnitTests' = 'Kiem thu don vi'
    'UseCase' = 'Use case'
    'UserManuals' = 'Huong dan nguoi dung'
    'UserStories' = 'Cau chuyen nguoi dung'
    'Value' = 'Gia tri'
    'WastedMoney' = 'Tien lang phi'
  }

  $exactStrings = [ordered]@{
    '"Artifacts At-A-Glance"' = '"Tong quan san pham"'
    '"Customers At-A-Glance"' = '"Tong quan khach hang"'
    '"Employees At-A-Glance"' = '"Tong quan nhan vien"'
    '"Projects At-A-Glance"' = '"Tong quan du an"'
    '"Tools At-A-Glance"' = '"Tong quan cong cu"'
    '"Choose Action Role"' = '"Chon vai tro hanh dong"'
    '"Join Action"' = '"Tham gia hanh dong"'
    '"Stop Action(s)"' = '"Dung hanh dong"'
    '"Participant Selection"' = '"Chon nguoi tham gia"'
    '"Multiple Timelines Browser"' = '"Trinh xem nhieu dong thoi gian"'
    '"Welcome!"' = '"Chao mung!"'
    '"Hide"' = (Convert-JavaUnicodeEscapes '"\u1EA8n"')
    '"Unhide"' = '"Hien"'
    '"Potential Employees"' = '"Nhan vien tiem nang"'
    '"Action Graph:"' = '"Do thi hanh dong:"'
    '"Object Graph:"' = '"Do thi doi tuong:"'
    '"Show Attributes:"' = '"Hien thuoc tinh:"'
    '"Generate Graph(s):"' = '"Tao do thi:"'
    '"Participants:"' = '"Nguoi tham gia:"'
    '"Actions:"' = '"Hanh dong:"'
    '"View Rules:"' = '"Xem rule:"'
    '"Trigger Rules:"' = '"Rule kich hoat:"'
    '"Intermediate Rules:"' = '"Rule trung gian:"'
    '"Destroyer Rules:"' = '"Rule huy:"'
    '"Triggers:"' = '"Kich hoat:"'
    '"Destroyers:"' = '"Ket thuc:"'
    '"Trigger:"' = '"Kich hoat:"'
    '"Destroyer:"' = '"Ket thuc:"'
    '"ActionDescription:"' = '"Mo ta hanh dong:"'
    '"Description:"' = '"Mo ta:"'
    '"Choose role to play:"' = '"Chon vai tro de choi:"'
    '"An Educational Software Engineering Simulation Environment"' = '"Moi truong mo phong giao duc quy trinh cong nghe phan mem"'
    '"Lead Developer:"' = '"Lap trinh vien chinh:"'
    '"Contributing Developer:"' = '"Lap trinh vien dong gop:"'
    '"Developer dong gop:"' = '"Lap trinh vien dong gop:"'
    '"Supervising Faculty:"' = '"Giang vien huong dan:"'
    '"Action Info"' = '"Thong tin hanh dong"'
    '"Action Graph"' = '"Do thi hanh dong"'
    '"Composite (Object/Action) Graph"' = '"Do thi tong hop doi tuong/hanh dong"'
    '"Explanatory Tool"' = '"Cong cu giai thich"'
    '"Choose which attributes to graph"' = '"Chon thuoc tinh de ve do thi"'
    '"Choose which actions to graph"' = '"Chon hanh dong de ve do thi"'
    '"Choose which action to show rules for"' = '"Chon hanh dong de xem rule"'
    '"ACustomers:"' = '"Khach hang:"'
    '"AcceptanceTestss:"' = '"Kiem thu chap nhan:"'
    '"ArchitecturalPrototypes:"' = '"Prototype kien truc:"'
    '"AutomatedTestingTools:"' = '"Cong cu test tu dong:"'
    '"Checklists:"' = '"Checklist:"'
    '"Codes:"' = '"Ma nguon:"'
    '"CodingStandards:"' = '"Chuan ma nguon:"'
    '"ConfigurationManagementTools:"' = '"Cong cu quan ly cau hinh:"'
    '"CRCCardss:"' = '"CRC card:"'
    '"CurrentIterationPlans:"' = '"Ke hoach vong lap hien tai:"'
    '"CustomerRepresentatives:"' = '"Dai dien khach hang:"'
    '"CustomerReps:"' = '"Dai dien khach hang:"'
    '"DesignDocuments:"' = '"Tai lieu thiet ke:"'
    '"DesignEnvironments:"' = '"Moi truong thiet ke:"'
    '"Designs:"' = '"Thiet ke:"'
    '"DesignTools:"' = '"Cong cu thiet ke:"'
    '"IDEs:"' = '"IDE:"'
    '"ImplementationTools:"' = '"Cong cu lap trinh:"'
    '"LanguageTools:"' = '"Cong cu ngon ngu:"'
    '"Managers:"' = '"Quan ly:"'
    '"Modules:"' = '"Module:"'
    '"PhasePlans:"' = '"Ke hoach pha:"'
    '"ProjectPlans:"' = '"Ke hoach du an:"'
    '"Prototypes:"' = '"Prototype:"'
    '"RefactoringTools:"' = '"Cong cu tai cau truc:"'
    '"ReleasePlans:"' = '"Ke hoach phat hanh:"'
    '"RequirementsCaptureTools:"' = '"Cong cu thu thap yeu cau:"'
    '"RequirementsDocuments:"' = '"Tai lieu yeu cau:"'
    '"RequirementsTools:"' = '"Cong cu yeu cau:"'
    '"ScootieSoftwareProjects:"' = '"Du an phan mem Scootie:"'
    '"SEProjects:"' = '"Du an phan mem:"'
    '"SoftwareDevelopers:"' = '"Lap trinh vien:"'
    '"SoftwareEngineers:"' = '"Ky su phan mem:"'
    '"SoftwareProjects:"' = '"Du an phan mem:"'
    '"SystemTestPlans:"' = '"Ke hoach test he thong:"'
    '"TestingTools:"' = '"Cong cu testing:"'
    '"TheCustomers:"' = '"Khach hang:"'
    '"TheProjects:"' = '"Du an:"'
    '"UnitTestingFrameworks:"' = '"Framework test don vi:"'
    '"UnitTestss:"' = '"Kiem thu don vi:"'
    '"UseCases:"' = '"Use case:"'
    '"UserManualss:"' = '"Huong dan nguoi dung:"'
    '"UserStoriess:"' = '"Cau chuyen nguoi dung:"'
    '"Acceptance testing"' = '"Dang kiem thu chap nhan"'
    '"Assigned to Construction phase"' = '"Duoc gan vao pha Xay dung"'
    '"Assigned to Elaboration phase"' = '"Duoc gan vao pha Lam ro"'
    '"Assigned to Inception phase"' = '"Duoc gan vao pha Khoi dau"'
    '"Cancel"' = '"Huy"'
    '"Check All"' = '"Chon tat ca"'
    '"Choosing user stories for iteration"' = '"Dang chon cau chuyen cho vong lap"'
    '"Clear All"' = '"Bo chon tat ca"'
    '"Close"' = '"Dong"'
    '"Construction phase assessment"' = '"Danh gia pha Xay dung"'
    '"Dang evolve code"' = '"Dang phat trien code"'
    '"Dang inspection Code"' = '"Dang inspection code"'
    '"Dang tao programming tasks"' = '"Dang tao tac vu lap trinh"'
    '"Dang tich hop a component"' = '"Dang tich hop component"'
    '"Designing"' = '"Dang thiet ke"'
    '"Developing architectural prototype"' = '"Dang phat trien prototype kien truc"'
    '"Developing component"' = '"Dang phat trien component"'
    '"Developing prototype"' = '"Dang phat trien prototype"'
    '"Developing user manuals"' = '"Dang viet huong dan nguoi dung"'
    '"Discussing"' = '"Dang thao luan"'
    '"Elaboration phase assessment"' = '"Danh gia pha Lam ro"'
    '"Generate Action Graph"' = '"Tao do thi hanh dong"'
    '"Generate Composite Graph"' = '"Tao do thi tong hop"'
    '"Generate Object Graph"' = '"Tao do thi doi tuong"'
    '"Implementation"' = '"Hien thuc hoa"'
    '"Implementing system"' = '"Dang hien thuc he thong"'
    '"In iteration planning meeting"' = '"Trong hop lap ke hoach vong lap"'
    '"In release planning meeting"' = '"Trong hop lap ke hoach phat hanh"'
    '"In yeu cau meeting"' = '"Trong meeting yeu cau"'
    '"In yêu cầu meeting"' = '"Trong meeting yeu cau"'
    '"Inception phase assessment"' = '"Danh gia pha Khoi dau"'
    '"Integrating"' = '"Dang tich hop"'
    '"Khach hang prototype evaluation"' = '"Khach hang dang danh gia prototype"'
    '"Khách hàng prototype evaluation"' = '"Khach hang dang danh gia prototype"'
    '"Learning coding standard"' = '"Dang hoc chuan ma nguon"'
    '"Meeting with khach hang"' = '"Dang meeting voi khach hang"'
    '"Meeting with khách hàng"' = '"Dang meeting voi khach hang"'
    '"OK"' = '"Dong y"'
    '"Out sick"' = '"Dang nghi benh"'
    '"Pair integrating"' = '"Dang tich hop cap doi"'
    '"Pair programming"' = '"Dang lap trinh cap doi"'
    '"Planning Construction phase"' = '"Lap ke hoach pha Xay dung"'
    '"Planning Elaboration phase"' = '"Lap ke hoach pha Lam ro"'
    '"Planning Transition phase"' = '"Lap ke hoach pha Chuyen giao"'
    '"Programming"' = '"Dang lap trinh"'
    '"Refactoring"' = '"Dang tai cau truc"'
    '"Specifying yeu cau"' = '"Dang dac ta yeu cau"'
    '"Specifying yêu cầu"' = '"Dang dac ta yeu cau"'
    '"The CRC:"' = '"CRC card:"'
    '"Thiet keing system"' = '"Dang thiet ke he thong"'
    '"Thiết kếing system"' = '"Dang thiet ke he thong"'
    '"Tired"' = '"Met"'
    '"Unit testing and fixing"' = '"Dang test don vi va sua loi"'
  }

  $accentedStringReplacements = @(
    @('Du lieu nhap khong hop le -- vui long thu lai!', 'D\u1EEF li\u1EC7u nh\u1EADp kh\u00F4ng h\u1EE3p l\u1EC7 -- vui l\u00F2ng th\u1EED l\u1EA1i!')
    @('Ban phai nhap du lieu -- vui long thu lai!', 'B\u1EA1n ph\u1EA3i nh\u1EADp d\u1EEF li\u1EC7u -- vui l\u00F2ng th\u1EED l\u1EA1i!')
    @('Vui long nhap so nguyen duong cho so nhip dong ho', 'Vui l\u00F2ng nh\u1EADp s\u1ED1 nguy\u00EAn d\u01B0\u01A1ng cho s\u1ED1 nh\u1ECBp \u0111\u1ED3ng h\u1ED3')
    @('Vui long chon it nhat mot attribute', 'Vui l\u00F2ng ch\u1ECDn \u00EDt nh\u1EA5t m\u1ED9t attribute')
    @('Vui long chon it nhat mot action', 'Vui l\u00F2ng ch\u1ECDn \u00EDt nh\u1EA5t m\u1ED9t action')
    @('Vui long dat ten luot choi moi nay:', 'Vui l\u00F2ng \u0111\u1EB7t t\u00EAn l\u01B0\u1EE3t ch\u01A1i m\u1EDBi n\u00E0y:')
    @('Bat dau luot choi moi tu day', 'B\u1EAFt \u0111\u1EA7u l\u01B0\u1EE3t ch\u01A1i m\u1EDBi t\u1EEB \u0111\u00E2y')
    @('Bat dau nhanh moi tu day', 'B\u1EAFt \u0111\u1EA7u nh\u00E1nh m\u1EDBi t\u1EEB \u0111\u00E2y')
    @('Dat ten luot choi moi', '\u0110\u1EB7t t\u00EAn l\u01B0\u1EE3t ch\u01A1i m\u1EDBi')
    @('Diem cua ban la ', '\u0110i\u1EC3m c\u1EE7a b\u1EA1n l\u00E0 ')
    @('Tro choi ket thuc!', 'Tr\u00F2 ch\u01A1i k\u1EBFt th\u00FAc!')
    @('Du lieu nhap khong hop le', 'D\u1EEF li\u1EC7u nh\u1EADp kh\u00F4ng h\u1EE3p l\u1EC7')
    @('Ban phai chon it nhat mot action', 'B\u1EA1n ph\u1EA3i ch\u1ECDn \u00EDt nh\u1EA5t m\u1ED9t action')
    @('Ban phai chon it nhat ', 'B\u1EA1n ph\u1EA3i ch\u1ECDn \u00EDt nh\u1EA5t ')
    @('Ban chi duoc chon toi da ', 'B\u1EA1n ch\u1EC9 \u0111\u01B0\u1EE3c ch\u1ECDn t\u1ED1i \u0111a ')
    @('Do hoan thien lap trinh', '\u0110\u1ED9 ho\u00E0n thi\u1EC7n l\u1EADp tr\u00ECnh')
    @('Do hoan thien dac ta', '\u0110\u1ED9 ho\u00E0n thi\u1EC7n \u0111\u1EB7c t\u1EA3')
    @('Do hoan thien', '\u0110\u1ED9 ho\u00E0n thi\u1EC7n')
    @('Do chinh xac', '\u0110\u1ED9 ch\u00EDnh x\u00E1c')
    @('Do kho lap trinh da biet', '\u0110\u1ED9 kh\u00F3 l\u1EADp tr\u00ECnh \u0111\u00E3 bi\u1EBFt')
    @('Do kho thiet ke da biet', '\u0110\u1ED9 kh\u00F3 thi\u1EBFt k\u1EBF \u0111\u00E3 bi\u1EBFt')
    @('Do kho tich hop da biet', '\u0110\u1ED9 kh\u00F3 t\u00EDch h\u1EE3p \u0111\u00E3 bi\u1EBFt')
    @('Do kho yeu cau da biet', '\u0110\u1ED9 kh\u00F3 y\u00EAu c\u1EA7u \u0111\u00E3 bi\u1EBFt')
    @('Do kho lap trinh', '\u0110\u1ED9 kh\u00F3 l\u1EADp tr\u00ECnh')
    @('Do kho thiet ke', '\u0110\u1ED9 kh\u00F3 thi\u1EBFt k\u1EBF')
    @('Do kho tich hop', '\u0110\u1ED9 kh\u00F3 t\u00EDch h\u1EE3p')
    @('Do kho yeu cau', '\u0110\u1ED9 kh\u00F3 y\u00EAu c\u1EA7u')
    @('Do kem linh hoat da biet', '\u0110\u1ED9 k\u00E9m linh ho\u1EA1t \u0111\u00E3 bi\u1EBFt')
    @('Do kem linh hoat', '\u0110\u1ED9 k\u00E9m linh ho\u1EA1t')
    @('Tien do phan tich do kho', 'Ti\u1EBFn \u0111\u1ED9 ph\u00E2n t\u00EDch \u0111\u1ED9 kh\u00F3')
    @('Tien do phan tich rui ro', 'Ti\u1EBFn \u0111\u1ED9 ph\u00E2n t\u00EDch r\u1EE7i ro')
    @('Tien do yeu cau', 'Ti\u1EBFn \u0111\u1ED9 y\u00EAu c\u1EA7u')
    @('Tien do thiet ke', 'Ti\u1EBFn \u0111\u1ED9 thi\u1EBFt k\u1EBF')
    @('Tien do lap trinh', 'Ti\u1EBFn \u0111\u1ED9 l\u1EADp tr\u00ECnh')
    @('Tien do tich hop', 'Ti\u1EBFn \u0111\u1ED9 t\u00EDch h\u1EE3p')
    @('Ky nang quan ly du an', 'K\u1EF9 n\u0103ng qu\u1EA3n l\u00FD d\u1EF1 \u00E1n')
    @('Ky nang lap trinh', 'K\u1EF9 n\u0103ng l\u1EADp tr\u00ECnh')
    @('Ky nang yeu cau', 'K\u1EF9 n\u0103ng y\u00EAu c\u1EA7u')
    @('Ky nang thiet ke va phat trien', 'K\u1EF9 n\u0103ng thi\u1EBFt k\u1EBF v\u00E0 ph\u00E1t tri\u1EC3n')
    @('Ky nang kien truc', 'K\u1EF9 n\u0103ng ki\u1EBFn tr\u00FAc')
    @('Kiem thu chap nhan', 'Ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn')
    @('Kiem thu don vi', 'Ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB')
    @('Huong dan nguoi dung', 'H\u01B0\u1EDBng d\u1EABn ng\u01B0\u1EDDi d\u00F9ng')
    @('Dai dien khach hang', '\u0110\u1EA1i di\u1EC7n kh\u00E1ch h\u00E0ng')
    @('Muc hai long khach hang', 'M\u1EE9c h\u00E0i l\u00F2ng kh\u00E1ch h\u00E0ng')
    @('Muc rui ro uu tien', 'M\u1EE9c r\u1EE7i ro \u01B0u ti\u00EAn')
    @('Cong cu quan ly cau hinh', 'C\u00F4ng c\u1EE5 qu\u1EA3n l\u00FD c\u1EA5u h\u00ECnh')
    @('Cong cu thu thap yeu cau', 'C\u00F4ng c\u1EE5 thu th\u1EADp y\u00EAu c\u1EA7u')
    @('Cong cu test tu dong', 'C\u00F4ng c\u1EE5 test t\u1EF1 \u0111\u1ED9ng')
    @('Cong cu test he thong', 'C\u00F4ng c\u1EE5 test h\u1EC7 th\u1ED1ng')
    @('Ke hoach test he thong', 'K\u1EBF ho\u1EA1ch test h\u1EC7 th\u1ED1ng')
    @('Ke hoach iteration hien tai', 'K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i')
    @('Ke hoach vong lap hien tai', 'K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i')
    @('Iteration hien tai', 'V\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i')
    @('Vong lap hien tai', 'V\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i')
    @('Ke hoach release', 'K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh')
    @('Ke hoach phat hanh', 'K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh')
    @('Cau chuyen nguoi dung', 'C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng')
    @('Chuan ma nguon', 'Chu\u1EA9n m\u00E3 ngu\u1ED3n')
    @('Cong cu tai cau truc', 'C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc')
    @('Pha hien tai', 'Pha hi\u1EC7n t\u1EA1i')
    @('Thoi gian hien tai', 'Th\u1EDDi gian hi\u1EC7n t\u1EA1i')
    @('Thoi gian du kien', 'Th\u1EDDi gian d\u1EF1 ki\u1EBFn')
    @('Thoi gian duoc cap', 'Th\u1EDDi gian \u0111\u01B0\u1EE3c c\u1EA5p')
    @('Thoi gian da qua', 'Th\u1EDDi gian \u0111\u00E3 qua')
    @('Thoi gian da dung', 'Th\u1EDDi gian \u0111\u00E3 d\u00F9ng')
    @('Tien da chi pha Xay dung', 'Ti\u1EC1n \u0111\u00E3 chi pha X\u00E2y d\u1EF1ng')
    @('Tien da chi pha Lam ro', 'Ti\u1EC1n \u0111\u00E3 chi pha L\u00E0m r\u00F5')
    @('Tien da chi pha Khoi dau', 'Ti\u1EC1n \u0111\u00E3 chi pha Kh\u1EDFi \u0111\u1EA7u')
    @('Tien da chi cho cong cu', 'Ti\u1EC1n \u0111\u00E3 chi cho c\u00F4ng c\u1EE5')
    @('Tien da chi', 'Ti\u1EC1n \u0111\u00E3 chi')
    @('Tien lang phi', 'Ti\u1EC1n l\u00E3ng ph\u00ED')
    @('Ngan sach goi y pha Xay dung', 'Ng\u00E2n s\u00E1ch g\u1EE3i \u00FD pha X\u00E2y d\u1EF1ng')
    @('Ngan sach goi y pha Lam ro', 'Ng\u00E2n s\u00E1ch g\u1EE3i \u00FD pha L\u00E0m r\u00F5')
    @('Ngan sach goi y pha Khoi dau', 'Ng\u00E2n s\u00E1ch g\u1EE3i \u00FD pha Kh\u1EDFi \u0111\u1EA7u')
    @('Ngan sach cong cu goi y', 'Ng\u00E2n s\u00E1ch c\u00F4ng c\u1EE5 g\u1EE3i \u00FD')
    @('Diem hoan thien san pham', '\u0110i\u1EC3m ho\u00E0n thi\u1EC7n s\u1EA3n ph\u1EA9m')
    @('Diem dung san pham', '\u0110i\u1EC3m \u0111\u00FAng s\u1EA3n ph\u1EA9m')
    @('Diem lich trinh', '\u0110i\u1EC3m l\u1ECBch tr\u00ECnh')
    @('He so giam loi', 'H\u1EC7 s\u1ED1 gi\u1EA3m l\u1ED7i')
    @('He so loi lap trinh', 'H\u1EC7 s\u1ED1 l\u1ED7i l\u1EADp tr\u00ECnh')
    @('He so toc do lap trinh', 'H\u1EC7 s\u1ED1 t\u1ED1c \u0111\u1ED9 l\u1EADp tr\u00ECnh')
    @('He so tang nang suat', 'H\u1EC7 s\u1ED1 t\u0103ng n\u0103ng su\u1EA5t')
    @('He so toc do prototype', 'H\u1EC7 s\u1ED1 t\u1ED1c \u0111\u1ED9 prototype')
    @('So defect da phat hien', 'S\u1ED1 defect \u0111\u00E3 ph\u00E1t hi\u1EC7n')
    @('So defect chua phat hien', 'S\u1ED1 defect ch\u01B0a ph\u00E1t hi\u1EC7n')
    @('So yeu cau da tim ra', 'S\u1ED1 y\u00EAu c\u1EA7u \u0111\u00E3 t\u00ECm ra')
    @('So yeu cau chua tim ra', 'S\u1ED1 y\u00EAu c\u1EA7u ch\u01B0a t\u00ECm ra')
    @('So yeu cau da dac ta', 'S\u1ED1 y\u00EAu c\u1EA7u \u0111\u00E3 \u0111\u1EB7c t\u1EA3')
    @('So loi da biet', 'S\u1ED1 l\u1ED7i \u0111\u00E3 bi\u1EBFt')
    @('Tong so yeu cau', 'T\u1ED5ng s\u1ED1 y\u00EAu c\u1EA7u')
    @('Tong hai long', 'T\u1ED5ng h\u00E0i l\u00F2ng')
    @('Tong use case uoc tinh', 'T\u1ED5ng use case \u01B0\u1EDBc t\u00EDnh')
    @('Tong quan san pham', 'T\u1ED5ng quan s\u1EA3n ph\u1EA9m')
    @('Tong quan khach hang', 'T\u1ED5ng quan kh\u00E1ch h\u00E0ng')
    @('Tong quan nhan vien', 'T\u1ED5ng quan nh\u00E2n vi\u00EAn')
    @('Tong quan du an', 'T\u1ED5ng quan d\u1EF1 \u00E1n')
    @('Tong quan cong cu', 'T\u1ED5ng quan c\u00F4ng c\u1EE5')
    @('Chon hanh dong de ve do thi', 'Ch\u1ECDn h\u00E0nh \u0111\u1ED9ng \u0111\u1EC3 v\u1EBD \u0111\u1ED3 th\u1ECB')
    @('Chon thuoc tinh de ve do thi', 'Ch\u1ECDn thu\u1ED9c t\u00EDnh \u0111\u1EC3 v\u1EBD \u0111\u1ED3 th\u1ECB')
    @('Chon hanh dong de xem rule', 'Ch\u1ECDn h\u00E0nh \u0111\u1ED9ng \u0111\u1EC3 xem rule')
    @('Chon hanh dong de dung:', 'Ch\u1ECDn h\u00E0nh \u0111\u1ED9ng \u0111\u1EC3 d\u1EEBng:')
    @('Chon hanh dong de tham gia:', 'Ch\u1ECDn h\u00E0nh \u0111\u1ED9ng \u0111\u1EC3 tham gia:')
    @('Chon vai tro hanh dong', 'Ch\u1ECDn vai tr\u00F2 h\u00E0nh \u0111\u1ED9ng')
    @('Chon vai tro de choi:', 'Ch\u1ECDn vai tr\u00F2 \u0111\u1EC3 ch\u01A1i:')
    @('bam de xem thong tin hanh dong', 'b\u1EA5m \u0111\u1EC3 xem th\u00F4ng tin h\u00E0nh \u0111\u1ED9ng')
    @('va cac hanh dong da chon', 'v\u00E0 c\u00E1c h\u00E0nh \u0111\u1ED9ng \u0111\u00E3 ch\u1ECDn')
    @('khoi tat ca hanh dong khac.', 'kh\u1ECFi t\u1EA5t c\u1EA3 h\u00E0nh \u0111\u1ED9ng kh\u00E1c.')
    @('Dung tai su kien', 'D\u1EEBng t\u1EA1i s\u1EF1 ki\u1EC7n')
    @('Thue nhan vien - ', 'Thu\u00EA nh\u00E2n vi\u00EAn - ')
    @('Cho nhan vien nghi - ', 'Cho nh\u00E2n vi\u00EAn ngh\u1EC9 - ')
    @('Nhan vien tiem nang', 'Nh\u00E2n vi\u00EAn ti\u1EC1m n\u0103ng')
    @('Nhip dong ho', 'Nh\u1ECBp \u0111\u1ED3ng h\u1ED3')
    @('dong ho', '\u0111\u1ED3ng h\u1ED3')
    @('Moi truong mo phong giao duc quy trinh cong nghe phan mem', 'M\u00F4i tr\u01B0\u1EDDng m\u00F4 ph\u1ECFng gi\u00E1o d\u1EE5c quy tr\u00ECnh c\u00F4ng ngh\u1EC7 ph\u1EA7n m\u1EC1m')
    @('Lap trinh vien chinh:', 'L\u1EADp tr\u00ECnh vi\u00EAn ch\u00EDnh:')
    @('Lap trinh vien dong gop:', 'L\u1EADp tr\u00ECnh vi\u00EAn \u0111\u00F3ng g\u00F3p:')
    @('Giang vien huong dan:', 'Gi\u1EA3ng vi\u00EAn h\u01B0\u1EDBng d\u1EABn:')
    @('Do thi tong hop doi tuong/hanh dong', '\u0110\u1ED3 th\u1ECB t\u1ED5ng h\u1EE3p \u0111\u1ED1i t\u01B0\u1EE3ng/h\u00E0nh \u0111\u1ED9ng')
    @('Trinh xem nhieu dong thoi gian', 'Tr\u00ECnh xem nhi\u1EC1u d\u00F2ng th\u1EDDi gian')
    @('Hien thuoc tinh:', 'Hi\u1EC3n th\u1ECB thu\u1ED9c t\u00EDnh:')
    @('Hien thi', 'Hi\u1EC3n th\u1ECB')
    @('Bo chon tat ca', 'B\u1ECF ch\u1ECDn t\u1EA5t c\u1EA3')
    @('Chon tat ca', 'Ch\u1ECDn t\u1EA5t c\u1EA3')
    @('Dang kiem thu chap nhan', '\u0110ang ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn')
    @('Dang test don vi va sua loi', '\u0110ang test \u0111\u01A1n v\u1ECB v\u00E0 s\u1EEDa l\u1ED7i')
    @('Dang lap trinh cap doi', '\u0110ang l\u1EADp tr\u00ECnh c\u1EB7p \u0111\u00F4i')
    @('Dang tich hop cap doi', '\u0110ang t\u00EDch h\u1EE3p c\u1EB7p \u0111\u00F4i')
    @('Dang viet huong dan nguoi dung', '\u0110ang vi\u1EBFt h\u01B0\u1EDBng d\u1EABn ng\u01B0\u1EDDi d\u00F9ng')
    @('Dang tao tac vu lap trinh', '\u0110ang t\u1EA1o t\u00E1c v\u1EE5 l\u1EADp tr\u00ECnh')
    @('Dang meeting voi khach hang', '\u0110ang meeting v\u1EDBi kh\u00E1ch h\u00E0ng')
    @('Khach hang dang danh gia prototype', 'Kh\u00E1ch h\u00E0ng \u0111ang \u0111\u00E1nh gi\u00E1 prototype')
    @('Danh gia pha Xay dung', '\u0110\u00E1nh gi\u00E1 pha X\u00E2y d\u1EF1ng')
    @('Danh gia pha Lam ro', '\u0110\u00E1nh gi\u00E1 pha L\u00E0m r\u00F5')
    @('Danh gia pha Khoi dau', '\u0110\u00E1nh gi\u00E1 pha Kh\u1EDFi \u0111\u1EA7u')
    @('Lap ke hoach pha Xay dung', 'L\u1EADp k\u1EBF ho\u1EA1ch pha X\u00E2y d\u1EF1ng')
    @('Lap ke hoach pha Lam ro', 'L\u1EADp k\u1EBF ho\u1EA1ch pha L\u00E0m r\u00F5')
    @('Lap ke hoach pha Chuyen giao', 'L\u1EADp k\u1EBF ho\u1EA1ch pha Chuy\u1EC3n giao')
    @('Dang nghi benh', '\u0110ang ngh\u1EC9 b\u1EC7nh')
    @('Nhan vien nghi giai lao de phuc hoi nang luong', 'Nh\u00E2n vi\u00EAn ngh\u1EC9 gi\u1EA3i lao \u0111\u1EC3 ph\u1EE5c h\u1ED3i n\u0103ng l\u01B0\u1EE3ng')
    @('Nhan vien bi benh va nghi lam mot thoi gian', 'Nh\u00E2n vi\u00EAn b\u1EC7nh v\u00E0 ngh\u1EC9 l\u00E0m m\u1ED9t th\u1EDDi gian')
    @('Nhan vien nghi viec va khong con lam tai cong ty', 'Nh\u00E2n vi\u00EAn ngh\u1EC9 vi\u1EC7c v\u00E0 kh\u00F4ng c\u00F2n l\u00E0m t\u1EA1i c\u00F4ng ty')
    @('Kha nang thay doi da biet', 'Kh\u1EA3 n\u0103ng thay \u0111\u1ED5i \u0111\u00E3 bi\u1EBFt')
    @('Kha nang thay doi', 'Kh\u1EA3 n\u0103ng thay \u0111\u1ED5i')
    @('Kha nang sua doi', 'Kh\u1EA3 n\u0103ng s\u1EEDa \u0111\u1ED5i')
    @('So nhip thay doi', 'S\u1ED1 nh\u1ECBp thay \u0111\u1ED5i')
    @('So dong', 'S\u1ED1 d\u00F2ng')
    @('So trang', 'S\u1ED1 trang')
    @('So use case khi nop', 'S\u1ED1 use case khi n\u1ED9p')
    @('So use case hien co', 'S\u1ED1 use case hi\u1EC7n co')
    @('So CRC card da xong', 'S\u1ED1 CRC card \u0111\u00E3 xong')
    @('So test that bai', 'S\u1ED1 test th\u1EA5t b\u1EA1i')
    @('So test da chay', 'S\u1ED1 test \u0111\u00E3 ch\u1EA1y')
    @('So cau chuyen da hien thuc', 'S\u1ED1 c\u00E2u chuy\u1EC7n \u0111\u00E3 hi\u1EC7n th\u1EF1c')
    @('So cau chuyen da tich hop', 'S\u1ED1 c\u00E2u chuy\u1EC7n \u0111\u00E3 t\u00EDch h\u1EE3p')
    @('So cau chuyen da dac ta', 'S\u1ED1 c\u00E2u chuy\u1EC7n \u0111\u00E3 \u0111\u1EB7c t\u1EA3')
    @('Phan tram da hien thuc', 'Ph\u1EA7n tr\u0103m \u0111\u00E3 hi\u1EC7n th\u1EF1c')
    @('Phan tram da tich hop', 'Ph\u1EA7n tr\u0103m \u0111\u00E3 t\u00EDch h\u1EE3p')
    @('Phan tram da tai cau truc', 'Ph\u1EA7n tr\u0103m \u0111\u00E3 t\u00E1i c\u1EA5u tr\u00FAc')
    @('Phan tram da kiem thu', 'Ph\u1EA7n tr\u0103m \u0111\u00E3 ki\u1EC3m th\u1EED')
    @('Da uu tien', '\u0110\u00E3 \u01B0u ti\u00EAn')
    @('Duoc chon de lap trinh', '\u0110\u01B0\u1EE3c ch\u1ECDn \u0111\u1EC3 l\u1EADp tr\u00ECnh')
    @('Duoc chon de prototype', '\u0110\u01B0\u1EE3c ch\u1ECDn \u0111\u1EC3 prototype')
    @('Duoc gan vao pha Xay dung', '\u0110\u01B0\u1EE3c g\u00E1n v\u00E0o pha X\u00E2y d\u1EF1ng')
    @('Duoc gan vao pha Lam ro', '\u0110\u01B0\u1EE3c g\u00E1n v\u00E0o pha L\u00E0m r\u00F5')
    @('Duoc gan vao pha Khoi dau', '\u0110\u01B0\u1EE3c g\u00E1n v\u00E0o pha Kh\u1EDFi \u0111\u1EA7u')
    @('Dang chon user story cho iteration', '\u0110ang ch\u1ECDn c\u00E2u chuy\u1EC7n cho v\u00F2ng l\u1EB7p')
    @('Dang chon cau chuyen cho vong lap', '\u0110ang ch\u1ECDn c\u00E2u chuy\u1EC7n cho v\u00F2ng l\u1EB7p')
    @('Dang dac ta yeu cau', '\u0110ang \u0111\u1EB7c t\u1EA3 y\u00EAu c\u1EA7u')
    @('Dang phat trien code', '\u0110ang ph\u00E1t tri\u1EC3n code')
    @('Dang phat trien prototype kien truc', '\u0110ang ph\u00E1t tri\u1EC3n prototype ki\u1EBFn tr\u00FAc')
    @('Dang phat trien prototype', '\u0110ang ph\u00E1t tri\u1EC3n prototype')
    @('Dang phat trien component', '\u0110ang ph\u00E1t tri\u1EC3n component')
    @('Dang thiet ke he thong', '\u0110ang thi\u1EBFt k\u1EBF h\u1EC7 th\u1ED1ng')
    @('Dang lap trinh he thong', '\u0110ang l\u1EADp tr\u00ECnh h\u1EC7 th\u1ED1ng')
    @('Dang hien thuc he thong', '\u0110ang hi\u1EC7n th\u1EF1c h\u00F3a h\u1EC7 th\u1ED1ng')
    @('Dang thao luan', '\u0110ang th\u1EA3o lu\u1EADn')
    @('Dang hoc coding standard', '\u0110ang h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n')
    @('Dang hoc chuan ma nguon', '\u0110ang h\u1ECDc chu\u1EA9n m\u00E3 ngu\u1ED3n')
    @('Trong meeting yeu cau', 'Trong meeting y\u00EAu c\u1EA7u')
    @('Trong meeting lap ke hoach iteration', 'Trong h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p')
    @('Trong meeting lap ke hoach release', 'Trong h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh')
    @('Trong hop lap ke hoach vong lap', 'Trong h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p')
    @('Trong hop lap ke hoach phat hanh', 'Trong h\u1ECDp l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh')
    @('Chao mung', 'Ch\u00E0o m\u1EEBng')
    @('Phan tich mo phong', 'Ph\u00E2n t\u00EDch m\u00F4 ph\u1ECFng')
    @('Phan tich', 'Ph\u00E2n t\u00EDch')
    @('Mo phong', 'M\u00F4 ph\u1ECFng')
    @('Hoat dong hien tai', 'Ho\u1EA1t \u0111\u1ED9ng hi\u1EC7n t\u1EA1i')
    @('Hoat dong', 'Ho\u1EA1t \u0111\u1ED9ng')
    @('Loai', 'Lo\u1EA1i')
    @('Ky su phan mem', 'K\u1EF9 s\u01B0 ph\u1EA7n m\u1EC1m')
    @('Lap trinh vien', 'L\u1EADp tr\u00ECnh vi\u00EAn')
    @('phan mem', 'ph\u1EA7n m\u1EC1m')
    @('Phan mem', 'Ph\u1EA7n m\u1EC1m')
    @('Ten cong ty', 'T\u00EAn c\u00F4ng ty')
    @('Ten', 'T\u00EAn')
    @('Nang luong', 'N\u0103ng l\u01B0\u1EE3ng')
    @('Tam trang', 'T\u00E2m tr\u1EA1ng')
    @('Kinh nghiem', 'Kinh nghi\u1EC7m')
    @('thiet ke', 'thi\u1EBFt k\u1EBF')
    @('Thiet ke', 'Thi\u1EBFt k\u1EBF')
    @('yeu cau', 'y\u00EAu c\u1EA7u')
    @('Yeu cau', 'Y\u00EAu c\u1EA7u')
    @('Luong gio', 'L\u01B0\u01A1ng gi\u1EDD')
    @('Cong cu', 'C\u00F4ng c\u1EE5')
    @('cong cu', 'c\u00F4ng c\u1EE5')
    @('Du an', 'D\u1EF1 \u00E1n')
    @('du an', 'd\u1EF1 \u00E1n')
    @('San pham', 'S\u1EA3n ph\u1EA9m')
    @('san pham', 's\u1EA3n ph\u1EA9m')
    @('Khach hang', 'Kh\u00E1ch h\u00E0ng')
    @('khach hang', 'kh\u00E1ch h\u00E0ng')
    @('Nhan vien', 'Nh\u00E2n vi\u00EAn')
    @('nhan vien', 'nh\u00E2n vi\u00EAn')
    @('Nguoi tham gia', 'Ng\u01B0\u1EDDi tham gia')
    @('nguoi tham gia', 'ng\u01B0\u1EDDi tham gia')
    @('Tai lieu', 'T\u00E0i li\u1EC7u')
    @('tai lieu', 't\u00E0i li\u1EC7u')
    @('Ma nguon', 'M\u00E3 ngu\u1ED3n')
    @('Ke hoach', 'K\u1EBF ho\u1EA1ch')
    @('ke hoach', 'k\u1EBF ho\u1EA1ch')
    @('Kiem thu', 'Ki\u1EC3m th\u1EED')
    @('kiem thu', 'ki\u1EC3m th\u1EED')
    @('he thong', 'h\u1EC7 th\u1ED1ng')
    @('He thong', 'H\u1EC7 th\u1ED1ng')
    @('Chon', 'Ch\u1ECDn')
    @('chon', 'ch\u1ECDn')
    @('Dung', 'D\u1EEBng')
    @('Dang', '\u0110ang')
    @('dang', '\u0111ang')
    @('Hanh dong', 'H\u00E0nh \u0111\u1ED9ng')
    @('hanh dong', 'h\u00E0nh \u0111\u1ED9ng')
    @('hien tai', 'hi\u1EC7n t\u1EA1i')
    @('Tao', 'T\u1EA1o')
    @('tao', 't\u1EA1o')
    @('Do thi', '\u0110\u1ED3 th\u1ECB')
    @('do thi', '\u0111\u1ED3 th\u1ECB')
    @('Doi tuong', '\u0110\u1ED1i t\u01B0\u1EE3ng')
    @('doi tuong', '\u0111\u1ED1i t\u01B0\u1EE3ng')
    @('Thong tin', 'Th\u00F4ng tin')
    @('thong tin', 'th\u00F4ng tin')
    @('Giai thich', 'Gi\u1EA3i th\u00EDch')
    @('giai thich', 'gi\u1EA3i th\u00EDch')
    @('Duoc', '\u0110\u01B0\u1EE3c')
    @('duoc', '\u0111\u01B0\u1EE3c')
    @('Thoi gian', 'Th\u1EDDi gian')
    @('thoi gian', 'th\u1EDDi gian')
    @('Nhip', 'Nh\u1ECBp')
    @('Loi', 'L\u1ED7i')
    @('loi', 'l\u1ED7i')
    @('Dong y', '\u0110\u1ED3ng \u00FD')
    @('Dong', '\u0110\u00F3ng')
    @('Huy', 'H\u1EE7y')
    @('Ranh', 'R\u1EA3nh')
    @('Met', 'M\u1EC7t')
    @('nang suat', 'n\u0103ng su\u1EA5t')
    @('Nang suat', 'N\u0103ng su\u1EA5t')
    @('years', 'n\u0103m')
    @('year', 'n\u0103m')
    @('months', 'th\u00E1ng')
    @('month', 'th\u00E1ng')
    @('weeks', 'tu\u1EA7n')
    @('week', 'tu\u1EA7n')
    @('Beginner', 'Ng\u01B0\u1EDDi m\u1EDBi')
    @('beginner', 'ng\u01B0\u1EDDi m\u1EDBi')
    @('considers himself an expert', 't\u1EF1 xem l\u00E0 chuy\u00EAn gia')
    @('fast but careless at times', 'nhanh nh\u01B0ng \u0111\u00F4i khi b\u1EA5t c\u1EA9n')
    @('but hates', 'kh\u00F4ng th\u00EDch')
    @('hates coding', 'kh\u00F4ng th\u00EDch coding')
    @('testing is her life', 'r\u1EA5t gi\u1ECFi testing')
    @('chi duoc', 'ch\u1EC9 \u0111\u01B0\u1EE3c')
    @('toi da', 't\u1ED1i \u0111a')
    @('it nhat', '\u00EDt nh\u1EA5t')
    @('phai', 'ph\u1EA3i')
    @('vui long', 'vui l\u00F2ng')
    @('thu lai', 'th\u1EED l\u1EA1i')
    @('khong', 'kh\u00F4ng')
    @('hop le', 'h\u1EE3p l\u1EC7')
    @('nhap', 'nh\u1EADp')
    @('Du lieu', 'D\u1EEF li\u1EC7u')
    @('cua ban', 'c\u1EE7a b\u1EA1n')
    @('Tro choi', 'Tr\u00F2 ch\u01A1i')
    @('ket thuc', 'k\u1EBFt th\u00FAc')
    @('Ket thuc', 'K\u1EBFt th\u00FAc')
    @('Bat dau', 'B\u1EAFt \u0111\u1EA7u')
    @('luot choi', 'l\u01B0\u1EE3t ch\u01A1i')
    @('Canh bao', 'C\u1EA3nh b\u00E1o')
    @('Diem', '\u0110i\u1EC3m')
    @('hoan thien', 'ho\u00E0n thi\u1EC7n')
    @('chinh xac', 'ch\u00EDnh x\u00E1c')
    @('lap trinh', 'l\u1EADp tr\u00ECnh')
    @('tich hop', 't\u00EDch h\u1EE3p')
    @('Ky nang', 'K\u1EF9 n\u0103ng')
    @('tien do', 'ti\u1EBFn \u0111\u1ED9')
    @('Mo ta', 'M\u00F4 t\u1EA3')
    @('Dai dien', '\u0110\u1EA1i di\u1EC7n')
    @('Muc', 'M\u1EE9c')
    @('hai long', 'h\u00E0i l\u00F2ng')
    @('Ngan sach', 'Ng\u00E2n s\u00E1ch')
    @('thay doi', 'thay \u0111\u1ED5i')
    @('linh hoat', 'linh ho\u1EA1t')
    @('kem', 'k\u00E9m')
    @('giam', 'gi\u1EA3m')
    @('He so', 'H\u1EC7 s\u1ED1')
    @('tang', 't\u0103ng')
    @('uoc tinh', '\u01B0\u1EDBc t\u00EDnh')
    @('du kien', 'd\u1EF1 ki\u1EBFn')
    @('su dung', 's\u1EED d\u1EE5ng')
    @('khoi tao', 'kh\u1EDFi t\u1EA1o')
    @('goi y', 'g\u1EE3i \u00FD')
    @('thu thap', 'thu th\u1EADp')
    @('rui ro', 'r\u1EE7i ro')
    @('lich trinh', 'l\u1ECBch tr\u00ECnh')
    @('lang phi', 'l\u00E3ng ph\u00ED')
    @('don vi', '\u0111\u01A1n v\u1ECB')
    @('chap nhan', 'ch\u1EA5p nh\u1EADn')
    @('kien truc', 'ki\u1EBFn tr\u00FAc')
    @('tu dong', 't\u1EF1 \u0111\u1ED9ng')
    @('quan ly', 'qu\u1EA3n l\u00FD')
    @('cau hinh', 'c\u1EA5u h\u00ECnh')
    @('ngon ngu', 'ng\u00F4n ng\u1EEF')
    @('tiem nang', 'ti\u1EC1m n\u0103ng')
    @('su kien', 's\u1EF1 ki\u1EC7n')
    @('nhieu', 'nhi\u1EC1u')
    @('tong hop', 't\u1ED5ng h\u1EE3p')
    @('Tong ', 'T\u1ED5ng ')
    @('phat trien', 'ph\u00E1t tri\u1EC3n')
    @('phat hien', 'ph\u00E1t hi\u1EC7n')
    @('dac ta', '\u0111\u1EB7c t\u1EA3')
    @('tim ra', 't\u00ECm ra')
    @('chua', 'ch\u01B0a')
    @('uu tien', '\u01B0u ti\u00EAn')
    @('Vuot', 'V\u01B0\u1EE3t')
    @('Gia tri', 'Gi\u00E1 tr\u1ECB')
    @('Biet', 'Bi\u1EBFt')
    @('da biet', '\u0111\u00E3 bi\u1EBFt')
    @('ban dau', 'ban \u0111\u1EA7u')
    @('phuc hoi', 'ph\u1EE5c h\u1ED3i')
    @('giai lao', 'gi\u1EA3i lao')
    @('benh', 'b\u1EC7nh')
    @('nghi lam', 'ngh\u1EC9 l\u00E0m')
    @('nghi viec', 'ngh\u1EC9 vi\u1EC7c')
    @('cong ty', 'c\u00F4ng ty')
    @('thao luan', 'th\u1EA3o lu\u1EADn')
    @('sua loi', 's\u1EEDa l\u1ED7i')
    @('huong dan', 'h\u01B0\u1EDBng d\u1EABn')
    @('giao duc', 'gi\u00E1o d\u1EE5c')
    @('quy trinh', 'quy tr\u00ECnh')
    @('cong nghe', 'c\u00F4ng ngh\u1EC7')
    @('tac vu', 't\u00E1c v\u1EE5')
    @('cap doi', 'c\u1EB7p \u0111\u00F4i')
    @('dong gop', '\u0111\u00F3ng g\u00F3p')
    @('vai tro', 'vai tr\u00F2')
    @('thuoc tinh', 'thu\u1ED9c t\u00EDnh')
    @('ve do thi', 'v\u1EBD \u0111\u1ED3 th\u1ECB')
    @('tat ca', 't\u1EA5t c\u1EA3')
    @('khoi', 'kh\u1ECFi')
    @('va cac', 'v\u00E0 c\u00E1c')
    @('bam', 'b\u1EA5m')
    @('Thue', 'Thu\u00EA')
    @('Hien', 'Hi\u1EC7n')
    @('Xay dung', 'X\u00E2y d\u1EF1ng')
    @('Lam ro', 'L\u00E0m r\u00F5')
    @('Khoi dau', 'Kh\u1EDFi \u0111\u1EA7u')
    @('Chuyen giao', 'Chuy\u1EC3n giao')
    @('Giang vien', 'Gi\u1EA3ng vi\u00EAn')
    @('Danh gia', '\u0110\u00E1nh gi\u00E1')
    @('Moi truong', 'M\u00F4i tr\u01B0\u1EDDng')
    @('Trinh xem', 'Tr\u00ECnh xem')
    @('dong thoi gian', 'd\u00F2ng th\u1EDDi gian')
    @('that bai', 'th\u1EA5t b\u1EA1i')
    @('da chay', '\u0111\u00E3 ch\u1EA1y')
    @('da xong', '\u0111\u00E3 xong')
    @('da mua', '\u0111\u00E3 mua')
    @('da qua', '\u0111\u00E3 qua')
    @('da dung', '\u0111\u00E3 d\u00F9ng')
    @('da chi', '\u0111\u00E3 chi')
    @('duoc cap', '\u0111\u01B0\u1EE3c c\u1EA5p')
    @('hien co', 'hi\u1EC7n co')
    @('khi nop', 'khi n\u1ED9p')
  )
  $accentedStringReplacements += ,@((Convert-JavaUnicodeEscapes 'thi\u00E1\u00BA\u00BFt k\u00E1\u00BA\u00BF'), 'thi\u1EBFt k\u1EBF')
  $accentedStringReplacements += ,@((Convert-JavaUnicodeEscapes 'y\u00C3\u00AAu c\u00C3\u00A1\u00BA\u00A7u'), 'y\u00EAu c\u1EA7u')
  $accentedStringReplacements += ,@((Convert-JavaUnicodeEscapes 'kh\u00C3\u00A1ch h\u00C3\u00A0ng'), 'kh\u00E1ch h\u00E0ng')
  $resolvedAccentedStringReplacements = Resolve-JavaReplacementMap $accentedStringReplacements
  $resolvedGeneralVisibleStringReplacements = Resolve-JavaReplacementMap (Get-GeneralVisibleStringReplacements)

  $nameStringReplacements = [ordered]@{
    'Andre' = 'An'
    'Anita' = 'B\u00ECnh'
    'Calvin' = 'C\u01B0\u1EDDng'
    'Emily' = 'Linh'
    'Mimi' = 'Mai'
    'Pedro' = 'Duy'
    'Roger' = 'Ph\u00FAc'
    'Wayne' = 'H\u00F9ng'
    'Robert' = 'Nam'
    'Joyce' = 'H\u01B0\u01A1ng'
    'Timothy' = 'Minh'
    'Reda' = 'Lan'
    'Peg' = 'Trang'
    'Sigfreido' = 'Quang'
  }
  $resolvedNameStringReplacements = Resolve-JavaReplacementMap $nameStringReplacements

  Get-ChildItem -LiteralPath $generatedRoot -Recurse -Filter '*.java' -ErrorAction SilentlyContinue |
    ForEach-Object {
      if (-not (Test-Path -LiteralPath $_.FullName)) {
        return
      }
      $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName
      $updated = $text
      foreach ($key in $replacements.Keys) {
        $updated = $updated.Replace($key, $replacements[$key])
      }
      foreach ($key in $displayTerms.Keys) {
        $value = $displayTerms[$key]
        $updated = $updated.Replace('columnNames.add("' + $key + '")', 'columnNames.add("' + $value + '")')
        $updated = $updated.Replace('columnNames.contains("' + $key + '")', 'columnNames.contains("' + $value + '")')
        $updated = $updated.Replace('getColumnIndex("' + $key + '")', 'getColumnIndex("' + $value + '")')
        $updated = $updated.Replace('>' + $key + ': ', '>' + $value + ': ')
        $updated = $updated.Replace('Type: ' + $key + '</font>', 'Loai: ' + $value + '</font>')
        $updated = $updated.Replace('new JLabel("' + $key + 's:")', 'new JLabel("' + $value + ':")')
        $updated = $updated.Replace('"' + $key + ' Employee ', '"' + $value + ' ')
        $updated = $updated.Replace('"' + $key + ' Artifact ', '"' + $value + ' ')
        $updated = $updated.Replace('"' + $key + ' Customer ', '"' + $value + ' ')
        $updated = $updated.Replace('"' + $key + ' Project ', '"' + $value + ' ')
        $updated = $updated.Replace('"' + $key + ' Tool ', '"' + $value + ' ')
      }
      foreach ($key in $exactStrings.Keys) {
        $updated = $updated.Replace($key, $exactStrings[$key])
      }
      $updated = [regex]::Replace($updated, '"[^"]*evolve code"', '"Dang phat trien code"')
      $updated = [regex]::Replace($updated, '"[^"]*inspection Code"', '"Dang inspection code"')
      $updated = [regex]::Replace($updated, '"[^"]*programming tasks"', '"Dang tao tac vu lap trinh"')
      $updated = [regex]::Replace($updated, '"[^"]*a component"', '"Dang tich hop component"')
      $updated = [regex]::Replace($updated, '"[^"]*làm implementation"', '"Dang lap trinh"')
      $updated = [regex]::Replace($updated, '"[^"]*ng l[^"]*m implementation"', '"Dang lap trinh"')
      $updated = [regex]::Replace($updated, '"In [^"]*y[^"]*u [^"]*u meeting"', '"Trong meeting yeu cau"')
      $updated = [regex]::Replace($updated, '"Kh[^"]*prototype evaluation"', '"Khach hang dang danh gia prototype"')
      $updated = [regex]::Replace($updated, '"Meeting with [^"]*"', '"Dang meeting voi khach hang"')
      $updated = [regex]::Replace($updated, '"Specifying [^"]*"', '"Dang dac ta yeu cau"')
      $updated = [regex]::Replace($updated, '"Thi[^"]*ing system"', '"Dang thiet ke he thong"')
      $updated = [regex]::Replace($updated, '"An [^"]*takes a break from work to try to regain energy"', '"Nhan vien nghi giai lao de phuc hoi nang luong"')
      $updated = [regex]::Replace($updated, '"An [^"]*falls ill and is away from work for a time"', '"Nhan vien bi benh va nghi lam mot thoi gian"')
      $updated = [regex]::Replace($updated, '"An [^"]*quits their job, after which he/she no longer works at the company"', '"Nhan vien nghi viec va khong con lam tai cong ty"')
      $updated = $updated.Replace('>Type: ', '>Loai: ')
      $updated = $updated.Replace('>Name: ', '>Ten: ')
      $updated = Replace-InJavaStringLiterals $updated $resolvedAccentedStringReplacements
      if ($_.Name -ne 'SimSEAboutDialog.java') {
        $updated = Replace-InJavaStringLiterals $updated $resolvedNameStringReplacements
      }
      $updated = Replace-InJavaStringLiterals $updated $resolvedGeneralVisibleStringReplacements
      if ($_.Name -in @('EmployeeParticipantSelectionDialog.java', 'NonEmployeeParticipantSelectionDialog.java')) {
        $participantDialogHelpers = (& $u @'
private static String displayParticipantRole(String roleName)
{
if(roleName.equals("Emp") || roleName.equals("EmpWhoseMenuClickedOn"))
{
return "nh\u00E2n vi\u00EAn";
}
if(roleName.equals("other Emp"))
{
return "nh\u00E2n vi\u00EAn kh\u00E1c";
}
if(roleName.equals("Developer") || roleName.equals("SoftwareDeveloper") || roleName.equals("L\u1EADp tr\u00ECnh vi\u00EAn"))
{
return "l\u1EADp tr\u00ECnh vi\u00EAn";
}
if(roleName.equals("SoftwareEngineer") || roleName.equals("K\u1EF9 s\u01B0 ph\u1EA7n m\u1EC1m"))
{
return "k\u1EF9 s\u01B0 ph\u1EA7n m\u1EC1m";
}
if(roleName.equals("Manager"))
{
return "qu\u1EA3n l\u00FD";
}
if(roleName.equals("CustomerRep") || roleName.equals("CustRep") || roleName.equals("CustomerRepresentative"))
{
return "\u0111\u1EA1i di\u1EC7n kh\u00E1ch h\u00E0ng";
}
if(roleName.equals("ReqDoc") || roleName.equals("RequirementsDocument"))
{
return "t\u00E0i li\u1EC7u y\u00EAu c\u1EA7u";
}
if(roleName.equals("DesignDoc") || roleName.equals("DesignDocument"))
{
return "t\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF";
}
if(roleName.equals("SystemTestPlan"))
{
return "k\u1EBF ho\u1EA1ch ki\u1EC3m th\u1EED h\u1EC7 th\u1ED1ng";
}
if(roleName.equals("Proj") || roleName.equals("SEProject") || roleName.equals("TheProject"))
{
return "d\u1EF1 \u00E1n";
}
if(roleName.equals("RequirementsCaptureTool"))
{
return "c\u00F4ng c\u1EE5 thu th\u1EADp y\u00EAu c\u1EA7u";
}
if(roleName.equals("DesignTool") || roleName.equals("DesignEnvironment"))
{
return "m\u00F4i tr\u01B0\u1EDDng thi\u1EBFt k\u1EBF";
}
if(roleName.equals("AutomatedTestingTool"))
{
return "c\u00F4ng c\u1EE5 test t\u1EF1 \u0111\u1ED9ng";
}
if(roleName.equals("ACustomer"))
{
return "kh\u00E1ch h\u00E0ng";
}
if(roleName.equals("AssociatedCodeDoc") || roleName.equals("CodeDoc") || roleName.equals("Code"))
{
return "m\u00E3 ngu\u1ED3n";
}
if(roleName.equals("UserStories"))
{
return "c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng";
}
if(roleName.equals("ReleasePlan"))
{
return "k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh";
}
if(roleName.equals("CurrentIterationPlan"))
{
return "k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p";
}
if(roleName.equals("AcceptanceTests"))
{
return "ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn";
}
if(roleName.equals("CRCCards"))
{
return "CRC card";
}
if(roleName.equals("Design"))
{
return "thi\u1EBFt k\u1EBF";
}
if(roleName.equals("UnitTestingFramework"))
{
return "framework ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB";
}
if(roleName.equals("UnitTests"))
{
return "ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB";
}
if(roleName.equals("CodingStandard"))
{
return "chu\u1EA9n m\u00E3 ngu\u1ED3n";
}
if(roleName.equals("RefactoringTool"))
{
return "c\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc";
}
if(roleName.equals("Nh\u00E2n vi\u00EAn b\u1ECB cho ngh\u1EC9"))
{
return "nh\u00E2n vi\u00EAn b\u1ECB cho ngh\u1EC9";
}
return roleName;
}

private static String normalizeParticipantObjectType(String objTypeName)
{
if(objTypeName == null)
{
return null;
}
if(objTypeName.equals("L\u1EADp tr\u00ECnh vi\u00EAn"))
{
return "SoftwareDeveloper";
}
if(objTypeName.equals("K\u1EF9 s\u01B0 ph\u1EA7n m\u1EC1m"))
{
return "SoftwareEngineer";
}
if(objTypeName.equals("Qu\u1EA3n l\u00FD"))
{
return "Manager";
}
if(objTypeName.equals("\u0110\u1EA1i di\u1EC7n kh\u00E1ch h\u00E0ng"))
{
return "CustomerRep";
}
if(objTypeName.equals("Kh\u00E1ch h\u00E0ng"))
{
return "ACustomer";
}
if(objTypeName.equals("T\u00E0i li\u1EC7u y\u00EAu c\u1EA7u"))
{
return "RequirementsDocument";
}
if(objTypeName.equals("T\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF"))
{
return "DesignDocument";
}
if(objTypeName.equals("K\u1EBF ho\u1EA1ch ki\u1EC3m th\u1EED h\u1EC7 th\u1ED1ng"))
{
return "SystemTestPlan";
}
if(objTypeName.equals("D\u1EF1 \u00E1n ph\u1EA7n m\u1EC1m"))
{
return "SEProject";
}
if(objTypeName.equals("C\u00F4ng c\u1EE5 thu th\u1EADp y\u00EAu c\u1EA7u"))
{
return "RequirementsCaptureTool";
}
if(objTypeName.equals("M\u00F4i tr\u01B0\u1EDDng thi\u1EBFt k\u1EBF"))
{
return "DesignEnvironment";
}
if(objTypeName.equals("C\u00F4ng c\u1EE5 test t\u1EF1 \u0111\u1ED9ng"))
{
return "AutomatedTestingTool";
}
if(objTypeName.equals("C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng"))
{
return "UserStories";
}
if(objTypeName.equals("K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh"))
{
return "ReleasePlan";
}
if(objTypeName.equals("D\u1EF1 \u00E1n"))
{
return "TheProject";
}
if(objTypeName.equals("K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p"))
{
return "CurrentIterationPlan";
}
if(objTypeName.equals("Ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn"))
{
return "AcceptanceTests";
}
if(objTypeName.equals("CRC card"))
{
return "CRCCards";
}
if(objTypeName.equals("Thi\u1EBFt k\u1EBF"))
{
return "Thi\u1EBFt k\u1EBF";
}
if(objTypeName.equals("Framework ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB"))
{
return "UnitTestingFramework";
}
if(objTypeName.equals("Ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB"))
{
return "UnitTests";
}
if(objTypeName.equals("M\u00E3 ngu\u1ED3n"))
{
return "Code";
}
if(objTypeName.equals("Chu\u1EA9n m\u00E3 ngu\u1ED3n"))
{
return "CodingStandard";
}
if(objTypeName.equals("C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc"))
{
return "RefactoringTool";
}
return objTypeName;
}

'@)
        if ($updated -notmatch 'displayParticipantRole') {
          $updated = [regex]::Replace($updated, 'private boolean actionCancelled;\r?\n', ("private boolean actionCancelled;`r`n" + $participantDialogHelpers), 1)
        }
        if ($_.Name -eq 'EmployeeParticipantSelectionDialog.java') {
          $choose = [regex]::Escape((& $u 'Ch\u1ECDn '))
          $employeeTitlePattern = '(?s)String title = "' + $choose + '";\s*if\(selectedEmp != null\).*?title = title\.concat\("\):"\);'
          $employeeTitleReplacement = (& $u @'
String title = "Ch\u1ECDn ";
title = title.concat(displayParticipantRole(partName));
if(selectedEmp != null) // selected emp already added in this participant role
{
title = title.concat(" kh\u00E1c");
}
title = title.concat(" (");
if(minNumParts == maxNumParts)
{
title = title.concat("ch\u00EDnh x\u00E1c " + minNumParts);
}
else
{
title = title.concat("\u00EDt nh\u1EA5t " + minNumParts);
if(maxNumParts < 999999) // not boundless
{
title = title.concat(", nhi\u1EC1u nh\u1EA5t " + maxNumParts);
}
}
title = title.concat("):");
'@)
          $updated = [regex]::Replace($updated, $employeeTitlePattern, $employeeTitleReplacement, 1)
        } else {
          $choose = [regex]::Escape((& $u 'Ch\u1ECDn '))
          $nonEmployeeTitlePattern = '(?s)String title = "' + $choose + '";\s*title = title\.concat\(partName \+ " participant\(s\) \("\);.*?title = title\.concat\("\):"\);'
          $nonEmployeeTitleReplacement = (& $u @'
String title = "Ch\u1ECDn ";
title = title.concat(displayParticipantRole(partName));
title = title.concat(" (");
if(minNumParts == maxNumParts)
{
title = title.concat("ch\u00EDnh x\u00E1c " + minNumParts);
}
else
{
title = title.concat("\u00EDt nh\u1EA5t " + minNumParts);
if(maxNumParts < 999999) // not boundless
{
title = title.concat(", nhi\u1EC1u nh\u1EA5t " + maxNumParts);
}
}
title = title.concat("):");
'@)
          $updated = [regex]::Replace($updated, $nonEmployeeTitlePattern, $nonEmployeeTitleReplacement, 1)
        }
        $participantDialogLabelReplacements = [ordered]@{
          '"SoftwareEngineer ("' = (& $u '"K\u1EF9 s\u01B0 ph\u1EA7n m\u1EC1m ("')
          '"SoftwareDeveloper ("' = (& $u '"L\u1EADp tr\u00ECnh vi\u00EAn ("')
          '"Manager ("' = (& $u '"Qu\u1EA3n l\u00FD ("')
          '"CustomerRepresentative ("' = (& $u '"\u0110\u1EA1i di\u1EC7n kh\u00E1ch h\u00E0ng ("')
          '"CustomerRep ("' = (& $u '"\u0110\u1EA1i di\u1EC7n kh\u00E1ch h\u00E0ng ("')
          '"RequirementsDocument ("' = (& $u '"T\u00E0i li\u1EC7u y\u00EAu c\u1EA7u ("')
          '"DesignDocument ("' = (& $u '"T\u00E0i li\u1EC7u thi\u1EBFt k\u1EBF ("')
          '"SystemTestPlan ("' = (& $u '"K\u1EBF ho\u1EA1ch ki\u1EC3m th\u1EED h\u1EC7 th\u1ED1ng ("')
          '"SEProject ("' = (& $u '"D\u1EF1 \u00E1n ph\u1EA7n m\u1EC1m ("')
          '"RequirementsCaptureTool ("' = (& $u '"C\u00F4ng c\u1EE5 thu th\u1EADp y\u00EAu c\u1EA7u ("')
          '"DesignEnvironment ("' = (& $u '"M\u00F4i tr\u01B0\u1EDDng thi\u1EBFt k\u1EBF ("')
          '"AutomatedTestingTool ("' = (& $u '"C\u00F4ng c\u1EE5 test t\u1EF1 \u0111\u1ED9ng ("')
          '"ACustomer ("' = (& $u '"Kh\u00E1ch h\u00E0ng ("')
          '"UserStories ("' = (& $u '"C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng ("')
          '"ReleasePlan ("' = (& $u '"K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh ("')
          '"TheProject ("' = (& $u '"D\u1EF1 \u00E1n ("')
          '"CurrentIterationPlan ("' = (& $u '"K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p ("')
          '"AcceptanceTests ("' = (& $u '"Ki\u1EC3m th\u1EED ch\u1EA5p nh\u1EADn ("')
          '"CRCCards ("' = (& $u '"CRC card ("')
          '"Design ("' = (& $u '"Thi\u1EBFt k\u1EBF ("')
          '"UnitTestingFramework ("' = (& $u '"Framework ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB ("')
          '"UnitTests ("' = (& $u '"Ki\u1EC3m th\u1EED \u0111\u01A1n v\u1ECB ("')
          '"Code ("' = (& $u '"M\u00E3 ngu\u1ED3n ("')
          '"CodingStandard ("' = (& $u '"Chu\u1EA9n m\u00E3 ngu\u1ED3n ("')
          '"RefactoringTool ("' = (& $u '"C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc ("')
        }
        foreach ($key in $participantDialogLabelReplacements.Keys) {
          $updated = $updated.Replace($key, $participantDialogLabelReplacements[$key])
        }
        $updated = $updated.Replace(
          'String objTypeName = cBoxText.substring(0, (cBoxText.indexOf(''('') - 1));',
          'String objTypeName = normalizeParticipantObjectType(cBoxText.substring(0, (cBoxText.indexOf(''('') - 1)));'
        )
      }
      $updated = $updated.Replace((& $u 'Purchase c\u00F4ng c\u1EE5(s)'), (& $u 'Mua c\u00F4ng c\u1EE5'))
      $updated = $updated.Replace((& $u '"JOIN Purchase c\u00F4ng c\u1EE5(s)"'), (& $u '"Tham gia Mua c\u00F4ng c\u1EE5"'))
      $updated = $updated.Replace((& $u '"Purchase c\u00F4ng c\u1EE5(s)"'), (& $u '"Mua c\u00F4ng c\u1EE5"'))
      $updated = $updated.Replace((& $u '"Tham gia Purchase c\u00F4ng c\u1EE5(s)"'), (& $u '"Tham gia Mua c\u00F4ng c\u1EE5"'))
      $updated = $updated.Replace((& $u '"JOIN Fire"'), (& $u '"Tham gia cho ngh\u1EC9 vi\u1EC7c"'))
      $updated = $updated.Replace((& $u '"Fire"'), (& $u '"Cho ngh\u1EC9 vi\u1EC7c"'))
      $updated = $updated.Replace((& $u '"FiredPerson"'), (& $u '"Nh\u00E2n vi\u00EAn b\u1ECB cho ngh\u1EC9"'))
      $updated = $updated.Replace(
        (& $u 'The qu\u1EA3n l\u00FD d\u1EF1 \u00E1n (player) fires an nh\u00E2n vi\u00EAn from their job, after which that nh\u00E2n vi\u00EAn no longer works at the company'),
        (& $u 'Ng\u01B0\u1EDDi qu\u1EA3n l\u00FD d\u1EF1 \u00E1n (ng\u01B0\u1EDDi ch\u01A1i) cho m\u1ED9t nh\u00E2n vi\u00EAn ngh\u1EC9 vi\u1EC7c; sau \u0111\u00F3 nh\u00E2n vi\u00EAn n\u00E0y kh\u00F4ng c\u00F2n l\u00E0m vi\u1EC7c cho c\u00F4ng ty.')
      )
      $updated = Replace-InJavaStringLiterals $updated ([ordered]@{
        'JOIN ' = (& $u 'Tham gia ')
      })
      foreach ($key in $xpExactStrings.Keys) {
        $updated = $updated.Replace($key, $xpExactStrings[$key])
      }
      if ($_.FullName -match '[\\/]generated[\\/]xp[\\/]') {
        $xpCleanup = [ordered]@{
          'pair programming' = (Convert-JavaUnicodeEscapes 'l\u1EADp tr\u00ECnh c\u1EB7p')
          (Convert-JavaUnicodeEscapes 'thi\u1EBFt k\u1EBFing') = (Convert-JavaUnicodeEscapes 'thi\u1EBFt k\u1EBF')
          '(Nam and H\u01B0\u01A1ng)' = (Convert-JavaUnicodeEscapes '(Nam v\u00E0 H\u01B0\u01A1ng)')
          '(Minh and Lan)' = (Convert-JavaUnicodeEscapes '(Minh v\u00E0 Lan)')
          '(Trang and Quang)' = (Convert-JavaUnicodeEscapes '(Trang v\u00E0 Quang)')
          '(Trang & Quang)' = (Convert-JavaUnicodeEscapes '(Trang v\u00E0 Quang)')
        }
        foreach ($cleanupKey in $xpCleanup.Keys) {
          $updated = $updated.Replace($cleanupKey, $xpCleanup[$cleanupKey])
        }
        $xpTerminologyCleanup = @(
          ,@((Convert-JavaUnicodeEscapes 'K\u1EBF ho\u1EA1ch release'), (Convert-JavaUnicodeEscapes 'K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch release'), (Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'release planning'), (Convert-JavaUnicodeEscapes 'l\u1EADp k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'Release Plan'), (Convert-JavaUnicodeEscapes 'K\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'release plan'), (Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'K\u1EBF ho\u1EA1ch iteration'), (Convert-JavaUnicodeEscapes 'K\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p'))
          ,@((Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch iteration'), (Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p'))
          ,@((Convert-JavaUnicodeEscapes 'current iteration plan'), (Convert-JavaUnicodeEscapes 'k\u1EBF ho\u1EA1ch v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i'))
          ,@((Convert-JavaUnicodeEscapes 'current iteration'), (Convert-JavaUnicodeEscapes 'v\u00F2ng l\u1EB7p hi\u1EC7n t\u1EA1i'))
          ,@((Convert-JavaUnicodeEscapes 'new iteration'), (Convert-JavaUnicodeEscapes 'v\u00F2ng l\u1EB7p m\u1EDBi'))
          ,@((Convert-JavaUnicodeEscapes 'this iteration'), (Convert-JavaUnicodeEscapes 'v\u00F2ng l\u1EB7p n\u00E0y'))
          ,@((Convert-JavaUnicodeEscapes 'the iteration'), (Convert-JavaUnicodeEscapes 'v\u00F2ng l\u1EB7p'))
          ,@((Convert-JavaUnicodeEscapes 'each iteration'), (Convert-JavaUnicodeEscapes 'm\u1ED7i v\u00F2ng l\u1EB7p'))
          ,@((Convert-JavaUnicodeEscapes 'iteration'), (Convert-JavaUnicodeEscapes 'v\u00F2ng l\u1EB7p'))
          ,@((Convert-JavaUnicodeEscapes 'User stories'), (Convert-JavaUnicodeEscapes 'C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng'))
          ,@((Convert-JavaUnicodeEscapes 'User story'), (Convert-JavaUnicodeEscapes 'C\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng'))
          ,@((Convert-JavaUnicodeEscapes 'user stories'), (Convert-JavaUnicodeEscapes 'c\u00E1c c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng'))
          ,@((Convert-JavaUnicodeEscapes 'user story'), (Convert-JavaUnicodeEscapes 'c\u00E2u chuy\u1EC7n ng\u01B0\u1EDDi d\u00F9ng'))
          ,@((Convert-JavaUnicodeEscapes 'developers'), (Convert-JavaUnicodeEscapes 'l\u1EADp tr\u00ECnh vi\u00EAn'))
          ,@((Convert-JavaUnicodeEscapes 'developer'), (Convert-JavaUnicodeEscapes 'l\u1EADp tr\u00ECnh vi\u00EAn'))
          ,@((Convert-JavaUnicodeEscapes 'implemented'), (Convert-JavaUnicodeEscapes '\u0111\u00E3 hi\u1EC7n th\u1EF1c'))
          ,@((Convert-JavaUnicodeEscapes 'implementing'), (Convert-JavaUnicodeEscapes '\u0111ang hi\u1EC7n th\u1EF1c'))
          ,@((Convert-JavaUnicodeEscapes 'implement'), (Convert-JavaUnicodeEscapes 'hi\u1EC7n th\u1EF1c'))
          ,@((Convert-JavaUnicodeEscapes 'refactoring the code'), (Convert-JavaUnicodeEscapes 't\u00E1i c\u1EA5u tr\u00FAc code'))
          ,@((Convert-JavaUnicodeEscapes 'Refactor code'), (Convert-JavaUnicodeEscapes 'T\u00E1i c\u1EA5u tr\u00FAc code'))
          ,@((Convert-JavaUnicodeEscapes 'refactor code'), (Convert-JavaUnicodeEscapes 't\u00E1i c\u1EA5u tr\u00FAc code'))
          ,@((Convert-JavaUnicodeEscapes 'Refactor to\u00E0n b\u1ED9 code'), (Convert-JavaUnicodeEscapes 'T\u00E1i c\u1EA5u tr\u00FAc to\u00E0n b\u1ED9 code'))
          ,@((Convert-JavaUnicodeEscapes 'refactoring'), (Convert-JavaUnicodeEscapes 't\u00E1i c\u1EA5u tr\u00FAc'))
          ,@((Convert-JavaUnicodeEscapes 'Test cases'), (Convert-JavaUnicodeEscapes 'Ca ki\u1EC3m th\u1EED'))
          ,@((Convert-JavaUnicodeEscapes 'Test case'), (Convert-JavaUnicodeEscapes 'Ca ki\u1EC3m th\u1EED'))
          ,@((Convert-JavaUnicodeEscapes 'test cases'), (Convert-JavaUnicodeEscapes 'ca ki\u1EC3m th\u1EED'))
          ,@((Convert-JavaUnicodeEscapes 'test case'), (Convert-JavaUnicodeEscapes 'ca ki\u1EC3m th\u1EED'))
          ,@((Convert-JavaUnicodeEscapes 'Coding standard'), (Convert-JavaUnicodeEscapes 'Chu\u1EA9n m\u00E3 ngu\u1ED3n'))
          ,@((Convert-JavaUnicodeEscapes 'coding standard'), (Convert-JavaUnicodeEscapes 'chu\u1EA9n m\u00E3 ngu\u1ED3n'))
          ,@((Convert-JavaUnicodeEscapes 'Code cho c\u00E1c'), (Convert-JavaUnicodeEscapes 'M\u00E3 ngu\u1ED3n cho c\u00E1c'))
          ,@((Convert-JavaUnicodeEscapes 'Release code'), (Convert-JavaUnicodeEscapes 'Ph\u00E1t h\u00E0nh code'))
          ,@((Convert-JavaUnicodeEscapes 'release the code'), (Convert-JavaUnicodeEscapes 'ph\u00E1t h\u00E0nh code'))
          ,@((Convert-JavaUnicodeEscapes 'release code'), (Convert-JavaUnicodeEscapes 'ph\u00E1t h\u00E0nh code'))
          ,@((Convert-JavaUnicodeEscapes 'new release'), (Convert-JavaUnicodeEscapes 'b\u1EA3n ph\u00E1t h\u00E0nh m\u1EDBi'))
          ,@((Convert-JavaUnicodeEscapes 'this release'), (Convert-JavaUnicodeEscapes 'b\u1EA3n ph\u00E1t h\u00E0nh n\u00E0y'))
          ,@((Convert-JavaUnicodeEscapes 'system release'), (Convert-JavaUnicodeEscapes 'b\u1EA3n ph\u00E1t h\u00E0nh h\u1EC7 th\u1ED1ng'))
          ,@((Convert-JavaUnicodeEscapes 'c\u00E1c release'), (Convert-JavaUnicodeEscapes 'c\u00E1c b\u1EA3n ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'release nh\u1ECF'), (Convert-JavaUnicodeEscapes 'b\u1EA3n ph\u00E1t h\u00E0nh nh\u1ECF'))
          ,@((Convert-JavaUnicodeEscapes 'release tr\u01B0\u1EDBc'), (Convert-JavaUnicodeEscapes 'ph\u00E1t h\u00E0nh tr\u01B0\u1EDBc'))
          ,@((Convert-JavaUnicodeEscapes 'b\u1EA1n release'), (Convert-JavaUnicodeEscapes 'b\u1EA1n ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 't\u1EEBng release'), (Convert-JavaUnicodeEscapes 't\u1EEBng b\u1EA3n ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'ng\u00E0y release'), (Convert-JavaUnicodeEscapes 'ng\u00E0y ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'ch\u1EA5p nh\u1EADn release'), (Convert-JavaUnicodeEscapes 'ch\u1EA5p nh\u1EADn b\u1EA3n ph\u00E1t h\u00E0nh'))
          ,@((Convert-JavaUnicodeEscapes 'test-driven development'), (Convert-JavaUnicodeEscapes 'ph\u00E1t tri\u1EC3n h\u01B0\u1EDBng ki\u1EC3m th\u1EED'))
          ,@((Convert-JavaUnicodeEscapes 'continuous testing'), (Convert-JavaUnicodeEscapes 'ki\u1EC3m th\u1EED li\u00EAn t\u1EE5c'))
          ,@((Convert-JavaUnicodeEscapes 'development'), (Convert-JavaUnicodeEscapes 'ph\u00E1t tri\u1EC3n'))
          ,@((Convert-JavaUnicodeEscapes 'integration'), (Convert-JavaUnicodeEscapes 't\u00EDch h\u1EE3p'))
          ,@((Convert-JavaUnicodeEscapes 'artifact'), (Convert-JavaUnicodeEscapes 's\u1EA3n ph\u1EA9m'))
          ,@((Convert-JavaUnicodeEscapes 'RefactoringC\u00F4ng c\u1EE5'), (Convert-JavaUnicodeEscapes 'C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc'))
          ,@((Convert-JavaUnicodeEscapes 'RefactoringTool ('), (Convert-JavaUnicodeEscapes 'C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc ('))
          ,@((Convert-JavaUnicodeEscapes 'RefactoringTool('), (Convert-JavaUnicodeEscapes 'C\u00F4ng c\u1EE5 t\u00E1i c\u1EA5u tr\u00FAc('))
        )
        $updated = Replace-InJavaStringLiterals $updated (Resolve-JavaReplacementMap $xpTerminologyCleanup)
        $updated = $updated.Replace('"No"', (& $u '"Ch\u01B0a"'))
        $updated = $updated.Replace('"Yes"', (& $u '"C\u00F3"'))
        $updated = $updated.Replace('"Developer"', (& $u '"L\u1EADp tr\u00ECnh vi\u00EAn"'))
        $updated = $updated.Replace('"Developer(s): "', (& $u '"L\u1EADp tr\u00ECnh vi\u00EAn: "'))
        $updated = $updated.Replace('"Developer(s); "', (& $u '"L\u1EADp tr\u00ECnh vi\u00EAn; "'))
      }
      if ($_.Name -eq 'SimSE.java' -and $updated -notmatch 'configureVietnameseFont') {
        $updated = [regex]::Replace(
          $updated,
          'import java\.util\.ArrayList;\r?\n',
          "import java.util.ArrayList;`r`nimport java.util.Enumeration;`r`nimport java.awt.Font;`r`nimport javax.swing.UIManager;`r`nimport javax.swing.plaf.FontUIResource;`r`n",
          1
        )
        $updated = [regex]::Replace(
          $updated,
          'public class SimSE\s*\{\r?\n',
          "public class SimSE`r`n{`r`nstatic {`r`nconfigureVietnameseFont();`r`n}`r`n`r`n",
          1
        )
        $fontMethod = @'
private static void configureVietnameseFont() {
FontUIResource font = new FontUIResource("Tahoma", Font.PLAIN, 12);
Enumeration<Object> keys = UIManager.getDefaults().keys();
while (keys.hasMoreElements()) {
Object key = keys.nextElement();
Object value = UIManager.get(key);
if (value instanceof FontUIResource) {
UIManager.put(key, font);
}
}
}

'@
        $updated = $updated.Replace('public static void startNewBranch(State state, Branch branch) {', $fontMethod + 'public static void startNewBranch(State state, Branch branch) {')
      }
      if ($_.Name -eq 'ClockPanel.java') {
        $clockBuildGui = @'
private void buildGUI()
{
setLayout(null);
setOpaque(false);
setPreferredSize(new Dimension(250,100));

btnNextEvent = new JLabel(icoNextEvent);
btnNextEvent.setBounds(141, 12, icoNextEvent.getIconWidth(), icoNextEvent.getIconHeight());
btnNextEvent.addMouseListener(this);
add(btnNextEvent);

btnAdvClock = new JLabel(icoAdvClock);
btnAdvClock.setBounds(141, 35, icoAdvClock.getIconWidth(), icoAdvClock.getIconHeight());
btnAdvClock.addMouseListener(this);
add(btnAdvClock);

stopCBox = new JCheckBox();
stopCBox.setOpaque(false);
stopCBox.setFocusPainted(false);
stopCBox.setBounds(136, 56, 18, 18);
stopCBox.addMouseListener(this);
add(stopCBox);

txtAdvClock = new JTextField("1");
txtAdvClock.setForeground(Color.DARK_GRAY);
txtAdvClock.setHorizontalAlignment(JTextField.CENTER);
txtAdvClock.setFont(new Font("Tahoma", Font.PLAIN, 11));
txtAdvClock.setOpaque(false);
txtAdvClock.setPreferredSize(new Dimension(48,18));
txtAdvClock.setBounds(161, 56, 48, 18);
txtAdvClock.setBorder(new LineBorder(new Color(0, 0, 0, 0)));
add(txtAdvClock);
}
'@
        $updated = [regex]::Replace($updated, '(?s)private void buildGUI\(\)\s*\{.*?\r?\n\}\r?\n\r?\npublic void resetAdvClockImage', $clockBuildGui.TrimEnd() + "`r`n`r`npublic void resetAdvClockImage")
        $updated = $updated.Replace('g.fillRect(0,0,242+10,96+20);', 'g.fillRect(0,0,250,100);')
        $updated = $updated.Replace('int x = 20 + blanks + (i * 10);', 'int x = 14 + blanks + (i * 10);')
        $updated = $updated.Replace('g.drawImage(timeElapsedDigits[i],x,52,this);', 'g.drawImage(timeElapsedDigits[i],x,41,this);')
      }
      if ($updated -ne $text) {
        Write-Utf8NoBom $_.FullName $updated
      }
    }
}

function Add-LegacyImagePlaceholders($generatedRoot) {
  Get-ChildItem -LiteralPath $generatedRoot -Directory |
    ForEach-Object {
      $imagesDir = Join-Path $_.FullName 'simse\gui\images'
      $fallback = Join-Path $imagesDir 'transparent.gif'
      if (Test-Path -LiteralPath $fallback) {
        foreach ($imageName in @('table.gif', 'dark.gif')) {
          $target = Join-Path $imagesDir $imageName
          if (-not (Test-Path -LiteralPath $target)) {
            Copy-Item -LiteralPath $fallback -Destination $target -Force
          }
        }
      }
    }
}

function Add-VietnameseImageLabels($generatedRoot) {
  Reset-Directory $imageGeneratorClasses
  $imageSrc = Join-Path $PSScriptRoot 'VietnameseImageGenerator.java'
  Invoke-QuietJavac -Arguments ($javacArgs + @('-d', $imageGeneratorClasses, $imageSrc))
  Invoke-QuietJava -Arguments @('-Djava.awt.headless=true', '-cp', $imageGeneratorClasses, 'VietnameseImageGenerator', $generatedRoot)
}

function Write-Launchers($simulationDir, $jarName) {
  $cpSep = if ($LauncherPlatform -eq 'Unix') { ':' } else { ';' }
  $classpath = "$jarName${cpSep}lib/*"
  Write-Utf8NoBom (Join-Path $simulationDir 'run.ps1') @"
`$scriptDir = Split-Path -Parent `$MyInvocation.MyCommand.Path
Set-Location `$scriptDir
& java "-Dfile.encoding=UTF-8" -cp "$classpath" simse.SimSE
"@
  if ($LauncherPlatform -eq 'Unix') {
    Write-Utf8NoBom (Join-Path $simulationDir 'run.sh') @"
#!/usr/bin/env bash
set -euo pipefail
cd "`$(dirname "`$0")"
exec java "-Dfile.encoding=UTF-8" -cp "$classpath" simse.SimSE
"@
  } else {
    Set-Content -Encoding ASCII -LiteralPath (Join-Path $simulationDir 'run.bat') -Value @"
@echo off
setlocal
cd /d "%~dp0"
java "-Dfile.encoding=UTF-8" -cp "$classpath" simse.SimSE
"@
  }
}

function Assert-NativeSuccess($label) {
  if ($LASTEXITCODE -ne 0) {
    throw "$label failed with exit code $LASTEXITCODE"
  }
}

New-Item -ItemType Directory -Force -Path $bin | Out-Null
Reset-Directory $generatedRoot
Reset-Directory $simulationsRoot

Reset-Directory $builderClasses
$builderSources = Get-ChildItem -LiteralPath (Join-Path $root 'src') -Recurse -Filter '*.java' |
  ForEach-Object { $_.FullName }
Invoke-QuietJavac -Arguments ($javacArgs + @('-d', $builderClasses) + $builderSources)
Copy-BuilderResources (Join-Path $root 'src') $builderClasses

Invoke-QuietJava -Arguments @(
  '-Djava.awt.headless=true',
  '-Dfile.encoding=UTF-8',
  '-cp', $builderClasses,
  'simse.tools.SimulationBatchGenerator',
  $modelsRoot,
  $generatedRoot
)
Apply-GeneratedVietnameseTextFixups $generatedRoot
$resolvedWindowTitleSuffix = Resolve-WindowTitleSuffix $StudentName $StudentId $WindowTitleSuffix
Apply-GeneratedWindowTitleSuffix $generatedRoot $resolvedWindowTitleSuffix
Add-LegacyImagePlaceholders $generatedRoot
Add-VietnameseImageLabels $generatedRoot

$models = @(
  @{ Id = 'waterfall'; Jar = 'simse-waterfall-vn.jar'; Title = 'Waterfall' },
  @{ Id = 'incremental'; Jar = 'simse-incremental-vn.jar'; Title = 'Incremental' },
  @{ Id = 'xp'; Jar = 'simse-xp-vn.jar'; Title = 'XP' }
)

Reset-Directory $packageWorkRoot

foreach ($model in $models) {
  $id = $model.Id
  $sourceDir = Join-Path $generatedRoot $id
  $modelWorkDir = Join-Path $packageWorkRoot $id
  $classDir = Join-Path $modelWorkDir 'classes'
  $simulationDir = Join-Path $simulationsRoot $id
  $manifest = Join-Path $modelWorkDir 'manifest.mf'
  $classpath = Get-ClassPath (Join-Path $sourceDir 'lib')

  Reset-Directory $classDir
  New-Item -ItemType Directory -Force -Path $simulationDir | Out-Null

  $sourceRoot = Join-Path $sourceDir 'simse'
  $generatedSources = @()
  for ($attempt = 1; $attempt -le 10; $attempt++) {
    if (Test-Path -LiteralPath $sourceRoot) {
      $generatedSources = @(Get-ChildItem -LiteralPath $sourceRoot -Recurse -Filter '*.java' -ErrorAction SilentlyContinue |
        ForEach-Object { $_.FullName })
      if ($generatedSources.Count -gt 0) {
        break
      }
    }
    Start-Sleep -Milliseconds ([Math]::Min(500 * $attempt, 2000))
  }
  $sourcesFile = Join-Path $modelWorkDir 'sources.txt'
  if ($generatedSources.Count -eq 0) {
    throw "No generated Java sources found for $id in $sourceDir"
  }
  $sourceLines = @($generatedSources |
    ForEach-Object { '"' + ($_ -replace '\\', '/') + '"' })
  Set-Content -Encoding ASCII -LiteralPath $sourcesFile -Value $sourceLines
  if ($classpath) {
    Invoke-QuietJavac -Arguments (@('--release', '8') + $javacArgs + @('-cp', $classpath, '-d', $classDir, "@$sourcesFile"))
  } else {
    Invoke-QuietJavac -Arguments (@('--release', '8') + $javacArgs + @('-d', $classDir, "@$sourcesFile"))
  }

  Copy-Resources (Join-Path $sourceDir 'simse') (Join-Path $classDir 'simse')

  $manifestLines = @('Manifest-Version: 1.0', 'Main-Class: simse.SimSE')
  $libDir = Join-Path $sourceDir 'lib'
  if (Test-Path -LiteralPath $libDir) {
    $targetLibDir = Join-Path $simulationDir 'lib'
    New-Item -ItemType Directory -Force -Path $targetLibDir | Out-Null
    Get-ChildItem -LiteralPath $libDir -File |
      ForEach-Object {
        $targetLib = Join-Path $targetLibDir $_.Name
        if (-not (Test-Path -LiteralPath $targetLib)) {
          Copy-Item -LiteralPath $_.FullName -Destination $targetLibDir -Force
        }
      }
    $relativeJars = Get-ChildItem -LiteralPath $targetLibDir -Filter '*.jar' |
      ForEach-Object { 'lib/' + $_.Name }
    if ($relativeJars.Count -gt 0) {
      $manifestLines += 'Class-Path: ' + ($relativeJars -join ' ')
    }
  }
  Set-Content -Encoding ASCII -LiteralPath $manifest -Value ($manifestLines -join "`r`n")
  Add-Content -Encoding ASCII -LiteralPath $manifest -Value ''

  & $jarExe cfm (Join-Path $simulationDir $model.Jar) $manifest -C $classDir .
  Assert-NativeSuccess "JAR packaging for $id"
  Write-Launchers $simulationDir $model.Jar
  if ($LauncherPlatform -eq 'Unix') {
    $runSh = Join-Path $simulationDir 'run.sh'
    if ((Test-Path -LiteralPath $runSh) -and (Get-Command chmod -ErrorAction SilentlyContinue)) {
      & chmod +x $runSh
    }
  }
  Write-Host "Built $($model.Title): $(Join-Path $simulationDir $model.Jar)"
}
