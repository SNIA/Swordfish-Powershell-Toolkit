function Get-SwordfishConnection
{
<#
.SYNOPSIS
    Retrieve The list of valid Connections from the SwordFish Target.
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
    Get-SwordFishConnection
    
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
    Get-SwordFishConnection -StorageId AC-102345
    { Example looks the same as above, but limits the selection to only those Connections pointed to be this storage system }
.EXAMPLE
    Get-SwordFishConnection -FabricId AC-102345
    { Example looks the same as above, but limits the selection to only those Connections pointed located in this fabric system }
.EXAMPLE
    Get-SwordFishConnection -StorageId AC-102345 -ConnectionId Host1Mapping | ConvertTo-Json

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
    Get-SwordFishConnection -ReturnCollectionOnly $True

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
[CmdletBinding()]
param(
    [string]    $StorageId,
    [string]    $FabricId,
    [string]    $ConnectionId,
    [boolean]   $ReturnCollectionOnly   =   $False
)
process{
    $ReturnConnectionColl=@()
    if ( -not $StorageID )
        {   $FabricUri = Get-SwordfishURIFolderByFolder "Fabrics"
            $FabricsData = invoke-restmethod2 -uri $FabricUri               # Search for the Endpoints by detecting them from /redfish/v1/Fabrics/{id}/Drives
            foreach($Fabric in $FabricsData.Members )
                {   $MyFabricObj    = $Fabric.'@odata.id'
                    $ConnectionsCol = Invoke-RestMethod2 -uri ( $base + $MyFabricObj + '/Connections' )
                    foreach( $Connection in ( $ConnectionsCol).Members )
                        {   $MyConnection = Invoke-RestMethod2 -uri ( $base + ($Connection.'@odata.id') )
                            if( ( $FabricID -eq $MyFabricData.id ) -or ( -not $FabricID ) )
                                {   if ( ( $MyConnection.id -like $ConnectionID) -or ( -not $ConnectionID ))
                                        {   $ReturnConnectionColl += $MyConnection
                                            $ReturnOnlyColl = $ConnectionsCol
                                        }
                                }
                        }
                }
        } else 
        {   $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
            $StorageData = invoke-restmethod2 -uri $StorageUri
            foreach($Stor in ($StorageData).Members )
            {   $MyStorage = Invoke-RestMethod2 -uri ( $base + ($Stor.'@odata.id') )
                $MyConnectionCollectionlocation = ($MyStorage.Connections)
                $ConnectionsCol = Invoke-RestMethod2 -uri ( $base + $MyConnectionCollectionLocation )
                foreach( $Connection in ( $ConnectionsCol).Members )
                    {   $MyConnection = Invoke-RestMethod2 -uri ( $base + ($Connection.'@odata.id') )
                        if( ( $StorageID -eq $MyStorage.id ) -or ( -not $StorageID ) )
                            {   if ( ( $MyConnection.id -like $ConnectionID) -or ( -not $ConnectionID ))
                                    {   $ReturnConnectionColl += $MyConnection
                                        $ReturnOnlyColl = $ConnectionsCol
                                    }
                            }
                    }
            } 
        }
    if ( $ReturnCollectionOnly )
        {       return $ReturnOnlyColl
        } else 
        {       return $ReturnConnectionColl
        }
}
}

function Get-SwordFishGroup{
<#
.SYNOPSIS
    Retrieve The list of valid Volumes from the SwordFish Target.
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
    Get-SwordFishGroup -StorageServiceID S1

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
    Get-SwordFishVolume -StorageId AC-102345
    
    { Output Identical to example 1}
.EXAMPLE
    Get-SwordFishGroup -ReturnCollectionOnly $True

    @odata.context      : /redfish/v1/$metadata#StorageGroupCollection.StorageGroupCollection
    @odata.type         : #StorageGroupCollection.StorageGroupCollection
    @odata.id           : /redfish/v1/StorageServices/S1/StorageGroups
    Name                : StorageGroup Collection
    Members@odata.count : 2
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/StorageGroups/00c0ff50437d0000d9c73e5f01000000_00c0ff50437d000062a63f5f01010000},
                          @{@odata.id=/redfish/v1/StorageServices/S1/StorageGroups/00c0ff50437d000052ab465f01000000_00c0ff504392000079aa465f01010000}}
.LINK
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(      [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
            [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
    
            [Parameter(ParameterSetName='ByStorageID')]
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='Default')]             [string]    $StorageGroupId,
    
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='ByStorageID')]        
            [Parameter(ParameterSetName='Default')]             [boolean]   $ReturnCollectionOnly =   $False  
     )
process{
        $FullGroupCollection=@()
        $FullGroupCollectionOnly=@()
        switch ($PSCmdlet.ParameterSetName )
        {     'Default'           { $DefSGCol     = @()
                                    $DefSGColOnly = @()
                                    foreach ( $StorID in (Get-SwordfishStorage).id )
                                    {   $DefSGCol        += Get-SwordfishGroup -StorageID $StorID
                                        $DefSGColOnly    += Get-SwordfishGroup -StorageID $StorID -ReturnCollectionOnly $True
                                    }
                                    foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                    {   $DefSGCol        += Get-SwordfishGroup -StorageServiceID $SSID
                                        $DefSGColOnly    += Get-SwordfishGroup -StorageServiceID $SSID -ReturnCollectionOnly $True
                                    }
                                    if ( $ReturnCollectionOnly )
                                    {   return ($DefSGColOnly | get-unique)
                                    } else 
                                    {   if ( $StorageGroupID )
                                        {   return ( $DefSGCol | where-object {$_.id -eq $StorageGroupId} ) 
                                        } else 
                                        {   return $DefSGCol
                                        }
                                    } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
            'ByStorageID'       {   $PulledData = Get-SwordfishStorage -StorageID $StorageID
                                }
        }
        $FullSGCollectionOnly  =@()
        $FullSGCollection     =@()
        if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $PulledData.StorageGroups
            $MySGCollection = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
            $FullSGCollectionOnly  += $MySGCollection
            foreach ( $MySGdata in $MySGCollection.Members )
            {   $MySG = Invoke-RestMethod2 -uri ( $base + ( $MySGData.'@odata.id' ) )
                $FullSGCollection += $MySG
            }
        if ( $ReturnCollectionOnly )
            {   return $FullSGCollectionOnly
            } else 
            {   if ( $StorageGroupID)
                {   return ( $FullSGCollection | where-object { $_.id -eq $StorageGroupID } )
                } else 
                {   return $FullSGCollection
                }            
            }
        }
    }
    }