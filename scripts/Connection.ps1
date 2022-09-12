function Get-SwordfishConnection
{
<#
.SYNOPSIS
    Retrieve The list of valid Connections from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Connection objects that exist across all of the 
    Storage Systems, unless a specific Storage system ID is used to limit it, or a specific Conection ID 
    is directly requested. 
.PARAMETER StorageId
    The StorageID name for a specific Storage System to query, otherwise the command will return all Connections 
    defined in the /redfish/v1/fabrics/{fabricid}/Connections.
.PARAMETER FabricId
    The FabricID name for a specific fabrics, otherwise the command will return all Connections defined
    in all of the the /redfish/v1/fabrics/{fabricids}/Connections.
.PARAMETER ConnectionId
    The ConnectionId will limit the returned data to ONLY the single Connection specified.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the 
    actual objects if set to true.
.EXAMPLE
    Get-SwordfishConnection
    
    @Redfish.Copyright               : Copyright 2020 HPE and DMTF
    @odata.id                        : /redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000001
    @odata.type                      : #Connections.v1_0_0.Connections
    Name                             : 0d2b4bd8361b856bbc000000000000000000000001
    Description                      : Access Control Group connecting Endpoints to Volumes
    ClientEndpointGroups@odata.count : 1
    Zones                            : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Zones/022b4bd8361b856bbc000000000000000000000001},
                                        @{@odata.id=/redfish/v1/Fabrics/AC-109032/Zones/AC-109032_AllSubnets}}
    Volumes                          : {@{Volume=/redfish/v1/Storage/AC-109032/StoragePools/Default/Volumes/Crypt-MovsOld; LogicalUnitNumber=0}}
    Id                               : 0d2b4bd8361b856bbc000000000000000000000001

    @Redfish.Copyright               : Copyright 2020 HPE and DMTF
    @odata.id                        : /redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000002
    @odata.type                      : #Connections.v1_0_0.Connections
    Name                             : 0d2b4bd8361b856bbc000000000000000000000002
    Description                      : Access Control Group connecting Endpoints to Volumes
    ClientEndpointGroups@odata.count : 1
    Zones                            : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Zones/022b4bd8361b856bbc000000000000000000000001},
                                        @{@odata.id=/redfish/v1/Fabrics/AC-109032/Zones/AC-109032_AllSubnets}}
    Volumes                          : {@{Volume=/redfish/v1/Storage/AC-109032/StoragePools/Default/Volumes/Crypt-Port; LogicalUnitNumber=0}}
    Id                               : 0d2b4bd8361b856bbc000000000000000000000002
.EXAMPLE
    Get-SwordfishConnection -StorageId AC-102345
    { Example looks the same as above, but limits the selection to only those Connections pointed to be this storage system }
.EXAMPLE
    Get-SwordfishConnection -FabricId AC-102345
    { Example looks the same as above, but limits the selection to only those Connections pointed located in this fabric system }
.EXAMPLE
    Get-SwordfishConnection -StorageId AC-102345 -ConnectionId Host1Mapping | ConvertTo-Json

    {
        "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Connections/Host1Mapping",
        "@odata.type":  "#Connections.v1_0_0.Connections",
        "Name":  "Host1Mapping",
        "Description":  "Access Control Group connecting Endpoints to Volumes",
        "ClientEndpointGroups@odata.count":  1,
        "Zones":  [
                      {
                          "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Zones/022b4bd8361b856bbc000000000000000000000001"
                      },
                      {
                          "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Zones/AC-109032_AllSubnets"
                      }
                  ],
        "Volumes":  [
                        {
                            "Volume":  "/redfish/v1/Storage/AC-109032/StoragePools/Default/Volumes/V2",
                            "LogicalUnitNumber":  0
                        }
                    ],
        "Id":  "Host1Mapping"
    }

.EXAMPLE
    Get-SwordfishConnection -ReturnCollectionOnly $True

    @Redfish.Copyright  : Copyright 2020 HPE and DMTF
    Members@odata.count : 34
    @odata.type         : #ConnectionsCollection.ConnectionsCollection
    @odata.id           : /redfish/v1/Fabrics/AC-109032/Connections
    Name                : Nimble Storage Groups (Access Control Maps)
    Members             : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000001},
                           @{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000002},
                           @{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000003},
                           @{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000004}...}
.LINK
    http://redfish.dmtf.org/schemas/v1/Connection.v1_0_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
        [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
        [Parameter(ParameterSetName='ByFabricID')]          [string]    $FabricID,

        [Parameter(ParameterSetName='ByStorageID')]
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='ByFabricID')]
        [Parameter(ParameterSetName='Default')]             [string]    $ConnectionId,

        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='ByStorageID')]        
        [Parameter(ParameterSetName='ByFabricID')]        
        [Parameter(ParameterSetName='Default')]             [Switch]   $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
    {     'Default'         {   $DefConnCol = @()
                                foreach ( $FabID in (Get-SwordfishFabric).id )
                                    {   $DefConnCol    += Get-SwordfishConnection   -FabricID $FabID        -ReturnCollectionOnly:$ReturnCollectionOnly
                                    }
                                foreach ( $StorID in (Get-SwordfishStorage).id )
                                    {   $DefConnCol    += Get-SwordfishConnection   -StorageID $StorID      -ReturnCollectionOnly:$ReturnCollectionOnly
                                    }
                                foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                    {   $DefConnCol    += Get-SwordfishConnection   -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                    }
                                if ( $ConnectionID )
                                    {   return ( $DefConnCol | where-object {$_.id -eq $ConnectionId} ) 
                                    } else 
                                    {   return $DefConnCol
                                    } 
                            }
        'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices  -StorageID $StorageServiceID
                            }
        'ByStorageID'       {   $PulledData = Get-SwordfishStorage          -StorageID $StorageID
                            }
        'ByFabricID'        {   $PulledData = Get-SwordfishFabric           -FabricID $FabricID
                            }
    }
    $FullConnCollectionOnly  =@()
    $FullConnCollection      =@()
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $EPMemberOrCollection = $PulledData.Connections
            foreach ( $EPorEPC in $Memberset )
                {   $EPColOrEP = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
                    if ( $EPColOrEP.Members ) 
                        {   $EPMemberOrCollection = $EPColOrEP.Members    
                        }
                    $FullConnCollectionOnly  += $EPColOrEP
                    foreach ( $MyEPData in $EPMemberOrCollection )
                        {   $FullConnCollection      += Invoke-RestMethod2 -uri ( $base + ($MyEPData.'@odata.id') )                          
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return $FullConnCollectionOnly
                } else 
                {   if ( $ConnectionID)
                        {   return $FullConnCollection | where-object { $_.id -eq $ConnectionID }
                        } else 
                        {   return $FullConnCollection
}}      }       }       }            

function Get-SwordfishGroup{
<#
.SYNOPSIS
    Retrieve The list of valid Volumes from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of StorageGroups that exist across all of 
    the Storage Services and/or Storage Systems, unless a  specific Storage Services ID or Storage Systems ID is used to limit it, or a specific 
    Storage Group ID is directly requested. It will search the following locations; /refish/v1/Storage/id/StorageGroups, /refish/v1/StorageServices/id/StorageGroups.
    Storage Groups are an outdated concept, and more modern Swordfish implemenations use Connections in the Fabric as opposed to Storage Groups.
.PARAMETER StorageId
    The Storage ID name for a specific Storage System, otherwise the command
    will return Storage Groups for all Storage Services and/or Storage Systems.
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command
    will return Storage Groups for all Storage Services and/or Storage Systems.
.PARAMETER StorageGroupId
    The Storage Group ID will limit the returned data to the type specified, otherwise the command will return all Storage Groups.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishGroup -StorageServiceID S1

    @odata.context       : /redfish/v1/$metadata#StorageGroup.StorageGroup
    @odata.id            : /redfish/v1/StorageServices/S1/StorageGroups/00c0ff50437d0000d9c73e5f01000000_00c0ff50437d000062a63f5f01010000
    @odata.type          : #StorageGroup.v1_2_0.StorageGroup
    Description          : Mapping Information
    Id                   : 00c0ff50437d0000d9c73e5f01000000_00c0ff50437d000062a63f5f01010000
    Name                 : Vol1_00c0ff50437d000062a63f5f01010000
    AccessCapabilities   : {Read, Write}
    MappedVolumes        : {@{LogicalUnitNumber=1; Volume=}}
    ClientEndpointGroups : {@{@odata.id=/redfish/v1/StorageServices/S1/EndpointGroups/00c0ff50437d000062a63f5f01010000}}
    ServerEndpointGroups : {@{@odata.id=/redfish/v1/StorageServices/S1/EndpointGroups/A1}, @{@odata.id=/redfish/v1/StorageServices/S1/EndpointGroups/B1}, @{@odata.id=/redfish/v1/StorageServices/S1/EndpointGroups/A2},
                           @{@odata.id=/redfish/v1/StorageServices/S1/EndpointGroups/B2}...}
    AccessState          : Optimized
    Status               : @{State=Enabled; Health=OK; HealthRollup=OK}
    MembersAreConsistent : True
    VolumesAreExposed    : True
.EXAMPLE
    Get-SwordfishVolume -StorageId AC-102345
    
    { Output Identical to example 1}
.EXAMPLE
    Get-SwordfishGroup -ReturnCollectionOnly $True

    @odata.context      : /redfish/v1/$metadata#StorageGroupCollection.StorageGroupCollection
    @odata.type         : #StorageGroupCollection.StorageGroupCollection
    @odata.id           : /redfish/v1/StorageServices/S1/StorageGroups
    Name                : StorageGroup Collection
    Members@odata.count : 2
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/StorageGroups/00c0ff50437d0000d9c73e5f01000000_00c0ff50437d000062a63f5f01010000},
                          @{@odata.id=/redfish/v1/StorageServices/S1/StorageGroups/00c0ff50437d000052ab465f01000000_00c0ff504392000079aa465f01010000}}
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/EndpointGroup.v1_2_1.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(      [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
            [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
    
            [Parameter(ParameterSetName='ByStorageID')]
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='Default')]             [string]    $StorageGroupId,
    
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStorageID')]        
            [Parameter(ParameterSetName='Default')]             [switch]   $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {     'Default'         {   foreach ( $StorID in (Get-SwordfishStorage).id )
                                        {   [array]$DefSGCol += Get-SwordfishGroup -StorageID $StorID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefSGCol += Get-SwordfishGroup -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $StorageGroupID )
                                        {   return ( $DefSGCol | where-object {$_.id -eq $StorageGroupId} ) 
                                        } else 
                                        {   return $DefSGCol
                                        }
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
            'ByStorageID'       {   $PulledData = Get-SwordfishStorage -StorageID $StorageID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $PulledData.StorageGroups
            [array]$FullSGCollectionOnly = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
            foreach ( $MySGdata in $FullSGCollectionOnly.Members )
                {   [array]$FullSGSet = Invoke-RestMethod2 -uri ( $base + ( $MySGData.'@odata.id' ) )
                }
            if ( $ReturnCollectionOnly )
                {   return $FullSGCollectionOnly
                } else 
                {   if ( $StorageGroupID)
                    {   return ( $FullSGSet | where-object { $_.id -eq $StorageGroupID } )
                    } else 
                    {   return $FullSGSet
                    }            
                }
        }
}
}