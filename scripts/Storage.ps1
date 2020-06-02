function Get-SwordFishStorage{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Systems from the SwordFish Target.
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
    http://redfish.dmtf.org/schemas/swordfish/v1/StorageSystem.v1_2_0.json
#>   
[CmdletBinding()]
    param(
        [string]    $StorageID,
        [boolean]   $ReturnCollectionOnly   =   $False
    )
    process{
        $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
        write-verbose "Folder = $StorageUri"
        $StorageData = invoke-restmethod2 -uri $StorageUri
        # Now must find if this contains links or directly goes to members. 
        $StorageSystems = (($StorageData).Links).Members + ($StorageData).Members
        $StorageSysCol=@()  
        foreach($StorageSys in $StorageSystems)
            {   # This seperates out the name of each controller so that I can compair it to the passed StorageID if specified
                $MyStorageSysObj    = $StorageSys.'@odata.id'
                $MyStorageSysArray  = $MyStorageSysObj.split('/')
                $MyStorageSysName   = $MyStorageSysArray[ ($MyStorageSysArray.length -1) ]
                if ( ( $MyStorageSysName -like $StorageID ) -or ( -not $StorageID ) )
                    {   $MyStorageSysData   =   invoke-restmethod2 -uri ( $base + $MyStorageSysObj )
                        $StorageSysCol      +=  $MyStorageSysData 
                        $ReturnColl         =   $StorageData
                    } 
            }
        if ( $ReturnCollectionOnly )
            {   return $ReturnColl
            } else 
            {   return $StorageSysCol
            }        
    }
}
