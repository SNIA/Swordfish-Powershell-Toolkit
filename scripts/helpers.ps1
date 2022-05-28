function Connect-SwordfishTarget 
{
<#
.SYNOPSIS
    Connects to a SNIA Swordfish or Redfish API enabled device.
.DESCRIPTION
    Connect-SwordfishTarget is an advanced function that provides the initial connection to a Swordfish oe Redfish enabled device
    so that other subsequent commands can be run without having to authenticate individually.
.PARAMETER Target
    The DNS name or IP address of the Swordfish Target Device. This is a required parameter
.PARAMETER Port
    The port to connect with, If using HTTPS this is overridden and uses 443. This is a useful parameter if running a 
    Swordfish or Redfish Emulated Device instead of an actual Swordifsh or Redfish endpoint. This is not a required parameter.
.PARAMETER Protocol
    Can be used to force the toolkit to use either HTTP or HTTPS. Either the Port can be specified, or the HTTPs protocol 
    since the HTTPS protocol will use port 443.
.EXAMPLE
    This Redfish System exists in the DMTF/SNIA Lab and is an HPE ProLiant DL360 Gen 10

    PS:> Connect-RedfishTarget -Target 10.2.119.30                                                                                                                                                                                  

    @odata.context            : /redfish/v1/$metadata#ServiceRoot.ServiceRoot
    @odata.etag               : W/"ADF6535F"
    @odata.id                 : /redfish/v1/
    @odata.type               : #ServiceRoot.v1_5_1.ServiceRoot
    Id                        : RootService
    AccountService            : @{@odata.id=/redfish/v1/AccountService/}
    CertificateService        : @{@odata.id=/redfish/v1/CertificateService/}
    Chassis                   : @{@odata.id=/redfish/v1/Chassis/}
    EventService              : @{@odata.id=/redfish/v1/EventService/}
    JsonSchemas               : @{@odata.id=/redfish/v1/JsonSchemas/}
    Links                     : @{Sessions=}
    Managers                  : @{@odata.id=/redfish/v1/Managers/}
    Name                      : HPE RESTful Root Service
    Oem                       : @{Hpe=}
    Product                   : ProLiant DL360 Gen10
    ProtocolFeaturesSupported : @{ExpandQuery=; FilterQuery=True; OnlyMemberQuery=True; SelectQuery=True}
    RedfishVersion            : 1.6.0
    Registries                : @{@odata.id=/redfish/v1/Registries/}
    SessionService            : @{@odata.id=/redfish/v1/SessionService/}
    Systems                   : @{@odata.id=/redfish/v1/Systems/}
    Tasks                     : @{@odata.id=/redfish/v1/TaskService/}
    TelemetryService          : @{@odata.id=/redfish/v1/TelemetryService/}
    UUID                      : b961d9ce-97b7-5992-af0a-8912ec02b17a
    UpdateService             : @{@odata.id=/redfish/v1/UpdateService/}
    Vendor                    : HPE
.EXAMPLE
    This Redfish System exists in the DMTF/SNIA Lab and is an Dell PowerEdge R640 
    
    PS:> Connect-RedfishTarget -Target 10.2.119.32                                                                                                                                                                                  

    @odata.context            : /redfish/v1/$metadata#ServiceRoot.ServiceRoot
    @odata.id                 : /redfish/v1
    @odata.type               : #ServiceRoot.v1_6_0.ServiceRoot
    AccountService            : @{@odata.id=/redfish/v1/AccountService}
    CertificateService        : @{@odata.id=/redfish/v1/CertificateService}
    Chassis                   : @{@odata.id=/redfish/v1/Chassis}
    Description               : Root Service
    EventService              : @{@odata.id=/redfish/v1/EventService}
    Fabrics                   : @{@odata.id=/redfish/v1/Fabrics}
    Id                        : RootService
    JobService                : @{@odata.id=/redfish/v1/JobService}
    JsonSchemas               : @{@odata.id=/redfish/v1/JsonSchemas}
    Links                     : @{Sessions=}
    Managers                  : @{@odata.id=/redfish/v1/Managers}
    Name                      : Root Service
    Oem                       : @{Dell=}
    Product                   : Integrated Dell Remote Access Controller
    ProtocolFeaturesSupported : @{ExcerptQuery=False; ExpandQuery=; FilterQuery=True; OnlyMemberQuery=True; SelectQuery=True}
    RedfishVersion            : 1.9.0
    Registries                : @{@odata.id=/redfish/v1/Registries}
    SessionService            : @{@odata.id=/redfish/v1/SessionService}
    Systems                   : @{@odata.id=/redfish/v1/Systems}
    Tasks                     : @{@odata.id=/redfish/v1/TaskService}
    TelemetryService          : @{@odata.id=/redfish/v1/TelemetryService}
    UpdateService             : @{@odata.id=/redfish/v1/UpdateService}
    Vendor                    : Dell
.EXAMPLE
    This Redfish System exists in the DMTF/SNIA Lab and is an Lenovo XCC 10

    PS:> Connect-RedfishTarget -Target 10.2.119.34                                                                                                                                                                                  

    ProtocolFeaturesSupported : @{DeepOperations=; ExpandQuery=; OnlyMemberQuery=True; ExcerptQuery=True; FilterQuery=True; SelectQuery=True}
    Description               : This resource is used to represent a service root for a Redfish implementation.
    Registries                : @{@odata.id=/redfish/v1/Registries}
    EventService              : @{@odata.id=/redfish/v1/EventService}
    Links                     : @{Sessions=}
    RedfishVersion            : 1.10.0
    JsonSchemas               : @{@odata.id=/redfish/v1/JsonSchemas}
    Systems                   : @{@odata.id=/redfish/v1/Systems}
    UpdateService             : @{@odata.id=/redfish/v1/UpdateService}
    Chassis                   : @{@odata.id=/redfish/v1/Chassis}
    AccountService            : @{@odata.id=/redfish/v1/AccountService}
    UUID                      : F95FC508-986B-11E7-85F8-7ED30AE1044F
    SessionService            : @{@odata.id=/redfish/v1/SessionService}
    Name                      : Root Service
    @odata.type               : #ServiceRoot.v1_7_0.ServiceRoot
    Vendor                    : Lenovo
    TelemetryService          : @{@odata.id=/redfish/v1/TelemetryService}
    Managers                  : @{@odata.id=/redfish/v1/Managers}
    JobService                : @{@odata.id=/redfish/v1/JobService}
    @odata.etag               : "9dc2f3f6471431da3493d"
    Id                        : RootService
    CertificateService        : @{@odata.id=/redfish/v1/CertificateService}
    @odata.id                 : /redfish/v1/
    Tasks                     : @{@odata.id=/redfish/v1/TaskService}
.EXAMPLE
    This Redfish System exists in the DMTF/SNIA Lab and is an Cisco UCS
        
    PS:> Connect-RedfishTarget -Target 10.2.119.36                                                                                                                                                                                  

    @odata.id          : /redfish/v1
    @odata.type        : #ServiceRoot.v1_5_1.ServiceRoot
    @odata.context     : /redfish/v1/$metadata#ServiceRoot.ServiceRoot
    Id                 : RootService
    Name               : Cisco RESTful Root Service
    Description        : Root Service
    JsonSchemas        : @{@odata.id=/redfish/v1/JsonSchemas}
    Registries         : @{@odata.id=/redfish/v1/Registries}
    Systems            : @{@odata.id=/redfish/v1/Systems}
    AccountService     : @{@odata.id=/redfish/v1/AccountService}
    Managers           : @{@odata.id=/redfish/v1/Managers}
    UpdateService      : @{@odata.id=/redfish/v1/UpdateService}
    Chassis            : @{@odata.id=/redfish/v1/Chassis}
    SessionService     : @{@odata.id=/redfish/v1/SessionService}
    EventService       : @{@odata.id=/redfish/v1/EventService}
    CertificateService : @{@odata.id=/redfish/v1/CertificateService}
    Fabrics            : @{@odata.id=/redfish/v1/Fabrics}
    Tasks              : @{@odata.id=/redfish/v1/TaskService}
    Links              : @{Sessions=}
    RedfishVersion     : 1.5.1
    Product            : UCSC-C240-M5SX
    Vendor             : Cisco Systems Inc.
.EXAMPLE
    This Redfish System exists in the DMTF/SNIA Lab and is an Intel Reference Arch Server
        
    PS:> Connect-redfishTarget -Target 10.2.119.38                                                                                                                                                                                    

    @odata.context     : /redfish/v1/$metadata#ServiceRoot.ServiceRoot
    @odata.id          : /redfish/v1
    @odata.type        : #ServiceRoot.v1_5_1.ServiceRoot
    Id                 : RootService
    Name               : Root Service
    RedfishVersion     : 1.7.0
    UUID               : 88770d6b-744a-4cb4-abb0-c919c766d215
    Systems            : @{@odata.id=/redfish/v1/Systems}
    Chassis            : @{@odata.id=/redfish/v1/Chassis}
    Managers           : @{@odata.id=/redfish/v1/Managers}
    Tasks              : @{@odata.id=/redfish/v1/TaskService}
    SessionService     : @{@odata.id=/redfish/v1/SessionService}
    AccountService     : @{@odata.id=/redfish/v1/AccountService}
    UpdateService      : @{@odata.id=/redfish/v1/UpdateService}
    EventService       : @{@odata.id=/redfish/v1/EventService}
    Registries         : @{@odata.id=/redfish/v1/Registries}
    CertificateService : @{@odata.id=/redfish/v1/CertificateService}
    TelemetryService   : @{@odata.id=/redfish/v1/TelemetryService}
    Links              : @{Sessions=}
    @odata.etag        : 6ec95e65c638cc923c2802f5515488d5
.EXAMPLE
    This Swordfish System exists in the DMTF/SNIA Lab and is an HPE MSA 2060 Storage Array
    
    PS:> connect-swordfishtarget -Target 10.2.101.90                                                                                                                                                                                  

    @odata.context  : /redfish/v1/$metadata#ServiceRoot.ServiceRoot
    @odata.id       : /redfish/v1/
    @odata.type     : #ServiceRoot.v1_2_0.ServiceRoot
    Id              : RootService
    Name            : Root Service
    RedfishVersion  : 1.0.2
    UUID            : 92384634-2938-2342-8820-489239905423
    Systems         : @{@odata.id=/redfish/v1/ComputerSystem}
    Chassis         : @{@odata.id=/redfish/v1/Chassis}
    StorageServices : @{@odata.id=/redfish/v1/StorageServices}
    Managers        : @{@odata.id=/redfish/v1/Managers}
    Tasks           : @{@odata.id=/redfish/v1/TaskService}
    SessionService  : @{@odata.id=/redfish/v1/SessionService}
    Links           : @{Oem=; Sessions=}
.EXAMPLE
    This example illustrates how the PowerShell returned object can be shown in JSON format

    PS:> connect-swordfishtarget -Target 10.2.101.90 | ConvertTo-Json                                                                                                                                                                 {
    
    {
        "@odata.context":  "/redfish/v1/$metadata#ServiceRoot.ServiceRoot",
        "@odata.id":  "/redfish/v1/",
        "@odata.type":  "#ServiceRoot.v1_2_0.ServiceRoot",
        "Id":  "RootService",
        "Name":  "Root Service",
        "RedfishVersion":  "1.0.2",
        "UUID":  "92384634-2938-2342-8820-489239905423",
        "Systems":  {
                        "@odata.id":  "/redfish/v1/ComputerSystem"
                    },
        "Chassis":  {
                        "@odata.id":  "/redfish/v1/Chassis"
                    },
        "StorageServices":  {
                                "@odata.id":  "/redfish/v1/StorageServices"
                            },
        "Managers":  {
                         "@odata.id":  "/redfish/v1/Managers"
                     },
        "Tasks":  {
                      "@odata.id":  "/redfish/v1/TaskService"
                  },
        "SessionService":  {
                               "@odata.id":  "/redfish/v1/SessionService"
                           },
        "Links":  {
                      "Oem":  {

                              },
                      "Sessions":  {
                                       "@odata.id":  "/redfish/v1/SessionService/Sessions"
                                   }
                  }
    }
.LINK
    https://redfish.dmtf.org/schemas/v1/redfish-schema.v1_7_0.json
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param ( [Parameter(Mandatory=$true)]    [string]    $Target,
                                        [string]    $Port,            
        [Validateset("http","https")]   [string]    $Protocol   = "https"            
      )
Process
  {   if ( $Protocol -eq 'http')
                {   $Global:Base = "http://$($Target):$($Port)"
                } else 
                {   $Global:Base = "https://$($Target)"                
                }
            $Global:RedFishRoot = "/redfish/v1/"
            $Global:BaseTarget  = $Target
            $Global:BaseUri     = $Base+$RedfishRoot    
            $Global:MOCK        = $false
            $PowerShellVersion = ($PSVersionTable.PSVersion).major
            Try     {   if ( $PowerShellVersion -lt 6 ) 
                            {   FixTheUntrustedLink
                                $ReturnData = invoke-restmethod -uri "$BaseUri" 
                            } else 
                            {   $ReturnData = invoke-restmethod -uri "$BaseUri" -SkipCertificateCheck                          
                            }
                    }
            Catch   {   $_
                    }
            if ( $ReturnData )
                    {   write-verbose "The Global Redfish Root Location variable named RedfishRoot will be set to $RedfishRoot"
                        write-verbose "The Global Base Target Location variable named BaseTarget will be set to $BaseTarget"
                        write-verbose "The Global Base Uri Location variable named BaseUri will be set to $BaseUri"            
                        return $ReturnData
                    } 
                else 
                    {   Write-verbose "Since no connection was made, the global connection variables have been removed"
                        remove-variable -name RedfishRoot -scope Global
                        remove-variable -name BaseTarget -scope Global
                        remove-variable -name Base -scope Global
                        remove-variable -name BaseUri -scope Global
                        remove-variable -name MOCK -scope Global
                        Write-Error "No RedFish/Swordfish target Detected or wrong port used at that address"
                    }
  }
} 
Set-Alias -name 'Connect-RedfishTarget' -value 'Connect-SwordfishTarget'
function FixTheUntrustedLink
{   if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
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

}
function invoke-restmethod2
{
    [cmdletbinding()]
    param   (   [string] $Uri
            )
    process {   try {   if ( $Uri -ne $base )
                                {   write-verbose "Getting Result in Invoke-RestMethod2 Function using URI $Uri"
                                    if ( -not $XAuthToken ) 
                                            {   $XAuthToken = ""
                                            }
                                    $PowerShellVersion = [int]($PSVersionTable.PSVersion).major
                                    if ( $PowerShellVersion -lt 6)
                                            {   $XHead = @{ 'X-Auth-Token'   = $XAuthToken }
                                            }
                                        else{   $XHead = @{ 'X-Auth-Token'   = $XAuthToken[0] }
                                            }
                                    if ( $PowerShellVersion -lt 6)
                                        {   $ReturnObj = invoke-restmethod -Uri $Uri -headers $XHead
                                        } else 
                                        {   $ReturnObj = invoke-restmethod -Uri $Uri -headers $XHead -SkipCertificateCheck
                                        }
                                }    
                        return $ReturnObj
                    }
                catch { write-verbose "Invoke of $Uri failed"
                        $_
                    }
            }
}

function Get-SwordfishODataTypeName 
{   [cmdletbinding()]
    param   ( $DataObject
            )
    if ( $ReturnType = $DataObject.'@odata.type')
            {   # clip the first hash mark from the type name
                $ReturnType = $ReturnType.Substring(1)
                # clip everything after the first period symbol
                $ReturnType = $ReturnType.Substring(0,$ReturnType.indexof('.'))
                write-verbose "The Type name is $ReturnType"
                return $ReturnType
            } 
        else 
            {   write-verbose "No Type was found"
                return
            }
}

function Get-SwordfishURIFolderByFolder
{   [cmdletbinding()]
    param ( $Folder
          )
    write-verbose "Invoke-RestMethod from Get-SwordfishURIFolderByFolder function to find folder $Folder"      
    $GetRootLocation = invoke-restmethod2 -uri "$BaseUri" 
    
    if ( ((($GetRootLocation).links).$($Folder)).'@odata.id')
            {   $FolderUri = $Base + ((($GetRootLocation).links).$($Folder)).'@odata.id'
            }   
        else 
            {   $FolderUri = $Base + (($GetRootLocation).$($Folder)).'@odata.id'
            } 
    return $FolderUri
}