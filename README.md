# Windows PowerShell Toolkit for Swordfish
The PowerShell Toolkit for Swordfish provides a basic framework for querying resources from the [SNIA API Emulator](https://github.com/SNIA/Swordfish-API-Emulator). 

The SNIASwordFish PowerShell Module can be used with Microsoft Windows, Windows Server, macOS or Linux. Below is an example of a connected SwordFish target being used with macOS and PowerShell for Linux (v6.1). 

![SNIASwordFish Example with PowerShell for Linux](https://github.com/SNIA/Swordfish-Powershell-Toolkit/blob/master/SNIASwordFish_pwsh.png)

## Contributors
* Chris Lionetti, HPE
* Barkz, Pure Storage, Inc.

## Feedback
If there is any feedback please use [Issues](https://github.com/SNIA/Swordfish-Powershell-Toolkit/issues) for tracking.

## Deployment Steps
1. Create a directory named SNIASwordFish in C:\Program Files\WindowsPowerShell\Modules\ 
2. Then import the module:
```powershell
PS:> Import-Module SNIASwordFish.psm1
```
3. Check to make sure the module has been loaded:
```powershell
PS:> Get-Module -Name SNIASwordFish
```
4. Once the module has been loaded a connect to a Swordfish Target using:
```powershell
Connect-SwordfishTarget -target 192.168.1.100 -protocol https

5. If your storage device requires an Autorization token, you can use the following command to obtain or populate this token. Once this token has been gathered, all further commands will attempt to use the token by default in the rest method header. 
Get-SwordfishSessionToken -target 192.168.1.100 -protocol https -Username chris -password P@ssw0rd!
```
This command will set the various global variables that other commands need to operate
```powershell
PS:> Connect-SwordFishTarget -Target 192.168.1.100
```
5. Once a connection has been made, you can issue other commands such as:
```powershell
Get-SwordFishStorageService
```
6. To view a complete list of commands, use the following:
```powershell
PS:> Get-Command -module SNIASwordFish
```
7. Documented help is available, use the following:
```powershell
PS:> Get-Help Get-SwordFishStorageService -Full
```
8. This module follows the PowerShell Verb/Noun model. Naming scheme is as follows:
```powershell
<Verb>-SwordFish<Noun>
```
All of the verbs are well known verbs and match the RestAPI CRUD (Create, Read, Update, Delete) to the standard Get-Set-New-Remove well known PowerShell verbs. To see a list of all the Verbs use the following:
```powershell
PS:> Get-Verb
```
In each case, the SwordFish Noun refers to a Folder that has been made singular. i.e. StorageServices --> StorageService
The Swordfish PowerShell module works with collections of objects. When you make a request for something like Storage Services, the commands will return an array of objects that represent each storage service. In these cases, you can limit the return to a specific storage service by specifying the storage service name to be returned:
```powershell
PS:> Get-SwordFishStorageService -StorageServiceID 1
```
9. To get subordinate information about an object, i.e to return information such as the power metrics for a chassis, additional commands have been added. The extra commands for this deeper information follow the naming scheme:
```<original_command><DetailNoun>```
An example of this would be the Power or Thermal metrics gathered by the Chassis object. These each have three detailed objects (metrics) under each of these detailed nouns; i.e. Power has as metrics <PowerControl>,<PowerSupplies>, and <Voltages>. So the command for this would appear as such:
```powershell
  PS:> Get-SwordFishChassisPower -MetricName Voltages
``` 
The current list of supported cmdlets are:
```powershell
Connect-SwordFishTarget
Connect-SwordFishMockup
Get-SwordfishSessionToken
Get-SwordFishChassis
Get-SwordFishChassisPower
Get-SwordFishChassisThermal
Get-SwordfishDrive
Get-SwordFishEndpoint
Get-SwordFishConnection
Get-SwordFishPool
Get-SwordFishStorage
Get-SwordFishVolume
```
### Alternate SwordFish Targets

The Swordfish PowerShell toolkit is designed to be used primarily against an actual Swordfish Implementation, however it works equally well against the SNIA SwordFish Emulator located at the following location https://github.com/SNIA/Swordfish-API-Emulator. To use the SwordFish PowerShell toolkit module, configure the API Emulator according to the instructions on the Github site.
To connect the SwordFish PowerShell Toolkit to either a Swordfish Implementation or the API Emulator use the command Connect-SwordFishTarget to the IP address that represents that target. See 
```powershell 
Get-Help Connect-SwordFishTarget
```

Since not all features may not be implemented against a specific vendors SwordFish Target, or even against the Swordfish API Emulator, an additional method of connection and test has been offered. A command called Connect-SwordfishMockup has been created that will connect directly to the swordfish mockup site http://swordfishmockups.com/redfish/v1. Once this connection command has been issued, all remaining commands such as Get-SwordFishChassis will be executed against the Mockup website. See 
```powershell 
Get-Help Connect-SwordFishMockup
```

I should note that there exists three cavaets with the use of the SwordFishMockup option; 
1. Two dependancies that must be met to use the Connect-SwordFishMockup command, These are that you need the PowerShell Module Selenium from the PSGallery to allow automation of a Chrome envrionment since the Mockup website requires Javascript compatibility. THe second dependancy is the requirement that the Chrome Browser be installed on the node running these commands to process the Javascript.
2. The commands output a significant amount of debug type information to the PowerShell windows that I have not been able to suppress yet. This debug information can render the returned data hard to read. The recommendation here is to always cast the returned object(s) from a command to a Variable and then view that variable which will be free of all the debug information. 
 i.e.  
 ```powershell
 PS:> $MyVar = Get-SwordfishChassis
 PS:> $MyVar | format-table id,name,chassistype,serialnumber

 Id     Name                    ChassisType SerialNumber
 --     ----                    ----------- ------------
 1      Computer System Chassis RackMount   2M220100SL
 1URack Computer System Chassis RackMount   556ST22255E
 1      Storage System Chassis  RackMount   XXXYYY
```
3. When using the SwordfishMockup site, the launching and rendering of the javascript to produce the final Swordfish code takes considerably more time that running directly against either a native SwordFish target or the Emulator

