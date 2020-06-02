function Get-SwordFishPool{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Pools from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Storagep Pool objects that exist across all of the Storage Systems, unless a 
    specific Storage System ID is used to limit it, or a specific StoragePool ID is directly requested. 
.PARAMETER StorageId
    The Storage System ID name for a specific Storage System, otherwise the command will return Storage Pool for all Storage Systems.
.PARAMETER PoolId
    The StoragePool ID name for a specific StoragePool, otherwise the command will return all Storage Pool.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordFishPool
    
    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Storage/AC-109032/StoragePools/default
    @odata.type        : #StoragePool.v1_3_1.StoragePool
    Id                 : 0a2b4bd8361b856bbc000000000000000000000001
    Name               : default
    Description        : Default pool
    CapacityInfo       : @{ConsumedBytes=3996069624926; AllocatedBytes=24716521871770}
    Status             : @{HealthRollUp=OK; Health=OK; State=Enabled}
    AllocatedVolumes   : {@{@odata.id=/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/Crypt-MovsOld},
                          @{@odata.id=/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/Crypt-Audio},
                          @{@odata.id=/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/V2},
                          @{@odata.id=/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SCSQL2017}...}
    CapacitySources    : {@{ProvidedCapacity=; ProvidingDrives=}}
    Compressed         : True
    Deduplicated       : True
    Encryption         : True
    SupportedRAIDTypes : RAID6TP
.EXAMPLE
    Get-SwordFishPool -StorageId AC-102345
    
    { The output of this command will look similar to example 1, since only a single pool is exposed. }
.EXAMPLE
    Get-SwordFishPool -PoolID default 

    { The output of this command will look similar to example 1, since only a single pool is exposed. }
.EXAMPLE
    PS:> Get-SwordfishPool | ConvertTo-Json    

    {
        "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default",
        "@odata.type":  "#StoragePool.v1_3_1.StoragePool",
        "Id":  "0a2b4bd8361b856bbc000000000000000000000001",
        "Name":  "default",
        "Description":  "Default pool",
        "CapacityInfo":  {
                             "ConsumedBytes":  3996069633246,
                             "AllocatedBytes":  24716521871770
                         },
        "Status":  {
                       "HealthRollUp":  "OK",
                       "Health":  "OK",
                       "State":  "Enabled"
                   },
        "AllocatedVolumes":  [
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SCSQL2017"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SCSCOM2019"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SCVMM2019"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SQL2019-DataBase"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/SQL2019-Logs"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/DS9CSV"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/EnterpriseCSV"
                                 },
                                 {
                                     "@odata.id":  "/redfish/v1/Storage/AC-109032/StoragePools/default/Volumes/DS9CSV1"
                                 },
                             ],
        "CapacitySources":  [
                                {
                                    "ProvidedCapacity":  "@{AllocatedCapacity=24716521871770; ConsumedBytes=3996069633246}",
                                    "ProvidingDrives":  "@{Drives=System.Object[]}"
                                }
                            ],
        "Compressed":  true,
        "Deduplicated":  true,
        "Encryption":  true,
        "SupportedRAIDTypes":  "RAID6TP"
    }
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/StoragePool.v1_2_0.json
#>   
[CmdletBinding()]
    param(  [string]    $StorageId,
            [string]    $PoolId,
            [boolean]   $ReturnCollectionOnly   =   $False
        )
    process{
        $MyPoolsCol=@()
        $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
        write-verbose "Storage Folder = $StorageUri"
        $StorageData = invoke-restmethod2 -uri $StorageUri
        foreach( $StorageSys in ( $StorageData ).Members )
            {   $MyStorageSysURI = $Base + $StorageSys.'@odata.id' + '/StoragePools'
                write-verbose "MyStorageSysURI = $MyStorageSysURI"
                #Gotta find my Array Name to see if it matches passed in filter
                $MyStorageSysObj   = $StorageSys.'@odata.id'
                $MyStorageSysArray = $MyStorageSysObj.split('/')
                $MyStorageSysName  = $MyStorageSysArray[ ($MyStorageSysArray.length -1) ]
                write-verbose "MyStorageSysName = $MyStorageSysName"
                if ( ($StorageId -like $MyStorageSysName) -or ( -not $StorageId ) )
                    {   $MyPoolCollection = invoke-restmethod2 -uri ( $MyStorageSysURI )
                        foreach( $MyPool in ($MyPoolCollection.Members) )
                            {   #Gotta find my Pool name to see if it matches passed in filter
                                $MyPoolObj   = $MyPool.'@odata.id'
                                $MyPoolArray = $MyPoolObj.split('/')
                                $MyPoolName  = $MyPoolArray[ ($MyPoolArray.length -1) ]
                                write-verbose "MyPoolName = $MyPoolName"
                                if ( ($PoolId -like $MyPoolName) -or (-not $PoolId) )
                                    {   $Pool = invoke-restmethod2 -uri ( $Base + $MyPool.'@odata.id' )
                                        $MyPoolCol+=$Pool
                                        $ReturnColl = $MyPoolCollection
                                    }                                 
                            }
                    }
            }
        if ( $ReturnCollectionOnly )
            {   return $ReturnColl
            } else 
            {   return $MyPoolCol            
            }
    }
}



