#Requires -Version 5.1
param(
  [string] $WindowTitleSuffix = '',
  [string] $StudentName = '',
  [string] $StudentId = ''
)

$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'build-simulations-common.ps1') `
  -LauncherPlatform Windows `
  -WindowTitleSuffix $WindowTitleSuffix `
  -StudentName $StudentName `
  -StudentId $StudentId
