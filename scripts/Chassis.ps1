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
    The following is an example from the HPE ProLiant DL360 Gen 10 Server in the SNIA Labs
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
    Manufacturer    : HPE
    Model           : ProLiant DL360 Gen10
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
.EXAMPLE
    The following is an example from the Dell R640 Server in the SNIA Labs
    PS:> Get-RedfishChassis

    @odata.context     : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id          : /redfish/v1/Chassis/System.Embedded.1
    @odata.type        : #Chassis.v1_11_0.Chassis
    Actions            : @{#Chassis.Reset=}
    Assembly           : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/Assembly}
    AssetTag           :
    ChassisType        : RackMount
    Description        : It represents the properties for physical components for any system.It represent racks, rackmount servers, blades, standalone, modular systems,enclosures, and all
                         other containers.The non-cpu/device centric parts of the schema are all accessed either directly or indirectly through this resource.
    EnvironmentalClass : A2 
    Id                 : System.Embedded.1
    IndicatorLED       : Lit
    Links              : @{ComputerSystems=System.Object[]; ComputerSystems@odata.count=1; Contains=System.Object[]; Contains@odata.count=2; CooledBy=System.Object[];
                         CooledBy@odata.count=16; Drives=System.Object[]; Drives@odata.count=0; ManagedBy=System.Object[]; ManagedBy@odata.count=1; ManagersInChassis=System.Object[];
                         ManagersInChassis@odata.count=1; PCIeDevices=System.Object[]; PCIeDevices@odata.count=7; PoweredBy=System.Object[]; PoweredBy@odata.count=2;
                         Processors=System.Object[]; Processors@odata.count=2; Storage=System.Object[]; Storage@odata.count=4}
    Location           : @{Info=;;;;1; InfoFormat=DataCenter;RoomName;Aisle;RackName;RackSlot; Placement=; PostalAddress=}
    Manufacturer       : Dell Inc.
    Memory             : @{@odata.id=/redfish/v1/Systems/System.Embedded.1/Memory}
    Model              : PowerEdge R640
    Name               : Computer System Chassis
    NetworkAdapters    : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/NetworkAdapters}
    Oem                : @{Dell=}
    PCIeSlots          : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/PCIeSlots}
    PartNumber         : 008R9MX08
    PhysicalSecurity   : @{IntrusionSensor=Normal; IntrusionSensorNumber=115; IntrusionSensorReArm=Manual}
    Power              : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/Power}
    PowerState         : On
    SKU                : GGSPJH2
    Sensors            : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/Sensors}
    SerialNumber       : CN7475171J0074
    Status             : @{Health=OK; HealthRollup=OK; State=Enabled}
    Thermal            : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/Thermal}
    UUID               : 4c4c4544-0047-5310-8050-c7c04f4a4832

    @Redfish.Settings : @{@odata.context=/redfish/v1/$metadata#Settings.Settings; @odata.type=#Settings.v1_3_0.Settings; SettingsObject=; SupportedApplyTimes=System.Object[]}
    @odata.context    : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id         : /redfish/v1/Chassis/Enclosure.Internal.0-0:RAID.Slot.1-1
    @odata.type       : #Chassis.v1_11_0.Chassis
    Actions           :
    AssetTag          :
    ChassisType       : StorageEnclosure
    Description       : Backplane 0 on Connector 0 of RAID Controller in Slot 1
    Id                : Enclosure.Internal.0-0:RAID.Slot.1-1
    Links             : @{ContainedBy=; Contains=System.Object[]; Contains@odata.count=0; Drives=System.Object[]; Drives@odata.count=2; ManagedBy=System.Object[]; ManagedBy@odata.count=1;
                        PCIeDevices=System.Object[]; PCIeDevices@odata.count=1; Storage=System.Object[]; Storage@odata.count=1}
    Manufacturer      :
    Model             : BP14G+ 0:0
    Name              : BP14G+ 0:0
    Oem               : @{Dell=}
    PartNumber        :
    PowerState        : On
    SKU               :
    SerialNumber      :
    Status            : @{Health=OK; HealthRollup=OK; State=Enabled}

    @Redfish.Settings : @{@odata.context=/redfish/v1/$metadata#Settings.Settings; @odata.type=#Settings.v1_3_0.Settings; SettingsObject=; SupportedApplyTimes=System.Object[]}
    @odata.context    : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id         : /redfish/v1/Chassis/Enclosure.Internal.0-1:NonRAID.Integrated.1-1
    @odata.type       : #Chassis.v1_11_0.Chassis
    Actions           :
    AssetTag          :
    ChassisType       : StorageEnclosure
    Description       : Backplane 1 on Connector 0 of Integrated Storage Controller 1
    Id                : Enclosure.Internal.0-1:NonRAID.Integrated.1-1
    Links             : @{ContainedBy=; Contains=System.Object[]; Contains@odata.count=0; Drives=System.Object[]; Drives@odata.count=2; ManagedBy=System.Object[]; ManagedBy@odata.count=1;
                        PCIeDevices=System.Object[]; PCIeDevices@odata.count=1; Storage=System.Object[]; Storage@odata.count=1}
    Manufacturer      :
    Model             : BP14G+ 0:1
    Name              : BP14G+ 0:1
    Oem               : @{Dell=}
    PartNumber        :
    PowerState        :
    SKU               :
    SerialNumber      :
    Status            : @{Health=; HealthRollup=; State=Enabled}
.EXAMPLE
    The following is an example from the Lenovo XCC Server in the SNIA Labs
    PS:> Get-RedfishChassis

    Manufacturer       : Lenovo
    Description        : This resource is used to represent a chassis or other physical enclosure for a Redfish implementation.
    IndicatorLED       : Off
    SerialNumber       : J10003YV
    PartNumber         : SB27A01982
    Memory             : @{@odata.id=/redfish/v1/Systems/1/Memory}
    @odata.id          : /redfish/v1/Chassis/1
    UUID               : F95FC508-986B-11E7-85F8-7ED30AE1044F
    EnvironmentalClass : A4
    HeightMm           : 44.45
    SKU                : 7X02CTO1WW
    PCIeDevices        : @{@odata.id=/redfish/v1/Chassis/1/PCIeDevices}
    Location           : @{PostalAddress=; Placement=; PartLocation=; Contacts=System.Object[]}
    Status             : @{State=Enabled; Health=OK}
    Oem                : @{Lenovo=}
    Links              : @{ManagedBy=System.Object[]; ManagersInChassis=System.Object[]; PoweredBy=System.Object[]; PCIeDevices=System.Object[]; Storage=System.Object[];
                         Drives=System.Object[]; ComputerSystems=System.Object[]; Processors=System.Object[]; CooledBy=System.Object[]}
    NetworkAdapters    : @{@odata.id=/redfish/v1/Chassis/1/NetworkAdapters}
    Id                 : 1
    Name               : Chassis
    @odata.type        : #Chassis.v1_12_0.Chassis
    AssetTag           :
    PCIeSlots          : @{@odata.id=/redfish/v1/Chassis/1/PCIeSlots}
    PowerState         : On
    Power              : @{@odata.id=/redfish/v1/Chassis/1/Power}
    @odata.etag        : "186a545456a0a33bb221f5"
    Model              : 7X02CTO1WW
    ChassisType        : RackMount
    Thermal            : @{@odata.id=/redfish/v1/Chassis/1/Thermal}
    LogServices        : @{@odata.id=/redfish/v1/Systems/1/LogServices}

    Status       : @{State=Enabled; Health=OK}
    Oem          : @{Lenovo=}
    Description  : This resource is used to represent a chassis or other physical enclosure for a Redfish implementation.
    Id           : 3
    SerialNumber : V1SH77F002S
    @odata.type  : #Chassis.v1_12_0.Chassis
    ChassisType  : Enclosure
    PartNumber   : SC57A01987
    Name         : Backplane
    SKU          : 01GV281
    @odata.etag  : "3c84039472612964eb7"
    Model        :
    @odata.id    : /redfish/v1/Chassis/3
    PowerState   :
    Manufacturer : LNVO
.EXAMPLE
    The following is an example from the Intel Reference Server in the SNIA Labs
    PS:> Get-RedfishChassis
    
    @odata.context   : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id        : /redfish/v1/Chassis/RackMount
    @odata.type      : #Chassis.v1_9_1.Chassis
    Id               : RackMount
    Name             : Computer System Chassis
    Description      : System Chassis
    ChassisType      : RackMount
    Manufacturer     : Intel Corporation
    Model            : S2600WFT
    SerialNumber     : ..................
    PartNumber       : ..................
    PowerState       : On
    PhysicalSecurity : @{IntrusionSensorNumber=4; IntrusionSensor=Normal}
    IndicatorLED     : Off
    Status           : @{State=Enabled; Health=OK; HealthRollup=OK}
    Links            : @{Storage=System.Object[]; ComputerSystems=System.Object[]; ManagedBy=System.Object[]; Contains=System.Object[]}
    @odata.etag      : 315fc4a001fb1cf1ff736adc9b648b01

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/Baseboard
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : Baseboard
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : Intel Corporation
    Model          : S2600WFT
    SerialNumber   : BQWF83800130
    PartNumber     : H48104-853
    PowerState     : On
    Thermal        : @{@odata.id=/redfish/v1/Chassis/RackMount/Baseboard/Thermal}
    Power          : @{@odata.id=/redfish/v1/Chassis/RackMount/Baseboard/Power}
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : b5fd9b36429d1e08811ae52ecf6c1b5a

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/FrontPanel
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : FrontPanel
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : Intel Corporation
    Model          : FFPANEL
    SerialNumber   : BQWL83104026
    PartNumber     : H39380-171
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 85ca3ef0ee489fbf6448a8d4cc504b9e

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/HSBackplane1
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : HSBackplane1
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : Intel Corporation
    Model          : F1U8X25S3PHSBP
    SerialNumber   : BQWK83500933
    PartNumber     : H88382-351
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; Drives=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 23686e2513c28ac886c00c922737a7e3

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/PCIeRiser1
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : PCIeRiser1
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : Intel Corporation
    Model          : F1UL16RISER3
    SerialNumber   : BQWK81301247
    PartNumber     : H88399-250
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 87ac00c0de186c9dd60dd4d9dec0fc64

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/PCIeRiser2
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : PCIeRiser2
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : Intel Corporation
    Model          : F1UL16RISER3
    SerialNumber   : BQWK83600837
    PartNumber     : H88399-250
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 53bf612a650d4a35ba1804f0f4f1c1dd

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/PwrSupply1FRU
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : PwrSupply1FRU
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : FLEXTRONICS
    Model          : S-1100ADU00-201
    SerialNumber   : EXWD83501687
    PartNumber     : G84027-009
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 29aec62a519d15015417a8ee22288e15
.EXAMPLE
    PS:> Get-SwordfishChassis -ChassisId PwrSupply1FRU

    @odata.context : /redfish/v1/$metadata#Chassis.Chassis
    @odata.id      : /redfish/v1/Chassis/RackMount/PwrSupply1FRU
    @odata.type    : #Chassis.v1_9_1.Chassis
    Id             : PwrSupply1FRU
    Name           : Computer System Card
    ChassisType    : Card
    Manufacturer   : FLEXTRONICS
    Model          : S-1100ADU00-201
    SerialNumber   : EXWD83501687
    PartNumber     : G84027-009
    PowerState     : On
    Links          : @{ComputerSystems=System.Object[]; ManagedBy=System.Object[]; ContainedBy=}
    @odata.etag    : 29aec62a519d15015417a8ee22288e15
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
            {   # $ReturnData = @{}
                ForEach ( $PowerHash in ($MyChassis).Power )
                    {   # write-warning 'Inside loop'
                        $MyURL = $PowerHash.'@odata.id'
                        try     {   $Powers = Invoke-RestMethod2 -uri ( $Base + $MyURL )   
                                    if ( $Powers )
                                        {   #write-warning 'about to switch'
                                            #write-host "The url is as follows"
                                            #$Base + $MyURL
                                            #$Powers | convertto-json | out-string
                                            switch ($MetricName)
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