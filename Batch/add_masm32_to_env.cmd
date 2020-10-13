:: File / folder chooser dialog from a Windows batch script
:: https://stackoverflow.com/a/15885133

@echo off
setlocal

echo Please select the folder of MASM32

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please select the folder of MASM32.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
echo.
echo Set user enviroment variable: %%MASM32%%=!folder!
setx MASM32 "!folder!"
echo.
echo Please close Visual Studio 2019 and rerun the projects, thank you.
echo.
endlocal

pause
