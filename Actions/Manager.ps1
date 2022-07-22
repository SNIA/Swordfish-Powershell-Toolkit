
function Set-RedfishManager
{
<#
.SYNOPSIS
    Invoke a change for the management subsystem for the system that this redfish implementation represents.
.DESCRIPTION
    Invoke a System Reset for the system that this redfish implementation represents.
.PARAMETER CommandShellServiceEnabled
    An indication of whether the service is enabled for this manager.
.PARAMETER DateTimeLocalOffset
    The time offset from UTC that the DateTime property is in +HH:MM format.
.PARAMETER AutoDSTEnabled
    An indication of whether the manager is configured for automatic Daylight
Saving Time (DST) adjustment. Introduced in Redfish v1.4
.PARAMETER DateTime
    The current date and time with UTC offset of the manager
.PARAMETER TimeZoneName
    The time zone of the manager. Introduced in Redfish v1.10.
.PARAMETER GraphicConsoleServiceEnabled
    An indication of whether the service is enabled for this manager.
.PARAMETER SerialConsoleServiceEnabled
    An indication of whether the service is enabled for this manager. Introduced in Redfish v1.10
.PARAMETER LocationIndicatorActive
    An indicator allowing an operator to physically locate this resource. Introduced in Redfish v1.11.
.PARAMETER ServiceIndication
    A product instance identifier displayed in the Redfish service root. Introduced in Redfish v1.15.

.NOTES
#>   
[CmdletBinding()]
param(  [boolean]   $CommandShellServiceEnabled,
        [string]    $DateTimeLocalOffset,
        [boolean]   $AutoDSTEnabled,
        [string]    $DateTime,
        [string]    $TimeZoneName,
        [boolean]   $GraphicConsoleServiceEnabled,
        [boolean]   $SerialConsoleServiceEnabled,
        [boolean]   $LocationIndicatorActive,
        [boolean]   $ServiceIndication
        
)
process
 {  $SystemData = Get-RedfishManager
    if ( $PSBoundParameters.ContainsKey('CommandShellServiceEnabled'))
        {    if ( ($SystemData).CommandShell )
                    {   $MyBody = @{  CommandShell = @{   ServiceEnabled = $CommandShellServiceEnabled 
                                                      } 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No CommandShell section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('DateTimeLocalOffset'))
        {   if ( ($SystemData).DateTimeLocalOffset )
                    {   $MyBody = @{  DateTimeOffset = $DateTimeLocalOffset 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No DateTime Local Offset section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('AutDSTEnabled') )
        {   if ( ($SystemData).AutDSTEnabled )
                    {   $MyBody = @{  AutDSTEnabled = $AutDSTEnabled 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No AutoDSTEnabled section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('DateTime') )
        {   if ( ($SystemData).DateTime )
                    {   $MyBody = @{  DateTime = $DateTime 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No DateTime section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('GraphicConsoleServiceEnabled') )
        {   if ( ($SystemData).GraphicConsole )
                    {    $MyBody = @{  GraphicalConsole = @{   ServiceEnabled = $GraphicConsoleServiceEnabled 
                                                           } 
                                    }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No Graphical Console section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('LocationIndicatorActive') )
        {   if ( ($SystemData).LocationIndicatorActive )
                    {   $MyBody = @{  LocationIndicatorActive = $LocationIndicatorActive 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No DateTime section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('SerialConsoleServiceEnabled'))
        {    if ( ($SystemData).SerialConsole )
                    {   $MyBody = @{  SerialConsole = @{   ServiceEnabled = $Enabled 
                                                      } 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No Serial Console section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('ServiceIndication') )
        {   if ( ($SystemData).LocationIndicatorActive )
                    {   $MyBody = @{  ServiceIndication = $ServiceIndication 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No ServiceIndication section found for this manager"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('TimeZoneName') )
        {   if ( ($SystemData).TimeZoneName )
                    {   $MyBody = @{  TimeZoneName = $TimeZoneName 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No TimeZoneName section found for this manager"
                        return
                    }
            return $Result
        }
 }
}

Function Invoke-RedfishManagerReset
{
<#
.SYNOPSIS
    This command will reset the Redfish Manager for this system. 
.DESCRIPTION
    You may reset the Redfish Manager on the system using this action. However issue the command
    (Get-RedfishManager).Actions | convertTo-Json to see what the value values for the reset type are.
.PARAMETER ResetType
    This is the type of reset that is sent requested of the Redfish manager. 
    The possible values of this may be 'ForceOff','ForceOn','ForceRestart','GracefulRestart',
    'GracefulShutdown','Nmi','On','Pause','PowerCycle','PushPowerButton','Resume','Suspend'
    although not all of these may be valid for your target.
.NOTES
https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf section 6.53.4.3
#>   
[CmdletBinding()]
param(  [ValidateSet('ForceOff','ForceOn','ForceRestart','GracefulRestart','GracefulShutdown',
                     'Nmi','On','Pause','PowerCycle','PushPowerButton','Resume','Suspend')]
        [string]    $ResetType
     )
process
    {   $SystemData = Get-RedfishManager
        $MyURL = ((($SystemData).Actions).'#Manager.Reset').Target
        if ( $MyURL )
                {   $MyBody = @{  ResetType = $ResetType 
                               }
                    $Result = invoke-restmethod2 -uri ( $base + $MyURL) -body $MyBody -Method 'POST'
                }  
            else 
                {   write-error "No Action called Reset found in the Manager"
                    return
                }
        return $Result
    }
}
Function Invoke-RedfishManagerForceFailover
{
<#
.SYNOPSIS
    This command will Force failover the manager to another Redfish Manager for this system. 
.DESCRIPTION
    You may force failover the Redfish Manager on the system using this action. However issue the command
    (Get-RedfishManager).Actions | convertTo-Json to see if this command is supported and what the valid parameter options are.
.PARAMETER NewManagerODataId
    This must be a string that lookes like '/redfish/v1/Managers/3'
.NOTES
https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf section 6.53.4.1
#>   
[CmdletBinding()]
param(  [string]    $NewManagerODataId
     )
process
    {   $SystemData = Get-RedfishManager
        $MyURL = ((($SystemData).Actions).'#Manager.ForceFailover').Target
        if ( $MyURL )
                {   $MyBody = @{  NewManager = @{   '@odata.id' = $NewManagerODataId
                                                } 
                               }
                    $Result = invoke-restmethod2 -uri ( $base + $MyURL) -body $MyBody -Method 'POST'
                }  
            else 
                {   write-error "No Action called ForceFailover found in the Manager"
                    return
                }
        return $Result
    }
}
Function Invoke-RedfishManagerModifyRedundancySet
{
<#
.SYNOPSIS
    This command will Modify the failover manager redundancy set  for this system. 
.DESCRIPTION
    You may force failover the Redfish Manager on the system using this action. However issue the command
    (Get-RedfishManager).Actions | convertTo-Json to see if this command is supported and what the valid parameter options are.
.PARAMETER NewManagerODataId
    This must be a string that lookes like '/redfish/v1/Managers/3'
.NOTES
https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf section 6.53.4.1
#>   
[CmdletBinding()]
param(  [string]    $AddODataId,
        [String]    $RemoveODataId
     )
process
    {   $SystemData = Get-RedfishManager
        $MyURL = ((($SystemData).Actions).'#Manager.ModifyRedundancySet').Target
        if ( $MyURL )
                {   $MyBody = @()
                    if ( $AddODataId )
                        {   $MyBody += @{ Add = @{ '@odata.id' = $AddODataId
                                                 }
                                        }
                        } 
                    if ( $RemoveODataId )
                        {   $MyBody += @{ Remove = @{ '@odata.id' = $AddODataId
                                                    }
                                        }
                        } 
                    if ( $AddODataId -or $RemoveODataId )
                            {    $Result = invoke-restmethod2 -uri ( $base + $MyURL) -body $MyBody -Method 'POST'
                            }  
                        else
                            {   write-warning "You Must choose to either add or remove (or both) a new item for this command to work"
                            }
                }
            else
                {   write-error "No Action called ForceFailover found in the Manager"
                    return
                }
        return $Result
    }
}
