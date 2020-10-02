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
    https://redfish.dmtf.org/schemas/Chassis.v1_9_0.json

#>   
[CmdletBinding()]
param   (   [string]    $ChassisId,
            [boolean]   $ReturnChassisCollectionOnly =   $False
        )
process{
    $LocalUri = Get-SwordfishURIFolderByFolder "Chassis"
    write-verbose "Folder = $LocalUri"
    $LocalData = invoke-restmethod2 -uri $LocalUri
    # Now must find if this contains links or directly goes to members. Only one of these will exist, whichever one will be the one that survives this assignment.
    $Links = (($LocalData).Links).Members + ($LocalData).Members
    $LocalCol=@()
    foreach($link in $Links)
        {   $SingletonUri=($link).'@odata.id'
            if ($SingletonUri) # needed to avoid an empty dataset getting inserted into collection
                {   $Singleton=$base+$SingletonUri
                    $LocalChassis=invoke-restmethod2 -uri $Singleton
                    if ( ( ($LocalChassis).id -like $ChassisId ) -or ( $ChassisId -eq '' ) )
                        {   write-verbose "Adding singleton to collection"
                            $LocalCol+=$LocalChassis 
        }       }      }
    if ( $ReturnChassisCollectionOnly )
        {   return $LocalData
        } else
        {   return $LocalCol
        }   
    }
}

function Get-SwordFishChassisThermal
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' Thermal sensors from the SwordFish Target Chassis.
.DESCRIPTION
    This command will return all of the Thermal sensors for a specific Chassis ID. You must
    specify either to retrieve the Temperature Sensor values, the Fan Sensor values or the 
    redundancy values. 
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is required.
.PARAMETER MetricName
    The metric name is required, and only Temperatures, Fans, and Redundancy are valid.
.EXAMPLE
    PS:> Get-SwordfishChassisThermal -ChassisId AC-109032 -MetricName Temperatures

    @odata.id       : /redfish/v1/Chassis/AC-109032/Thermal#/Temperatures/0
    @odata.type     : #Thermal.v1_6_0.Thermal
    MemberId        : 0
    Name            : motherboard
    Status          : @{State=Enabled; Health=OK}
    ReadingCelsius  : 41
    PhysicalContext : ChassisSocketA_motherboard

    @odata.id       : /redfish/v1/Chassis/AC-109032/Thermal#/Temperatures/1
    @odata.type     : #Thermal.v1_6_0.Thermal
    MemberId        : 1
    Name            : bp-temp1
    Status          : @{State=Enabled; Health=OK}
    ReadingCelsius  : 26
    PhysicalContext : ChassisSocketA_left-side backplane
.EXAMPLE
    PS:> Get-SwordfishChassisThermal -ChassisID AC109032 -MetricName Fans

    @odata.id       : /redfish/v1/Chassis/AC-109032/Thermal#/Fans/1
    MemberId        : 1
    Name            : fan1
    Status          : @{State=Enabled; Health=OK}
    ReadingRPM      : 11220
    PhysicalContext : ChassisSocketA_lower front of controller A

    @odata.id       : /redfish/v1/Chassis/AC-109032/Thermal#/Fans/2
    MemberId        : 2
    Name            : fan2
    Status          : @{State=Enabled; Health=OK}
    ReadingRPM      : 11220
    PhysicalContext : ChassisSocketA_lower left rear of controller A
.EXAMPLE
    PS:> Get-SwordfishChassisThermal -ChassisID AC109032 -MetricName Fans | Format-Table '@odata.id', MemberId, Name, ReadingRPM, PhysicalContext

    @odata.id                                      MemberId Name ReadingRPM     PhysicalContext
    ---------                                      -------- ---- -------------- ---------------
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/1         1 fan1          11220 ChassisSocketA_lower front of controller A 
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/2         2 fan2          11237 ChassisSocketA_lower left rear of controller A
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/3         3 fan3          11611 ChassisSocketA_lower right rear of controller A
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/4         4 fan4          10829 ChassisSocketA_upper right front of controller A
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/5         5 fan5          10982 ChassisSocketA_upper left front of controller A
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/6         6 fan6          10693 ChassisSocketA_upper left rear of controller A
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/7         7 fan1          11466 ChassisSocketB_lower front of controller B
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/8         8 fan2          11313 ChassisSocketB_lower left rear of controller B
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/9         9 fan3          11050 ChassisSocketB_lower right rear of controller B
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/10       10 fan4          10914 ChassisSocketB_upper right front of controller B
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/11       11 fan5          10650 ChassisSocketB_upper left front of controller B
    /redfish/v1/Chassis/AC-109032/Thermal#/Fans/12       12 fan6          10829 ChassisSocketB_upper left rear of controller B
.EXAMPLE
    PS:> Get-SwordfishChassisThermal -ChassisID AC109032 -MetricName Fans | ConvertTo-Json
    [
        {
            "@odata.id":  "/redfish/v1/Chassis/AC-109032/Thermal#/Fans/1",
            "MemberId":  1,
            "Name":  "fan1",
            "Status":  {
                           "State":  "Enabled",
                           "Health":  "OK"
                       },
            "ReadingCelsius":  11211,
            "PhysicalContext":  "ChassisSocketA_lower front of controller A"
        },
        {
            "@odata.id":  "/redfish/v1/Chassis/AC-109032/Thermal#/Fans/2",
            "MemberId":  2,
            "Name":  "fan2",
            "Status":  {
                           "State":  "Enabled",
                           "Health":  "OK"
                       },
            "ReadingCelsius":  11245,
            "PhysicalContext":  "ChassisSocketA_lower left rear of controller A"
        }
    ]
.LINK
    https://redfish.dmtf.org/schemas/Chassis.v1_9_0.json
#>   
[CmdletBinding()]
param(  [Parameter (Mandatory = $True)]
        [string] $ChassisId,
        
        [Parameter (Mandatory = $True)]
        [Validateset ("Temperatures","Fans","Redundancy")]
        [string] $MetricName

     )
process{
    $LocalUri = Get-SwordfishURIFolderByFolder "Chassis"
    write-verbose "Folder = $LocalUri"
    $LocalData = invoke-restmethod2 -uri $LocalUri
    # Now must find if this contains links or directly goes to members. Only one of these will exist, whichever one will be the one that survives this assignment.
    $Links = (($LocalData).Links).Members + ($LocalData).Members
    $ReturnSet=@()
    foreach($link in $Links)
        {   $SingletonUri=($link).'@odata.id'
            $Singleton=$base+$SingletonUri
            $Thermals=$Singleton+"/Thermal"
            if  ( ( (invoke-restmethod2 -uri $Singleton).id -like $ChassisId ) -or ( $ChassisId -eq '' ) )
                {   switch ($MetricName)
                    {   "Temperatures"  {   $ReturnSet=(invoke-restmethod2 -uri $Thermals).Temperatures
                                        }
                        "Fans"          {   $ReturnSet=(invoke-restmethod2 -uri $Thermals).Fans
                                        }
                        "Redundancy"    {   $ReturnSet=(invoke-restmethod2 -uri $Thermals).Redundancy
                                        }
                    }
                } 
        }
    return $ReturnSet

    }
}

function Get-SwordfishChassisPower
{
<#
.SYNOPSIS
    Retrieve The list of valid Chassis' Power sensors from the SwordFish Target Chassis.
.DESCRIPTION
    This command will return all of the Power sensors for a specific Chassis ID. You must
    specify either to retrieve the PowerControl values, the Voltage values or the 
    PowerSupply values. 
.PARAMETER ChassisId
    The Chassis ID name for a specific Chassis is required.
.PARAMETER MetricName
    The metric name is required, and only PowerControl, Voltage, and PowerSupply are valid.
.EXAMPLE
    PS :> Get-SwordfishChassisPower -ChassisId AC-109032 -MetricName PowerControl | convertto-json

    {
        "@odata.id":  "/redfish/v1/Chassis/AC-109032/Power#/PowerControl/0",
        "Status":  {
                       "State":  "Enabled",
                       "Health":  "OK"
                   },
        "MemberID":  "0"
    }
.EXAMPLE
    PS:> Get-SwordfishChassisPower -ChassisId AC-109032 -MetricName PowerSupplies

    Manufacturer       : HPE-Nimble
    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    Name               : power-supply1
    Description        : power-supply1 Located in left rear of Chassis
    Status             : @{State=Enabled; Health=OK}
    MemberID           : 1
    InputRanges        : {@{OutputWattage=900; MinimumVoltage=100; MaximumVoltage=120; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}, @{OutputWattage=900;
                         MinimumVoltage=200; MaximumVoltage=240; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}}
    @odata.id          : /redfish/v1/Chassis/AC-109032/Power/PowerSupplies/1

    Manufacturer       : HPE-Nimble
    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    Name               : power-supply2
    Description        : power-supply2 Located in right rear of Chassis
    Status             : @{State=Enabled; Health=OK}
    MemberID           : 2
    InputRanges        : {@{OutputWattage=900; MinimumVoltage=100; MaximumVoltage=120; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}, @{OutputWattage=900;
                         MinimumVoltage=200; MaximumVoltage=240; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}}
    @odata.id          : /redfish/v1/Chassis/AC-109032/Power/PowerSupplies/2
.EXAMPLE
    PS:> Get-SwordfishChassisPower -ChassisId AC-109032 -MetricName PowerSupplies | ConvertTo-Json
    [
        {
            "Manufacturer":  "HPE-Nimble",
            "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
            "Name":  "power-supply1",
            "Description":  "power-supply1 Located in left rear of Chassis",
            "Status":  {
                           "State":  "Enabled",
                           "Health":  "OK"
                       },
            "MemberID":  "1",
            "InputRanges":  [
                                "@{OutputWattage=900; MinimumVoltage=100; MaximumVoltage=120; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}",
                                "@{OutputWattage=900; MinimumVoltage=200; MaximumVoltage=240; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}"
                            ],
            "@odata.id":  "/redfish/v1/Chassis/AC-109032/Power/PowerSupplies/1"
        },
        {
            "Manufacturer":  "HPE-Nimble",
            "@Redfish.Copyright":  "Copyright 2020 HPE and DMTF",
            "Name":  "power-supply2",
            "Description":  "power-supply2 Located in right rear of Chassis",
            "Status":  {
                           "State":  "Enabled",
                           "Health":  "OK"
                       },
            "MemberID":  "2",
            "InputRanges":  [
                                "@{OutputWattage=900; MinimumVoltage=100; MaximumVoltage=120; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}",
                                "@{OutputWattage=900; MinimumVoltage=200; MaximumVoltage=240; Maximumfrequency=60; InputType=AC; MinimumFrequency=50}"
                            ],
            "@odata.id":  "/redfish/v1/Chassis/AC-109032/Power/PowerSupplies/2"
        }
    ]
.LINK
    https://redfish.dmtf.org/schemas/Chassis.v1_9_0.json
#>   
[CmdletBinding()]
param(  [Parameter (Mandatory = $True)]
        [string] $ChassisId,
        
        [Parameter (Mandatory = $True)]
        [Validateset ("PowerControl","Voltages","PowerSupplies")]
        [string] $MetricName
    )
process{
    $LocalUri = Get-SwordfishURIFolderByFolder "Chassis"
    write-verbose "Folder = $LocalUri"
    $LocalData = invoke-restmethod2 -uri $LocalUri
    # Now must find if this contains links or directly goes to members. Only one of these will exist, whichever one will be the one that survives this assignment.
    $Links = (($LocalData).Links).Members + ($LocalData).Members
    $ReturnSet=@()
    foreach($link in $Links)
        {   $SingletonUri=($link).'@odata.id'
            $Singleton=$base+$SingletonUri
            $Power=$Singleton+"/Power"
            if  ( ( (invoke-restmethod2 -uri $Singleton).id -like $ChassisId ) -or ( $ChassisId -eq '' ) )
                {   switch ($MetricName)
                    {   "PowerControl"  {   $PowerControlObj = (invoke-restmethod2 -uri $Power).PowerControl
                                            $ReturnSet+=$PowerControlObj
                                        }
                        "Voltages"      {   $ReturnSet=(invoke-restmethod2 -uri $Power).Voltages
                                        }
                        "PowerSupplies" {   $MyPowerSupplies = (invoke-restmethod2 -uri ($Power+'/PowerSupplies') )
                                            $MyPSObj=@()
                                            foreach( $MyPS in ($MyPowerSupplies).Members )
                                            {   $MyPSURI= $MyPS.'@odata.id'
                                                $MyPSObj+= (invoke-restmethod2 -uri ( $base+$MyPSURI ) )
                                            }
                                            $ReturnSet=$MyPSObj
                                        }
        }       }   } 
    return $ReturnSet
    }
}