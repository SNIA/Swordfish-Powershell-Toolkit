This folder contains all of the commands used to test commands against the various machines
in the SNIA Storage Management Labs. To run these tests, it is required that you be VPN'ed
into the SNIA labs as these machines are not available to the outside world. 
Alternately if you wish to test your own machines using these scripts; you may edit the LabConnect.PS1
to add a new machine in the Switch section of the code. You will need to know the IP Address to the machine
as well as a description and the username and password for your Redfish implementation.

Steps to run these tests;
1. First you will need to Import the master SNIASwordfish Module as these commands require them.
<code> CD SNIASwordfish
       Import-Module .\SNIASwordfish.psd1 -force
</code>
2. Then you will need to bring the added test functions into your powershell session
<code> Cd Tests
       . .\LabConnect.ps1
</code>
3. You will then want to connect to the machine to be tested. This command will issue both
the Connect-RedfishTarget command, as well as the Get-RedfishSessionToken command. Run this 
command with only the vendor argument defined the first time as this will give you screen output 
in case of any errors
<code> Connect-RedfishLabServer -Vendor HPE
</code>
4. Once you are able to see successful output, you can rerun the command with the -WriteExampleFile which will write the output of each command to both a RAW text file, as well as a JSON version. 
<code> Connect-RedfishLabServer -Vendor HPE -WriteExampleFile
</code>
The output files will be located in the folder /SNIASwordfish/Examples/ and will be named after the command that
is being tested along with possible options and values for the options and finally the machine identifier. Examples of a output file name is listed below
<code> Connect-RedfishTarget.Example.HPE.txt and Connect-RedfishTarget.Example.HPE.json
</code>
If you choose to run a command using the extra parameter -returncollection only then the output or example file will reflect that in both the name of the file and the content. If no file is created when a command is run, that would indicate that the underlying command did not return a valid response.
To run additional commands such as the chassis commands you will need to load the chassis PS1 file
<code> . .\LabChassis
</code>
And a quick look at the code will show you that three test functions exist in this file, the Get-RedfishLabChassis, Get-RedfishLabChassisThermal, and the Get-RedfishLabChassisPower commands.
Each of these may have functions that allow you to excersie the options of the underlying commands, and each run will generate a new Example file which includes the name of the option used.
A Complete list of the test functions is shows below;

- LabConnect.ps1
    - Connect-RedfishLabServer -Vendor {Hpe, Dell, Cisco, Lenovo, Intel}
- LabChassis.ps1
    - Get-RedfishLabChassis (-ReturnCollectionOnly)
    - Get-RedfishLabChassisPower -MetricName {PowerSupplies,PowerControl,Voltages} (-ReturnCollectionOnly)
- LabDrive.ps1
    - Get-RedfishLabDrive (-ReturnCollectionOnly)
- LabSystem.ps1
    - Get-RedfishLabSystem (-ReturnCollectionOnly)
    - Get-RedfishLabSystemComponent -SubComponent {Bios, Boot, EthernetInterfaces, LogServices, Memory, MemoryDomains, NetworkInterfaces, Processors, SecureBoot, Storage', TrustedModules} (-ReturnCollectionOnly)
