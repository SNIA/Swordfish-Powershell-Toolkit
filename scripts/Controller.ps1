function Get-SwordfishController
{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Controllers that make up the various Storage Systems from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Storage Controller objects that exist across all of the Storage Systems, unless a 
    specific Storage System ID is used to limit it, or a specific Storage Controller ID is directly requested. 
.PARAMETER StorageId
    The Storage System ID name for a specific Storage System, otherwise the command will return Storage Pool for all Storage Systems.
.PARAMETER ControllerId
    The StorageController ID name for a specific Storage Controller, otherwise the command will return all Storage Controllers.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordfishController

    @odata.Copyright   : Copyright 2020 HPE and DMTF
    @odata.type        : #Storage.v1_8_1.Storage
    @odata.id          : /redfish/v1/Storage/AC-109032/StorageControllers/AC-109032-A
    Name               : cs700-A
    Id                 : c32b4bd8361b856bbc000000000000000100000000
    MemberId           : A
    Model              : CS700
    PartNumber         : CS700-2G-36T-3200F
    Location           : Lionetti Rack
    SerialNumber       : AC-109032-C1
    Description        : Controller AC-109032 controller A
    Status             : @{State=StandbyOffline; Health=OK}
    Manufacturer       : HPE Nimble Storage
    FirmwareVersion    : 5.0.8.0-677726-opt
    SupportedRAIDTypes : RAID6TP
    Redundancy         : @{RedundancySet=System.Object[]; Status=OK; MaxNumSupported=2; MemberId=A; RedundancyEndabled=True; Mode=Failover; MinNumNeeded=1}

    @odata.Copyright   : Copyright 2020 HPE and DMTF
    @odata.type        : #Storage.v1_8_1.Storage
    @odata.id          : /redfish/v1/Storage/AC-109032/StorageControllers/AC-109032-B
    Name               : cs700-B
    Id                 : c32b4bd8361b856bbc000000000000000100000001
    MemberId           : B
    Model              : CS700
    PartNumber         : CS700-2G-36T-3200F
    Location           : Lionetti Rack
    SerialNumber       : AC-109032-C2
    Description        : Controller AC-109032 controller B
    Status             : @{State=Enabled; Health=OK}
    Manufacturer       : HPE Nimble Storage
    FirmwareVersion    : 5.0.8.0-677726-opt
    SupportedRAIDTypes : RAID6TP
    Redundancy         : @{RedundancySet=System.Object[]; Status=OK; MaxNumSupported=2; MemberId=B; RedundancyEndabled=True; Mode=Failover; MinNumNeeded=1}
    
.EXAMPLE
    Get-SwordfishController -ControllerId A | ConvertTo-Json

    {
        "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.type":  "#Storage.v1_8_1.Storage",
        "@odata.id":  "/redfish/v1/Storage/AC-109032/StorageControllers/AC-109032-A",
        "Name":  "cs700-A",
        "Id":  "c32b4bd8361b856bbc000000000000000100000000",
        "MemberId":  "A",
        "Model":  "CS700",
        "PartNumber":  "CS700-2G-36T-3200F",
        "Location":  "Lionetti Rack",
        "SerialNumber":  "AC-109032-C1",
        "Description":  "Controller AC-109032 controller A",
        "Status":  {
                       "State":  "StandbyOffline",
                       "Health":  "OK"
                   },
        "Manufacturer":  "HPE Nimble Storage",
        "FirmwareVersion":  "5.0.8.0-677726-opt",
        "SupportedRAIDTypes":  "RAID6TP",
        "Redundancy":  {
                           "RedundancySet":  [
                                                 "@{@odata.id=/redfish/v1/Storage/AC-109032/StorageControllers/A}",
                                                 "@{@odata.id=/redfish/v1/Storage/AC-109032/StorageControllers/B}"
                                             ],
                           "Status":  "OK",
                           "MaxNumSupported":  2,
                           "MemberId":  "A",
                           "RedundancyEndabled":  true,
                           "Mode":  "Failover",
                           "MinNumNeeded":  1
                       }
    }
.EXAMPLE
    Get-SwordfishPool -StorageID AC-109032 -ControllerID A 

    { The output of this command will look similar to example 2, since only a single pool is exposed. }
.EXAMPLE
    PS:> Get-SwordfishController -ReturnCollectionOnly $True
    
    @odata.Copyright : Copyright 2020 HPE and DMTF
    @odata.type      : #StorageControllerCollection.StorageControllerCollection
    @odata.id        : /redfish/v1/Storage/AC-109032/StorageControllers
    Name             : Storage System Collection
    Members          : {@{@odata.id=/redfish/v1/Storage/AC-109032/StorageControllers/A}, @{@odata.id=/redfish/v1/Storage/AC-109032/StorageControllers/B}}
.LINK
    http://redfish.dmtf.org/schemas/v1/Storage.v1_8_1.json
#>   
[CmdletBinding()]
    param(  [string]    $StorageId,
            [string]    $ControllerId,
            [boolean]   $ReturnCollectionOnly   =   $False
        )
    process{
        $MyControllersCol=@()
        $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
        write-verbose "Storage Folder = $StorageUri"
        $StorageData = invoke-restmethod2 -uri $StorageUri
        foreach( $StorageSys in ( $StorageData ).Members )
            {   $MyStorageSysURI = $Base + $StorageSys.'@odata.id' + '/StorageControllers'
                write-verbose "MyStorageSysURI = $MyStorageSysURI"
                #Gotta find my Array Name to see if it matches passed in filter
                $MyStorageSysObj   = $StorageSys.'@odata.id'
                $MyStorageSysArray = $MyStorageSysObj.split('/')
                $MyStorageSysName  = $MyStorageSysArray[ ($MyStorageSysArray.length -1) ]
                write-verbose "MyStorageSysName = $MyStorageSysName"
                if ( ($StorageId -like $MyStorageSysName) -or ( -not $StorageId ) )
                    {   $MyControllerCollection = invoke-restmethod2 -uri ( $MyStorageSysURI )
                        foreach( $MyController in ($MyControllerCollection.Members) )
                            {   #Gotta find my Controller name to see if it matches passed in filter
                                $MyControllerObj   = $MyController.'@odata.id'
                                $MyControllerArray = $MyControllerObj.split('/')
                                $MyControllerName  = $MyControllerArray[ ($MyControllerArray.length -1) ]
                                write-verbose "MyPoolName = $MyControllerName"
                                if ( ($ControllerId -like $MyControllerName) -or (-not $ControllerId) )
                                    {   $Controller = invoke-restmethod2 -uri ( $Base + $MyController.'@odata.id' )
                                        $MyControllersCol+=$Controller
                                        $ReturnColl = $MyControllerCollection
                                    }                                 
                            }
                    }
            }
        if ( $ReturnCollectionOnly )
            {   return $ReturnColl
            } else 
            {   return $MyControllersCol            
            }
    }
}
Set-Alias -name 'Get-RedfishController' -Value 'Get-SwordfishController'


