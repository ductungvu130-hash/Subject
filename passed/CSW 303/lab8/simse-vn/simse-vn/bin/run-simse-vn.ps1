$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir
java -Dfile.encoding=UTF-8 -jar simse-vn.jar
