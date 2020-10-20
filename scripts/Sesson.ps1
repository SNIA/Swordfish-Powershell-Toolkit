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
.LINK
    https://redfish.dmtf.org/schemas/v1/Session.v1_3_0.json
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param   (                                   [string] $Target    = "192.168.100.98",
                                            [string] $Port      = "5000",
                                            [string] $Protocol  = "https",
                                            [string] $Username  = "chris",
                                            [string] $Password  = "Pa55w0rd!"       
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
        {   $Global:Base= "https://$($Target)"                
        }
    $Global:BaseUri     = $Base+"/redfish/v1/"
    $Global:MOCK        = $false
    $SSBody = @{    UserName    =   $Username;
                    Password    =   $Password
               }     
    $BodyJSON = $SSBody | convertto-json
    Write-Verbose "Base URI = $BaseUri"
    Try     {   $ReturnData = invoke-restmethod -uri ( $BaseURI + "SessionService/Sessions" ) -method Post -Body $BodyJSON
                $ReturnATok = invoke-WebRequest -uri ( $BaseURI + "SessionService/Sessions" ) -method Post -Body $BodyJSON
            }
    Catch   {   $_
            }
    if ( $ReturnATok )
        {   $Global:XAuthToken = (($ReturnATok.Headers).'X-Auth-Token')
            $ReturnData | add-member -membertype NoteProperty -name 'X-Auth-Token' -value $XAuthToken
            return ($ReturnData)
        } else 
        {   Write-Error "No RedFish/SwordFish target Detected or wrong port used at that address"
        }
    }
}

function Get-SwordfishSessionService {
<#
.SYNOPSIS
    Retrieve the Session Service from the Swordfish Target.
.DESCRIPTION
    This returns the specifics of the Swordfish Session service, not the details of the Swordfish sessions themselves.
.EXAMPLE
    Get-SwordfishSessionService

    @odata.context : /redfish/v1/$metadata#SessionService.SessionService
    @odata.id      : /redfish/v1/SessionService
    @odata.type    : #SessionService.v1_1_2.SessionService
    Id             : SessionService
    Name           : SessionService
    Sessions       : @{@odata.id=/redfish/v1/SessionService/Sessions}
    ServiceEnabled : True
.LINK
    https://redfish.dmtf.org/schemas/v1/Session.v1_3_0.json
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param(  
     )
Process{  
    [array]$DefSSCol = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "SessionService" ) 
    return $DefSSCol  
}}

function Get-SwordfishSession {
<#
.SYNOPSIS
    Gets either the collection of Swordfish Sessions, or return the individual session information.
.DESCRIPTION
    Gets either the collection of Swordfish Sessions, or return the individual session information.
.PARAMETER SessionID
    The Session ID present on the SwordFish Target Device.
.EXAMPLE
    Get-SwordfishSession -SessionID 226

    @odata.context : /redfish/v1/$metadata#Session.Session
    @odata.id      : /redfish/v1/SessionService/Sessions/226
    @odata.type    : #Session.v1_1_0.Session
    Id             : 226
    Name           : User Session
    Description    : User Session
    UserName       : chris
.EXAMPLE
    Get-SwordfishSession -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#SessionCollection.SessionCollection
    @odata.type         : #SessionCollection.SessionCollection
    @odata.id           : /redfish/v1/SessionService/Sessions
    Name                : Session Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/SessionService/Sessions/226}}
.NOTES
    By default if the port is not given, it assumes port 5000, and if no hostname is given it assumes localhost.
.LINK
    https://redfish.dmtf.org/schemas/v1/Session.v1_3_0.json
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='Default')]                 [string]    $SessionID,
      
        [Parameter(ParameterSetName='ReturnCollectionOnly')]    [Switch]    $ReturnCollectionOnly
     )
Process{  
    $SessionsLink = ( Get-SwordfishSessionService ).Sessions
    switch ($PSCmdlet.ParameterSetName )
        {   'ReturnCollectionOnly'  {   [array]$DefSSCollection = invoke-restmethod2 -uri ( $Base + $SessionsLink.'@odata.id' ) 
                                        return $DefSSCollection
                                    }
            'Default'               {   # $CollectionSet = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Managers" )
                                        $Members = ( Get-SwordfishSession -ReturnCollectionOnly ).Members
                                        foreach ( $SesLink in $Members )
                                            {   $SES = Invoke-RestMethod2 -uri ( $base + ( $SesLink.'@odata.id' ) )
                                                [array]$DefSesCol += $SES 
                                            }
                                        if ( $SessionID )
                                            {   return ( $DefSesCol | Where-Object { $_.id -like $SessionID } )
                                            } else
                                            {   return ( $DefSesCol )
                                            }
                                    }
        }  
}}
