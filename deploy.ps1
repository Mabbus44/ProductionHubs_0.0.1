echo "Deploy started"

#Delete old temporary folder
if (test-path "c:\temp\ProductionHubs") {
	rm -r "c:\temp\ProductionHubs"
}

#Copy files to temporary folder
xcopy ".\*" "c:\temp\ProductionHubs\" /exclude:deployExcludes.txt /y /s

#Remove "Dev" from info file
(Get-Content "c:\temp\ProductionHubs\info.json") -replace 'ProductionHubsDev', 'ProductionHubs' | Out-File -Encoding ascii "c:\temp\ProductionHubs\info.json"

#Set "release" to true in globals file
(Get-Content "c:\temp\ProductionHubs\control\globals.lua") -replace 'prodHubs.release = false', 'prodHubs.release = true' | Out-File -Encoding ascii "c:\temp\ProductionHubs\control\globals.lua"

#Get version from info file
$infoJson = (Get-Content "c:\temp\ProductionHubs\info.json")
$infoJsonString = [string]::Join("`n", $infoJson)
$startPos = $infoJsonString.IndexOf('"version": "') + '"version": "'.Length
$fromVersion = $infoJsonString.substring($startPos,  $infoJsonString.Length - $startPos)
$endPos = $fromVersion.IndexOf('"')
$version = $fromVersion.substring(0,  $endPos)
$newName = "ProductionHubs_"+$version
$newNameFullPath = "c:\temp\" + $newName

#Remove old deploy folder
if (test-path $newNameFullPath){
	rm -r $newNameFullPath
}

#Rename temporary folder to correct version
Rename-Item -Path "c:\temp\ProductionHubs" -NewName $newName

#Done
echo "Deploy done"
cmd /k