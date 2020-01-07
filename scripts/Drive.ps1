function Get-SwordFishDrive{
    <#
    .SYNOPSIS
        Retrieve The list of valid Drives from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Drives that exist across all of the Storage Services or Storage Systems, 
        unless a specific Storage Service ID or Storage System ID is used to limit 
        it, or a specific Drive ID is directly requested. 
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return drives for all Storage Services and Storage Systems.
    .PARAMETER StorageSystemId
        The Storage System ID name for a specific Storage System, otherwise the command
        will return drives for all Storage Systems and Storage Services.
    .PARAMETER DriveId
        The Drive ID will limit the returned data
        to the type specified, otherwise the command will return all Drives.
    .EXAMPLE
         Get-SwordFishStorageDrive
    .EXAMPLE
         Get-SwordFishStorageDrive -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStorageDrive -StorageSystemId AC-102345
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
        [string] $StorageSystemID,
        [string] $DriveId
    )

    process
    {   $StorageClasses=@("StorageSystems","StorageServices")
        # This allows me to do a search first for the Non-Class of Service Swordfish, then do the search for Class-of-Service type swordfish.
        # StorageSystems is service/less, thusly doesnt require class-of-service as specified in Swordfish 1.1.0+
        $DsCol=@() 
        foreach ($StorageClass in $StorageClasses)
        {   $LocalUri = Get-SwordfishURIFolderByFolder "$StorageClass"
            write-verbose "Folder = $LocalUri"
            $LocalData = invoke-restmethod2 -uri $LocalUri
            $SSsLinks = ($LocalData).Members
            $SSsCol=@()
            foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                $Data = invoke-restmethod2 -uri $SSUri
                write-verbose "-+-+ Determining if the Storage Service is excluded by parameter"
                if ( ( ( ($Data).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) ) -and ( (($Data).id -like $StorageSystemId )  -or ( $StorageSystemId -eq ''  ) )  )
                    {   $DDrives=($Data).Drives
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
        }   }       }   }        } 
        return $DsCol
}   }