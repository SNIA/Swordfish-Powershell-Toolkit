function Get-SwordFishChassis
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' from the SwordFish Target.
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
    PS:> Get-SwordFishChassis

    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Chassis/AC-109032
    @odata.type        : #Chassis.v1_11_0.Chassis
    Id                 : AC-109032
    Name               : 2d2b4bd8361b856bbc00000001000041430001a9e8
    ChassisType        : Shelf
    Manufacturer       : HPE-Nimble
    Model              : CS700
    SKU                : CS700-2G-36T-3200F
    SerialNumber       : AC-109032
    PartNumber         : CS700-2G-36T-3200F
    IndicatorLED       : Lit
    PowerState         : On
    EnviornmentalClass : A2
    Status             : @{State=Enabled; Health=OK}
    Thermal            : @{@odata.id=/redfish/v1/Chassis/AC-109032/Thermal}
    Power              : @{@odata.id=/redfish/v1/Chassis/AC-109032/Power}
    Drives             : @{@odata.id=/redfish/v1/Chassis/AC-109032/Drives}
    Links              : @{Storage=}

.EXAMPLE
    PS:> Get-SwordfishChassis -ChassisId Chassis-13

    { This output from this command will appear similar to the above output, but only limit the output to a single chassis instead of a possible collection }
.EXAMPLE
    PS:> Get-SwordfishChassis | ConvertTo-Json

    {
        "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.id":  "/redfish/v1/Chassis/AC-109032",
        "@odata.type":  "#Chassis.v1_11_0.Chassis",
        "Id":  "AC-109032",
        "Name":  "2d2b4bd8361b856bbc00000001000041430001a9e8",
        "ChassisType":  "Shelf",
        "Manufacturer":  "HPE-Nimble",
        "Model":  "CS700",
        "SKU":  "CS700-2G-36T-3200F",
        "SerialNumber":  "AC-109032",
        "PartNumber":  "CS700-2G-36T-3200F",
        "IndicatorLED":  "Lit",
        "PowerState":  "On",
        "EnviornmentalClass":  "A2",
        "Status":  {
                       "State":  "Enabled",
                       "Health":  "OK"
                   },
        "Thermal":  {
                        "@odata.id":  "/redfish/v1/Chassis/AC-109032/Thermal"
                    },
        "Power":  {
                      "@odata.id":  "/redfish/v1/Chassis/AC-109032/Power"
                  },
        "Drives":  {
                       "@odata.id":  "/redfish/v1/Chassis/AC-109032/Drives"
                   },
        "Links":  {
                      "Storage":  {
                                      "@odata.id":  "/redfish/v1/Storage/AC-109032"
                                  }
                  }
    }
.LINK
    https://redfish.dmtf.org/schemas/v1/Chassis.v1_16_0.json
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

function Get-SwordfishChassisThermal
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' Thermal sensors from the SwordFish Target Chassis(S).
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
    Get-SwordFishChassisThermal

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
    PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-SwordFishChassisThermal -MetricName Fans

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
    Get-SwordFishChassisThermal -ChassisID enclosure_1 -MetricName Temperatures

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
    https://redfish.dmtf.org/schemas/v1/Chassis.v1_14_0.json
#>  
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByChassisID')]             [string]    $ChassisID,

        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]             
        [Validateset("Temperatures","Fans","Redundancy","All")] [string]    $MetricName="All",

        [Parameter(ParameterSetName='ByChassisID')]        
        [Parameter(ParameterSetName='Default')]                 [Switch]   $ReturnCollectionOnly
     ) 

process{
    switch ($PSCmdlet.ParameterSetName )
            {   'Default'       {   foreach ( $ChassID in ( Get-SwordfishChassis ).id )
                                        {   [array]$DefChassSet += Get-SwordfishChassisThermal -ChassisID $ChassID -MetricName $MetricName -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    return ( $DefChassSet )  
                                }
                'ByChassisID'   {   $PulledData = Get-SwordfishChassis -ChassisID $ChassisID
                                }
            }
    if ( $PSCmdlet.ParameterSetName -ne "Default" )
        {   $Thermals = invoke-restmethod2 -uri ($base + ($PulledData.'@odata.id') +  "Thermal" )
            switch ($MetricName)
                    {   "Temperatures"  {   [array]$ReturnSet=($Thermals).Temperatures
                                        }
                        "Fans"          {   [array]$ReturnSet=($Thermals).Fans
                                        }
                        "Redundancy"    {   [array]$ReturnSet=($Thermals).Redundancy
                                        }
                        "All"           {   [array]$ReturnSet=($Thermals)
                                        }
                    } 
            if ( $ReturnCollectionOnly )
                {   return $ReturnSet
                } else 
                {   return $ReturnSet
                }
        }
}
}

function Get-RedfishChassisThermal
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' Thermal sensors from the Redfish Target Chassis(s).
.DESCRIPTION
    This command will return all of the Thermal sensors for a specific Chassis ID or all Chassis if unspecified.  
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is that will be requested. If this is not specified
    the command will retrieve the sensor data for all of the chassis IDs that exist on the Redfish
    Target.
.PARAMETER MetricName
    The metric name may be defined as Temperatures, Fans, and Redundancy and these values will be 
    returned, if no metric name is specified, the command will recover the collection which maintains all three.
    For all intent purposes, if this value is not specified, the returned data will be similar to using 
    the ReturnCollectionOnly option.
.PARAMETER ReturnCollectionOnly
    If specified (as a swich) the command will return the collection that contains all of the thermal values.
.EXAMPLE
    Get-RedFishChassisThermal

    @odata.context : /redfish/v1/$metadata#Thermal.Thermal
    @odata.etag    : W/"85889056"
    @odata.id      : /redfish/v1/Chassis/1/Thermal
    @odata.type    : #Thermal.v1_1_0.Thermal
    Id             : Thermal
    Fans           : {@{@odata.id=/redfish/v1/Chassis/1/Thermal#Fans/0; MemberId=0; Name=Fan 1; Oem=; Reading=11; ReadingUnits=Percent; Status=},
                    @{@odata.id=/redfish/v1/Chassis/1/Thermal#Fans/1; MemberId=1; Name=Fan 2; Oem=; Reading=11; ReadingUnits=Percent; Status=},
                    @{@odata.id=/redfish/v1/Chassis/1/Thermal#Fans/2; MemberId=2; Name=Fan 3; Oem=; Reading=11; ReadingUnits=Percent; Status=},
                    @{@odata.id=/redfish/v1/Chassis/1/Thermal#Fans/3; MemberId=3; Name=Fan 4; Oem=; Reading=11; ReadingUnits=Percent; Status=}...}
    Name           : Thermal
    Temperatures   : {@{@odata.id=/redfish/v1/Chassis/1/Thermal#Temperatures/0; MemberId=0; Name=01-Inlet Ambient; Oem=; PhysicalContext=Intake; ReadingCelsius=23;
                    SensorNumber=1; Status=; UpperThresholdCritical=42; UpperThresholdFatal=47}, @{@odata.id=/redfish/v1/Chassis/1/Thermal#Temperatures/1; MemberId=1;
                    Name=02-CPU 1; Oem=; PhysicalContext=CPU; ReadingCelsius=40; SensorNumber=2; Status=; UpperThresholdCritical=70; UpperThresholdFatal=},
                    @{@odata.id=/redfish/v1/Chassis/1/Thermal#Temperatures/2; MemberId=2; Name=03-CPU 2; Oem=; PhysicalContext=CPU; ReadingCelsius=40; SensorNumber=3; Status=;
                    UpperThresholdCritical=70; UpperThresholdFatal=}, @{@odata.id=/redfish/v1/Chassis/1/Thermal#Temperatures/3; MemberId=3; Name=04-P1 DIMM 1-6; Oem=;
                    PhysicalContext=SystemBoard; ReadingCelsius=0; SensorNumber=4; Status=; UpperThresholdCritical=; UpperThresholdFatal=}...}
.EXAMPLE
    PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-RedfishChassisThermal -MetricName Fans

    @odata.id    : /redfish/v1/Chassis/1/Thermal#Fans/3
    MemberId     : 3
    Name         : Fan 4
    Oem          : @{Hpe=}
    Reading      : 11
    ReadingUnits : Percent
    Status       : @{Health=OK; State=Enabled}

    @odata.id    : /redfish/v1/Chassis/1/Thermal#Fans/4
    MemberId     : 4
    Name         : Fan 5
    Oem          : @{Hpe=}
    Reading      : 11
    ReadingUnits : Percent
    Status       : @{Health=OK; State=Enabled}

    In this example, the number of returned items was excessive, so only the last two are show. 
.EXAMPLE
    PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-RedfishChassisThermal -MetricName Fans

    @odata.id              : /redfish/v1/Chassis/1/Thermal#Temperatures/48
    MemberId               : 48
    Name                   : 73-PCI 3 M2
    Oem                    : @{Hpe=}
    PhysicalContext        : SystemBoard
    ReadingCelsius         : 0
    SensorNumber           : 49
    Status                 : @{State=Absent}
    UpperThresholdCritical :
    UpperThresholdFatal    :

    @odata.id              : /redfish/v1/Chassis/1/Thermal#Temperatures/49
    MemberId               : 49
    Name                   : 74-PCI 3 M2 Zn
    Oem                    : @{Hpe=}
    PhysicalContext        : SystemBoard
    ReadingCelsius         : 0
    SensorNumber           : 50
    Status                 : @{State=Absent}
    UpperThresholdCritical :
    UpperThresholdFatal    :

    In this example, the number of returned items was excessive, so only the last two are show. 
.EXAMPLE
    PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-RedfishChassisThermal -MetricName Fans | format-Table MemberId, Name, PhysicalContext, ReadingCelsius, Status

    MemberId Name             PhysicalContext ReadingCelsius Status
    -------- ----             --------------- -------------- ------
    0        01-Inlet Ambient Intake                      23 @{Health=OK; State=Enabled}
    1        02-CPU 1         CPU                         40 @{Health=OK; State=Enabled}
    2        03-CPU 2         CPU                         40 @{Health=OK; State=Enabled}
    3        04-P1 DIMM 1-6   SystemBoard                  0 @{State=Absent}
    5        06-P1 DIMM 7-12  SystemBoard                 31 @{Health=OK; State=Enabled}
    9        10-P2 DIMM 7-12  SystemBoard                 33 @{Health=OK; State=Enabled}
    12       13-Exp Bay Drive SystemBoard                 35 @{Health=OK; State=Enabled}
    13       14-Stor Batt 1   SystemBoard                 24 @{Health=OK; State=Enabled}
    14       15-Front Ambient Intake                      29 @{Health=OK; State=Enabled}
    21       22-Chipset       SystemBoard                 44 @{Health=OK; State=Enabled}
    22       23-BMC           SystemBoard                 73 @{Health=OK; State=Enabled}
    23       24-BMC Zone      SystemBoard                 43 @{Health=OK; State=Enabled}
    24       25-HD Controller SystemBoard                 40 @{Health=OK; State=Enabled}
    25       26-HD Cntlr Zone SystemBoard                 34 @{Health=OK; State=Enabled}
    26       27-LOM           SystemBoard                 51 @{Health=OK; State=Enabled}    
    27       28-LOM Card      SystemBoard                  0 @{State=Absent}
    28       29-I/O Zone      SystemBoard                 34 @{Health=OK; State=Enabled}
    30       31-PCI 1 Zone    SystemBoard                 34 @{Health=OK; State=Enabled}
    32       33-PCI 2 Zone    SystemBoard                 33 @{Health=OK; State=Enabled}
    34       35-PCI 3 Zone    SystemBoard                 33 @{Health=OK; State=Enabled}
    36       38-Battery Zone  SystemBoard                 36 @{Health=OK; State=Enabled}
    37       39-P/S 1 Inlet   PowerSupply                 30 @{Health=OK; State=Enabled}
    38       40-P/S 2 Inlet   PowerSupply                 31 @{Health=OK; State=Enabled}
    39       41-P/S 1         PowerSupply                 40 @{Health=OK; State=Enabled}
    40       42-P/S 2         PowerSupply                 40 @{Health=OK; State=Enabled}
    41       43-E-Fuse        PowerSupply                 28 @{Health=OK; State=Enabled}
    42       44-P/S 2 Zone    PowerSupply                 36 @{Health=OK; State=Enabled}

    In this example, the number of returned items was still excessive, so the output was trimmed. 

.LINK
    https://redfish.dmtf.org/schemas/v1/Chassis.v1_14_0.json
#>  
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByChassisID')]             [string]    $ChassisID,

        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]             
        [Validateset("Temperatures","Fans","Redundancy","All")] [string]    $MetricName="All",

        [Parameter(ParameterSetName='ByChassisID')]        
        [Parameter(ParameterSetName='Default')]                 [Switch]   $ReturnCollectionOnly
     ) 

process{
    switch ($PSCmdlet.ParameterSetName )
            {   'Default'       {   foreach ( $ChassID in ( Get-SwordfishChassis ).id )
                                        {   [array]$DefChassSet += Get-SwordfishChassisThermal -ChassisID $ChassID -MetricName $MetricName -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    return ( $DefChassSet )  
                                }
                'ByChassisID'   {   $PulledData = Get-SwordfishChassis -ChassisID $ChassisID
                                }
            }
    if ( $PSCmdlet.ParameterSetName -ne "Default" )
        {   $Thermals = invoke-restmethod2 -uri ($base + ($PulledData.'@odata.id') +  "Thermal" )
            switch ($MetricName)
                    {   "Temperatures"  {   [array]$ReturnSet=($Thermals).Temperatures
                                        }
                        "Fans"          {   [array]$ReturnSet=($Thermals).Fans
                                        }
                        "Redundancy"    {   [array]$ReturnSet=($Thermals).Redundancy
                                        }
                        "All"           {   [array]$ReturnSet=($Thermals)
                                        }
                    } 
            if ( $ReturnCollectionOnly )
                {   return $ReturnSet
                } else 
                {   return $ReturnSet
                }
        }
}
}

function Get-SwordfishChassisPower
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis(s) Power sensors from the SwordFish Target Chassis(s).
.DESCRIPTION
    This command will return all of the Power sensors for a specific Chassis ID. You must
    specify either to retrieve the PowerControl values, the Voltage values or the 
    PowerSupply values. 
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is required.
.PARAMETER MetricName
    The metric name is required, and only PowerControl, Voltages, and PowerSupplies are valid.
.EXAMPLE
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
.EXAMPLE
    Get-SwordfishChassisPower -ReturnCollectionOnly

    { OUTPUT is exactly the same as the previous example }
.LINK
    https://redfish.dmtf.org/schemas/v1/Chassis.v1_14_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByChassisID')]                     [string]    $ChassisID,

        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]             
        [Validateset("PowerControl","Voltages","PowerSupplies","All")]  [string]    $MetricName="All",

        [Parameter(ParameterSetName='ByChassisID')]        
        [Parameter(ParameterSetName='Default')]                         [Switch]    $ReturnCollectionOnly
     ) 
process{
    switch ($PSCmdlet.ParameterSetName )
            {   'Default'       {   foreach ( $ChassID in ( Get-SwordfishChassis ).id )
                                        {   [array]$DefChassSet += Get-SwordfishChassisPower -ChassisID $ChassID -MetricName $MetricName -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    return ( $DefChassSet )  
                                }
                'ByChassisID'   {   $PulledData = Get-SwordfishChassis -ChassisID $ChassisID
                                }
            }
    if ( $PSCmdlet.ParameterSetName -ne "Default" )
        {   $Powers = invoke-restmethod2 -uri ($base + ($PulledData.'@odata.id') +  "/Power" )
            switch ($MetricName)
                    {   "PowerControl"  {   [array]$ReturnSet=($Powers).PowerControl
                                        }
                        "Voltages"      {   [array]$ReturnSet=($Powers).Voltages
                                        }
                        "PowerSupplies" {   [array]$ReturnSet=($Powers).PowerSupplies
                                        }
                        "All"           {   [array]$ReturnSet=($Powers)
                                        }
                    } 
            if ( $ReturnCollectionOnly )
                {   return $ReturnSet
                } else 
                {   return $ReturnSet
}}      }       }