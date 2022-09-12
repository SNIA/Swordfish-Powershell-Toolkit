function Get-SwordfishVolume
{
<#
.SYNOPSIS
    Retrieve The list of valid Volumes from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Volumes that exist across all of 
    the Storage Services and/or Storage Systems, unless a  specific Storage Services ID or Storage Systems ID is used to limit it, or a specific 
    Volume ID is directly requested. It will search the following locations; /refish/v1/Storage/id/volumes, /refish/v1/StorageServices/id/volumes,
    /redfish/v1/Storage/id/StoragePools/id/Volumes, and /redfish/v1/StorageServices/id/StoragePools/id/Volumes
.PARAMETER StorageId
    The Storage ID name for a specific Storage System, otherwise the command
    will return Volumes for all Storage Services and/or Storage Systems and all pools.
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command
    will return Volumes for all Storage Services and/or Storage Systems and all pools.
.PARAMETER PoolId
    The Storage Pool ID name for a specific Storage Service or Storage System, otherwise the command
    will return Volumes for all pools within all of the Storage Services and/or Storage Systems.
.PARAMETER VolumeId
    The Storage Group ID will limit the returned data to the type specified, otherwise the command will return all Volumes.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishVolume
.EXAMPLE
    Get-SwordfishVolume -StorageId AC-102345
.EXAMPLE
    Get-SwordfishVolume -VolumeId 00c0ff50437d000052ab465f01000000
.EXAMPLE
    Get-SwordfishVolume -StorageServiceID S1 -VolumeId 00c0ff50437d000052ab465f01000000

    @odata.context           : /redfish/v1/$metadata#Volume.Volume
    @odata.id                : /redfish/v1/StorageServices/S1/Volumes/00c0ff50437d000052ab465f01000000
    @odata.type              : #Volume.v1_4_0.Volume
    Id                       : 00c0ff50437d000052ab465f01000000
    Name                     : Crush50
    Manufacturer             : HPE
    BlockSizeBytes           : 512
    CapacityBytes            : 49996103680
    AccessCapabilities       : {Read, Write}
    RemainingCapacityPercent : 99
    Encrypted                : True
    EncryptionTypes          : {NativeDriveEncryption}
    IOStatistics             : @{ReadHitIORequests=881; ReadIOKiBytes=11952; WriteHitIORequests=1055; WriteIOKiBytes=386842}
    Capacity                 : @{Data=}
    Status                   : @{State=Enabled; Health=OK}
    CapacitySources          : {@{@odata.id=/redfish/v1/StorageServices/S1/Volumes/00c0ff50437d000052ab465f01000000#/CapacitySources/0; @odata.type=#Capacity.v1_1_2.CapacitySource; Id=00c0ff50437d000052ab465f01000000; Name=Crush50; ProvidingPools=}}
.EXAMPLE
    Get-SwordfishVolume -ReturnCollectionOnly $True

    @odata.context      : /redfish/v1/$metadata#VolumeCollection.VolumeCollection
    @odata.type         : #VolumeCollection.VolumeCollection
    @odata.id           : /redfish/v1/StorageServices/S1/Volumes
    Name                : Volume Collection
    Members@odata.count : 2
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/Volumes/00c0ff50437d0000d9c73e5f01000000}, @{@odata.id=/redfish/v1/StorageServices/S1/Volumes/00c0ff50437d000052ab465f01000000}}
.LINK
    https://redfish.dmtf.org/schemas/v1/Volume.v1_5_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(      [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
            [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
            [Parameter(ParameterSetName='ByStoragePoolID')]     [string]    $StoragePoolID,

            [Parameter(ParameterSetName='ByStorageID')]
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStoragePoolID')]
            [Parameter(ParameterSetName='Default')]             [string]    $VolumeId,

            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStorageID')]        
            [Parameter(ParameterSetName='Default')]
            [Parameter(ParameterSetName='ByStoragePoolID')]     [switch]   $ReturnCollectionOnly =   $False  
        )
process{
    $FullVolCollection=@()
    $FullVolCollectionOnly=@()
    switch ($PSCmdlet.ParameterSetName )
    {     'Default'           { $DefVolsCol     = @()
                                foreach ( $PoolID in (Get-SwordfishPool).id )
                                {   $DefVolsCol        += Get-SwordfishVolume -StoragePoolID $PoolID -ReturnCollectionOnly:$ReturnCollectionOnly
                                }
                                foreach ( $StorID in (Get-SwordfishStorage).id )
                                {   $DefVolsCol        += Get-SwordfishVolume -StorageID $StorID -ReturnCollectionOnly:$ReturnCollectionOnly
                                }
                                foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                {   $DefVolsCol        += Get-SwordfishVolume -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                }
                                if ( $VolumeID )
                                    {   return ( $DefVolsCol | where-object {$_.id -eq $VolumeId} ) 
                                    } else 
                                    {   return $DefVolsCol
                                    } 
                            }
        'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                            }
        'ByStorageID'       {   $PulledData = Get-SwordfishStorage -StorageID $StorageID
                            }
        'ByStoragePoolID'   {   $PulledData = Get-SwordfishURIFolderByFolder "StoragePool"
                            }
    }
    $FullVolSet=@()
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
    {   $MemberSet = $VolMemberOrCollection = $PulledData.Volumes
        $VolColOrVols = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
        if ( $VolColOrVols.Members ) 
            {   $VolMemberOrCollection = $VolColOrVols.Members    
            }
        [array]$FullVolCollectionOnly += $VolColOrVols    
        foreach ( $VorVC in $Memberset )
            {   foreach ( $MyVolData in $VolMemberOrCollection )
                    {   [array]$FullVolSet += Invoke-RestMethod2 -uri ( $base + ($MyVolData.'@odata.id') )
                    }
            }
        if ( $ReturnCollectionOnly )
            {   return $FullVolCollectionOnly
            } else 
            {   if ( $VolumeID)
                {   return $FullVolSet | where-object { $_.id -eq $VolumeID }
                } else 
                {   return $FullVolSet
}}  }       }   } 
Set-Alias -Name 'Get-RedfishVolume' -Value 'Get-SwordfishVolume'           