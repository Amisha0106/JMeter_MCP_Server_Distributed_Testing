$outFile = 'c:\Expert-Jmter\results-clean.csv'
$header = 'timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,bytes,Latency,SampleCount,ErrorCount,Hostname,IdleTime,Connect'
Set-Content -Path $outFile -Value $header -Encoding ASCII
[xml]$jtl = Get-Content 'c:\Expert-Jmter\results.jtl'
$nodes = $jtl.SelectNodes('//httpSample | //sample')
foreach ($n in $nodes) {
    $ts = $n.GetAttribute('ts')
    $t = $n.GetAttribute('t')
    $lb = ($n.GetAttribute('lb') -replace '"','""' -replace "[\r\n]+", ' ')
    $rc = $n.GetAttribute('rc')
    $rm = ($n.GetAttribute('rm') -replace '"','""' -replace "[\r\n]+", ' ')
    $tn = ($n.GetAttribute('tn') -replace '"','""' -replace "[\r\n]+", ' ')
    $dt = $n.GetAttribute('dt')
    $s = $n.GetAttribute('s')
    $by = $n.GetAttribute('by')
    $lt = $n.GetAttribute('lt')
    $ct = $n.GetAttribute('ct')
    $errorCount = if ($s -eq 'true') { 0 } else { 1 }
    $line = "$ts,$t,$lb,$rc,$rm,$tn,$dt,$s,$by,$lt,1,$errorCount,,0,$ct"
    Add-Content -Path $outFile -Value $line -Encoding ASCII
}
Write-Output "Wrote $outFile"