$s = Get-Content 'c:\Expert-Jmter\results-report.csv' -Raw
if ($s.Length -gt 300) { Write-Output $s.Substring(0,300) } else { Write-Output $s }