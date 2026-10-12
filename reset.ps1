$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

Write-Warning 'Команда удалит только локальные данные этого стенда OWA.'
docker compose down --volumes --remove-orphans
docker compose up -d --build

