function Get-SwordfishSessionToken 
{
<#
.SYNOPSIS
    Connects to a SNIA Swordfish or Redfish API enabled device and obtain the Autorization Token that is required for further commands.
.DESCRIPTION
    An advanced function that populates a authorization token that the other commands in the PowerShell toolkit use. 
    Once the Token has been obtained other subsequent commands can be run without having to authenticate individually.
    Before using this command you MUST run the Connect-SwordfishTarget or Connect-RedfishTarget successfully.
.PARAMETER Username
    The username that will be sent to the device for authentication.
.PARAMETER Password
    The password that will be sent to the device for authentication.
.EXAMPLE
    PS:> Get-SwordfishSessionToken -username Chris -passwrd Pa55w0rd!
        
    @odata.context : /redfish/v1/$metadata#Session.Session
    @odata.id      : /redfish/v1/SessionService/Sessions/68
    @odata.type    : #Session.v1_1_0.Sess
    Id             : 68
    Name           : User Session
    Description    : User Session
    UserName       : chris
    X-Auth-Token   : fa4927c126ea40f5b49b4d8e1c540060  
.LINK
    https://redfish.dmtf.org/schemas/v1/Session.v1_3_0.json
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param   (   [Parameter(Mandatory=$true)]    [string] $Username,
            [Parameter(Mandatory=$true)]    [string] $Password 
        )
Process{
    if ( -not $BaseUri ) 
        {   Write-Warning "This command requires that you run the Connect-SwordfishTarget or Connect-RedfishTarget first."
            return
        } 
    $SSBody = @{    UserName    =   $Username;
                    Password    =   $Password
               }
    $MyBody=( $SSBody | convertTo-Json | out-string )
    write-verbose "the following RestAPI calls will use a Body of of `n$MyBody"
    $SSContType = @{   'Content-type'    = 'Application/json'
                   }
    $MyContent = ($SSContType | convertTo-Json | out-string)
    write-verbose "the following RestAPI calls will use a Content Type of `n$MyContent"
    $BodyJSON = $SSBody | convertto-json 
    $PowerShellVersion = ($PSVersionTable.PSVersion).major
    Try     {   if ( $PowerShellVersion -lt 6)
                    {   FixTheUntrustedLink
                        $ReturnData = invoke-restmethod -uri ( $BaseUri + "SessionService/Sessions" ) -header $SSContType -method Post -Body $BodyJSON
                        $ReturnATok = invoke-WebRequest -uri ( $BaseUri + "SessionService/Sessions" ) -header $SSContType -method Post -Body $BodyJSON
                    } else 
                    {   $ReturnData = invoke-restmethod -uri ( $BaseUri + "SessionService/Sessions" ) -header $SSContType -method Post -Body $BodyJSON -SkipCertificateCheck
                        $ReturnATok = invoke-WebRequest -uri ( $BaseUri + "SessionService/Sessions" ) -header $SSContType -method Post -Body $BodyJSON -SkipCertificateCheck                        
                    }
                
            }
    Catch   {   write-error $_
            }
    if ( $ReturnATok )
        {   $Global:XAuthToken = (($ReturnATok.Headers).'X-Auth-Token')
            $ReturnData | add-member -membertype NoteProperty -name 'X-Auth-Token' -value $XAuthToken
            return ($ReturnData)
        } else 
        {   throw "No RedFish/Swordfish target Detected or wrong port used at that address"
        }
    }
}
Set-Alias -value 'Get-SwordfishSessionToken' -name 'Get-RedfishSessionToken'

function Get-SwordfishSessionService 
{
<#
.SYNOPSIS
    Retrieve the Session Service from the Swordfish or Redfish Target.
.DESCRIPTION
    This returns the specifics of the Swordfish or Redfish Session service, not the details of the sessions themselves.
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
[CmdletBinding()]
param(  
     )
Process
    {   [array]$DefSSCol = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "SessionService" ) 
        return $DefSSCol  
    }
}
Set-Alias -value 'Get-SwordfishSessionService' -name 'Get-RedfishSessionService'

function Get-SwordfishSession 
{
<#
.SYNOPSIS
    Gets either the collection of Swordfish or Redfish Sessions, or return the individual session information.
.DESCRIPTION
    Gets either the collection of Swordfish or Redfish Sessions, or return the individual session information.
.PARAMETER SessionID
    The Session ID present on the Swordfish Target Device.
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
Process
    {   $SessionsLink = ( Get-SwordfishSessionService ).Sessions
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
                                                    } 
                                                else
                                                    {   return ( $DefSesCol )
                                                    }
                                        }
        }  
    }
}
Set-Alias -value 'Get-SwordfishSession' -name 'Get-RedfishSession'
