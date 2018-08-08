This is a self-contained script to build an ova file of Photon OS with euc launchpad connector on it. Click start.bat to begin.
Input: input.txt and config.js
Output: a VM with Photon OS and launchpad connector source code (auto run on port 8003 after startup) on Vcenter, and its ova file downloaded

Requirement: It requires nodejs, VMware ovftool and authority to access euc_launchpad git repo (ssh://git@git.eng.vmware.com/euc_cst/euclaunchpad.git). And easyvc module which is in node_modules folder. It contains a package.json file.

How To Use: You need to offer information in input.txt (input after '=', script recognize variable name before '=' and take whatever after as value) as well as in config.js. By click start.bat, the script will do following steps:

1.	Download Photon OS ova file from %ovaURL% to download folder using windows power shell (call downloadPhoton.ps1)
2.	Deploy Photon VM on offerred vcenter and power on

****after sucessfully deploy, you need to login manually for the first time to change initail pass word 'changeme' to password you just wrote in config.js****

3.	Pull connector codes from EUC git to download folder
4.	Transfer related codes into Unix form and zip connector
5.	Run a nodejs script using easyvc send codes into our VM and run. This script will print ip address of VM instance we generate.
	i. connector.zip
	ii. setupPhoton.sh -- used to set up code and environment on Photon 
	iii. setupAutorun.txt -- file for 'crontab' command, set autorun after reboot

****Use incomplete command like: "%ovftoolPath%" --noSSLVerify --overwrite --powerOffSource vi://asdf:asdf@10.117.160.100/ to find your VM path following hints appear. And replace path in the last step of .bat file****

6.	shutdown VM and export ova file to current folder

Parameters (and examples) in input.txt
ovaDLURL=http://dl.bintray.com/vmware/photon/2.0/GA/ova/photon-custom-hw11-2.0-304b817.ova    URL for downloading ova (make sure your Vcenter supports hardware version of ova) 
ovaName=photon-custom-hw11-2.0-304b817.ova                                                    Name of your downloaded file
ovftoolPath=C:\Program Files\VMware\VMware OVF Tool\ovftool.exe                               Full path of ovftool.exe
datastore=datastore1                                                                          Choose the datastore to use
vmName=PhotonWithConnector                                                                    Set your VM instance name on Vcenter (make sure same as in config.js)
sourceNET=None                                                                                Source network for network mapping (original official ova uses "None")
targetNET="VM Network"                                                                        Target network for network mapping (then ova generated will have source network named "VM Network")
ovaPath=C:\Users\changf\Downloads\photon-custom-hw11-2.0-304b817.ova        	              Full path of your downloaded ova file on local disk            
userName=asdf										      Vcenter user name (make sure same as in config.js)
userPassword=asdf                                                                             Vcenter password (make sure same as in config.js)
VcenterIP=10.117.160.100                                                                      Vcenter IP address (make sure same as in config.js)
hostIP=10.117.160.96									      IP address of host (EXSi) to use

Other files:
DeployFromS3.bat: Contains only one command, using a ova of OS described above archived on Amazon S3 (https://s3.us-east-2.amazonaws.com/launchpad-dev-resource/Photon-with-connector/PhotonWithConnector.ova) to directly build a VM on Vcenter provided in input.txt (VM username:root, password:VMware123)

startWithoutDownload.bat: If you have everything ready in download directory. Click this to skip download steps. But make sure you use right file names.

===========following bat use hard-coded parameters===========

startForJenkins.bat: For Jenkins job 'CombinationTest' under Deploy-Wen to call remotely. Will create a Photon connector VM on Vcenter but no following steps. Baiclly same as start.bat. But download an original Photon OS but with changed password root/VMware123 on AWS S3 and directly copy connector codes from local codes on Jenkins node (VM name: Jenkins Win10 @ 10.117.162.24). Reboot VM to make connector work at last. All parameters are hard-coded. VMName=PhotonWithConnector.

buildOVAForJenkins.bat: For Jenkins job 'BuildPhotonWithConnector' under Deploy-Wen to call remotely. Search VM named 'PhotonWithConnector' on vcenter 10.117.160.100 and export its ova, upload to S3

downloadPhoton.ps1: Script to download photon ova from given URL in input.txt
downloadPhotonJ.ps1: Script for jenkins job to download photon ova from S3 (hard-coded)

setupAutoRun.txt: file to upload to Photon VM. Settings for crontab command in Photon. Make connector autotun after reboot

setupPhoton.js: script to communicate with VM, upload file and run them within VM. Target is wrote in config.js

setupPhoton.sh: file to upload to Photon VM. Install necessary packages and other settings

ftpcmd.txt: config for ftp protocal to transport OVA we built to webserver VM




