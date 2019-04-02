function Connect-SwordFishTarget {
    <#
    .SYNOPSIS
        Connects to a SNIA SwordFish API enabled device.
    .DESCRIPTION
        Connect-SwordFishTarget is an advanced function that provides the initial connection to a SwordFish
        so that other subsequent commands can be run without having to authenticate individually.
        It is recommended to ignore the server certificate validation (-IgnoreServerCertificate param)
    .PARAMETER Group
        The DNS name or IP address of the SwordFish Target Device.
    .EXAMPLE
         Connect-SwordFish -Target 192.168.1.50 -port 5000
    .NOTES
        By default if the port is not given, it assumes port 5000, and if no hostname is given it assumes localhost.
    #>
        [cmdletbinding()]
        param   (
            [Parameter(position=0)]
            [string]$Target="192.168.1.229",
            
            [Parameter(position=1)]
            [string]$Port="5000"
        )
        Process{
            $Global:Base = "http://$($Target):$($Port)"
            $Global:RedFishRoot = "/redfish/v1/"
            $Global:BaseUri = $Base+$RedfishRoot
            Write-host "Base URI = $BaseUri"
            Try     {   $ReturnData = invoke-restmethod -uri "$BaseUri" 
                    }
            Catch   {   $_
                    }
            if ( $ReturnData )
            {   return $ReturnData
                <#  foreach($key in $ReturnData.PSObject.Properties)
                    {   $name=$key.name
                        $value=$key.value
                        write-verbose "Key = $name Value = $value"
                    }
                    #>
            }
            else 
            {   Write-Error "No RedFish/SwordFish target Detected or wrong port used at that address"
            }
        }
    }

