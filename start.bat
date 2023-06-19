@echo off
setlocal

:: Check XAMPP installation directory
for /f "usebackq delims=" %%I in (`powershell -ExecutionPolicy Bypass -Command "$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -gt 0 }; foreach ($drive in $drives) { $xamppPath = Join-Path -Path $drive.Root -ChildPath 'xampp'; if (Test-Path $xamppPath) { $xamppPath } }"`) do (
    set "xamppPath=%%I"
)

:: Check if XAMPP was found
if not defined xamppPath (
    echo XAMPP not found on this system.
    exit /b
)

:: Navigate to XAMPP MySQL bin directory
cd /d "%xamppPath%\mysql\bin"

:: Create the database using MySQL command
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS shootingClub;"

:: Navigate back to the root directory
cd /d "%~dp0"

:: Copy .env.example to .env
php -r "copy('.env.example', '.env');"

:: Install dependencies using Composer
@REM call composer install

:: Run database migrations and seed
@REM call php artisan migrate:fresh --seed

:: Generate application key
@REM call php artisan key:generate

:: Open current directory in Visual Studio Code
code .

:: End of script