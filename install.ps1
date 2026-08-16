# Dr. Stone - Windows installer
# Usage:  irm https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.ps1 | iex

$ErrorActionPreference = 'Stop'

$dir = Join-Path $env:USERPROFILE '.claude'
$file = Join-Path $dir 'settings.json'
$reminder = 'echo DRSTONE: keep answers short. NEVER: filler, pleasantries, narrating tool calls, unrequested extras. Code and errors verbatim.'

New-Item -ItemType Directory -Force $dir | Out-Null

if (Test-Path $file) {
  # Back up before touching anything: this file usually holds the user own permissions and hooks.
  $backup = "$file.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  Copy-Item $file $backup
  Write-Host "Backup: $backup"
  $json = Get-Content $file -Raw | ConvertFrom-Json
} else {
  $json = [pscustomobject]@{}
}

if (-not $json.PSObject.Properties['hooks']) {
  $json | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{})
}

$entrada = [pscustomobject]@{
  hooks = @([pscustomobject]@{ type = 'command'; command = $reminder; timeout = 5 })
}

$previos = @()
if ($json.hooks.PSObject.Properties['UserPromptSubmit']) {
  # Keep whatever hooks were already there, except a previous install of this one.
  $previos = @($json.hooks.UserPromptSubmit | Where-Object {
    ($_ | ConvertTo-Json -Depth 10 -Compress) -notlike '*DRSTONE ON*'
  })
  $json.hooks.PSObject.Properties.Remove('UserPromptSubmit')
}

$json.hooks | Add-Member -NotePropertyName UserPromptSubmit -NotePropertyValue (@($previos) + $entrada)

# UTF-8 without BOM: with a BOM, Claude Code cannot parse the JSON.
$enc = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($file, ($json | ConvertTo-Json -Depth 20), $enc)

Write-Host ''
Write-Host 'Dr. Stone installed.' -ForegroundColor Green
Write-Host 'Quit and reopen Claude Code (the app, not just the session) for it to take effect.'
