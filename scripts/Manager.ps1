function Get-SwordfishManager{
<#
.SYNOPSIS
    Retrieve The list of valid Managers from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Manager objects that exist across all of the 
    Storage Systems, unless a specific ID is used to limit it. 
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

function Get-RedfishManager{
    <#
    .SYNOPSIS
        Retrieve The list of valid Managers from the RedFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of Manager objects that exist across the Target, 
        unless a specific manager ID is used to limit it. 
    .PARAMETER ManagerId
        The ManagerID name for a specific Manager to query, otherwise the command will return all managers 
        defined in the /redfish/v1/Managers/{Managerid}/.
    .PARAMETER ReturnCollectioOnly
        This switch will return the collection instead of a Manager of the actual objects if set.
    .EXAMPLE
        Get-RedfishManager -ReturnCollectionOnly

        @odata.context      : /redfish/v1/$metadata#ManagerCollection.ManagerCollection
        @odata.etag         : W/"AA6D42B0"
        @odata.id           : /redfish/v1/Managers/
        @odata.type         : #ManagerCollection.ManagerCollection
        Description         : Managers view
        Name                : Managers
        Members             : {@{@odata.id=/redfish/v1/Managers/1/}}
        Members@odata.count : 1

    .EXAMPLE
        Get-RedfishManager
        @odata.context      : /redfish/v1/$metadata#Manager.Manager
        @odata.etag         : W/"E7CD8052"
        @odata.id           : /redfish/v1/Managers/1/
        @odata.type         : #Manager.v1_5_1.Manager
        Id                  : 1
        Actions             : @{#Manager.Reset=}
        CommandShell        : @{ConnectTypesSupported=System.Object[]; MaxConcurrentSessions=9; ServiceEnabled=True}
        DateTime            : 2021-09-10T20:56:35Z
        DateTimeLocalOffset : +00:00
        EthernetInterfaces  : @{@odata.id=/redfish/v1/Managers/1/EthernetInterfaces/}
        FirmwareVersion     : iLO 5 v2.10
        GraphicalConsole    : @{ConnectTypesSupported=System.Object[]; MaxConcurrentSessions=10; ServiceEnabled=True}
        HostInterfaces      : @{@odata.id=/redfish/v1/Managers/1/HostInterfaces/}
        Links               : @{ManagerInChassis=; ManagerForServers=System.Object[]; ManagerForChassis=System.Object[]}
        LogServices         : @{@odata.id=/redfish/v1/Managers/1/LogServices/}
        ManagerType         : BMC
        Model               : iLO 5
        Name                : Manager
        NetworkProtocol     : @{@odata.id=/redfish/v1/Managers/1/NetworkProtocol/}
        Oem                 : @{Hpe=}
        SerialConsole       : @{ConnectTypesSupported=System.Object[]; MaxConcurrentSessions=13; ServiceEnabled=True}
        Status              : @{Health=OK; State=Enabled}
        UUID                : 36b9473d-6492-5b76-bb1d-d9f530a8957a
        VirtualMedia        : @{@odata.id=/redfish/v1/Managers/1/VirtualMedia/}
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
    
function Get-SwordfishManagerComponent
{
    <#
    .SYNOPSIS
        Retrieve The list of valid Managers from the Swordfish Target.
    .DESCRIPTION
        This command will either return the a complete collection of Manager objects that exist across all of the 
        Storage Systems, unless a specific Storage system ID is used to limit it. 
    .PARAMETER ManagerId
        The ManagerID name for a specific Storage System to query, otherwise the command will return all managers 
        defined in the /redfish/v1/Managers/{Managerid}/.
    .PARAMETER SubComponent

    .PARAMETER ReturnCollectioOnly
        This switch will return the collection instead of an array of the actual objects if set.
    .EXAMPLE

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

    .LINK
        http://redfish.dmtf.org/schemas/v1/Manager.v1_10_0.json
    #>   
    [CmdletBinding(DefaultParameterSetName='Default')]
    param(  [Parameter(ParameterSetName='ReturnCollectionOnly')]    [Switch]    $ReturnCollectionOnly,  
        
            [ValidateSet ('CommandShell', 'EthernetInterfaces', 'GraphicalConsole', 'HostInterfaces', 'LogServices', 
                            'NetworkProtocol', 'SerialConsole', 'Status', 'VirtualMedia')]
                                                                    [string]    $SubComponent
         )
    process
    {   [array]$DefMgrCol = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Managers" )
            $MyComponent = @()
            $MyCollection = @()
            $MyMgr = @()
            foreach( $Mgr in $DefMgrCol.'Members' )
                {   $MyMgr += invoke-restmethod2 -uri ( $Base + $Mgr.'@odata.id' )
                    $X += $MyMgr."$SubComponent"
                    $Y += invoke-restmethod2 -uri ( $Base + ($MyMgr."$SubComponent").'@odata.id' )
                    if ( $Y )
                            {   if ( $Y.'Members@odata.count' )
                                        {   $MyCollection += $Y
                                            $Z=@()
                                            foreach ( $SubItem in ($Y.'Members') )
                                                {   $Z += invoke-restmethod2 -uri ( $Base + $SubItem.'@odata.id' )
                                                }
                                            $MyComponent += $Z
                                        } 
                                    else 
                                        {   $MyComponent += $Y
                                        }
                            }
                        else
                            {   $MyComponent += $x
                            }
                }
            if ( $ReturnCollectionOnly )
                    {   return $MyCollection
                    } 
                else
                    {   return $MyComponent
                    }
    }    
}

function Get-RedfishManagerComponent
{
    <#
    .SYNOPSIS
        Retrieve The list of Managers from the Redfish Target.
    .DESCRIPTION
        This command will either return the a complete collection of Manager objects that exist across all of the 
        Systems, unless a specific ID is used to limit it. 
    .PARAMETER ManagerId
        The ManagerID name for a specific Storage System to query, otherwise the command will return all managers 
        defined in the /redfish/v1/Managers/{Managerid}/.
    .PARAMETER SubComponent
        These can be any of the following; 'CommandShell', 'EthernetInterfaces', 'GraphicalConsole', 'HostInterfaces', 'LogServices', 
        'NetworkProtocol', 'SerialConsole', 'Status', 'VirtualMedia'. If that subcomponent does not exist, nothing will be returned.
    .PARAMETER ReturnCollectioOnly
        This switch will return the collection instead of an array of the actual objects if set.
    .EXAMPLE

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

    .LINK
        http://redfish.dmtf.org/schemas/v1/Manager.v1_10_0.json
    #>   
    [CmdletBinding(DefaultParameterSetName='Default')]
    param(  [Parameter(ParameterSetName='ReturnCollectionOnly')]    [Switch]    $ReturnCollectionOnly,  
        
            [ValidateSet ('CommandShell', 'EthernetInterfaces', 'GraphicalConsole', 'HostInterfaces', 'LogServices', 
                            'NetworkProtocol', 'SerialConsole', 'Status', 'VirtualMedia')]
                                                                    [string]    $SubComponent
         )
    process
    {   [array]$DefMgrCol = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Managers" )
            $MyComponent = @()
            $MyCollection = @()
            $MyMgr = @()
            foreach( $Mgr in $DefMgrCol.'Members' )
                {   $MyMgr += invoke-restmethod2 -uri ( $Base + $Mgr.'@odata.id' )
                    $X += $MyMgr."$SubComponent"
                    $Y += invoke-restmethod2 -uri ( $Base + ($MyMgr."$SubComponent").'@odata.id' )
                    if ( $Y )
                            {   if ( $Y.'Members@odata.count' )
                                        {   $MyCollection += $Y
                                            $Z=@()
                                            foreach ( $SubItem in ($Y.'Members') )
                                                {   $Z += invoke-restmethod2 -uri ( $Base + $SubItem.'@odata.id' )
                                                }
                                            $MyComponent += $Z
                                        } 
                                    else 
                                        {   $MyComponent += $Y
                                        }
                            }
                        else
                            {   $MyComponent += $x
                            }
                }
            if ( $ReturnCollectionOnly )
                    {   return $MyCollection
                    } 
                else
                    {   return $MyComponent
                    }
    }    
}
