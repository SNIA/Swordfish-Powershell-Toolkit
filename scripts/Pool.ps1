function Get-SwordfishPool
{
<#
.SYNOPSIS
    Retrieve The list of valid Storage Pools from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Storagep Pool objects that exist across all of the Storage Systems, unless a 
    specific Storage System ID is used to limit it, or a specific StoragePool ID is directly requested. 
.PARAMETER StoragePoolId
    The Storage pool ID for a specific pool, otherwise the command will return all Storage Pools for all Storage Systems and storage services.
.PARAMETER StorageId
    The Storage System ID name for a specific Storage System, otherwise the command will return Storage Pool for all Storage Systems.
.PARAMETER StorageServiceId
    The Storage Service ID name for a specific Storage Service, otherwise the command will return Storage Pool for all Storage Systems and Storage Services.
.PARAMETER PoolId
    The StoragePool ID name for a specific StoragePool, otherwise the command will return all Storage Pool.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishPool -StorageServiceID S1 -StoragePoolID 00c0ff5043920000603c3d5f01000000

    @odata.context           : /redfish/v1/$metadata#StoragePool.StoragePool
    @odata.id                : /redfish/v1/StorageServices/S1/StoragePools/B
    @odata.type              : #StoragePool.v1_2_0.StoragePool
    Id                       : 00c0ff5043920000603c3d5f01000000
    Name                     : B
    Description              : Pool
    MaxBlockSizeBytes        : 512
    AllocatedVolumes         : @{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/B/Volumes}
    AllocatedPools           : @{@odata.id=/redfish/v1/StorageServices/S1/StoragePools}
    RemainingCapacityPercent : 99
    IOStatistics             : @{ReadHitIORequests=542362; ReadIOKiBytes=148062208; ReadIORequestTime=62324; WriteHitIORequests=158; WriteIOKiBytes=384657; WriteIORequestTime=0}
    Capacity                 : @{Data=}
    Status                   : @{State=Enabled; Health=OK}
    CapacitySources          : {@{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/B#/CapacitySources/0; @odata.type=#Capacity.v1_1_2.CapacitySource; Id=00c0ff5043920000603c3d5f01000000; Name=B; ProvidingPools=}}
.EXAMPLE
    Get-SwordfishPool -StorageId AC-102345
    
    { The output of this command will look similar to example 1, but may display multiple or a single pool. }
.EXAMPLE
    Get-SwordfishPool -StorageServiceID S1 

    { The output of this command will look similar to example 1, but may display multiple or a single pool. }
.EXAMPLE
    Get-SwordfishPool -ReturnCollectionOnly $true

    @odata.context      : /redfish/v1/$metadata#StoragePoolCollection.StoragePoolCollection
    @odata.type         : #StoragePoolCollection.StoragePoolCollection
    @odata.id           : /redfish/v1/StorageServices/S1/StoragePools
    Name                : StoragePool Collection
    Members@odata.count : 4
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/00c0ff50437d0000f93a3d5f00000000}, @{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/00c0ff5043920000593c3d5f00000000}, @{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/A},
                           @{@odata.id=/redfish/v1/StorageServices/S1/StoragePools/B}}
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/StoragePool.v1_5_0.json
#>   
[CmdletBinding( DefaultParameterSetName='Default' )]
param(      [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
            [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
            
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStorageID')]        
            [Parameter(ParameterSetName='Default')]             [string]    $StoragePoolID,

            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStorageID')]        
            [Parameter(ParameterSetName='Default')]             [switch]    $ReturnCollectionOnly
     )

process{
    switch ($PSCmdlet.ParameterSetName )
        {     'Default'         {   foreach ( $StorID in (Get-SwordfishStorage).id )
                                        {   [array]$DefPoolCol += Get-SwordfishPool -StorageID $StorID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefPoolCol += Get-SwordfishPool -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $StoragePoolID ) 
                                        {   return ( $DefPoolCol | where-object { $_.id -eq $StoragePoolID } )
                                        } else 
                                        {   return $DefPoolCol
                                        }                                             
                                }   
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
            'ByStorageID'       {   $PulledData = Get-SwordfishStorage -StorageID $StorageID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = [array]$FullPoolCollectionOnly = $PulledData.StoragePools
            foreach ( $PorPC in $Memberset )
                {   $MyPorPC = Invoke-RestMethod2 -uri ( $base + ($PorPC.'@odata.id') )
                    if ( -not $MyPorPC.Members ) 
                        {   [array]$FullPoolSet += $MyPorPC
                        } else 
                        {   [array]$FullPoolCollectionOnly = $MyPorPC
                            foreach ( $Pool in $MyPorPC.Members)
                            {   [array]$FullPoolSet += Invoke-RestMethod2 -uri ( $base + ($Pool.'@odata.id') )
                            }
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return $FullPoolCollectionOnly | get-unique
                } else 
                {   IF ( $StoragePoolID )
                    {   return ( $FullPoolSet | where-object { $_.id -eq $StoragePoolID } )
                    } else 
                    {   return ( $FullPoolSet )
                    }
                }
        }
}
}