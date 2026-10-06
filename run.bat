@echo off
title FitFlow Pro Launcher
echo ====================================================
echo Starting FitFlow Pro Fitness Tracker...
echo ====================================================

:: Step 1: Ensure MySQL Database is Running
echo [1/3] Checking MySQL Database status...
netstat -ano | findstr /R /C:":3306 " >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo       MySQL is already running on port 3306.
) else (
    echo       Starting MySQL Database from XAMPP...
    if exist "C:\xampp\mysql_start.bat" (
        start "MySQL Server" /min "C:\xampp\mysql_start.bat"
        echo       Waiting for MySQL to initialize...
        timeout /t 3 /nobreak >nul
    ) else if exist "C:\xampp\mysql\bin\mysqld.exe" (
        start "" /b "C:\xampp\mysql\bin\mysqld.exe" --defaults-file="C:\xampp\mysql\bin\my.ini" --standalone
        echo       Waiting for MySQL to initialize...
        timeout /t 3 /nobreak >nul
    ) else (
        echo       [WARNING] Could not find XAMPP MySQL. Please ensure MySQL is running manually.
    )
)

:: Step 2: Start Apache Tomcat Server
set "JAVA_HOME=C:\Program Files\Java\jdk-25"
set "CATALINA_HOME=C:\Users\ak155\Downloads\apache-tomcat-10.1.60-windows-x64\apache-tomcat-10.1.60"

echo [2/3] Launching Apache Tomcat Server...
cd /d "%CATALINA_HOME%\bin"
start "Tomcat Server" "%CATALINA_HOME%\bin\catalina.bat" run

timeout /t 4 /nobreak >nul

:: Step 3: Open Browser
echo [3/3] Opening FitFlow Pro in your browser...
start http://localhost:8080/fitness-tracker/

echo ====================================================
echo Application is running at http://localhost:8080/fitness-tracker/
echo Keep the Tomcat and MySQL windows open while using the app.
echo ====================================================
pause
