$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir
& java "-Dfile.encoding=UTF-8" -cp "simse-xp-vn.jar;lib/*" simse.SimSE