<# These will be re-enabled once we support Storage Services. For now the PowerShell Toolkit doesnt support ClassOfService.
#>

function Get-SwordfishClassOfService{
<#
.SYNOPSIS
    Retrieve The list of valid Classes of Services from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of 
    Classes of Services that exist across all of the Storage Services, unless a 
    specific Storage Service ID is used to limit it, or a specific 
    Classes of Services ID is directly requested. 
.PARAMETER StorageServiceId
    The Storage Service ID name for a specific Storage Service, otherwise the command
    will return Storage Classes of Service for all Storage Services.
.PARAMETER ClassOfServiceId
    The Class of Service ID will limit the returned data
    to the type specified, otherwise the command will return all Classes of Services.
.EXAMPLE
    Get-SwordfishStorageClassOfService
.EXAMPLE
    Get-SwordfishStorageClassOfService -StorageServiceId AC-102345
.EXAMPLE
    Get-SwordfishStorageClassOfService -StorageServiceId AC-102345 -ClassOfServiceId Gold
.EXAMPLE
    Get-SwordfishStorageClassOfService -ClassOfServiceId Gold
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/ClassOfService.v1_1_1.json
#>   
[CmdletBinding()]
param(  [string] $StorageServiceID,
        [string] $ClassOfServiceId
    )
process{# SS(s) = Storage Service(s)
        Write-Verbose "-+-+ Discovering the location of the Storage Services Root"
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        write-verbose "-+-+ Collecting the URIs to each Storage Services Root"
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $COSsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                write-verbose "-+-+ Determining if the Storage Service is excluded by parameter"
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   write-verbose "-+-+ Collecting Drive data about the specific Storage Service $SSUri"
                        $Data = invoke-restmethod -uri $SSUri
                        # $SSsCol+=invoke-restmethod -uri $SSUri 
                        # COS(s) = Classes Of Service(s)
                        $COSlink=($Data).ClassesOfService
                        write-verbose "Link = $COSlink"
                        $COSRoot = (($Data).ClassesOfService).'@odata.id'
                        $COSsUri=$base+$COSRoot
                        write-verbose "-+-+ Obtaining the collection of COS $COSsUri"
                        $COSsData = invoke-restmethod -uri $COSsUri
                        $COSs = $($COSsData).Members
                        foreach($COS in $COSs)
                        {   write-verbose "COS = $COS"
                            $COSRawUri=$(($COS).'@odata.id')
                            $COSUri=$base+$COSRawUri
                            write-verbose "-+-+ Determining if the ClassOfService should be excluded by parameter $COSUri"
                            try {    if ( ( (invoke-restmethod -uri $COSUri).Id -like $ClassOfServiceId) -or ( $ClassOfServiceId -eq '' ) )             
                                    {   write-verbose "-+-+ Obtaining information on a specific ClassOfService $COSUri"
                                        $COSsCol+=invoke-RestMethod -uri $COSUri
                                }   }
                            catch{  write-verbose "-+-+ No Classes of Service found on this system"                 
            }       }   }       }
        return $COSsCol
}    }

function Get-SwordfishClassOfServiceLineOfService{
<#
.SYNOPSIS
    Retrieve The list of valid Classes of Services from the Swordfish Target.
.DESCRIPTION
    This command requires a specific Storage Service ID and Class of Service ID to
    specify a singular Class of Service. You must specify the Line of Service to 
    obtain. 
.PARAMETER StorageServiceId
    The Storage Service ID name for a specific Storage Service.
.PARAMETER ClassOfServiceId
    The Class of Service ID will limit the returned data to a singular Classes of Service.
.PARAMETER LineOfServiceName
    The type of .
.EXAMPLE
    Get-SwordfishStorageClassOfService
.EXAMPLE
    Get-SwordfishStorageClassOfService -StorageServiceId AC-102345
.EXAMPLE
    Get-SwordfishStorageClassOfService -StorageServiceId AC-102345 -ClassOfServiceId Gold
.EXAMPLE
    Get-SwordfishStorageClassOfService -ClassOfServiceId Gold
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/ClassOfService.v1_1_1.json
#>   
[CmdletBinding()]
param(  [string] $StorageServiceID,
        [string] $ClassOfServiceId,

        [ValidateSet("DataProtectionLineOfService","DataSecurityLineOfService","DataStorageLineOfService","IOConnectivityLineOfService","IOPerformanceLineOfService")]
        [string] $LineOfService
     )
process{# SS(s) = Storage Service(s)
        Write-Verbose "-+-+ Discovering the location of the Storage Services Root"
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        write-verbose "-+-+ Collecting the URIs to each Storage Services Root"
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $COSsCol=@()
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                write-verbose "-+-+ Determining if the Storage Service is excluded by parameter"
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   write-verbose "-+-+ Collecting Drive data about the specific Storage Service $SSUri"
                        $Data = invoke-restmethod -uri $SSUri
                        # COS(s) = Classes Of Service(s)
                        $COSlink=($Data).ClassesOfService
                        $COSRoot = (($Data).ClassesOfService).'@odata.id'
                        $COSsUri=$base+$COSRoot
                        write-verbose "-+-+ Obtaining the collection of COS $COSsUri"
                        $COSsData = invoke-restmethod -uri $COSsUri
                        $COSs = $($COSsData).Members
                        foreach($COS in $COSs)
                        {   $COSRawUri=$(($COS).'@odata.id')
                            $COSUri=$base+$COSRawUri
                            write-verbose "-+-+ Determining if the ClassOfService should be excluded by parameter $COSUri"
                            try {   if ( ( (invoke-restmethod -uri $COSUri).Id -like $ClassOfServiceId) -or ( $ClassOfServiceId -eq '' ) )             
                                    {   write-verbose "-+-+ Obtaining information on a specific ClassOfService $COSUri"
                                        # LOS(s) = Line of Service
                                        $LOS=(invoke-restmethod -uri $COSUri).LinesOfService
                                        write-verbose "Lines of Service = $LOS"
                                        Switch($LineOfService)
                                        {   "DataProtectionLineOfService"   { $LOSSpec = ($LOS).DataProtectionLineOfService }
                                            "DataSecurityLineOfService"     { $LOSSpec = ($LOS).DataSecurityLineOfService   }
                                            "DataStorageLineOfService"      { $LOSSpec = ($LOS).DataStorageLineOfService    }
                                            "IOConnectivityLineOfService"   { $LOSSpec = ($LOS).IOConnectivityLineOfService }
                                            "IOPerformanceLineOfService"    { $LOSSpec = ($LOS).IOPerformanceLineOfService  }
                                        }
                                        $LOSSpec | add-member -membertype NoteProperty -name "StorageService" -value $SSRawUri 
                                        $LOSSpec | add-member -membertype NoteProperty -name "ClassOfService" -value $COSRawUri 
                                        $COSsCol+=$LOSSpec
                                }   }
                            catch{  write-verbose "-+-+ No Classes of Service found on this system"
            }       }   }        }
        return $COSsCol
}   }