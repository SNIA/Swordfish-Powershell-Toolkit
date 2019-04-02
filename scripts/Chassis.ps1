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
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $ChassisUri = $Base + ((($ReturnData).links).Chassis).'@odata.id'
        write-verbose "ChassisURI = $ChassisUri"
        $ChassisData = invoke-restmethod -uri $ChassisUri
        $ChassisLinks = (($ChassisData).Links).Members
        $ChassCol=@()  
        foreach($Chassis in $ChassisLinks)
            {   $SetChassisUri=($Chassis).'@odata.id'
                $GetSetChassis=$base+$SetChassisUri
                if ( ( (invoke-restmethod -uri $GetSetChassis).id -like $ChassisId ) -or ( $ChassisId -eq '' ) )
                    {   $ChassCol+=invoke-restmethod -uri $GetSetChassis 
                    } 
            }
        return $Chasscol
    }
}
  
function Get-SwordFishChassisThermal{
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
    param(
        [Parameter (Mandatory = $True)]
        [string] $ChassisId,
        
        [Parameter (Mandatory = $True)]
        [Validateset ("Temperatures","Fans","Redundancy")]
        [string] $MetricName
    )
    process{
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $ChassisUri = $Base + ((($ReturnData).links).Chassis).'@odata.id'
        write-verbose "ChassisURI = $ChassisUri"
        $ChassisData = invoke-restmethod -uri $ChassisUri
        $ChassisLinks = (($ChassisData).Links).Members
        $ReturnSet=@()
        foreach($Chassis in $ChassisLinks)
            {   $SetChassisUri=($Chassis).'@odata.id'
                $GetSetChassis=$base+$SetChassisUri
                $GetSetChasThermals=$GetSetChassis+"/Thermal"
                if ( ( (invoke-restmethod -uri $GetSetChassis).id -like $ChassisId ) )
                    {   write-Verbose "Found Chassis"
                        switch ($MetricName)
                        {   "Temperatures"  {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).Temperatures
                                            }
                            "Fans"          {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).Fans
                                            }
                            "Redundancy"    {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).Redundancy
                                            }
                        }
                    } 
            }
        return $ReturnSet
    }
}

function Get-SwordFishChassisPower{
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
    param(
        [Parameter (Mandatory = $True)]
        [string] $ChassisId,
        
        [Parameter (Mandatory = $True)]
        [Validateset ("PowerControl","Voltages","PowerSupplies")]
        [string] $MetricName
    )
    process{
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $ChassisUri = $Base + ((($ReturnData).links).Chassis).'@odata.id'
        write-verbose "ChassisURI = $ChassisUri"
        $ChassisData = invoke-restmethod -uri $ChassisUri
        $ChassisLinks = (($ChassisData).Links).Members
        $ReturnSet=@()
        foreach($Chassis in $ChassisLinks)
            {   $SetChassisUri=($Chassis).'@odata.id'
                $GetSetChassis=$base+$SetChassisUri
                $GetSetChasThermals=$GetSetChassis+"/Power"
                if ( ( (invoke-restmethod -uri $GetSetChassis).id -like $ChassisId ) )
                    {   write-Verbose "Found Chassis"
                        switch ($MetricName)
                        {   "PowerControl"  {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).PowerControl
                                                $ReturnSet.PSTypeNames.clear()
                                                $ReturnSet.PSTypeNames.Add('Swordfish.ChassisPowerPowerControl')
                                                $ReturnSet.PSObject.TypeNames.Insert(0,'Swordfish.ChassisPowerPowerControl.TypeName')
                                            }
                            "Voltages"      {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).Voltages
                                                $ReturnSet.psobject.TypeNames.Insert(0,'Swordfish.ChassisPowerVoltages')
                                                $ReturnSet.pstypenames.Insert(0,'Swordfish.ChassisPowerVoltages')
                                            }
                            "PowerSupplies" {   $ReturnSet=(invoke-restmethod -uri $GetSetChasThermals).PowerSupplies
                                                $ReturnSet.psobject.TypeNames.Insert(0,'Swordfish.ChassisPowerPowerSupplies')
                                                $ReturnSet.pstypenames.Insert(0,'Swordfish.ChassisPowerPowerSupplies')
                                            }

                                            
                        }
                    } 
            }
        return $ReturnSet
    }
}