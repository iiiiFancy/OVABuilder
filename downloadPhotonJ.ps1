echo 'Start download Photon ova...'
$ovaName="PhotonOnly.ova"
$curDir="$pwd\download\$ovaName"
$ovaURL="https://s3.us-east-2.amazonaws.com/launchpad-dev-resource/Photon-with-connector/PhotonOnly.ova"
$client=new-object System.Net.WebClient
$client.DownloadFile($ovaURL, $curDir)
