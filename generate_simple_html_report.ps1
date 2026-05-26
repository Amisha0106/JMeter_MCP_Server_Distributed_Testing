$csvPath = 'c:\Expert-Jmter\results-clean.csv'
$outDir = 'c:\Expert-Jmter\jmeter-report'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$rows = Import-Csv -Path $csvPath
$total = $rows.Count
$avg = [math]::Round(($rows | Measure-Object -Property elapsed -Average).Average,2)
$min = ($rows | Measure-Object -Property elapsed -Minimum).Minimum
$max = ($rows | Measure-Object -Property elapsed -Maximum).Maximum
$errors = $rows | Where-Object { $_.ErrorCount -ne '0' -or $_.success -ne 'true' }
$errorCount = $errors.Count
$errorRate = if ($total -gt 0) { [math]::Round(($errorCount / $total) * 100,2) } else { 0 }
$topSlow = $rows | Sort-Object -Property {[int]$_.elapsed} -Descending | Select-Object -First 20
$topErrors = $errors | Select-Object -First 20

$html = @"
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>JMeter Simple Report</title>
  <style>body{font-family:Arial,Helvetica,sans-serif;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px}th{background:#f4f4f4;text-align:left}</style>
</head>
<body>
  <h1>JMeter Simple Report</h1>
  <h2>Summary</h2>
  <ul>
    <li>Total samples: $total</li>
    <li>Average elapsed (ms): $avg</li>
    <li>Min elapsed (ms): $min</li>
    <li>Max elapsed (ms): $max</li>
    <li>Error count: $errorCount</li>
    <li>Error rate: $errorRate %</li>
  </ul>
  <h2>Top 20 Slowest Samples</h2>
  <table>
    <tr><th>elapsed</th><th>label</th><th>responseCode</th><th>success</th><th>threadName</th></tr>
"@

foreach ($r in $topSlow) {
  $html += "    <tr><td>$($r.elapsed)</td><td>$($r.label)</td><td>$($r.responseCode)</td><td>$($r.success)</td><td>$($r.threadName)</td></tr>`n"
}
$html += "  </table>`n  <h2>Top Errors (first 20)</h2>`n  <table>`n    <tr><th>elapsed</th><th>label</th><th>responseCode</th><th>responseMessage</th><th>threadName</th></tr>`n"
foreach ($r in $topErrors) {
  $html += "    <tr><td>$($r.elapsed)</td><td>$($r.label)</td><td>$($r.responseCode)</td><td>$($r.responseMessage)</td><td>$($r.threadName)</td></tr>`n"
}
$html += "  </table>`n</body>`n</html>"

Set-Content -Path (Join-Path $outDir 'index.html') -Value $html -Encoding UTF8
Write-Output "Wrote HTML report to $outDir\index.html"