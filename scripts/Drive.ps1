function Get-SwordFishDrive{
    <#
    .SYNOPSIS
        Retrieve The list of valid Drives from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Drives that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific 
        Drive ID is directly requested. 
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Storage Groups for all Storage Services.
    .PARAMETER DriveId
        The Storage Group ID will limit the returned data
        to the type specified, otherwise the command will return all Drives.
    .EXAMPLE
         Get-SwordFishStorageDrive
    .EXAMPLE
         Get-SwordFishStorageDrive -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStorageDrive -StorageServiceId AC-102345 -DriveId 2
    .EXAMPLE
         Get-SwordFishStorageDrive -DriveId 1
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/Drive.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [string] $DriveId
    )
    process{
        # SS(s) = Storage Service(s)
        Write-Verbose "-+-+ Discovering the location of the Storage Services Root"
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        write-verbose "-+-+ Collecting the URIs to each Storage Services Root"
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $DsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                write-verbose "-+-+ Determining if the Storage Service is excluded by parameter"
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   write-verbose "-+-+ Collecting Drive data about the specific Storage Service $SSUri"
                        $Data = invoke-restmethod -uri $SSUri
                        # $SSsCol+=invoke-restmethod -uri $SSUri 
                        # D(s) = Drive(s)
                        $DDrives=($Data).Drives
                        write-verbose "Data Drives = $DDrives"
                        $DRoot = (($Data).Drives).'@odata.id'
                        $DsUri=$base+$DRoot
                        write-verbose "-+-+ Obtaining the collection of drives $DsUri"
                        $DsData = invoke-restmethod -uri $DsUri
                        #write-host "DsData = $DsData"
                        $Ds = $($DsData).Members
                        #write-host "Ds = $Ds"
                        foreach($D in $Ds)
                        {   write-verbose "D = $D"
                            $DRawUri=$(($D).'@odata.id')
                            $DUri=$base+$DRawUri
                            write-verbose "-+-+ Determining if the Drive should be excluded by parameter $DUri"
                            try {    if ( ( (invoke-restmethod -uri $DUri).id -like $DriveId) -or ( $DriveId -eq '' ) )             
                                    {   write-verbose "-+-+ Obtaining information on a specific drive $DUri"
                                        $DsCol+=invoke-RestMethod -uri $DUri
                                    }
                                }
                            catch{  write-verbose "-+-+ No Drives found on this system"
                                }
                        }    
                    } 
            }
        return $DsCol
    }
}