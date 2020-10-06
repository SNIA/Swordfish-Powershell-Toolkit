function Get-SwordfishSessionToken {
<#
.SYNOPSIS
    Connects to a SNIA SwordFish API enabled device and obtain the Autorization Token that is required for further commands.
.DESCRIPTION
    Get-SwordfishSessionToken is an advanced function that populates a authorization token that the other commands in the 
    swordfish powershell toolkit use. Once the Token has been obtained other subsequent commands can be run without having to authenticate individually.
.PARAMETER Target
    The DNS name or IP address of the SwordFish Target Device.
.PARAMETER Port
        The DNS name or IP address of the SwordFish Target Device. This will default to 5000 if not specified but is only needed if changing the protocol to HTTP.
.PARAMETER Protocol
    Can be used to force the toolkit to use either HTTP or HTTPS. Either the Port can be specified, or the HTTPs protocol since the HTTPS protocol will use port 443.
    This will default to HTTPS if not specified
.PARAMETER Username
    The username that will be sent to the device for authentication.
.PARAMETER Password
    The password that will be sent to the device for authentication.
.EXAMPLE
    PS:> Get-SwordFishSessionToken -Target 192.168.1.50 -protocol https -username Chris -passwrd Pa55w0rd!
        
    @odata.context : /redfish/v1/$metadata#Session.Session
    @odata.id      : /redfish/v1/SessionService/Sessions/68
    @odata.type    : #Session.v1_1_0.Session
    Id             : 68
    Name           : User Session
    Description    : User Session
    UserName       : chris
    X-Auth-Token   : fa4927c126ea40f5b49b4d8e1c540060  
.NOTES
    By default if the port is not given, it assumes port 5000, and if no hostname is given it assumes localhost. 
#>
[cmdletbinding()]
param   (   [Parameter(position=0)][string] $Target =   "192.168.100.98",
            [Parameter(position=1)][string] $Port =     "5000",
            [Parameter(position=1)][string] $Protocol = "https",
            [Parameter(position=1)][string] $Username = "chris",
            [Parameter(position=1)][string] $Password = "Pa55w0rd!"       
        )
Process{    
    if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
        {   $certCallback = @"
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback
        {
            public static void Ignore()
            {
                if(ServicePointManager.ServerCertificateValidationCallback ==null)
                {
                    ServicePointManager.ServerCertificateValidationCallback += 
                        delegate
                        (
                            Object obj, 
                            X509Certificate certificate, 
                            X509Chain chain, 
                            SslPolicyErrors errors
                        )
                        {
                            return true;
                        };
                }
            }
        }
"@
            Add-Type $certCallback
        }
    [ServerCertificateValidationCallback]::Ignore()
    if ( $Protocol -eq 'http')
        {   $Global:Base= "http://$($Target):$($Port)"
        } else 
        {   $Global:Base= "https://$($Target):443"                
        }
    $Global:RedFishRoot = "/redfish/v1/"
    $Global:BaseUri     = $Base+$RedfishRoot
    $SesLoc             = $BaseURI+"SessionService/Sessions"
    $Global:MOCK        = $false
    $SSBody = @{    UserName    =   $Username;
                    Password    =   $Password
               }     
    $BodyJSON = $SSBody | convertto-json
    Write-Verbose "Base URI = $BaseUri"
    Try     {   $ReturnData = invoke-restmethod -uri "$SesLoc" -method Post -Body $BodyJSON
                $ReturnD = invoke-WebRequest -uri "$SesLoc" -method Post -Body $BodyJSON
            }
    Catch   {   $_
            }
    if ( $ReturnD )
        {   $XAuth = (($ReturnD.Headers).'X-Auth-Token')
            $ReturnData | add-member -membertype NoteProperty -name 'X-Auth-Token' -value $XAuth
            $Global:XAuthToken = $XAuth
            return ($ReturnData)
        } else 
        {   Write-Error "No RedFish/SwordFish target Detected or wrong port used at that address"
        }
    }

}
    
