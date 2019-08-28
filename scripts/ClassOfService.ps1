function Get-SwordFishClassOfService{
    <#
    .SYNOPSIS
        Retrieve The list of valid Classes of Services from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Classes of Services that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific 
        Classes of Services ID is directly requested. 
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Storage Groups for all Storage Services.
    .PARAMETER ClassOfServiceId
        The Storage Group ID will limit the returned data
        to the type specified, otherwise the command will return all Classes of Services.
    .EXAMPLE
         Get-SwordFishStorageClassOfService
    .EXAMPLE
         Get-SwordFishStorageClassOfService -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStorageClassOfService -StorageServiceId AC-102345 -ClassOfServiceId Gold
    .EXAMPLE
         Get-SwordFishStorageClassOfService -ClassOfServiceId Gold
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/ClassOfService.v1_1_1.json
    #>   
[CmdletBinding()]
    param(  [string] $StorageServiceID,
            [string] $ClassOfServiceId
         )
    process{
        $CoSCol=@() 
        foreach($link in (Get-SwordFishStorageService -StorageServiceID $StorageServiceID))
            {   $CoSURI = $base + (($link).ClassesOfService).'@odata.id'
                write-verbose "Opening URI SPsURI = $CoSURI"
                $CosData = invoke-restmethod2 -uri $CoSURI
                if ( $CoSData.members )
                    {   $CoSs = $CoSData.members
                    } else 
                    {   $CoSs = $CoSData   
                    }
                write-verbose "ClassesOfSerice = $CoSs"
                foreach ($CoS in $CoSs )
                {   $Finaluri = $Base+ ($CoS.'@odata.id')
                    write-verbose "Opening URI SPuri = $Finaluri"
                    $FinalData = invoke-restmethod2 -uri $Finaluri
                    if  ( ( $FinalData.id -like $ClassOfServiceId ) -or ( $ClassOfServiceId -eq '') ) 
                        {   write-verbose "++++Adding $FinalData"
                            $CoSCol+=$FinalData
            }   }       }
        return $CoSCol
}
}
function Get-SwordFishClassOfServiceLineOfService{
<#
.SYNOPSIS
    Retrieve The list of valid Classes of Services from the SwordFish Target.
.DESCRIPTION
    This command requires a specific Storage Service ID and Class of Service ID to
    specify a singular Class of Service. You may specify the Line of Service to 
    obtain, otherwise it will return all Lines Of Service connected to the Class Of Sevice 
.PARAMETER StorageServiceId
    The Storage Service ID name for a specific Storage Service.
.PARAMETER ClassOfServiceId
    The Class of Service ID will limit the returned data to a singular Classes of Service.
.PARAMETER LineOfServiceName
    The Line of service which may be null (all) or DataProtectionLineOfService","DataSecurityLineOfService",
    "DataStorageLineOfService","IOConnectivityLineOfService","IOPerformanceLineOfService".
.EXAMPLE
    Get-SwordFishStorageClassOfServiceLineOfService -StorageServiceId AC-102345 -ClassOfServiceId Gold
.EXAMPLE
    Get-SwordFishStorageClassOfServiceLineOfService -StorageServiceId AC-102345 -ClassOfServiceId Gold -LineOfService IOConnectivityLineOfService
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/ClassOfService.v1_1_1.json
#>   
[CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [string] $ClassOfServiceId,

        [parameter(mandatory=$true)]
        [ValidateSet("DataProtectionLinesOfService","DataSecurityLinesOfService","DataStorageLinesOfService","IOConnectivityLinesOfService","IOPerformanceLinesOfService", "All")]
        [string] $LineOfService
        )
    process
    {   $CoSLoSCol=@() 
        foreach($SS in (Get-SwordFishStorageService -StorageServiceID $StorageServiceID))
            {   foreach ($CoS in Get-SwordFishClassOfService -StorageServiceID (($SS).id) -ClassOfServiceId $ClassOfServiceID) 
                {   $Finaluri = $Base+ ($CoS.'@odata.id')
                    write-verbose "Opening URI ClasOfServiceURI = $Finaluri"
                    $FinalCoSData = invoke-restmethod2 -uri $Finaluri
                    $RequestedLinesOfService=$LineOfService
                    if ( $LineOfService -eq "All")
                        {   $RequestedLinesOfService = @("DataProtectionLinesOfService","DataSecurityLinesOfService","DataStorageLinesOfService","IOConnectivityLinesOfService","IOPerformanceLinesOfService")
                        }
                    foreach ($LineItem in $RequestedLinesOfService) # The Mockup site stores the LinesOfService in an element called LinesOfService, while the API emulator just stores them without this.
                        {   if ($FinalData.($LineItem) )
                                {   $FinalLoSURI =$base + (FinalData.($LineItem)).'@odata.id'
                                    $CoSLoSCol+=invoke-restmethod2 -uri $FinalLoSURI
                                }
                        }
                    foreach ($LineItem in $RequestedLinesOfService)
                        {   $Testname=$LineItem
                            if (-not $MOCK) # This is due to the fact that the API Emulator uses a pluralization of the lines of service, while real implementations do not.
                            {   $Testname=$Testname.replace("Lines","Line")
                            }
                            if ( (($FinalCosData.LinesOfService).($Testname)) -ne '')
                            {   $CoSLoSCol+=@{ $Testname=($FinalCosData.LinesOfService).$Testname }
                            }                            
                        }
                }   
            }       
        return $CoSLoSCol
    }
}