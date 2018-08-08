@echo off
cd %~dp0
echo ****************************STEP1: Download Photon OVA****************************
call Powershell.exe -executionpolicy remotesigned -File  %~dp0/downloadPhotonJ.ps1
echo Download completed

echo ****************************STEP2: Deploy Photon VM instance****************************
set ovftoolPath=C:\Program Files\VMware\VMware OVF Tool\ovftool.exe
set datastore=datastore1
set vmName=PhotonWithConnector
set sourceNET="VM Network"
set targetNET="VM Network"
set ovaPath=%~dp0download\PhotonOnly.ova
set userName=asdf
set userPassword=asdf
set VcenterIP=10.117.160.100
set hostIP=10.117.160.96

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

"%ovftoolPath%" --noSSLVerify --overwrite --powerOffSource %sourcePath% %~dp0/%vmName%.ova
echo Export to: %~dp0%vmName%.ova

echo **************STEP7: Cleanup**************
del /S /Q download\connector.zip 2>nul
del /S /Q %~dp0.localStorage 2>nul
pause