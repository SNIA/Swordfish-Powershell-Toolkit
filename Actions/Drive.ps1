Function Set-RedfishDrive
{
<#
.SYNOPSIS
    Modifies the values for the Drive specified by the Drive ID.
.DESCRIPTION
    Modifies the values for the Drive specified by the Drive ID.
.PARAMETER DriveId
    You must specify a Drive id
.PARAMETER AssetTag
    This property shall track the drive for inventory purposes.
.PARAMETER HotspareReplacementMode
    This property shall indicate whether a commissioned hot spare continues to serve as a hot spare after the 
    failed drive is replaced.
.PARAMETER HotspareType
    This property shall contain the hot spare type for the associated drive.  If the drive currently serves as a 
    hot spare, its Status.State field shall be 'StandbySpare' and 'Enabled' when it is part of a volume.", 
.PARAMETER LocationIndicatorActive
    Controls the LED to assist an operating in physically finding the Drive in the chassis.
.LINK
    https://github.com/DMTF/Redfish/blob/master/json-schema/Drive.v1_8_5.json
#>   
[CmdletBinding()]
param(  [parameter(Mandatory=$true)][string]    $DriveId,
                                    [string]    $AssetTag,
        [ValidateSet('NonRevertible','Revertible')]
                                    [String]    $HotspareReplacementMode,
        [ValidateSet('Chassis','Dedicated','Global',',None')]
                                    [string]    $HotspareType,
                                    [boolean]   $LocationIndicatorActive,
                                    [boolean]   $WriteCacheEnabled
     )
process 
{   if ( Get-RedfishDrive -DriveID $DriveId )
        {   $CBody = @()
            if ( $PSBoundParameters.ContainsKey('AssetTag'))                { $CBody += @{ AssetTag                 = $AssetTag                 } }
            if ( $PSBoundParameters.ContainsKey('HotspareReplacementMode')) { $CBody += @{ HotspareReplacementMode  = $HotspareReplacementMode  } }
            if ( $PSBoundParameters.ContainsKey('HotspareType'))            { $CBody += @{ HotspareType             = $HotspareType             } }
            if ( $PSBoundParameters.ContainsKey('LocagtionIndicatorActive')){ $CBody += @{ LocagtionIndicatorActive = $LocagtionIndicatorActive } }
            if ( $PSBoundParameters.ContainsKey('WriteCacheEnabled'))       { $CBody += @{ WriteCacheEnabled        = $WriteCacheEnabled        } }
            $CData = Get-RedfishDrive -DriveId $DriveId
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' ) -body $MyBody -Method 'POST'
            return $Result
        }
        else 
        {   write-error "The Drive Specified was not found."
        }
}
}

Function Reset-RedfishDrive
{
<#
.SYNOPSIS
    An Action that will Reset the Drive specified by the Drive ID.
.DESCRIPTION
    An Action that will Reset the Drive specified by the Drive ID.
.PARAMETER DriveId
    You must specify a Drive id
.PARAMETER ResetType
    This property shall describe the method of reset supported, valid values are ForceOff',
    'ForceOn','ForceRestart','GracefulRestart','GracefulShutdown','Nmi','On','Pause','PowerCycle',
    'PushPowerButton' However your target may only support a subset.
.LINK
    https://github.com/DMTF/Redfish/blob/master/json-schema/Drive.v1_8_5.json
#>   
[CmdletBinding()]
param(  [parameter(Mandatory=$true)][string]    $DriveId,
        [parameter(Mandatory=$true)][string]
        [ValidateSet('ForceOff','ForceOn','ForceRestart','GracefulRestart','GracefulShutdown',
                     'Nmi','On','Pause','PowerCycle','PushPowerButton')]
                                    [string]    $ResetType
     )
process 
{   if ( Get-RedfishDrive -DriveID $DriveId )
        {   $CBody = @( ResetType = $ResetType )
            $CData = Get-RedfishDrive -DriveId $DriveId
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' + '/Actions/Drive.Reset' ) -body $MyBody -Method 'POST'
            return $Result
        }
        else 
        {   write-error "The Drive Specified was not found."
        }
}
}

Function Invoke-RedfishDriveSecureErase
{
<#
.SYNOPSIS
    An Action that will Reset the Drive specified by the Drive ID.
.DESCRIPTION
    An Action that will Reset the Drive specified by the Drive ID.
.PARAMETER DriveId
    You must specify a Drive id
.PARAMETER OverwritePasses
    This property shall describe the required number of passes to overwrite the drive if performing an 
    overwriting type operation.
.PARAMETER SanitizationType
    The type of data sanitization to perform. The values may be 'BlockErase', 'CryptographicErase', or 'Overwrite'
.LINK
    https://github.com/DMTF/Redfish/blob/master/json-schema/Drive.v1_8_5.json
#>   
[CmdletBinding()]
param(  [parameter(Mandatory=$true)][string]    $DriveId,
                                    [int]       $OverwritePasses,
        [parameter(Mandatory=$true)][string]
        [ValidateSet('BlockErase', 'CryptographicErase','Overwrite')]
                                    [string]    $SanitizationType
     )
process 
{   if ( Get-RedfishDrive -DriveID $DriveId )
        {   $CBody                                                            = @( @{ SanitizationType = $SanitizationType} )
            if ( $PSBoundParameters.ContainsKey('OverwritePasses')) { $CBody +=    @{ OverwritePasses  = $OverwritePasses } }
            $CData = Get-RedfishDrive -DriveId $DriveId
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' ) -body $MyBody -Method 'POST'
            return $Result
        }
        else 
        {   write-error "The Drive Specified was not found."
        }
}
}

