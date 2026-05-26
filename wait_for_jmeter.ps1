Write-Output "Waiting for JMeter processes to finish..."
while (Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -and $_.CommandLine -match 'ApacheJMeter.jar' }) {
  Write-Output ("Still running at " + (Get-Date))
  Start-Sleep -Seconds 5
}
Write-Output "JMeter finished."
if (Test-Path 'c:\Expert-Jmter\results.jtl') {
  Get-Item 'c:\Expert-Jmter\results.jtl' | Select-Object FullName,Length,LastWriteTime | Format-List
  Write-Output "--- last 20 lines of results.jtl ---"
  Get-Content 'c:\Expert-Jmter\results.jtl' -Tail 20
} else {
  Write-Output 'RESULTS_NOT_FOUND'
}