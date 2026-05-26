Write-Output "JMETER_HOME=$env:JMETER_HOME"
try { where.exe jmeter } catch { Write-Output "where.exe didn't find jmeter" }
$paths = @(
  'C:\apache-jmeter*',
  'C:\Program Files\apache-jmeter*',
  'C:\Program Files\Apache*\apache-jmeter*',
  'C:\ProgramData\chocolatey\lib\jmeter*',
  'C:\Program Files (x86)\apache-jmeter*'
)
foreach ($p in $paths) {
  try {
    Get-ChildItem -Path $p -Directory -ErrorAction SilentlyContinue | ForEach-Object {
      $f = Join-Path $_.FullName 'bin\jmeter.bat'
      if (Test-Path $f) { Write-Output $f }
    }
  } catch {}
}
# Also check common Program Files locations directly
$more = @('C:\Program Files','C:\Program Files (x86)','C:\ProgramData\chocolatey\lib')
foreach ($m in $more) {
  try {
    Get-ChildItem -Path $m -Recurse -Directory -ErrorAction SilentlyContinue -Depth 2 | ForEach-Object {
      $f = Join-Path $_.FullName 'bin\jmeter.bat'
      if (Test-Path $f) { Write-Output $f }
    }
  } catch {}
}
Write-Output "Search complete."