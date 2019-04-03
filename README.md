# Windows PowerShell Toolkit for Swordfish
The PowerShell Toolkit for Swordfish provides a basic framework for querying resources from the [SNIA API Emulator](https://github.com/SNIA/Swordfish-API-Emulator). 

The SNIASwordFish PowerShell Module can be used with Microsoft Windows, Windows Server or Linux. Below is an example of a connected SwordFish target being used with Mac, PowerShell for Linux (v6.1). 

![SNIASwordFish Example with PowerShell for Linux](https://github.com/SNIA/Swordfish-Powershell-Toolkit/blob/barkz-patch-1/SNIASwordFish_pwsh.png)

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
Connect-SwordfishTarget
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
Get-SwordFishChassis
Get-SwordFishChassisPower
Get-SwordFishChassisThermal
Get-SwordFishClassOfService
Get-SwordFishClassOfServiceLineOfService
Get-SwordfishDrive
Get-SwordFishEndpoint
Get-SwordFishStorageGroup
Get-SwordFishStoragePool
Get-SwordFishStorageService
Get-SwordFishVolume
```
  
