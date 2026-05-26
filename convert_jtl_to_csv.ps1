[xml]$doc = Get-Content 'c:\Expert-Jmter\results.jtl'
$nodes = $doc.SelectNodes('//httpSample | //sample')
$out = @()
foreach ($n in $nodes) {
  $ts = $n.GetAttribute('ts')
  $t = $n.GetAttribute('t')
  $lb = $n.GetAttribute('lb') -replace "[\r\n]+"," "
  $rc = $n.GetAttribute('rc')
  $rm = $n.GetAttribute('rm') -replace "[\r\n]+"," "
  $tn = $n.GetAttribute('tn')
  $dt = $n.GetAttribute('dt')
  $s = $n.GetAttribute('s')
  $by = $n.GetAttribute('by')
  $lt = $n.GetAttribute('lt')
  $ct = $n.GetAttribute('ct')
  $error = if ($s -eq 'true') {0} else {1}
  $obj = [PSCustomObject]@{
    timeStamp = $ts
    elapsed = $t
    label = $lb
    responseCode = $rc
    responseMessage = $rm
    threadName = $tn
    dataType = $dt
    success = $s
    bytes = $by
    Latency = $lt
    SampleCount = 1
    ErrorCount = $error
    Hostname = ''
    IdleTime = 0
    Connect = $ct
  }
  $out += $obj
}
$out | Export-Csv -NoTypeInformation -Path 'c:\Expert-Jmter\results.csv' -Encoding UTF8
Write-Output "Wrote c:\Expert-Jmter\results.csv with $($out.Count) rows."