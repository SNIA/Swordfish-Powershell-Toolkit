
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

