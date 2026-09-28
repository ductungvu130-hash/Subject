@echo off
setlocal
cd /d "%~dp0"
java "-Dfile.encoding=UTF-8" -cp "simse-xp-vn.jar;lib/*" simse.SimSE
