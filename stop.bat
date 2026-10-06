@echo off
title FitFlow Pro - Stop Services
echo ====================================================
echo Stopping FitFlow Pro Services...
echo ====================================================

set "CATALINA_HOME=C:\Users\ak155\Downloads\apache-tomcat-10.1.60-windows-x64\apache-tomcat-10.1.60"

echo [1/2] Stopping Tomcat Server...
if exist "%CATALINA_HOME%\bin\shutdown.bat" (
    call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
)
taskkill /f /fi "WINDOWTITLE eq Tomcat Server*" >nul 2>&1

echo [2/2] Stopping MySQL Server...
if exist "C:\xampp\mysql_stop.bat" (
    call "C:\xampp\mysql_stop.bat" >nul 2>&1
)
taskkill /f /im mysqld.exe >nul 2>&1

echo ====================================================
echo All services stopped successfully.
echo ====================================================
pause
