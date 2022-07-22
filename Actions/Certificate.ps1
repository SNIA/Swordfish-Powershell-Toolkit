
function New-RedfishCertificate {
<#
.SYNOPSIS
    This command will create a new Security Certificate on the redfish endpoint. 
.DESCRIPTION
    This command will create a new Security Certificate on the redfish endpoint.
.PARAMETER AlternativeNames
    The additional host names of the component to secure.
.PARAMETER CertificateCollectionODataLocation
    The link to the certificate collection where the certificate is installed after the
    certificate authority (CA) signs the certificate. Contains a link to a resource. 
    Please use a has table in the format of @{CertificateCollection=@{'@odata.id'='/redfish/v1/CertificateLocation'
.PARAMETER ChallengePassword
    The challenge password to apply to the certificate for revocation requests.
.PARAMETER City
    The city or locality of the organization making the request.
.PARAMETER CommonName
    The fully qualified domain name of the component to secure.
.PARAMETER ContactPerson
    The name of the user making the request.
.PARAMETER Country
    The two-letter country code of the organization making the request
.PARAMETER Email
    The email address of the contact within the organization making the request
.PARAMETER GivenName
    The given name of the user making the request.
.PARAMETER Initials
    The initials of the user making the request.
.PARAMETER KeyBitLength
    The length of the key, in bits, if needed based on the KeyPairAlgorithm parameter value.
.PARAMETER KeyCurveId
    The curve ID to use with the key, if needed based on the KeyPairAlgorithm parameter value.
.PARAMETER KeyPairAlgorithm
    The type of key-pair for use with signing algorithms.
.PARAMETER KeyUsage
    The usage of the key contained in the certificate. For the possible property values, see KeyUsage in Property details.
.PARAMETER Organization
    The name of the organization making the request.
.PARAMETER OrganizationalUnit
    The name of the unit or division of the organization making the request
.PARAMETER State
    The state, province, or region of the organization making the request.
.PARAMETER Surname
    The surname of the user making the request.
.PARAMETER UnstructuredNam
    The unstructured name of the subject.
.PARAMETER Oem
    Can be a custom object to represent any OEM specific values.
.NOTES
    Uses CertificateService 1.0.4
.LINK 
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf

#>   
    [CmdletBinding()]
    param(                                  [string[]]  $AlternativeNames,
            [parameter(mandatory=$true,HelpMessage="Please use a has table in the format of @{CertificateCollection=@{'@odata.id'='/redfish/v1/CertificateLocation'}}" )]    
                                            [string]    $CertificateCollectionODataLocation,
                                            [string]    $ChallengePassword,
            [parameter(mandatory=$true)]    [string]    $City,
            [parameter(mandatory=$true)]    [string]    $CommonName,
                                            [string]    $ContactPerson,
            [parameter(mandatory=$true)]    [string]    $Country,
                                            [String]    $Email,
                                            [String]    $GivenName,
                                            [String]    $Initials,
                                            [int]       $KeyBitLength,
                                            [string]    $KeyCurveId,
                                            [String]    $KeyPairAlgorithm,
            [ValidateSet('ClientAuthentication', 'CodeSigning', 'CRLSigning', 'DataEncipherment', 'DecipherOnly', 'DigitalSignature ', 
                         'EmailProtection ', 'EncipherOnly', 'KeyAgreement ', 'KeyCertSign', 'KeyEncipherment', 'NonRepudiation', 
                         'OCSPSigning', 'ServerAuthentication', 'Timestamping')]
                                            [string[]]  $KeyUsage,
            [parameter(mandatory=$true)]    [string]    $Organization,
            [parameter(mandatory=$true)]    [string]    $OrganizationalUnit,
            [parameter(mandatory=$true)]    [string]    $State,
                                            [string]    $Surname,
                                            [string]    $UnstructuredName,
                                                        $Oem       
    )
    process {
        $CData = Get-RedfishCertificateService
        $CBody = @()
        if ( $PSBoundParameters.ContainsKey('AlternativeNames'))                    {    $CBody += @{ AlternativeNames      = $AlternativeNames     } }
        if ( $PSBoundParameters.ContainsKey('CertificateCollectionODataLocation'))  {    $CBody += @{ CertificateCollection = @{ '@odata.id' = $CertificateCollectionODataLocation }}}
        if ( $PSBoundParameters.ContainsKey('ChallengePassword'))                   {    $CBody += @{ ChallengePassword     = $ChallengePassword    } }
        if ( $PSBoundParameters.ContainsKey('City'))                                {    $CBody += @{ City                  = $City                 } }
        if ( $PSBoundParameters.ContainsKey('CommonName'))                          {    $CBody += @{ CommonName            = $CommonName           } }
        if ( $PSBoundParameters.ContainsKey('ContactPerson'))                       {    $CBody += @{ ContactPerson         = $ContactPerson        } }
        if ( $PSBoundParameters.ContainsKey('Country'))                             {    $CBody += @{ Country               = $Country              } }
        if ( $PSBoundParameters.ContainsKey('Email'))                               {    $CBody += @{ Email                 = $Email                } }
        if ( $PSBoundParameters.ContainsKey('GivenName'))                           {    $CBody += @{ GivenName             = $GivenName            } }
        if ( $PSBoundParameters.ContainsKey('Initials'))                            {    $CBody += @{ Initials              = $Initials             } }
        if ( $PSBoundParameters.ContainsKey('KeyBitLength'))                        {    $CBody += @{ KeyBitLength          = $KeyBitLength         } }
        if ( $PSBoundParameters.ContainsKey('KeyCurveId'))                          {    $CBody += @{ KeyCurveId            = $KeyCurveId           } }
        if ( $PSBoundParameters.ContainsKey('KeyPairAlgorithm'))                    {    $CBody += @{ KeyPairAlgorithm      = $KeyPairAlgorithm     } }
        if ( $PSBoundParameters.ContainsKey('KeyUsage'))                            {    $CBody += @{ KeyUsage              = $KeyUsage             } }
        if ( $PSBoundParameters.ContainsKey('Organization'))                        {    $CBody += @{ Organization          = $Organization         } }
        if ( $PSBoundParameters.ContainsKey('OrganizationalUnit'))                  {    $CBody += @{ OrganizationalUnit    = $OrganizationalUnit   } }
        if ( $PSBoundParameters.ContainsKey('State'))                               {    $CBody += @{ State                 = $State                } }
        if ( $PSBoundParameters.ContainsKey('Surname'))                             {    $CBody += @{ Surname               = $Surname              } }
        if ( $PSBoundParameters.ContainsKey('UnstructuredName'))                    {    $CBody += @{ UnstructuredName      = $UnstructuredName     } }
        if ( $PSBoundParameters.ContainsKey('Oem'))                                 {    $CBody += @{ Oem                   = $Oem                  } }

        $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' + '/Actions/CertificateService.GenerateCSR') -body $MyBody -Method 'POST'
        return $Result
    }
    
}

function Switch-RedfishCertificate {
<#
.SYNOPSIS
    This command replace an existing Certificate with a new Security Certificate on the redfish endpoint. 
.DESCRIPTION
    This command replace an existing Certificate with a new Security Certificate on the redfish endpoint. 
.PARAMETER CertificateString
    The additional host names of the component to secure.
.PARAMETER CertificateType
    The link to the certificate collection where the certificate is installed after the
    certificate authority (CA) signs the certificate. Contains a link to a resource. 
    Please use a has table in the format of @{CertificateCollection=@{'@odata.id'='/redfish/v1/CertificateLocation'
.PARAMETER ChallengeURILocation
    The link to the certificate collection where the certificate is installed after the
    certificate authority (CA) signs the certificate. Contains a link to a resource. 
    Please use a has table in the format of '@{'@odata.id'='/redfish/v1/CertificateLocation'
.NOTES
    Uses CertificateService 1.0.4
.LINK 
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding()]
param(  [parameter(mandatory=$true)]    [string]    $CertificateString,
        [ValidateSet('PEM','PEMchain','PKCS7')]
        [parameter(mandatory=$true)]    [string]    $CertificateType,
        [parameter(mandatory=$true,HelpMessage="Please use a has table in the format of @{CertificateUrl=@{'@odata.id'='/redfish/v1/CertificateLocation'}}" )]    
                                        [string]    $CertificateURILocation
     )
process {   $CData = Get-RedfishCertificateService
            $CBody = @{ CertificateString   = $CertificateString
                        CertificateType     = $CertificateType
                        CertificateUri      = $CertificateURILocation  
                      }
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' + '/Actions/CertificateService.ReplaceCertificate') -body $MyBody -Method 'POST'
            return $Result
        }
        
    }