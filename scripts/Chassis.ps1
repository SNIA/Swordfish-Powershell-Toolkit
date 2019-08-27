function Get-SwordFishChassis{
    <#
    .SYNOPSIS
        Retrieve The list of valid Chassis' from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Chassis objects that exist or if a single Chassis ID is selected, 
        it will return only the single Chassis ID.
    .PARAMETER ChassisId
        The Chassis ID name for a specific Chassis, otherwise the command
        will return all Chassis.
    .EXAMPLE
         Get-SwordFishChassis
    .EXAMPLE
         Get-SwordFishCHassis -ChassisId Chassis-13
    .LINK
        https://redfish.dmtf.org/schemas/Chassis.v1_9_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $ChassisId
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
                        } 
                }

            }
        return $LocalCol
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
    Get-SwordFishCHassisThermal -ChassisId Chassis-13 -MetricName Temperatures
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
                {   write-Verbose "Found Chassis"
                    switch ($MetricName)
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

function Get-SwordFishChassisPower
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
         Get-SwordFishCHassisThermal -ChassisId Chassis-13 -MetricName Voltage

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
                {   write-Verbose "Found Chassis"
                    switch ($MetricName)
                    {   "PowerControl"  {   $ReturnSet=(invoke-restmethod2 -uri $Power).PowerControl
                                        }
                        "Voltages"      {   $ReturnSet=(invoke-restmethod2 -uri $Power).Voltages
                                        }
                        "PowerSupplies" {   $ReturnSet=(invoke-restmethod2 -uri $Power).PowerSupplies
                                        }
                    }
                } 
        }
    return $ReturnSet

    }
}