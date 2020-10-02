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
            write-verbose "Folder = $FabricUri"
            $FabricsData = invoke-restmethod2 -uri $FabricUri
            # Search for the Endpoints by detecting them from /redfish/v1/Fabrics/{id}/Drives
            foreach($Fabric in $FabricsData.Members )
                {   write-verbose "Walking the Fabrics"
                    $MyFabricObj    = $Fabric.'@odata.id'
                    $MyFabricSplit  = $MyFabricObj.split('/')
                    $MyFabricName   = $MyFabricSplit[ ($MyFabricSplit.Length -1 ) ]
                    write-verbose "Fabric = $MyFabricName"
                    $ConnectionsCol = Invoke-RestMethod2 -uri ( $base + $MyFabricObj + '/Connections' )
                    foreach( $Connection in ( $ConnectionsCol).Members )
                        {   $MyConnectionURI     =   $Connection.'@odata.id'
                            $MyConnection        =   Invoke-RestMethod2 -uri ( $base + $MyConnectionURI )
                            $MyConnectionSplit   =   $MyConnectionURI.split('/')
                            $MyConnectionName    =   $MyConnectionSplit[ ( $MyConnectionSplit.length -1) ] 
                            if( ( $FabricID -eq $MyFabricName ) -or ( -not $FabricID ) )
                                {   # Only add the resulting drive if the Chassis ID matches or was not set.
                                    if ( ( $MyConnectionName -like $ConnectionID) -or ( -not $ConnectionID ))
                                        {   # Only add the resulting drive if the Drive ID matches or was not set
                                            $ReturnConnectionColl += $MyConnection
                                            $ReturnOnlyColl = $ConnectionsCol
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
                $MyConnectionCollectionlocation = ($MyStorage.Connections)
                write-verbose "My Connection Collection Location = $MyConnectionCollectionLocation"
                $ConnectionsCol = Invoke-RestMethod2 -uri ( $base + $MyConnectionCollectionLocation )
                foreach( $Connection in ( $ConnectionsCol).Members )
                    {   $MyConnectionURI =   $Connection.'@odata.id'
                        $MyConnection    =   Invoke-RestMethod2 -uri ( $base + $MyConnectionURI )
                        $MyConnectionSplit = $MyConnectionURI.split('/')
                        $MyConnectionName =   $MyConnectionSplit[ ( $MyConnectionSplit.length -1) ] 
                        write-verbose "Connection Name = $MyConnectionName"
                        if( ( $StorageID -eq $MyStorageName ) -or ( -not $StorageID ) )
                            {   # Only add the resulting drive if the Storage ID matches or was not set.
                                if ( ( $MyConnectionName -like $ConnectionID) -or ( -not $ConnectionID ))
                                    {   # Only add the resulting drive if the Drive ID matches or was not set
                                        $ReturnConnectionColl += $MyConnection
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

