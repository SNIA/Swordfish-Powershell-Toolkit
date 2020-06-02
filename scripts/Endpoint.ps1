function Get-SwordFishEndpoint{
<#
.SYNOPSIS
    Retrieve The list of valid Endpoint from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Endpoint objects that exist across all of the 
    Storage Services, unless a specific Storage Service ID is used to limit it, or a specific Endpoint ID 
    is directly requested. You may also limit the serch to only return target endpoints or initiator endpoints 
    using the EndpointType
.PARAMETER StorageId
    The StorageID name for a specific Storage System to query, otherwise the command will return all Endpoints 
    defined in the /redfish/v1/fabrics/{fabricid}/Endpoints.
.PARAMETER FabricId
    The FabricID name for a specific fabrics, otherwise the command will return all Endpoints defined
    in all of the the /redfish/v1/fabrics/{fabricids}/Endpoints.
.PARAMETER EndpointId
    The EndpointId will limit the returned data to ONLY the single endpoint specified.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the 
    actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordFishEndpoint

    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth4
    @odata.type        : #Endpoint.v1_4_0.Endpoint
    Name               : active_eth4
    ConnectedEntities  : {@{EntityRole=Target; EntityType=NetworkController}}
    Description        : active configuration, Port named eth4. iSCSI Target.
    EndpointProtocol   : iSCSI
    IPTransportDetails : {@{IPv4Address=}}
    Id                 :
    Status             : @{State=Disabled; Health=Warning}

    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth1
    @odata.type        : #Endpoint.v1_4_0.Endpoint
    Name               : active_eth1
    ConnectedEntities  : {@{EntityRole=Target; EntityType=NetworkController}}
    Description        : active configuration, Port named eth1. iSCSI Target.
    EndpointProtocol   : iSCSI
    IPTransportDetails : {@{IPv4Address=}}
    Id                 :
    Status             : @{State=Disabled; Health=Warning}

.EXAMPLE 
    PS:> Get-SwordfishEndpoint | Format-Table Name,'@odata.id', Description
    Name                 @odata.id                                                                          Description
    ----                 ---------                                                                          -----------
    active_eth1          /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth1                                active configuration, Port named eth1. iSCSI Target.
    active_eth2          /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth2                                active configuration, Port named eth2. iSCSI Target.
    active_eth3          /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth3                                active configuration, Port named eth3. iSCSI Target.
    CentOS-iqn           /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc000000000000000000000002 Device named CentOS-iqn. Registered iSCSI Initiator.
    RikerIQN             /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc000000000000000000000009 Device named RikerIQN. Registered iSCSI Initiator.
    PicardIQN            /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc00000000000000000000000a Device named PicardIQN. Registered iSCSI Initiator.
    KirkIQN              /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc00000000000000000000000c Device named KirkIQN. Registered iSCSI Initiator.
    SpockIQN             /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc00000000000000000000000d Device named SpockIQN. Registered iSCSI Initiator.
    Q-IQN                /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc000000000000000000000010 Device named Q-IQN. Registered iSCSI Initiator.
    Borg-IQN             /redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc000000000000000000000011 Device named Borg-IQN. Registered iSCSI Initiator.
.EXAMPLE
    Get-SwordfishEndpoint -StorageId AC-102345

    { Output is the same as Example 1, since this target only represents a single target swordifsh device }
.EXAMPLE
    Get-SwordfishEndpoint -FabricId AC-102345

    { Output is the same as Example 1, since this target only represents a single fabric which houses endpoint devices }
.EXAMPLE
    Get-SwordfishEndpoint -EndpointId active_eth1

    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Fabrics/AC-109032/Endpoints/active_eth1
    @odata.type        : #Endpoint.v1_4_0.Endpoint
    Name               : active_eth1
    ConnectedEntities  : {@{EntityRole=Target; EntityType=NetworkController}}
    Description        : active configuration, Port named eth1. iSCSI Target.
    EndpointProtocol   : iSCSI
    IPTransportDetails : {@{IPv4Address=}}
    Id                 :
    Status             : @{State=Disabled; Health=Warning}
.EXAMPLE
    Get-SwordfishEndpoint -EndpointId active_eth1 | ConvertTo-Json

    {
        "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Endpoints/active_eth1",
        "@odata.type":  "#Endpoint.v1_4_0.Endpoint",
        "Name":  "active_eth1",
        "ConnectedEntities":  [
                                  {
                                      "EntityRole":  "Target",
                                      "EntityType":  "NetworkController"
                                  }
                              ],
        "Description":  "active configuration, Port named eth1. iSCSI Target.",
        "EndpointProtocol":  "iSCSI",
        "IPTransportDetails":  [
                                   {
                                       "IPv4Address":  "@{Address=192.168.1.63}"
                                   }
                               ],
        "Id":  null,
        "Status":  {
                       "State":  "Disabled",
                       "Health":  "Warning"
                   }
    }
.EXAMPLE
    Get-SwordfishEndpoint -ReturnCollectionOnly $True

    @Redfish.Copyright  : Copyright 2020 HPE and DMTF
    @odata.id           : /redfish/v1/Fabrics/AC-109032/Endpoints
    @odata.type         : #EndpointCollection.EndpointCollection
    Name                : Nimble Endpoints Collection
    Members@odata.count : 8
    Members             : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/active_eth4}, @{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/active_eth1},
                           @{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/active_eth2}, @{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/active_eth3}...}
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/Endpoint.v1_2_0.json
#>   
    [CmdletBinding()]
    param(
        [string]    $StorageId,
        [string]    $FabricId,
        [string]    $EndpointId,
        [boolean]   $ReturnCollectionOnly   =   $False
    )
    process{
        $FullEndpointCollection=@()
        if ( -not $StorageID )
            {   $FabricUri = Get-SwordfishURIFolderByFolder "Fabrics"
                write-verbose "Folder = $FabricUri"
                $FabricsData = invoke-restmethod2 -uri $FabricUri
                # Search for the Endpoints by detecting them from /redfish/v1/Fabrics/{id}/Drives
                foreach($Fabric in $FabricsData.Members )
                    {   write-verbose "Walking the Fabrics"
                        $MyFabricObj    = $Fabric.'@odata.id'
                        $MyFabricSplit  = $MyFabricObj.split('/')
                        $MyFabricName   = $MyFabricSplit[ ($MyFabricSplit.Length -1 ) ]
                        write-verbose "Fabric = $MyFabricName"
                        $EndpointsCol = Invoke-RestMethod2 -uri ( $base + $MyFabricObj + '/Endpoints' )
                        foreach( $Endpoint in ( $EndpointsCol).Members )
                            {   $MyEndpointURI     =   $Endpoint.'@odata.id'
                                $MyEndpoint        =   Invoke-RestMethod2 -uri ( $base + $MyEndpointURI )
                                $MyEndpointSplit   =   $MyEndpointURI.split('/')
                                $MyEndpointName    =   $MyEndpointSplit[ ( $MyEndpointSplit.length -1) ] 
                                if( ( $FabricID -eq $MyFabricName ) -or ( -not $FabricID ) )
                                    {   # Only add the resulting drive if the Chassis ID matches or was not set.
                                        if ( ( $MyEndpointName -like $EndpointID) -or ( -not $EndpointID ))
                                            {   # Only add the resulting drive if the Drive ID matches or was not set
                                                $FullEndpointCollection += $MyEndpoint
                                                $ReturnOnlyColl = $EndpointsCol
                                            }
                                    }
                            }
                    }
            } else 
            {   $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
                write-verbose "Folder = $StorageUri"
                $StorageData = invoke-restmethod2 -uri $StorageUri
                foreach($Stor in ($StorageData).Members )
                {   write-verbose "Walking the StorageID's"
                    $MyStorObj = $Stor.'@odata.id'
                    $MyStorSplit = $MyStorObj.split('/')
                    $MyStorageName= $MyStorSplit[ ( $MyStorSplit.Length -1 ) ]
                    write-verbose "Storage = $MyStorageName"
                    # Now I need to explore the link from the actual storage device, since the Endpoints likely point somewhere else. I need to follow the other location.
                    $MyStorage = Invoke-RestMethod2 -uri ( $base + $MyStorObj )
                    $MyEndpointCollectionlocation = ($MyStorage.Endpoints)
                    write-verbose "My Endpoint Collection Location = $MyEndpointCollectionLocation"
                    $EndpointsCol = Invoke-RestMethod2 -uri ( $base + $MyEndpointCollectionLocation )
                    foreach( $Endpoint in ( $EndpointsCol).Members )
                        {   $MyEndpointURI =   $Endpoint.'@odata.id'
                            $MyEndpoint    =   Invoke-RestMethod2 -uri ( $base + $MyEndpointURI )
                            $MyEndpointSplit = $MyEndpointURI.split('/')
                            $MyEndpointName =   $MyEndpointSplit[ ( $MyEndpointSplit.length -1) ] 
                            write-verbose "Endpoint Name = $MyEndpointName"
                            if( ( $StorageID -eq $MyStorageName ) -or ( -not $StorageID ) )
                                {   # Only add the resulting drive if the Storage ID matches or was not set.
                                    if ( ( $MyEndpointName -like $EndpointID) -or ( -not $EndpointID ))
                                        {   # Only add the resulting drive if the Drive ID matches or was not set
                                            $FullEndpointCollection += $MyEndpoint
                                            $ReturnOnlyColl = $EndpointsCol
                                        }
                                }
                        }
                } 
            }
        if ( $ReturnCollectionOnly )
            {       return $ReturnOnlyColl
            } else 
            {       return $FullEndpointCollection
            }
    }
}

