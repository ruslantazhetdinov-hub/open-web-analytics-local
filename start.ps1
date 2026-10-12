$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
Set-Location $PSScriptRoot

$docker = (Get-Command docker -ErrorAction SilentlyContinue).Source
if (-not $docker) {
    $docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
}
if (-not (Test-Path -LiteralPath $docker)) {
    throw 'Docker Desktop не найден. Установите или переустановите Docker Desktop.'
}

& $docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Start-Process -FilePath 'C:\Program Files\Docker\Docker\Docker Desktop.exe' -ArgumentList '--accept-license' -WindowStyle Hidden
    Write-Host 'Запускаю Docker Desktop...' -ForegroundColor Yellow
    $ready = $false
    foreach ($attempt in 1..60) {
        Start-Sleep -Seconds 2
        & $docker info *> $null
        if ($LASTEXITCODE -eq 0) {
            $ready = $true
            break
        }
    }
    if (-not $ready) {
        throw 'Docker не запустился за 2 минуты. Проверьте Docker Desktop и перезагрузите Windows, если компоненты WSL были включены только что.'
    }
}

& $docker compose up -d --build
& $docker compose ps

Write-Host ''
Write-Host 'Тестовый сайт: http://localhost:8081/' -ForegroundColor Cyan
Write-Host 'Панель OWA:    http://localhost:8080/' -ForegroundColor Cyan
Write-Host 'Логин:         admin' -ForegroundColor Cyan
Write-Host 'Пароль:        значение OWA_DB_PASSWORD из файла .env' -ForegroundColor Cyan

