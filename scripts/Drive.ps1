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
    process
    {   $LocalUri = Get-SwordfishURIFolderByFolder "StorageServices"
        write-verbose "Folder = $LocalUri"
        $LocalData = invoke-restmethod2 -uri $LocalUri
        $SSsLinks = ($LocalData).Members
        $SSsCol=@()
        $DsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                $Data = invoke-restmethod2 -uri $SSUri
                write-verbose "-+-+ Determining if the Storage Service is excluded by parameter"
                if ( ( ($Data).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   # $SSsCol+=invoke-restmethod -uri $SSUri 
                        # D(s) = Drive(s)
                        $DDrives=($Data).Drives
                        write-verbose "Data Drives = $DDrives"
                        $DRoot = (($Data).Drives).'@odata.id'
                        $DsUri=$base+$DRoot
                        write-verbose "-+-+ Obtaining the collection of drives $DsUri"
                        $DsData = invoke-restmethod2 -uri $DsUri
                        #write-host "DsData = $DsData"
                        $Ds = $($DsData).Members
                        #write-host "Ds = $Ds"
                        foreach($D in $Ds)
                        {   write-verbose "D = $D"
                            $DRawUri=$(($D).'@odata.id')
                            $DUri=$base+$DRawUri
                            write-verbose "-+-+ Determining if the Drive should be excluded by parameter $DUri"
                            try {   $DriveToAdd = invoke-RestMethod2 -uri $DUri
                                    if ( ( ($DriveToAdd).id -like $DriveId) -or ( $DriveId -eq '' ) )             
                                    {   $DsCol+=$DriveToAdd
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