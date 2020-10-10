function Get-SwordfishSystem{
<#
.SYNOPSIS
    Retrieve The list of valid Computer Systems from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of System objects that exist or if a single 
    System is selected, it will return only the single System ID.
.PARAMETER ComputerSystemID
    The Computer System ID name for a specific System, otherwise the command
    will return all Computer Systems.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishSystem 

    @odata.context     : /redfish/v1/$metadata#ComputerSystem.ComputerSystem
    @odata.id          : /redfish/v1/ComputerSystem/00C0FF5038E8
    @odata.type        : #ComputerSystem.v1_6_0.ComputerSystem
    Id                 : 00C0FF5038E8
    Name               : Uninitialized Name
    Manufacturer       : HPE
    SerialNumber       : 00C0FF5038E8
    Status             : @{Health=OK}
    EthernetInterfaces : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces}
    Storage            : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/Storage}
    Links              : @{Chassis=System.Object[]; Endpoints=System.Object[]}

.EXAMPLE
    PS:> Get-SwordfishSystem -SystemId 00C0FF5038E8
    
    { Output Identical to example 1}
.EXAMPLE
    Get-SwordfishSystem -ReturnCollectionOnly $true

    @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
    @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
    @odata.id           : /redfish/v1/ComputerSystem
    Name                : ComputerSystem Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8}}

.EXAMPLE
    PS:> Get-SwordfishSystem -ReturnCollectionOnly $True | ConvertTo-Json
    
    {   "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.type":  "#StorageCollection.StorageCollection",
        "@odata.id":  "/redfish/v1/Storage",
        "Name":  "Storage System Collection",
        "Members":  [
                        {
                            "@odata.id":  "/redfish/v1/Storage/AC-109032"
                        }
                    ]
    }
.LINK
    https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
.VERSION 1.13.0
#>   
<#PSScriptInfo
.VERSION 1.13.0
#>
[CmdletBinding()]
param(  [string]    $SystemID,
        [switch]    $ReturnCollectionOnly
     )
process{
    $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems")
    $SysCollection=@()
    foreach($Sys in ($SystemData).Members )
        {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') )  
        }
    if ( $ReturnCollectionOnly )
        {   return $SystemData
        } else 
        {   if ( $SystemID )
                {   return ( $SysCollection | where-object { $_.id -eq $SystemId } )
                } else 
                {   return ( $SysCollection )                    
}}      }       }