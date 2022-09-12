
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
function Set-RedfishSystemBoot
{
<#
.SYNOPSIS
    This command will return a collection of possible Boot options for this system.
.DESCRIPTION
    The list of all possible boot sources for this system will be returned as a collection of objects.
    The list of boot options may be used either for regular boot options or Uefi boot options.
.PARAMETER ComputerSystemID
    If the redfish endpoint reflects multiple systems, you can restict the response to a single system by specifying a single system ID
.PARAMETER AliasBootOrder
    Ordered array of boot source aliases representing the persistent boot order associated with this computer system. For the possible 
    property values see allowable values, the following are the complete list: BiosSetup, Cd, Diags, Floppy, Hdd, None, Pxe, RemoteDrive, 
    SDCard, UefiBootNext, UefiHttp, UefiShell, UefiTarget, Usb, Utilities.
.PARAMETER AutomaticRetryAttempts
    The number of attempts the system will automatically retry booting.
.PARAMETER AutomaticRetryConfig
    The configuration of how the system retries booting automatically. For the
    possible property values only the following are valid; Disables, RetryAlways, RetryAttempts.
.PARAMETER BootNext
    The BootOptionReference of the Boot Option to perform a one-time boot
    from when BootSourceOverrideTarget is UefiBootNext .
.PARAMETER BootOrder
    An array of BootOptionReference strings that represent the persistent boot
    order for with this computer system.
.PARAMETER BootOrderPropertySelection
    The name of the boot order property that the system uses for the persistent boot order. For the possible property values only the following 
    may be valid; AliasBootOrder, BootOrder.
.PARAMETER BootSourceOverrideEnabled 
    The state of the boot source override feature. For the possible property values, Only the following are valid options; Continuouis, Disabled, Once
.PARAMETER BootSourceOverrideMode 
    The BIOS boot mode to use when the system boots from the BootSourceOverrideTarget boot source. For the possible property values; Legacy, UEFI
.PARAMETER BootSourceOverrideTarget
    The current boot source to use at the next boot instead of the normal boot device, if BootSourceOverrideEnabled is true . For the possible 
    property values see allowable values, the following are the complete list: BiosSetup, Cd, Diags, Floppy, Hdd, None, Pxe, RemoteDrive, 
    SDCard, UefiBootNext, UefiHttp, UefiShell, UefiTarget, Usb, Utilities.
.PARAMETER HttpBootUri
    The URI to boot from when BootSourceOverrideTarget is set to UefiHttp .
.PARAMETER StopBootOnFault
    If the boot should stop on a fault. For the possible property values, use; AnyFault or Never.
.PARAMETER TrustedModuleRequiredToBoot
    The Trusted Module boot requirement. For the possible property values, use; Disabled or Required
.PARAMETER UefiTargetBootSourceOverride 
    The UEFI device path of the device from which to boot when BootSourceOverrideTarget is UefiTarget 
.LINK
    https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
#>   
[CmdletBinding()]
    param(                                                                  [string]    $SystemID,
            [ValidateSet('BiosSetup', 'Cd', 'Diags', 'Floppy', 'Hdd', 
            'None', 'Pxe', 'RemoteDrive', 'SDCard', 'UefiBootNext', 
            'UefiHttp', 'UefiShell', 'UefiTarget', 'Usb', 'Utilities')]     [string]    $AliasBootOrder,
                                                                            [int]       $AutomaticRetryAttempts,
            [ValidateSet('Disables', 'RetryAlways', 'RetryAttempts')]       [string]    $AutomaticRetryConfig,
                                                                            [string]    $BootNext,
                                                                            [array]     $BootOrder,
            [ValidateSet('AliasBootOrder','BootOrder')]                     [string]    $BootOrderPropertySelection,
            [ValidateSet('Continuouse','Disabled','Once')]                  [string]    $BootSourceOverrideEnabled,
            [ValidateSet('Legacy','UEFI')]                                  [string]    $BootSourceOverrideMode,
            [ValidateSet('BiosSetup', 'Cd', 'Diags', 'Floppy', 'Hdd', 
            'None', 'Pxe', 'RemoteDrive', 'SDCard', 'UefiBootNext', 
            'UefiHttp', 'UefiShell', 'UefiTarget', 'Usb', 'Utilities')]     [string]    $BootSourceOverrideTarget,
                                                                            [string]    $HttpBootUri,
            [ValidateSet('AnyFault','Never')]                               [string]    $StopBootOnFault,

            [ValidateSet('Required','Disabled')]                            [string]    $TrustedModuleRequiredToBoot,

                                                                            [string]    $UefiTargetBootSourceOverride 
         )
    process{
        $NoCollectionExists=$False
        $SysCollection=@()
        $SecondOrderData=@()
        $BBody = @()
        if ( $PSBoundParameters.ContainsKey('AliasBootOrder'))              {    $BBody += @{ AliasBootOrder                = $AliasBootOrder               } }
        if ( $PSBoundParameters.ContainsKey('AutomaticRetryAttempts'))      {    $BBody += @{ AutomaticRetryAttempts        = $AutomaticRetryAttempts       } }
        if ( $PSBoundParameters.ContainsKey('AutomaticRetryConfig'))        {    $BBody += @{ AutomaticRetryConfig          = $AutomaticRetryConfig         } }
        if ( $PSBoundParameters.ContainsKey('BootNext'))                    {    $BBody += @{ BootNext                      = $BootNext                     } }
        if ( $PSBoundParameters.ContainsKey('BootOrder'))                   {    $BBody += @{ BootOrder                     = $BootOrder                    } }
        if ( $PSBoundParameters.ContainsKey('BootOrderPropertySelection'))  {    $BBody += @{ BootOrderPropertySelection    = $BootOrderPropertySelection   } }
        if ( $PSBoundParameters.ContainsKey('BootSourceOverrideEnabled'))   {    $BBody += @{ BootSourceOverrideEnabled     = $BootSourceOverrideEnabled    } }
        if ( $PSBoundParameters.ContainsKey('BootSourceOverrideMode'))      {    $BBody += @{ BootSourceOverrideMode        = $BootSourceOverrideMode       } }
        if ( $PSBoundParameters.ContainsKey('BootSourceOverrideTarget'))    {    $BBody += @{ BootSourceOverrideTarget      = $BootSourceOverrideTarget     } }
        if ( $PSBoundParameters.ContainsKey('HttpBootUri'))                 {    $BBody += @{ HttpBootUri                   = $HttpBootUri                  } }
        if ( $PSBoundParameters.ContainsKey('StopBootOnFault'))             {    $BBody += @{ StopBootOnFault               = $StopBootOnFault              } }
        if ( $PSBoundParameters.ContainsKey('TrustedModuleRequiredToBoot')) {    $BBody += @{ TrustedModuleRequiredToBoot   = $TrustedModuleRequiredToBoot  } }
        if ( $PSBoundParameters.ContainsKey('UefiTargetBootSourceOverride')){    $BBody += @{ $UefiTargetBootSourceOverride = $UefiTargetBootSourceOverride } }        
        foreach($Sys in Get-RedfishSystem )
            {   $SysCollection +=  Get-RedfishByURL -URL ($Sys.'@odata.id')  
            }
        if ( $SystemID )
                    {   $FirstOrderData = $SysCollection | where-object { $_.id -eq $SystemId } 
                    } else 
                    {   $FirstOrderData = $SysCollection                     
                    }     
        if ( $FirstOrderData )
                {   $Result = Set-RedfishByURL -URL (($FirstOrderData).'@odata.id') -Body $BBody
                    return $Results
                } 
            else
                {   return
                }
    }
}