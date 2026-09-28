$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir
& java "-Dfile.encoding=UTF-8" -cp "simse-incremental-vn.jar;lib/*" simse.SimSE