@echo off
cd %~dp0
echo ****************************STEP6: Export OVA****************************
"C:\Program Files\VMware\VMware OVF Tool\ovftool.exe" --noSSLVerify --overwrite --powerOffSource vi://asdf:asdf@10.117.160.100/nanw/host/core/Resources/PhotonWithConnector %~dp0/PhotonWithConnector.ova
echo Export completed!

echo ****************************STEP7: Upload To S3****************************
"C:\Program Files\nodejs\node" %~dp0\..\..\tools\scripts\uploadFiles2Dev.js %~dp0PhotonWithConnector.ova launchpad-dev-resource Photon-with-connector
pause

echo ****************************STEP8: upload to 170****************************
ren PhotonWithConnector.ova ElpConnector.ova
set HOST=10.117.140.170
ftp -s:ftpcmd.txt %HOST%