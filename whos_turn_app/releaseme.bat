@echo off
setlocal

:: Always run from the script's own directory, regardless of where it's called from
cd /d "%~dp0"

set APK_SRC=build\app\outputs\flutter-apk\app-release.apk
set APK_DST=release\app-release.apk

echo [1/2] Building Android release APK...
call flutter build apk --release

:: Check the APK was actually produced rather than relying on exit code,
:: as flutter.bat can return non-zero even on a successful build on Windows
if not exist "%APK_SRC%" (
    echo.
    echo ERROR: Build failed - APK not found at %APK_SRC%
    exit /b 1
)

echo.
echo [2/2] Copying APK to release\...
if not exist release mkdir release
copy /y "%APK_SRC%" "%APK_DST%" >nul
if errorlevel 1 (
    echo ERROR: Copy failed.
    exit /b 1
)

echo.
echo Done! APK available at: %~dp0%APK_DST%
endlocal
