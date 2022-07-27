function Get-SwordfishCertificate
{
<#
.SYNOPSIS
    Retrieve The list of Tasks or the Certificate Service collection from the Redfish or Swordfish Target.
.DESCRIPTION
    Retrieve The list of Tasks or the Certificate Service collection from the Redfish or Swordfish Target. 
.PARAMETER CertificateId
    The CertificateId will limit the returned data to ONLY the single Certificate specified if it exists. Without 
    this argument, the command will attempt to retrieve all tasks.
.PARAMETER ReturnCollectioOnly
    This switch will return the Certificate Service collection instead of an array of the 
    tasks.
.EXAMPLE
    The Following output is a Generic Example, for detailed examples see the Example folder in this Module
    PS> Get-RedfishCertificateService

    @odata.context       : /redfish/v1/$metadata#CertificateService.CertificateService
    @odata.etag          : W/"90FBE318"
    @odata.id            : /redfish/v1/CertificateService/
    @odata.type          : #CertificateService.v1_0_3.CertificateService
    Id                   : CertificateService
    Actions              : @{#CertificateService.GenerateCSR=}
    CertificateLocations : @{@odata.id=/redfish/v1/CertificateService/CertificateLocations/}
    Description          : Certificate service
    Name                 : Certificate Service
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ReturnCollection')]    [Switch]    $ReturnCollectionOnly
     )
process{    $DefCol=@()
            if ( $(Get-SwordfishCertificateService).CertificateLocations )
                    {   $MyC1 = $(Get-RedfishCertificateService).CertificateLocations
                        #write-host "MyC1"
                        #$MyC1 | convertto-json | out-string

                        $MyC2 = $MyC1.'@odata.id'
                        # write-host "MyC2"
                        $MyC3 = Get-RedfishByURL -URL $MyC2
                        # write-host "MyC3"
                        # $MyC3 | convertto-json
                        if ( $MyC3.Links )
                                {   $MyLinks = $MyC3.Links
                                } 
                            else 
                                {    $MyLinks = $MyC3
                                }

                        foreach ( $OneC in ($MyLinks).Certificates )
                            {   $DefCol += $( Get-RedfishByURL -URL $OneC )
                            }
                    }
            if ( $ReturnCollectionOnly )
                    {   return $MyC3
                    }
                else 
                    {   if ( $CertificateID )
                                {   return ( $DefCol | where-object {$_.id -eq $CertificateID })
                                }
                            else 
                                {  return   $DefCol    
                                }
                    }
        }
}
Set-Alias -Name 'Get-RedfishCertificate' -Value 'Get-SwordfishCertificate'

function Get-SwordfishCertificateService
{
<#
.SYNOPSIS
    Retrieve The Certificate Service from the Redfish or Swordfish Target.
.DESCRIPTION
    Retrieve The Certificate Service from the Redfish or Swordfish Target. 
.EXAMPLE 
    The Following output is a Generic Example, for detailed examples see the Example folder in this Module
    PS> Get-RedfishCertificateService

    @odata.context       : /redfish/v1/$metadata#CertificateService.CertificateService
    @odata.etag          : W/"90FBE318"
    @odata.id            : /redfish/v1/CertificateService/
    @odata.type          : #CertificateService.v1_0_3.CertificateService
    Id                   : CertificateService
    Actions              : @{#CertificateService.GenerateCSR=}
    CertificateLocations : @{@odata.id=/redfish/v1/CertificateService/CertificateLocations/}
    Description          : Certificate service
    Name                 : Certificate Service
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param()
process{    return ( Get-RedfishByURL -URL '/redfish/v1/CertificateService' )
       }    
}
Set-Alias -Name 'Get-RedfishCertificateService' -Value 'Get-SwordfishCertificateService'