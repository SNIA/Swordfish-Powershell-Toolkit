
function Invoke-RedfishChassisReset
{
<#
.SYNOPSIS
    Invoke a Chassis Reset for the system that this redfish implementation represents.
.DESCRIPTION
    Invoke a Chassis Reset for the system that this redfish implementation represents.
.PARAMETER ChassisID
    The Chasiss ID name for a specific System, otherwise the command
    will be invoked on all Systems.
.PARAMETER ResetType
    This option can be set to any of the following types of resets if they are supported;
    'On', 'ForceOff','GracefulShutdown','ForceRestart','Nmi','PushPowerButton','GracefulRestart'
.NOTES
    Future updates to this command may include implementing ResetType as a dynamic parameter and
    only display the reset types that the system actually supports. 
#>   
[CmdletBinding()]
param(  [string]    $ChassisID,
        [ValidateSet('On', 'ForceOff','GracefulShutdown','ForceRestart','Nmi','PushPowerButton','GracefulRestart')]
        [string]    $ResetType
     )
process
 {
    $MyChassis = Get-RedfishChassis -ChassisId $ChassisId 
    $MyChassisodata = $MyChassisData.'@odata.id'
    $MyBody = @{ 'ResetType'= $ResetType }
    if ( ($base + $MyChassis.'@odata.id').endswith('/') ) 
                    {   # The Dell Server doesnt have a trailing / mark, so I must add it.
                        $MyUrl = ( $base + ($MyChassis.'@odata.id') + 'Actions/Chassis.Reset')
                    } 
        else
                    {   # The HPE server contains the trailing / mark, so dont need to add it
                        $MyUrl = ( $base + ($MyChassis.'@odata.id') + '/Actions/Chassis.Reset')
                    }
    $JSONBody = $MyBody | convertto-json
    $Result += invoke-restmethod2 -Method 'POST' -Uri $MyUrl -body $JSONBody
    return $Result
 }
}

function Set-RedfishChassis {
<#
.SYNOPSIS
    The command will allow you to set the read/write values in the specified Chassis
.DESCRIPTION
    The command will allow you to set the read/write values in the specified Chassis
.PARAMETER ChassisId
    A Required parameter that indicates which ChassisID will be modified.
.PARAMETER AssetTag
     The user-assigned asset tag of this chassis.
.PARAMETER ElectricalSourceManagerOdataID
    The URIs of the management interfaces for the upstream electrical source connections for this chassis.
.PARAMETER ElectricalSourceNames
    The names of the upstream electrical sources, such as circuits or outlets, connected to this chassis.
.PARAMETER EnvironmentalClass
    The ASHRAE Environmental Class for this chassis. For the possible property values, see EnvironmentalClass in Property details.
.PARAMETER FacilityODataID 
    object The link to the facility that contains this chassis. See the Facility schema for details on this property.
    @odata.id string read-write Link to a Facility resource. See the Links section and the Facility schema for details.
.PARAMETER ContainedByOdataID
    array An array of links to any other chassis that this chassis has in it. @odata.id string read-write Link to another Chassis resource.
.PARAMETER PowerOutletsOdataID 
    array An array of links to the outlets that provide power to this chassis. @odata.id string read-write Link to a Outlet resource. 
    See the Links section and the Outlet schema for details.
.PARAMETER PhysicalSecurityIntrusionSensorReArm
    The method that restores this physical security sensor to the normal state. For the possible property values, see IntrusionSensorReArm in Property details.
.PARAMETER LocationIndicatorActive
    LocationIndicatorActive (v1.14+) boolean read-write (null) An indicator allowing an operator to physically locate this resource.
.PARAMETER Oem
    object See the Oem object definition in the Common properties section.
.NOTES
    Uses Chassis 1.0.4
.LINK 
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory=$true)]            [string]    $ChassisId,
                                                [string]    $AssetTag,
        [ValidateSet('A1','A2','A3','A4')]      [string]    $ElectricalSourceManagerOdataID,
                                                [string]    $ElectricalSourceNames,
                                                [string]    $EnvironmentalClass, 
                                                [string]    $FacilityODataID,
                                                [string]    $ContainedByOdataID,
                                                [string]    $PowerOutletsOdataID,
        [ValidateSet('Automatic',',Manual')]    [String]    $PhysicalSecurityIntrusionSensorReArm,
                                                [Boolean]   $LocationIndicatorActive,  
                                                            $Oem        
     )
process {   $CData = Get-RedfishChassis -ChassisID $ChassisId
            $CBody = @()
            if ( $PSBoundParameters.ContainsKey('AssetTag'))                        {    $CBody += @{ AssetTag                      = $AssetTag                             } }
            if ( $PSBoundParameters.ContainsKey('ElectricalSourceManagerOdataID'))  {    $CBody += @{ ElectricalSourceManagerURIs   = @{ '@odata.id' = $ElectricalSourceManagerOdataID }}}
            if ( $PSBoundParameters.ContainsKey('ElectricalSourceNames'))           {    $CBody += @{ ElectricalSourceNames         = $ElectricalSourceNames                } }
            if ( $PSBoundParameters.ContainsKey('EnvironmentalClass'))              {    $CBody += @{ EnvironmentalClass            = $EnvironmentalClass                   } }
            if ( $PSBoundParameters.ContainsKey('FacilityODataID'))                 {    $CBody += @{ Facility                      = @{ '@odata.id' = $FacilityPDataID }   } }
            if ( $PSBoundParameters.ContainsKey('ContainedByOdataID'))              {    $CBody += @{ ContainedBy                   = @{ '@odata.id' = $ContainedByOdataID }} }
            if ( $PSBoundParameters.ContainsKey('PowerOutletsOdataID'))             {    $CBody += @{ PowerOutletsOdataID           = @{ '@odata.id' = $PowerOutletsOdataID}} }
            if ( $PSBoundParameters.ContainsKey('PhysicalSecurityIntrusionSensorReArm')){$CBody += @{ PhysicalSecurity              = @{ '@odata.id' = $PhysicalSecurityIntrusionSensorReArm} } }
            if ( $PSBoundParameters.ContainsKey('LocationIndicatorActive'))         {    $CBody += @{ LocationIndicatorActive             = $LocationIndicatorActive        } }
            if ( $PSBoundParameters.ContainsKey('Oem'))                             {    $CBody += @{ Oem                           = $Oem                                  } }
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' ) -body $MyBody -Method 'POST'
            return $Result
        }
        
}
