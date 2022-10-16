@cd/d "%~dp0"
@Echo Off

:START
Set /P $InputPC="Inter PC name or IP: "

ping %$InputPC% -n 1 | find "TTL=" > nul
if errorlevel 1 (
	echo %$InputPC% is switch off or not exists
	goto START
)

:MENU
echo +++++++++++++++++%$InputPC%++++++++++++++++++++
echo 1. Shutdown PC
echo 2. Reset PC
echo 3. Change PC description
echo 4. User's profiles
echo 5. System info
echo 6. List of active users
echo 7. Local group and users console
echo 0. Exit
echo +++++++++++++++++++++++++++++++++++++++++++++++

set /p var="Your choice: "
if "%var%"=="1" goto P1
if "%var%"=="2" goto P2
if "%var%"=="3" goto P3
if "%var%"=="4" goto P4
if "%var%"=="5" goto P5
if "%var%"=="6" goto P6
if "%var%"=="7" goto P7
if "%var%"=="0" goto START
goto MENU

:P1
shutdown /f /s /m \\%$InputPC%
echo %$InputPC% will be switch off
start cmd.exe /C ping -t %$InputPC%
goto MENU

:P2
shutdown /f /r /m \\%$InputPC%
echo %$InputPC% will be reseted
start cmd.exe /C ping -t %$InputPC%
goto MENU

:P3
Set /P $InputDescr="Inter PC Description: "
echo %$InputDescr%
echo reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters /v srvcomment /t REG_SZ /d "%$InputDescr%" /f > C:\reg.bat
xcopy "C:\reg.bat" "\\%$InputPC%\C$"
wmic /node:"%$InputPC%" process call create "C:\reg.bat"
pause
del /f /q "C:\reg.bat"
del /f /q "\\%$InputPC%\C$\reg.bat"
echo reg file was deleted
pause
goto MENU

:P4
dir /D /B \\%$InputPC%\C$\Users
pause
goto MENU

:P5
systeminfo /S %$InputPC%
pause
goto MENU

:P6
quser /server:%$InputPC%
pause
goto MENU

:P7
lusrmgr.msc /computer=%$InputPC%
goto MENU
