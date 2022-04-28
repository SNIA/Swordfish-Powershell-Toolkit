function Get-SwordfishEthernetInterface
{
<#
.SYNOPSIS
    Retrieve The list of valid Endpoint from the Swordfish or Redfish Targets.
.DESCRIPTION
    This command will either return the a complete collection of Ethernet Interface objects that exist across all of the 
    Storage Services or Systems, unless a specific ID is used to limit it, or a specific Ethernet Interface ID 
    is directly requested.
.PARAMETER StorageId
    The StorageID name for a specific Storage System to query, otherwise the command will return all Ethernet Interfaces 
    defined in the /redfish/v1/Storage/{Storageid}/Endpoints.
.PARAMETER StorageServiceId
    The StorageServiceID name for a specific Storage Service to query, otherwise the command will return all Ethernet Interfaces 
    defined in the /redfish/v1/StorageService/{Storageid}/Endpoints.
.PARAMETER EthernetInterfaceId
    The Ethernet Interface Id will limit the returned data to ONLY the single Interface specified.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the 
    actual objects if set to true.
.EXAMPLE
    Get-SwordfishEthernetInterface

    @odata.context      : /redfish/v1/$metadata#EthernetInterface.EthernetInterface
    @odata.type         : #EthernetInterface.v1_5_1.EthernetInterface
    @odata.id           : /redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/A
    Name                : Manager Ethernet Interface
    Id                  : A
    InterfaceEnabled    : True
    Status              : @{State=Enabled; Health=OK}
    PermanentMACAddress : 00:c0:ff:50:43:7d
    IPv4Addresses       : {@{Address=192.168.100.98; SubnetMask=255.255.255.0; Gateway=192.168.100.1}}

    @odata.context      : /redfish/v1/$metadata#EthernetInterface.EthernetInterface
    @odata.type         : #EthernetInterface.v1_5_1.EthernetInterface
    @odata.id           : /redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/B
    Name                : Manager Ethernet Interface
    Id                  : B
    InterfaceEnabled    : True
    Status              : @{State=Enabled; Health=OK}
    PermanentMACAddress : 00:c0:ff:50:43:92
    IPv4Addresses       : {@{Address=192.168.100.99; SubnetMask=255.255.255.0; Gateway=192.168.100.1}}
.EXAMPLE
    Get-SwordfishEthernetInterface -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#EthernetInterfaceCollection.EthernetInterfaceCollection
    @odata.type         : #EthernetInterfaceCollection.EthernetInterfaceCollection
    @odata.id           : /redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces
    Name                : EthernetInterface Collection
    Members@odata.count : 2
    Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/A}, @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/B}}
.EXAMPLE
    Get-SwordfishEthernetInterface -ReturnCollectionOnly | convertto-JSON

    {   "@odata.context":  "/redfish/v1/$metadata#EthernetInterfaceCollection.EthernetInterfaceCollection",
        "@odata.type":  "#EthernetInterfaceCollection.EthernetInterfaceCollection",
        "@odata.id":  "/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces",
        "Name":  "EthernetInterface Collection",
        "Members@odata.count":  2,
        "Members":  [
                        {
                            "@odata.id":  "/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/A"
                        },
                        {
                            "@odata.id":  "/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces/B"
                        }
                    ]
    }
.LINK
    https://redfish.dmtf.org/schemas/v1/EthernetInterface.v1_6_2.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='BySystemID')]          [string]    $SystemID,
        [Parameter(ParameterSetName='ByStorageID')]         [string]    $StorageID,
        [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,

        [Parameter(ParameterSetName='ByStorageID')]
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [string]    $EthernetInterfaceId,

        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='ByStorageID')]        
        [Parameter(ParameterSetName='BySystemID')]        
        [Parameter(ParameterSetName='Default')]             [switch]   $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {   'Default'           {   foreach ( $SystID in (Get-SwordfishSystem).id )
                                        {   [array]$DefEISet += Get-SwordfishEthernetInterface -SystemID $SystID        -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $StorID in (Get-SwordfishStorage).id )
                                        {   [array]$DefEISet += Get-SwordfishEthernetInterface -StorageID $StorID       -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefEISet += Get-SwordfishEthernetInterface -StorageServiceID $SSID  -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $EthernetInterfaceId )
                                        {   return ( $DefEISet | where-object { $_.id -eq $EthernetInterfaceId } ) 
                                        } else 
                                        {   return ( $DefEISet )
                                        } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
            'ByStorageID'       {   $PulledData = Get-SwordfishStorage -StorageID $StorageID
                                }
            'BySystemID'        {   $PulledData = Get-SwordfishSystem -SystemID $SystemID
                                }
        }
    $FullEISet=@()
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $EIMemberOrCollection = $PulledData.EthernetInterfaces
            foreach ( $EIorEIC in $Memberset )
                {   $EIColOrEI = Invoke-RestMethod2 -uri ( $base + ( $EIorEIC.'@odata.id' ) )
                    if ( $EIColOrEI.Members ) 
                        {   $EIMemberOrCollection = $EIColOrEI.Members    
                        }
                    [array]$FullEICollectionOnly   += $EIColOrEI
                    foreach ( $MyEIData in $EIMemberOrCollection )
                        {   [array]$FullEISet += Invoke-RestMethod2 -uri ( $base + ($MyEIData.'@odata.id') )
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return ( $FullEICollectionOnly | get-unique )
                } else 
                {   if ( $EthernetInterfaceID )
                        {   return $FullEISet | where-object { $_.id -eq $EthernetInterfaceID }
                        } else 
                        {   return ( $FullEISet ) 
}}      }       }       
}   
Set-Alias -Name 'Get-RedfishEthernetInterface' -value 'Get-SwordfishEthernetInterface'
