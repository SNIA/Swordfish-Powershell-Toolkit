function Get-SwordfishZone{
<#
.SYNOPSIS
    Retrieve The list of valid Zones from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Zone objects that exist across all of the 
    Storage Systems, unless a specific Storage system ID is used to limit it, or a specific Zone ID 
    is directly requested. Zones are commonly used to group endpoints. 
.PARAMETER StorageId
    The StorageID name for a specific Storage System to query, otherwise the command will return all zones 
    defined in the /redfish/v1/fabrics/{fabricid}/Zones.
.PARAMETER FabricId
    The FabricID name for a specific fabrics, otherwise the command will return all Zones defined
    in all of the the /redfish/v1/fabrics/{fabricids}/Zones.
.PARAMETER ZoneId
    The ZoneId will limit the returned data to ONLY the single Zone specified.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the 
    actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordFishZone

    @Redfish.Copyright      : Copyright 2020 HPE and DMTF
    @odata.id               : /redfish/v1/Fabric/AC-109032/Zones/riker
    @odata.type             : #Zones.v1_4_0.Zones
    Name                    : riker
    Description             : Initiator EndpointGroup (Zone) for riker
    GroupType               : Client
    Endpoints@odata.count   : 1
    Connections@odata.count : 0
    Endpoints               : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc000000000000000000000009}}
    Connections             : {}

    @Redfish.Copyright      : Copyright 2020 HPE and DMTF
    @odata.id               : /redfish/v1/Fabric/AC-109032/Zones/picard
    @odata.type             : #Zones.v1_4_0.Zones
    Name                    : picard
    Description             : Initiator EndpointGroup (Zone) for picard
    GroupType               : Client
    Endpoints@odata.count   : 1
    Connections@odata.count : 2
    Endpoints               : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc00000000000000000000000a}}
    Connections             : {@{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc00000000000000000000002c},
                               @{@odata.id=/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc00000000000000000000002d}}
.EXAMPLE
    PS:> Get-SwordfishZone | Format-Table '@odata.id', Name, GroupType, Endpoints@odata.count, Connections@odata.count

    @odata.id                                                Name                 GroupType Endpoints@odata.count Connections@odata.count
    ---------                                                ----                 --------- --------------------- -----------------------
    /redfish/v1/Fabrics/AC-109032/Zones/management           management           Target                        1                       0
    /redfish/v1/Fabrics/AC-109032/Zones/iSCSI1               iSCSI1               Target                        1                       3
    /redfish/v1/Fabrics/AC-109032/Zones/iSCSI2               iSCSI2               Target                        1                       3
    /redfish/v1/Fabrics/AC-109032/Zones/AC-109032-AllSubnets AC-109032-AllSubnets Target                        4                      30
    /redfish/v1/Fabric/AC-109032/Zones/NSSQL                 NSSQL                Client                        1                       1
    /redfish/v1/Fabric/AC-109032/Zones/NSSCVMM               NSSCVMM              Client                        1                       1
    /redfish/v1/Fabric/AC-109032/Zones/NSSCOM                NSSCOM               Client                        1                       1
    /redfish/v1/Fabric/AC-109032/Zones/NSSCORCH              NSSCORCH             Client                        1                       0
    /redfish/v1/Fabric/AC-109032/Zones/NSSCDPM               NSSCDPM              Client                        1                       1
    /redfish/v1/Fabric/AC-109032/Zones/riker                 riker                Client                        1                       0
    /redfish/v1/Fabric/AC-109032/Zones/picard                picard               Client                        1                       2
    /redfish/v1/Fabric/AC-109032/Zones/kirk                  kirk                 Client                        1                       2
    /redfish/v1/Fabric/AC-109032/Zones/spock                 spock                Client                        1                       2
    /redfish/v1/Fabric/AC-109032/Zones/Q                     Q                    Client                        1                       1
    /redfish/v1/Fabric/AC-109032/Zones/Borg                  Borg                 Client                        1                       3
    /redfish/v1/Fabric/AC-109032/Zones/DFSR1                 DFSR1                Client                        1                       2
    /redfish/v1/Fabric/AC-109032/Zones/DFSR2                 DFSR2                Client                        1                       2
.EXAMPLE
    PS:> Get-SwordfishZone -ZoneId | ConvertTo-Json

    {
        "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.id":  "/redfish/v1/Fabric/AC-109032/Zones/kirk",
        "@odata.type":  "#Zones.v1_4_0.Zones",
        "Name":  "kirk",
        "Description":  "Initiator EndpointGroup (Zone) for kirk",
        "GroupType":  "Client",
        "Endpoints@odata.count":  1,
        "Connections@odata.count":  2,
        "Endpoints":  [
                          {
                              "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Endpoints/0b2b4bd8361b856bbc00000000000000000000000c"
                          }
                      ],
        "Connections":  [
                            {
                                "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000014"
                            },
                            {
                                "@odata.id":  "/redfish/v1/Fabrics/AC-109032/Connections/0d2b4bd8361b856bbc000000000000000000000016"
                            }
                        ]
    }

.LINK
    http://redfish.dmtf.org/schemas/v1/Zone.v1_0_0.json
#>   
[CmdletBinding()]
param(
    [string]    $StorageId,
    [string]    $FabricId,
    [string]    $ZoneId,
    [boolean]   $ReturnCollectionOnly   =   $False
)
process{
    $ReturnZoneColl=@()
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
                    $ZonesCol = Invoke-RestMethod2 -uri ( $base + $MyFabricObj + '/Zones' )
                    foreach( $Zone in ( $ZonesCol).Members )
                        {   $MyZoneURI     =   $Zone.'@odata.id'
                            $MyZone        =   Invoke-RestMethod2 -uri ( $base + $MyZoneURI )
                            $MyZoneSplit   =   $MyZoneURI.split('/')
                            $MyZoneName    =   $MyZoneSplit[ ( $MyConnectionSplit.length -1) ] 
                            if( ( $FabricID -eq $MyFabricName ) -or ( -not $FabricID ) )
                                {   # Only add the resulting drive if the Chassis ID matches or was not set.
                                    if ( ( $MyZoneName -like $ZoneID) -or ( -not $ZoneID ))
                                        {   # Only add the resulting drive if the Drive ID matches or was not set
                                            $ReturnZoneColl += $MyZone
                                            $ReturnOnlyColl = $ZonesCol
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
                $MyZoneCollectionlocation = ($MyStorage.Zones)
                write-verbose "My Zone Collection Location = $MyZoneCollectionLocation"
                $ZonesCol = Invoke-RestMethod2 -uri ( $base + $MyZoneCollectionLocation )
                foreach( $Zone in ( $ZoneCol).Members )
                    {   $MyZoneURI =   $Zone.'@odata.id'
                        $MyZone    =   Invoke-RestMethod2 -uri ( $base + $MyZoneURI )
                        $MyZoneSplit = $MyZoneURI.split('/')
                        $MyZoneName =   $MyZoneSplit[ ( $MyZoneSplit.length -1) ] 
                        write-verbose "Zone Name = $MyZoneName"
                        if( ( $StorageID -eq $MyStorageName ) -or ( -not $StorageID ) )
                            {   # Only add the resulting drive if the Storage ID matches or was not set.
                                if ( ( $MyZoneName -like $ZoneID) -or ( -not $ZoneID ))
                                    {   # Only add the resulting drive if the Drive ID matches or was not set
                                        $ReturnZoneColl += $MyZone
                                        $ReturnOnlyColl = $ConnectionsCol
                                    }
                            }
                    }
            } 
        }
    if ( $ReturnCollectionOnly )
        {       return $ReturnOnlyColl
        } else 
        {       return $ReturnZoneColl
        }
}
}

