@echo off


:: File / folder chooser dialog from a Windows batch script
:: https://stackoverflow.com/a/15885133
echo Please select the folder of MASM32
set openFolderDialogCommand="(new-object -COM 'Shell.Application').BrowseForFolder(0,'Please select the folder of MASM32.',0,0).self.path"
for /f "usebackq delims=" %%I in (`powershell %openFolderDialogCommand%`) do set "folder=%%I"


setlocal enabledelayedexpansion
echo Set user enviroment variable: %%MASM32%%=!folder!
setx MASM32 "!folder!"
echo Please RESTART Visual Studio 2019 and rebuild the projects, thank you.
endlocal

pause
