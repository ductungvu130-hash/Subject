@echo off
setlocal
cd /d "%~dp0"
java "-Dfile.encoding=UTF-8" -cp "simse-waterfall-vn.jar;lib/*" simse.SimSE
