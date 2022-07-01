function Invoke-RedfishLabTests
{   
    param(  [Parameter(Mandatory=$True)]
            [ValidateSet('HPE','Dell','Lenovo','Cisco','Intel')]    [string]    $Vendor      
         )
    process
    {   write-host "This command will run the complete list of tests against the defined Device."
        . .\LabConnect.ps1
        . .\LabSystem.ps1
        . .\LabChassis.ps1
        . .\LabDrive.ps1
        . .\LabSession.ps1
        . .\LabStorage.ps1
        Write-host "Connecting to Host $Vendor"        
        Connect-RedfishLabServer -Vendor $Vendor -WriteExampleFile
        
        write-host "Geting Redfish Lab Systems"
        Get-RedfishLabSystem -WriteExampleFile
        Get-RedfishLabSystem -WriteExampleFile -ReturnCollectionOnly
        
        write-host "Geting Redfish Lab Systems Subcomponents"
        Get-RedfishLabSystemComponent -SubComponent 'Bios' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'EthernetInterfaces' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'LogServices' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'Memory' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'MemoryDomains' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'NetworkInterfaces' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'Processors' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'SecureBoot' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'Storage' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'TrustedModules' -WriteExampleFile
        Get-RedfishLabSystemComponent -SubComponent 'Bios' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'EthernetInterfaces' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'LogServices' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'Memory' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'MemoryDomains' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'NetworkInterfaces' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'Processors' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'SecureBoot' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'Storage' -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabSystemComponent -SubComponent 'TrustedModules' -WriteExampleFile -ReturnCollectionOnly   

        write-host "Getting Redfish Drives"
        Get-RedfishLabDrive -WriteExampleFile
        Get-RedfishLabDrive -WriteExampleFile -ReturnCollectionOnly

        write-host "Getting Redfish Chassis"
        Get-RedfishLabChassis -WriteExampleFile
        Get-RedfishLabChassis -WriteExampleFile -ReturnCollectionOnly
        Get-RedfishLabChassisThermal -MetricName ALL -WriteExampleFile
        Get-RedfishLabChassisThermal -MetricName Fans -WriteExampleFile
        Get-RedfishLabChassisThermal -MetricName Temperatures -WriteExampleFile
        Get-RedfishLabChassisThermal -MetricName Redundancy -WriteExampleFile
        Get-RedfishLabChassisPower -MetricName All -WriteExampleFile
        Get-RedfishLabChassisPower -MetricName PowerControl -WriteExampleFile
        Get-RedfishLabChassisPower -MetricName PowerSupplies -WriteExampleFile
        Get-RedfishLabChassisPower -MetricName Voltages -WriteExampleFile
        
        write-host "Getting Redfish Session"
        Get-RedfishLabSession -WriteExampleFile
        Get-RedfishLabSession -WriteExampleFile -ReturnCollectionOnly

        write-host "Getting Redfish Tasks"
        Get-RedfishLabTaskService -WriteExampleFile
        Get-RedfishLabTask -WriteExampleFile
        Get-RedfishLabTask -WriteExampleFile -ReturnCollectionOnly

        write-host "Getting Redfish Manager"
        Get-RedfishLabManager -WriteExampleFile
        Get-RedfishLabManager -WriteExampleFile -ReturnCollectionOnly

        write-host "Getting Redfish Storage"
        Get-RedfishLabStorage -WriteExampleFile
        Get-RedfishLabStorage -WriteExampleFile -ReturnCollectionOnly
        
    }

}
