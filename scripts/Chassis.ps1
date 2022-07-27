function Get-SwordfishChassis
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Chassis objects that exist or if a single Chassis ID is selected, 
    it will return only the single Chassis ID. Note that this command doesnt return the Chassis Collection, but instead returns a 
    PowerShell Object that represents an Array of all of the Chassis that are in the Chassis collection. This default behavior 
    can be overridden using parameter called "ReturnCollectionOnly" and setting that value to True
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis, otherwise the command
    will return all Chassis.
.PARAMETER ReturnCollectionOnly
    A Boolean value that defaults to $False, will return a powershell array of the Chassis. To set this value true indicates that
    instead you wish to see the raw Chassis Collection Object and not what the Chassis Collection points to.
.EXAMPLE
    The following is a Generic example. For very specific examples see the Examples folder in this module
    PS:> Get-RedfishChassis

    @odata.context  : /redfish/v1/$metadata#Chassis.Chassis
    @odata.etag     : W/"B5DF47B2"
    @odata.id       : /redfish/v1/Chassis/1/
    @odata.type     : #Chassis.v1_10_2.Chassis
    Id              : 1
    AssetTag        :
    ChassisType     : RackMount
    IndicatorLED    : Off
    Links           : @{ManagedBy=System.Object[]; ComputerSystems=System.Object[]; Drives=System.Object[]}
    Manufacturer    : Vendor
    Model           : Server Model 123
    Name            : Computer System Chassis
    NetworkAdapters : @{@odata.id=/redfish/v1/Chassis/1/NetworkAdapters/}
    Oem             : @{Hpe=}
    PCIeDevices     : @{@odata.id=/redfish/v1/Chassis/1/PCIeDevices/}
    PCIeSlots       : @{@odata.id=/redfish/v1/Chassis/1/PCIeSlots/}
    Power           : @{@odata.id=/redfish/v1/Chassis/1/Power/}
    PowerState      : On
    SKU             : 867960-B21
    SerialNumber    : USE726CR3F
    Status          : @{Health=Warning; State=Enabled}
    Thermal         : @{@odata.id=/redfish/v1/Chassis/1/Thermal/}
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding()]
param   (   [string]    $ChassisId,
            [switch]    $ReturnCollectionOnly
        )
process{
    $ChassisCollection      = @()
    $ChassisCollectionOnly  = @()
    $ChassisCollectionOnly  = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Chassis")
    # Now must find if this contains links or directly goes to members. Only one of these will exist, whichever one will be the one that survives this assignment.
    $Links = (($ChassisCollectionOnly).Links).Members + ($ChassisCollectionOnly).Members
    foreach($link in $Links)
        {   $ChassisCollection += invoke-restmethod2 -uri ( $Base + ($link.'@odata.id') ) 
        }       
    if ( $ReturnCollectionOnly )
        {   return $ChassisCollectionOnly
        } else
        {   if ( $ChassisID ) 
                {   return ( $ChassisCollection | where-object {$_.id -like $ChassisID} )
                } else 
                {   return $ChassisCollection
                }
         }   
    }
}
Set-Alias -name 'Get-RedfishChassis' -value 'Get-SwordfishChassis'

function Get-SwordfishChassisThermal
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' Thermal sensors from the Swordfish Target Chassis(S).
.DESCRIPTION
    This command will return all of the Thermal sensors for a specific Chassis ID.  
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is that will be requested. If this is not specified
    the command will retrieve the sensor data for all of the chassis IDs that exist on the Swordfish
    Target.
.PARAMETER MetricName
    The metric name may be defined as Temperatures, Fans, and Redundancy and these values will be 
    returned, if no metric name is specified, the command will recover the collection which maintains all three.
    For all intent purposes, if this value is not specified, the returned data will be similar to using 
    the ReturnCollectionOnly option.
.PARAMETER ReturnCollectionOnly
    If specified (as a swich) the command will return the collection that contains all of the thermal values.
.EXAMPLE
    The following is a Generic example. For very specific examples see the Examples folder in this module
    Get-SwordfishChassisThermal

    @odata.context : /redfish/v1/$metadata#Thermal.Thermal
    @odata.id      : /redfish/v1/Chassis/enclosure_1/Thermal
    @odata.type    : #Thermal.v1_5_1.Thermal
    Name           : Thermal
    Id             : Thermal
    Temperatures   : {@{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/0; MemberId=0; Name=sensor_temp_ctrl_A.2; ReadingCelsius=53.000000; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/1; MemberId=1;
                    Name=sensor_temp_ctrl_A.3; ReadingCelsius=43.000000; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/2; MemberId=2; Name=sensor_temp_ctrl_A.4; ReadingCelsius=33.000000; Status=},
                    @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/3; MemberId=3; Name=sensor_temp_ctrl_A.5; ReadingCelsius=48.000000; Status=}...}
    Fans           : {@{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Fans/0; MemberId=0; Reading=4740; Name=Fan 1; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Fans/1; MemberId=1; Reading=4560; Name=Fan 2; Status=},
                    @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Fans/2; MemberId=2; Reading=4740; Name=Fan 3; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Thermal#/Fans/3; MemberId=3; Reading=4740; Name=Fan 4; Status=}}
.EXAMPLE
    The following is a Generic example. For very specific examples see the Examples folder in this module
    PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-SwordfishChassisThermal -MetricName Fans

    @odata.id : /redfish/v1/Chassis/enclosure_1/Thermal#/Fans/0
    MemberId  : 0
    Reading   : 4740
    Name      : Fan 1
    Status    : @{State=Enabled; Health=OK}

    @odata.id : /redfish/v1/Chassis/enclosure_1/Thermal#/Fans/1
    MemberId  : 1
    Reading   : 4620
    Name      : Fan 2
    Status    : @{State=Enabled; Health=OK}
.EXAMPLE
    The following is a Generic example. For very specific examples see the Examples folder in this module
    Get-SwordfishChassisThermal -ChassisID enclosure_1 -MetricName Temperatures

    @odata.id      : /redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/0
    MemberId       : 0
    Name           : sensor_temp_ctrl_A.2
    ReadingCelsius : 43.000000
    Status         : @{State=Enabled; Health=OK}

    @odata.id      : /redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/20
    MemberId       : 20
    Name           : sensor_temp_disk_1.1
    ReadingCelsius : 23.000000
    Status         : @{State=Enabled; Health=OK}

    @odata.id      : /redfish/v1/Chassis/enclosure_1/Thermal#/Temperatures/16
    MemberId       : 16
    Name           : sensor_temp_psu_1.2.1
    ReadingCelsius : 27.000000
    Status         : @{State=Enabled; Health=OK}
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>  
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByChassisID')]             [string]    $ChassisID,

        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]             
        [Validateset("Temperatures","Fans","Redundancy","All")] [string]    $MetricName="All"
     ) 

process{
    switch ($PSCmdlet.ParameterSetName )
            {   'Default'       {   foreach ( $ChassID in ( Get-SwordfishChassis ).id )
                                        {   [array]$DefChassSet += Get-SwordfishChassisThermal -ChassisID $ChassID -MetricName $MetricName
                                        }
                                    return ( $DefChassSet )  
                                }
                'ByChassisID'   {   $PulledData = Get-SwordfishChassis -ChassisID $ChassisID
                                }
            }
    if ( $PSCmdlet.ParameterSetName -ne "Default" )
        {   try     {   if ( (invoke-restmethod2 -uri ($base + ($PulledData.'@odata.id'))).Thermal )
                            {   $ThermalData = (invoke-restmethod2 -uri ($base + ($PulledData.'@odata.id'))).Thermal  
                                if ( $ThermalData.'@odata.id' )
                                    {   $ThermalData = Get-RedfishByURL $ThermalData
                                    }
                                switch ($MetricName)
                                    {   "Temperatures"  {   [array]$ReturnSet=($ThermalData).Temperatures
                                                        }
                                        "Fans"          {   [array]$ReturnSet=($ThermalData).Fans
                                                        }
                                        "Redundancy"    {   [array]$ReturnSet=($ThermalData).Redundancy
                                                        }
                                        "All"           {   [array]$ReturnSet=($ThermalData)
                                                        }
                                    } 
                                return $ReturnSet
                            }
                          else 
                            {   return
                            }
                    }
            catch   { $_
                    }
        }
}
}
Set-Alias -name 'Get-RedfishChassisThermal' -Value 'Get-SwordfishChassisThermal'

function Get-SwordfishChassisPower
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis(s) Power sensors from the Swordfish Target Chassis(s).
.DESCRIPTION
    This command will return all of the Power sensors for a specific Chassis ID. You must
    specify either to retrieve the PowerControl values, the Voltage values or the 
    PowerSupply values. 
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is required.
.PARAMETER MetricName
    The metric name is required, and only PowerControl, Voltages, and PowerSupplies are valid.
.EXAMPLE
    The Following output is a Generic Example, for detailed examples see the Example folder in this Module
    Get-SwordfishChassisPower -MetricName Voltages

    @odata.id    : /redfish/v1/Chassis/enclosure_1/Power#/Voltages/0
    MemberId     : 0
    ReadingVolts : 10.770000
    Name         : Capacitor Pack Voltage-Ctlr A
    Status       : @{State=Enabled; Health=OK}

    @odata.id    : /redfish/v1/Chassis/enclosure_1/Power#/Voltages/10
    MemberId     : 10
    ReadingVolts : 12.180000
    Name         : Voltage 12V Rail Loc: left-PSU
    Status       : @{State=Enabled; Health=OK}

    @odata.id    : /redfish/v1/Chassis/enclosure_1/Power#/Voltages/11
    MemberId     : 11
    ReadingVolts : 4.960000
    Name         : Voltage 5V Rail Loc: left-PSU
    Status       : @{State=Enabled; Health=OK}
.EXAMPLE
    The Following output is a Generic Example, for detailed examples see the Example folder in this Module
    Get-SwordfishChassisPower

    @odata.context : /redfish/v1/$metadata#Power.Power
    @odata.id      : /redfish/v1/Chassis/enclosure_1/Power
    @odata.type    : #Power.v1_5_2.Power
    Id             : Power
    Name           : Power
    PowerSupplies  : {@{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/PowerSupplies/0; MemberId=0; SerialNumber=7CE928T007; PartNumber=P12954-001; Name=PSU 1, Left; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/PowerSupplies/1; MemberId=1;
                     SerialNumber=7CE928T008; PartNumber=P12954-001; Name=PSU 2, Right; Status=}}
    Voltages       : {@{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/Voltages/0; MemberId=0; ReadingVolts=10.770000; Name=Capacitor Pack Voltage-Ctlr A; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/Voltages/1; MemberId=1; ReadingVolts=2.690000;
                     Name=Capacitor Cell 1 Voltage-Ctlr A; Status=}, @{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/Voltages/2; MemberId=2; ReadingVolts=2.690000; Name=Capacitor Cell 2 Voltage-Ctlr A; Status=},
                     @{@odata.id=/redfish/v1/Chassis/enclosure_1/Power#/Voltages/3; MemberId=3; ReadingVolts=2.690000; Name=Capacitor Cell 3 Voltage-Ctlr A; Status=}...}
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(                                                                  [string]    $ChassisID,
        [Validateset("PowerControl","Voltages","PowerSupplies","All")]  [string]    $MetricName="All"      
     ) 
process
  { if ( $ChassisID)
            {   $MyChassis = Get-RedfishChassis -ChassisId $ChassisID
            }
        else 
            {   $MyChassis = Get-RedfishChassis
            }
    if ( $MyChassis.Power )
            {   ForEach ( $PowerHash in ($MyChassis).Power )
                    {   try     {   $Powers = Get-RedfishByURL -URL ( $PowerHash.'@odata.id' )   
                                    if ( $Powers )
                                        {   switch ($MetricName)
                                            {   "PowerControl"  {   $ReturnData = ($Powers).PowerControl
                                                                }
                                                "Voltages"      {   $ReturnData = ($Powers).Voltages
                                                                }
                                                "PowerSupplies" {   $ReturnData = ($Powers).PowerSupplies
                                                                }
                                                "All"           {   $ReturnData = $Powers
                                                                }
                                            } 
                                    }
                                }
                        catch   {     write-warning 'Call to Power data failed'
                                }
                    }   
                return $ReturnData
            }
        else
            {   write-warning "No Power subsection found"
            }
  }
}
Set-Alias -Name 'Get-RedfishChassisPower' -Value 'Get-SwordfishChassisPower'