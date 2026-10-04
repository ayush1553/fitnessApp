@echo off
title FitFlow Pro Launcher
echo ====================================================
echo Starting FitFlow Pro Fitness Tracker...
echo ====================================================

set "JAVA_HOME=C:\Program Files\Java\jdk-25"
set "CATALINA_HOME=C:\Users\ak155\Downloads\apache-tomcat-10.1.60-windows-x64\apache-tomcat-10.1.60"

echo [1/2] Launching Apache Tomcat Server...
cd /d "%CATALINA_HOME%\bin"
start "Tomcat Server" "%CATALINA_HOME%\bin\catalina.bat" run

timeout /t 4 /nobreak >nul

echo [2/2] Opening FitFlow Pro in your browser...
start http://localhost:8080/fitness-tracker/

echo ====================================================
echo Application is running at http://localhost:8080/fitness-tracker/
echo Keep the Tomcat console window open while using the app.
echo ====================================================
pause
