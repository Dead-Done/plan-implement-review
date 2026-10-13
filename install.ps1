<#
.SYNOPSIS
  Installs the plan-implement-review skill and implementer agent for Claude Code.

.PARAMETER Project
  Optional project folder. When given, also scaffolds vault/, CLAUDE.md and AGENTS.md there
  (existing files are never overwritten).

.EXAMPLE
  ./install.ps1
  ./install.ps1 -Project D:\my-app
#>
param([string]$Project)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$claude = Join-Path $HOME '.claude'

New-Item -ItemType Directory -Force (Join-Path $claude 'skills\plan-implement-review'), (Join-Path $claude 'agents') | Out-Null
Copy-Item (Join-Path $src 'skills\plan-implement-review\SKILL.md') (Join-Path $claude 'skills\plan-implement-review\SKILL.md') -Force
Copy-Item (Join-Path $src 'agents\implementer.md') (Join-Path $claude 'agents\implementer.md') -Force
Write-Host "Installed skill and agent into $claude"

if ($Project) {
    $Project = (Resolve-Path $Project).Path
    $tpl = Join-Path $src 'templates'
    Get-ChildItem $tpl -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($tpl.Length + 1)
        $dest = Join-Path $Project $rel
        if (Test-Path $dest) {
            Write-Host "  skip (exists): $rel"
        } else {
            New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
            Copy-Item $_.FullName $dest
            Write-Host "  created: $rel"
        }
    }
    Write-Host "Scaffolded vault in $Project"
}

Write-Host "Restart Claude Code, then run: /plan-implement-review <task>"
