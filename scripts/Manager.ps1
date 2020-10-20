function Get-SwordfishManager{
<#
.SYNOPSIS
    Retrieve The list of valid Zones from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Zone objects that exist across all of the 
    Storage Systems, unless a specific Storage system ID is used to limit it, or a specific Zone ID 
    is directly requested. Zones are commonly used to group endpoints. 
.PARAMETER ManagerId
    The ManagerID name for a specific Storage System to query, otherwise the command will return all managers 
    defined in the /redfish/v1/Managers/{Managerid}/.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set.
.EXAMPLE
    Get-SwordfishManager -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#ManagerCollection.ManagerCollection
    @odata.type         : #ManagerCollection.ManagerCollection
    @odata.id           : /redfish/v1/Managers
    Name                : Manager Collection
    Members@odata.count : 2
    Members             : {@{@odata.id=/redfish/v1/Managers/controller_a}, @{@odata.id=/redfish/v1/Managers/controller_b}}
.EXAMPLE
    Get-SwordfishManager

    @odata.context     : /redfish/v1/$metadata#Manager.Manager
    @odata.id          : /redfish/v1/Managers/controller_a
    @odata.type        : #Manager.v1_3_1.Manager
    Id                 : controller_a
    Name               : management_controller_a
    ManagerType        : ManagementController
    FirmwareVersion    : IN100R003
    Status             : @{State=Enabled; Health=OK}
    EthernetInterfaces : @{@odata.id=/redfish/v1/Managers/controller_a/EthernetInterfaces}

    @odata.context     : /redfish/v1/$metadata#Manager.Manager
    @odata.id          : /redfish/v1/Managers/controller_b
    @odata.type        : #Manager.v1_3_1.Manager
    Id                 : controller_b
    Name               : management_controller_b
    ManagerType        : ManagementController
    FirmwareVersion    : IN100R003
    Status             : @{State=Enabled; Health=OK}
    EthernetInterfaces : @{@odata.id=/redfish/v1/Managers/controller_b/EthernetInterfaces}
.EXAMPLE
    Get-SwordfishManager -ManagerID controller_a

    @odata.context     : /redfish/v1/$metadata#Manager.Manager
    @odata.id          : /redfish/v1/Managers/controller_a
    @odata.type        : #Manager.v1_3_1.Manager
    Id                 : controller_a
    Name               : management_controller_a
    ManagerType        : ManagementController
    FirmwareVersion    : IN100R003
    Status             : @{State=Enabled; Health=OK}
    EthernetInterfaces : @{@odata.id=/redfish/v1/Managers/controller_a/EthernetInterfaces}
.LINK
    http://redfish.dmtf.org/schemas/v1/Manager.v1_10_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='Default')]                 [string]    $ManagerID,
      
        [Parameter(ParameterSetName='ReturnCollectionOnly')]    [Switch]    $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {   'ReturnCollectionOnly'  {   [array]$DefMgrCol = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Managers" ) 
                                        return $DefMgrCol
                                    }
            'Default'               {   # $CollectionSet = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Managers" )
                                        foreach ( $MgrLink in ( Get-SwordfishManager -ReturnCollectionOnly ).members )
                                            {   $Mgr = Invoke-RestMethod2 -uri ( $base + ( $MgrLink.'@odata.id' ) )
                                                [array]$DefMgrCol += $Mgr 
                                            }
                                        if ( $ManagerID )
                                            {   return ( $DefMgrCol | Where-Object { $_.id -eq "$ManagerID" } )
                                            } else
                                            {   return ( $DefMgrCol )
                                            }
                                    }
        }
}
}
