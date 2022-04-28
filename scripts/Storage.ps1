function Get-SwordfishStorage
{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Systems from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Storage System objects that exist or if a single 
    Storage System is selected, it will return only the single Storage System ID.
.PARAMETER StorageID
    The Storage System ID name for a specific Storage System, otherwise the command
    will return all Storage Systems.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordfishStorage

    @odata.Copyright   : Copyright 2020 HPE and DMTF
    @odata.type        : #Storage.v1_8_0.System
    @odata.id          : /redfish/v1/Storage/AC-109032
    Name               : cs700
    Id                 : 092b4bd8361b856bbc000000000000000000000001
    Description        :
    Status             : @{State=Enabled; Health=OK}
    Chassis            : /redfish/v1/Chassis/AC-109032
    Endpoints          : /redfish/v1/Fabrics/AC-109032/Endpoints
    Connections        : /redfish/v1/Fabrics/AC-109032/Connections
    Zones              : /redfish/v1/Fabrics/AC-109032/Zones
    Drives             : /redfish/v1/Storage/AC-109032/Drives
    ConsistencyGroups  : /redfish/v1/Storage/AC-109032/ConsistencyGroups
    StoragePools       : /redfish/v1/Storage/AC-109032/StoragePools
    StorageControllers : /redfish/v1/Storage/AC-109032/StorageControllers
    Volumes            : /redfish/v1/Storage/AC-109032/Volumes
    LineOfService      : /redfish/v1/Storage/AC-109032/LineOfService

.EXAMPLE
    PS:> Get-SwordfishStorage -StorageId AC-102345

    { Output Identical to example 1}
.EXAMPLE
    PS:> Get-SwordfishStorage -ReturnCollectionOnly $True

    @odata.Copyright : Copyright 2020 HPE and DMTF
    @odata.type      : #StorageCollection.StorageCollection
    @odata.id        : /redfish/v1/Storage
    Name             : Storage System Collection
    Members          : {@{@odata.id=/redfish/v1/Storage/AC-109032}}
.EXAMPLE
    PS:> Get-SwordfishStorage -ReturnCollectionOnly $True | ConvertTo-Json

    {
        "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
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
    http://redfish.dmtf.org/schemas/Swordfish/v1/StorageSystem.v1_2_0.json
#>   
[CmdletBinding()]
param(  [string]    $StorageID,
        [switch]    $ReturnCollectionOnly
     )
process{
    $ReturnColl = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Storage")
    $StorageSystems = (($ReturnColl).Links).Members + ($ReturnColl).Members     # Now must find if this contains links or directly goes to members. 
    foreach($StorageSys in $StorageSystems)
        {   [array]$StorageSysCol +=  invoke-restmethod2 -uri ( $base + ( $StorageSys.'@odata.id' ) ) 
        }
    if ( $ReturnCollectionOnly )
        {   return $ReturnColl
        } else 
        {   if ( $StorageID ) 
                {   return ( $StorageSysCol | where-object {$_.id -like $StorageID } )
                } else 
                {   return $StorageSysCol                    
                }
        }        
}
}
Set-Alias -Value 'Get-SwordfishStorage' -Name 'Get-RedfishStorage'

function Get-SwordfishStorageServices
{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Systems from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Storage System objects that exist or if a single 
    Storage System is selected, it will return only the single Storage System ID.
.PARAMETER StorageID
    The Storage System ID name for a specific Storage System, otherwise the command
    will return all Storage Systems.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordfishStorage

    @odata.Copyright   : Copyright 2020 HPE and DMTF
    @odata.type        : #Storage.v1_8_0.System
    @odata.id          : /redfish/v1/Storage/AC-109032
    Name               : cs700
    Id                 : 092b4bd8361b856bbc000000000000000000000001
    Description        :
    Status             : @{State=Enabled; Health=OK}
    Chassis            : /redfish/v1/Chassis/AC-109032
    Endpoints          : /redfish/v1/Fabrics/AC-109032/Endpoints
    Connections        : /redfish/v1/Fabrics/AC-109032/Connections
    Zones              : /redfish/v1/Fabrics/AC-109032/Zones
    Drives             : /redfish/v1/Storage/AC-109032/Drives
    ConsistencyGroups  : /redfish/v1/Storage/AC-109032/ConsistencyGroups
    StoragePools       : /redfish/v1/Storage/AC-109032/StoragePools
    StorageControllers : /redfish/v1/Storage/AC-109032/StorageControllers
    Volumes            : /redfish/v1/Storage/AC-109032/Volumes
    LineOfService      : /redfish/v1/Storage/AC-109032/LineOfService

.EXAMPLE
    PS:> Get-SwordfishStorage -StorageId AC-102345

    { Output Identical to example 1}
.EXAMPLE
    PS:> Get-SwordfishStorage -ReturnCollectionOnly $True

    @odata.Copyright : Copyright 2020 HPE and DMTF
    @odata.type      : #StorageCollection.StorageCollection
    @odata.id        : /redfish/v1/Storage
    Name             : Storage System Collection
    Members          : {@{@odata.id=/redfish/v1/Storage/AC-109032}}
.EXAMPLE
    PS:> Get-SwordfishStorage -ReturnCollectionOnly $True | ConvertTo-Json
    
    {
        "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
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
    http://redfish.dmtf.org/schemas/Swordfish/v1/StorageSystem.v1_2_0.json
#>   
[CmdletBinding()]
param(  [string]    $StorageID,
        [switch]    $ReturnCollectionOnly
     )
process{
    $ReturnColl = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "StorageServices" )
    $StorageSystems = (($ReturnColl).Links).Members + ($ReturnColl).Members
    foreach($StorageSys in $StorageSystems)
        {   [array]$StorageSysCol += invoke-restmethod2 -uri ( $base + ( $StorageSys.'@odata.id' ) ) 
        } 
    if ( $ReturnCollectionOnly )
        {   return $ReturnColl
        } else 
        {   if ( $StorageID )
                {   return ( $StorageSysCol | where-object { $_.id -like $StorageID } )
                } else 
                {   return $StorageSysCol
                }
        }        
}
}