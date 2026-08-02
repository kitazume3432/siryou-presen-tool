@echo off
pushd "%~dp0"
if errorlevel 1 (
  echo Failed to move to folder: %~dp0
  pause
  exit /b 1
)

echo ===============================================
echo   Update tool - pushing to GitHub
echo   Current folder: %cd%
echo ===============================================
echo.

REM --- Step 1: Find the newest .html file in the Downloads folder ---
set "DOWNLOADS=%USERPROFILE%\Downloads"
set "NEWEST="

for /f "delims=" %%F in ('dir /b /o-d /a-d "%DOWNLOADS%\*.html" 2^>nul') do (
  if not defined NEWEST set "NEWEST=%%F"
)

if not defined NEWEST (
  echo No .html file was found in: %DOWNLOADS%
  echo Skipping the overwrite step. Continuing with the files already in this folder.
  echo.
  goto :commitpush
)

echo Newest .html file found in Downloads folder:
echo   %NEWEST%
for %%A in ("%DOWNLOADS%\%NEWEST%") do echo   Last modified: %%~tA
echo.
echo This file can be used to overwrite index.html in this folder.
set /p CONFIRM="Overwrite index.html with this file? (Y = overwrite / N = skip and just commit current files): "
if /i "%CONFIRM%"=="Y" (
  copy /Y "%DOWNLOADS%\%NEWEST%" "index.html" >nul
  if errorlevel 1 (
    echo.
    echo [ERROR] Failed to copy the file into index.html.
    echo.
    pause
    popd
    exit /b 1
  )
  echo.
  echo index.html has been updated.
  echo.
) else (
  echo.
  echo Skipped overwriting index.html. Continuing with files already in this folder.
  echo.
)

:commitpush
REM --- Step 2: Commit and push to GitHub ---
git add -A

set "MSG="
set /p MSG="Commit message (leave blank and press Enter for default): "
if "%MSG%"=="" set "MSG=update"

git commit -m "%MSG%"
if errorlevel 1 (
  echo.
  echo No changes found, or commit failed.
  echo (This can happen if there was nothing new to save.)
  echo.
  pause
  popd
  exit /b 1
)

echo.
echo Uploading to GitHub...
git push
if errorlevel 1 (
  echo.
  echo [ERROR] Push failed. Please check your network connection and login status.
  echo.
  pause
  popd
  exit /b 1
)

echo.
echo Update completed successfully.
echo In a few minutes, your changes will be live on GitHub Pages.
echo.
pause
popd
