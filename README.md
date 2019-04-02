# Windows PowerShell Toolkit for Swordfish
The PowerShell Toolkit for Swordfish provides a basic framework for querying resources from the [SNIA API Emulator](https://github.com/SNIA/Swordfish-API-Emulator). 

## Contributors
* Chris Lionetti, HPE
* Barkz, Pure Storage, Inc.

Place this module in your module directory then use the import-module command to load the code;
PS:> Import-Module SNIASwordFish.psm1
Once the module has been loaded it should be pointed to a Swordfish Target using the connect-SwordfishTarget command, This command will set the various global variables that other commands need to operate;
PS:> Connect-SwordFishTarget -Target 192.168.1.100

Once a connection has been made, you can issue other commands such as Get-SwordFishStorageService
To obtain a complete list of commands, use the following command
PS:> Get-Command -module SNIASwordFish

To get help on a specific command, use the following command
PS:> Get-Help Get-SwordFishStorageService -Full

All commands in this module follow the naming scheme as follows;
<Verb>-SwordFish<Noun>
All of the verbs are well known verbs, and match the RestAPI CRUD (Create, Read, Update, Delete) to the standard Get-Set-New-Remove well known powershell verbs. 
  
In each case, the SwordFish Noun refers to a Folder that has been made singular. i.e. StorageServices --> StorageService
The toolkit works with collections of objects; when you make a request for something like Storage Services, the commands will return an array of objects that represent each storage service. In these cases, you can limit the return to a specific storage service by specifying the storage service name to be returned;
PS:> Get-SwordFishStorageService -StorageServiceID 1

To get subordinate information about an object, i.e to return information such as the power metrics for a chassis, additional commands have been added. The extra commands for this deeper information follow the naming scheme;
<original_command><DetailNoun>
An example of this would be the Power or Thermal metrics gathered by the Chassis object. These each has three detailed objects (metrics) under each of these detailed nouns; i.e. Power has as metrics <PowerControl>,<PowerSupplies>, and <Voltages>. So the command for this would appear as such;
PS:> Get-SwordFishChassisPower -MetricName Voltages
  
The current list of supported commands are as follows
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
