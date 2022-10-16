@cd/d "%~dp0"
@Echo Off

:START
Set /P $InputPC="Введите имя или IP ПК : "

ping %$InputPC% -n 1 | find "TTL=" > nul
if errorlevel 1 (
	echo %$InputPC% выключен или не существует
	goto START
)

:MENU
echo +++++++++++++++++%$InputPC%++++++++++++++++++++
echo 1. Выключить ПК
echo 2. Перезагрузить ПК
echo 3. Изменить описание ПК
echo 4. Вывести список всех профилей
echo 5. Показать сведения о системе
echo 6. Список активных пользователей
echo 7. Оснастка Локальные группы и пользователи
echo 0. Выход
echo +++++++++++++++++++++++++++++++++++++++++++++++

set /p var="Ваш выбор: "
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
echo %$InputPC% будет выключен
start cmd.exe /C ping -t %$InputPC%
goto MENU

:P2
shutdown /f /r /m \\%$InputPC%
echo %$InputPC% отправлен на перезагрузку
start cmd.exe /C ping -t %$InputPC%
goto MENU

:P3
Set /P $InputDescr="Введите описание (Description) ПК: "
echo %$InputDescr%
echo reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters /v srvcomment /t REG_SZ /d "%$InputDescr%" /f > C:\reg.bat
xcopy "C:\reg.bat" "\\%$InputPC%\C$"
wmic /node:"%$InputPC%" process call create "C:\reg.bat"
pause
del /f /q "C:\reg.bat"
del /f /q "\\%$InputPC%\C$\reg.bat"
echo reg файл был удален
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