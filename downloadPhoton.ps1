echo 'Start download Photon ova...'
$ovaName=((Select-String $pwd\input.txt -pattern "ovaName").Line-Split "=")[1]
$curDir="$pwd\download\$ovaName"
$ovaURL=((Select-String $pwd\input.txt -pattern "ovaDLURL").Line-Split "=")[1]
$client=new-object System.Net.WebClient
$client.DownloadFile($ovaURL, $curDir)
