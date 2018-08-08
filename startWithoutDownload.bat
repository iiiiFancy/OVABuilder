@echo off
cd %~dp0
echo ****************************STEP1: Download Photon OVA****************************

echo Download skipped

echo ****************************STEP2: Deploy Photon VM instance****************************
for /f "tokens=2 delims==" %%i in ('findstr ovftoolPath input.txt') do (set ovftoolPath=%%i)
for /f "tokens=2 delims==" %%i in ('findstr datastore input.txt') do (set datastore=%%i)
for /f "tokens=2 delims==" %%i in ('findstr vmName input.txt') do (set vmName=%%i)
for /f "tokens=2 delims==" %%i in ('findstr sourceNET input.txt') do (set sourceNET=%%i)
for /f "tokens=2 delims==" %%i in ('findstr targetNET input.txt') do (set targetNET=%%i)
for /f "tokens=2 delims==" %%i in ('findstr ovaPath input.txt') do (set ovaPath=%%i)
for /f "tokens=2 delims==" %%i in ('findstr userName input.txt') do (set userName=%%i)
for /f "tokens=2 delims==" %%i in ('findstr userPassword input.txt') do (set userPassword=%%i)
for /f "tokens=2 delims==" %%i in ('findstr VcenterIP input.txt') do (set VcenterIP=%%i)
for /f "tokens=2 delims==" %%i in ('findstr hostIP input.txt') do (set hostIP=%%i)

set VI_BASE=vi://%userName%:%userPassword%@%VcenterIP%
set sourcePath=%VI_BASE%/nanw/host/core/Resources/%vmName%

set command=-ds=%datastore% -n=%vmName% --net:%sourceNET%=%targetNET% %ovaPath% %VI_BASE%/?ip=%hostIP%

echo ****************************EXTRA STEP: Poweroff and delete existing VM: PhotonWithConnector if exists****************************
"%ovftoolPath%" --quiet --powerOffSource --acceptAllEulas %sourcePath%

echo Command generated: %command%
"%ovftoolPath%" --overwrite --acceptAllEulas --powerOn %command%
echo Deploy completed

echo ****************************STEP3: Copy connector source code****************************
del /S /Q download\connector.zip 2>nul
md download 2>nul
call %~dp0..\..\connector\clean.bat

echo ****************************STEP4: Prepare codes upload to Photon****************************
%~dp0/dos2unix-7.4.0-win64/bin/dos2unix.exe -o setupAutorun.txt
%~dp0/dos2unix-7.4.0-win64/bin/dos2unix.exe -o setupPhoton.sh
%~dp0/dos2unix-7.4.0-win64/bin/dos2unix.exe -o ..\..\connector\launch-impl.sh
%~dp0/dos2unix-7.4.0-win64/bin/dos2unix.exe -o ..\..\connector\launch.sh
7z a %~dp0download\connector.zip %~dp0..\..\connector 

echo Please login VM and change initial password, implement next step (setup Photon VM) while VM is turn on. And check the path of VM generated on Vcenter for export ova use
echo ****************************Wait 1min for VM powering on****************************
ping 127.1 -n 60 > nul

echo ****************************STEP5: Setup Photon VM****************************
node setupPhoton.js poweroff

ping 127.1 -n 60 > nul

echo **************STEP6: Export OVA**************

"%ovftoolPath%" --noSSLVerify --overwrite --powerOffSource %sourcePath% %~dp0ElpConnector.ova
echo Export to: %~dp0ElpConnector.ova

echo **************STEP7: Cleanup**************
del /S /Q download\connector.zip 2>nul
del /S /Q %~dp0.localStorage 2>nul
pause