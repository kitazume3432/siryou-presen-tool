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

git add -A

set "MSG="
set /p MSG="Commit message (leave blank and press Enter for default): "
if "%MSG%"=="" set "MSG=update"

git commit -m "%MSG%"
if errorlevel 1 (
  echo.
  echo No changes found, or commit failed.
  echo Did you forget to overwrite index.html with the new version?
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
echo In a few minutes, it will be live at:
echo https://kitazume3432.github.io/siryou-presen-tool/
echo.
pause
popd
