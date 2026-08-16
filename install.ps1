# Dr. Stone - instalador para Windows
# Uso:  irm https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$dir = Join-Path $env:USERPROFILE '.claude'
$file = Join-Path $dir 'settings.json'
$recordatorio = 'echo DRSTONE ON: responde como cavernicola inteligente. Sin articulos, sin muletillas, sin cortesias, sin hedging. Fragmentos OK, sinonimos cortos. Nada de narrar tool calls, tablas decorativas, emojis, recapitulaciones ni pendientes no pedidos. El largo es el que haga falta y ni una palabra mas. Toda la sustancia tecnica intacta: codigo, nombres de API, comandos y errores van literales. Responde en el idioma del usuario. Sal del modo solo para avisos de seguridad, confirmaciones irreversibles o cuando comprimir cree ambiguedad.'

New-Item -ItemType Directory -Force $dir | Out-Null

if (Test-Path $file) {
  # Copia antes de tocar nada: este archivo suele tener permisos y hooks propios.
  $backup = "$file.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  Copy-Item $file $backup
  Write-Host "Copia de seguridad: $backup"
  $json = Get-Content $file -Raw | ConvertFrom-Json
} else {
  $json = [pscustomobject]@{}
}

if (-not $json.PSObject.Properties['hooks']) {
  $json | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{})
}

$entrada = [pscustomobject]@{
  hooks = @([pscustomobject]@{ type = 'command'; command = $recordatorio; timeout = 5 })
}

$previos = @()
if ($json.hooks.PSObject.Properties['UserPromptSubmit']) {
  # Se conservan los hooks que ya tenia, salvo una instalacion anterior de este mismo.
  $previos = @($json.hooks.UserPromptSubmit | Where-Object {
    ($_ | ConvertTo-Json -Depth 10 -Compress) -notlike '*DRSTONE ON*'
  })
  $json.hooks.PSObject.Properties.Remove('UserPromptSubmit')
}

$json.hooks | Add-Member -NotePropertyName UserPromptSubmit -NotePropertyValue (@($previos) + $entrada)

# UTF-8 sin BOM: con BOM, Claude Code no puede leer el JSON.
$enc = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($file, ($json | ConvertTo-Json -Depth 20), $enc)

Write-Host ''
Write-Host 'Dr. Stone instalado.' -ForegroundColor Green
Write-Host 'Cerra y abri Claude Code (la app, no solo la sesion) para que tome el cambio.'
