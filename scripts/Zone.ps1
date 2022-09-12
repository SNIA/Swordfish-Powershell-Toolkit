function Get-SwordfishZone{
<#
.SYNOPSIS
    Retrieve The list of valid Zones from the Swordfish Target.
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
    PS:> Get-SwordfishZone

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
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByFabricID')]          [string]    $FabricID,

        [Parameter(ParameterSetName='ByFabricID')]
        [Parameter(ParameterSetName='Default')]             [string]    $ZoneId,

        [Parameter(ParameterSetName='ByFabricID')]        
        [Parameter(ParameterSetName='Default')]             [Switch]    $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
    {   'Default'       {   foreach ( $FabID in (Get-SwordfishFabric).id )
                                {   [array]$DefZoneCol += Get-SwordfishZone -FabricID $FabID -ReturnCollectionOnly:$ReturnCollectionOnly
                                }
                            if ( $ZoneID )
                                {   return ( $DefZoneCol | where-object {$_.id -eq $ZoneId} ) 
                                } else 
                                {   return $DefZoneCol
                                } 
                        }
        'ByFabricID'    {   $PulledData = Get-SwordfishFabric           -FabricID $FabricID
                        }
    }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $EPMemberOrCollection = $PulledData.Zones
            foreach ( $EPorEPC in $Memberset )
                {   $EPColOrEP = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
                    if ( $EPColOrEP.Members ) 
                        {   $EPMemberOrCollection = $EPColOrEP.Members    
                        }
                    [Array]$FullZoneCollectionOnly += $EPColOrEP
                    foreach ( $MyEPData in $EPMemberOrCollection )
                        {   [array]$FullZoneCollection += Invoke-RestMethod2 -uri ( $base + ($MyEPData.'@odata.id') )                          
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return $FullZoneCollectionOnly
                } else 
                {   if ( $ZoneID)
                        {   return $FullZoneCollection | where-object { $_.id -eq $ZoneID }
                        } else 
                        {   return $FullZoneCollection
}}      }       }       }            