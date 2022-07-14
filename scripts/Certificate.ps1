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
.LINK
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
                        $MyC3 = get-redfishByUrl $MyC2
                        # write-host "MyC3"
                        # $MyC3 | convertto-json
                        if ( $MyC3.Links )
                                {   $MyLinks = $MyC3.Links
                                } 
                            else 
                                {    $MyLinks = $MyC3
                                }

                        foreach ( $OneC in ($MyLinks).Certificates )
                            {   $DefCol += $( Get-RedfishByURL $OneC )
                            }
                    }
            if ( $ReturnCollectionOnly )
                    {   return $MyC3
                    }
                else 
                    {   if ( $CertificateID )
                                {   return ( $DefCol | where {$_.id -eq $CertificateID })
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
.LINK
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  
    )
process{
    return (invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "CertificateService" ) )
        }
    
}
Set-Alias -Name 'Get-RedfishCertificateService' -Value 'Get-SwordfishCertificateService'