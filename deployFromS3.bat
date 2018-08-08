@echo off
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

set command=-ds=%datastore% -n=FromS3 --net:"VM Network"=%targetNET% https://s3.us-east-2.amazonaws.com/launchpad-dev-resource/Photon-with-connector/PhotonWithConnector.ova vi://%userName%:%userPassword%@%VcenterIP%/?ip=%hostIP%
echo Command generated: %command%

"%ovftoolPath%" --overwrite --acceptAllEulas --powerOn %command%
pause