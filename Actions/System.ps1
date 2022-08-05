
function Invoke-RedfishSystemReset
{
<#
.SYNOPSIS
    Invoke a System Reset for the system that this redfish implementation represents.
.DESCRIPTION
    Invoke a System Reset for the system that this redfish implementation represents.
.PARAMETER SystemID
    The System ID name for a specific System, otherwise the command
    will be invoked on all Systems.
.PARAMETER ResetType
    This option can be set to any of the following types of resets if they are supported;
    'On', 'ForceOff','GracefulShutdown','ForceRestart','Nmi','PushPowerButton','GracefulRestart'
.NOTES
    Future updates to this command may include implementing ResetType as a dynamic parameter and
    only display the reset types that the system actually supports. 
#>   
[CmdletBinding()]
param(  [string]    $SystemID,
        [ValidateSet('On', 'ForceOff','GracefulShutdown','ForceRestart','Nmi','PushPowerButton','GracefulRestart')]
        [string]    $ResetType
     )
process
 {
    $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems") 
    $SysCollection=@()
    foreach($Sys in ($SystemData).Members )
        {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') ) 
        }
    if ( $SystemID )
            {   $MyId = ( $SysCollection | where-object { $_.id -eq $SystemId } )
            } 
        else 
            {   $MyID = ( $SysCollection )                    
            } 
    $Result=@()
    foreach ( $Sys in $MyID)
        {   if ( ($base + $Sys.'@odata.id').endswith('/') ) 
                    {   # The Dell Server doesnt have a trailing / mark, so I must add it.
                        $MyUrl = ( $base + ($Sys.'@odata.id') + 'Actions/ComputerSystem.Reset')
                    } 
                else
                    {   # The HPE server contains the trailing / mark, so dont need to add it
                        $MyUrl = ( $base + ($Sys.'@odata.id') + '/Actions/ComputerSystem.Reset')
                    }
            $MyBody = @{ 'ResetType'= $ResetType }
            $JSONBody = $MyBody | convertto-json
            $Result += invoke-restmethod2 -Method 'POST' -Uri $MyUrl -body $JSONBody
        }
    return $Result
 }
}
function Get-RedfishSystemLogEntries
{
<#
.SYNOPSIS
    Gather the various Logs from the system. 
.DESCRIPTION
    Gather the various logs from the system or identify the log names.
.PARAMETER LogName
    If a Log Name is given the set of logs will be returned, otherwise the command will return the possible names that can be used.
.PARAMETER ReturnCollectionOnly
    If specified it will return the collection of either Logs if the LogName is not specified, or the collection of events if a LogName is specified
#>   
[CmdletBinding()]
param(  [string]    $LogName,
        [switch]    $ReturnCollectionOnly
     )
process
 {  $Result = @()
    $MyLog = Get-RedfishSystemComponent -SubComponent LogServices
    foreach ( $ALog in $MyLog)
        {   if ( $ALog.id -eq $LogName )
                {   $Logodata = $ALog.'@odata.id' 
                }
        }
    if ( $Logodata )
            {   if ( -not $Logodata.endswith('/') )
                    {   $ResultCollection = Get-RedfishByURL ($Logodata + '/Entries')
                    }
                    else 
                    {   $ResultCollection = Get-RedfishByURL ($Logodata + 'Entries')
                    }
            }
        else 
            {   write-warning 'The LogName was not found in the possible logs on this machine. The possible log names are as follows;'
                (Get-RedfishSystemComponent -SubComponent LogServices).id | out-string
                return
            }
    foreach ( $AEntry in $ResultCollection.Members )
        {   $Result +=  Get-RedfishByURL ($AEntry.'@odata.id')
        }
    if ( $ReturnCollectionOnly )
            {   return $ResultCollection 
            }
        else 
            {   return $Result
            }
 }
}
function Clear-RedfishSystemLogEntries
{
<#
.SYNOPSIS
    Clear the specified Log from the system. 
.DESCRIPTION
    Clear the specified logs from the system, or identify the log names.
.PARAMETER LogName
    If a Log Name is given the set of logs will be cleared, otherwise the command will return the possible names that can be used.
#>   
[CmdletBinding()]
param(  [string]    $LogName
     )
process
 {  $Result = @()
    $MyLog = Get-RedfishSystemComponent -SubComponent LogServices
    foreach ( $ALog in $MyLog)
        {   if ( $ALog.id -eq $LogName )
                {   $Logodata = $ALog.'@odata.id' 
                }
        }
    if ( $Logodata )
            {   if ( -not $Logodata.endswith('/') )
                    {   $Result = Invoke-RestMethod2 -uri ($Base + $Logodata + '/Actions/LogService.ClearLog/') -Method 'POST'
                    }
                    else 
                    {   $Result = Invoke-RestMethod2 -uri ($Base + $Logodata + 'Actions/LogService.ClearLog/') -Method 'POST'
                    }
            }
        else 
            {   write-warning 'The LogName was not found in the possible logs on this machine. The possible log names are as follows;'
                (Get-RedfishSystemComponent -SubComponent LogServices).id | out-string
                return
            }
    return $Result
        
 }
}
