# Windows PowerShell Toolkit for Swordfish
The PowerShell Toolkit for Swordfish provides a basic framework for querying resources from the [SNIA API Emulator](https://github.com/SNIA/Swordfish-API-Emulator). 

The SNIASwordfish PowerShell Module can be used with Microsoft Windows, Windows Server, macOS or Linux. Below is an example of a connected Swordfish target being used with macOS and PowerShell for Linux (v6.1). 

![SNIASwordfish Example with PowerShell for Linux](https://github.com/SNIA/Swordfish-Powershell-Toolkit/blob/master/SNIASwordfish_pwsh.png)

## Contributors
* Chris Lionetti, HPE
* Barkz, Pure Storage, Inc.

## Feedback
If there is any feedback please use [Issues](https://github.com/SNIA/Swordfish-Powershell-Toolkit/issues) for tracking.

## Deployment Steps
1. Create a directory named SNIASwordfish in C:\Program Files\WindowsPowerShell\Modules\ 
2. Then import the module:
```powershell
PS:> Import-Module SNIASwordfish.psm1
```
3. Check to make sure the module has been loaded:
```powershell
PS:> Get-Module -Name SNIASwordfish
```
4. Once the module has been loaded a connect to a Swordfish Target using:
```powershell
Connect-SwordfishTarget -target 192.168.1.100
-or-
Connect-RedfishTarget -target 192.168.1.100

5. If your storage device requires an Autorization token, you can use the following command to obtain or populate this token. Once this token has been gathered, all further commands will attempt to use the token by default in the rest method header. 
Get-SwordfishSessionToken -target 192.168.1.100 -protocol https -Username chris -password P@ssw0rd!
Get-RedfishSessionToken   -target 192.168.1.100 -protocol https -Username chris -password P@ssw0rd!
```
This command will set the various global variables that other commands need to operate
```powershell
PS:> Connect-SwordfishTarget -Target 192.168.1.100
```
5. Once a connection has been made, you can issue other commands such as:
```powershell
Get-SwordfishStorageService
```
6. To view a complete list of commands, use the following:
```powershell
PS:> Get-Command -module SNIASwordfish
```
7. Documented help is available, use the following:
```powershell
PS:> Get-Help Get-SwordfishStorageService -Full
```
8. This module follows the PowerShell Verb/Noun model. Naming scheme is as follows:
```powershell
<Verb>-Swordfish<Noun>
```
All of the verbs are well known verbs and match the RestAPI CRUD (Create, Read, Update, Delete) to the standard Get-Set-New-Remove well known PowerShell verbs. To see a list of all the Verbs use the following:
```powershell
PS:> Get-Verb
```
In each case, the Swordfish Noun refers to a Folder that has been made singular. i.e. StorageServices --> StorageService
The Swordfish PowerShell module works with collections of objects. When you make a request for something like Storage Services, the commands will return an array of objects that represent each storage service. In these cases, you can limit the return to a specific storage service by specifying the storage service name to be returned:
```powershell
PS:> Get-SwordfishStorageService -StorageServiceID 1
```
9. To get subordinate information about an object, i.e to return information such as the power metrics for a chassis, additional commands have been added. The extra commands for this deeper information follow the naming scheme:
```<original_command><DetailNoun>```
An example of this would be the Power or Thermal metrics gathered by the Chassis object. These each have three detailed objects (metrics) under each of these detailed nouns; i.e. Power has as metrics <PowerControl>,<PowerSupplies>, and <Voltages>. So the command for this would appear as such:
```powershell
  PS:> Get-SwordfishChassisPower -MetricName Voltages
``` 
The current list of supported cmdlets are:
```powershell
Connect-RedfishTarget                              
Get-RedfishByURL                                   
Get-RedfishChassis                                 
Get-RedfishChassisPower -MetricName {PowerControl,Voltages,PowerSupplies}                          
Get-RedfishChassisThermal -MetricName {Temperatures,Fans,Redundancy}                        
Get-RedfishController                              
Get-RedfishDrive                                   
Get-RedfishManager                                 
Get-RedfishManagerComponent                        
Get-RedfishSession                                 
Get-RedfishSessionService                          
Get-RedfishSessionToken                            
Get-RedfishStorage                                 
Get-RedfishSystem                                  
Get-RedfishSystemComponent -SubComponent {Bios,Boot,EthernetInterfaces,LogServices,Memory,MemoryDomains,NetworkInterfaces,Processors,SecureBoot,Storage,TrustedModules)                        
Get-RedfishTask                                    
Get-RedfishTaskService                             
Get-RedfishVolume                                  
Clear-RedfishSystemLogEntries                      
Get-RedfishSystemLogEntries                        
Set-RedfishManager -CommandShellServiceEnabled =DateTimeLocalOffset -AutoDSTEnabled -DateTime -TimeZoneName -GraphicConsoleServiceEnabled -SerialConsoleServiceEnabled -LocationIndicatorActive -ServiceIndication
Set-RedfishTaskService -ServiceEnabled -TaskAutoDeleteTimeoutMinutes
Get-RedfishCertificateService
Get-RedfishCertificate

Connect-SwordfishTarget                            
Get-SwordfishByURL                                 
Get-SwordfishChassis                               
Get-SwordfishChassisPower -MetricName {PowerControl,Voltages,PowerSupplies}                          
Get-SwordfishChassisThermal -MetricName {Temperatures,Fans,Redundancy}                         
Get-SwordfishClassesOfService                      
Get-SwordfishConnection                            
Get-SwordfishController                            
Get-SwordfishDataStorageLinesOfService             
Get-SwordfishDataStorageLoSCapabilities            
Get-SwordfishDrive                                 
Get-SwordfishEndpoint                              
Get-SwordfishFabric                                
Get-SwordfishGroup                                 
Get-SwordfishIOConnectivityLoSCapabilities         
Get-SwordfishManager                               
Get-SwordfishManagerComponent                      
Get-SwordfishODataTypeName                         
Get-SwordfishPool                                  
Get-SwordfishSession                               
Get-SwordfishSessionService                        
Get-SwordfishSessionToken                          
Get-SwordfishStorage                               
Get-SwordfishStorageServices                       
Get-SwordfishSystem                                
Get-SwordfishSystemComponent -SubComponent {Bios,Boot,EthernetInterfaces,LogServices,Memory,MemoryDomains,NetworkInterfaces,Processors,SecureBoot,Storage,TrustedModules)                                
Get-SwordfishTask                                  
Get-SwordfishTaskService                           
Get-SwordfishURIFolderByFolder                     
Get-SwordfishVolume                                
Get-SwordfishZone                                  
Get-SwordfishCertificate
Get-SwordfishCertificateService
Invoke-RedfishSystemReset                          
```
### Alternate Swordfish Targets

The Swordfish PowerShell toolkit is designed to be used primarily against an actual Swordfish Implementation, however it works equally well against the SNIA Swordfish Emulator located at the following location https://github.com/SNIA/Swordfish-API-Emulator. To use the Swordfish PowerShell toolkit module, configure the API Emulator according to the instructions on the Github site.
To connect the Swordfish PowerShell Toolkit to either a Swordfish Implementation or the API Emulator use the command Connect-SwordfishTarget to the IP address that represents that target. See 
```powershell 
Get-Help Connect-SwordfishTarget
```
