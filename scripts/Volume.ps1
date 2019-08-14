function Get-SwordFishVolume{
<#
.SYNOPSIS
    Retrieve The list of valid Volumes from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Volumes that exist across all of 
    the Storage Services, unless a  specific Storage Service ID is used to limit it, or a specific 
    Volume ID is directly requested. 
.PARAMETER StorageServiceId
    The Storage Service ID name for a specific Storage Service, otherwise the command
    will return Storage Groups for all Storage Services.
.PARAMETER VolumeId
    The Storage Group ID will limit the returned data to the type specified, otherwise the command 
    will return all Volumes.
.EXAMPLE
    Get-SwordFishStorageVolume
.EXAMPLE
    Get-SwordFishStorageVolume -StorageServiceId AC-102345
.EXAMPLE
    Get-SwordFishStorageVolume -StorageServiceId AC-102345 -VolumeId 2
.EXAMPLE
    Get-SwordFishStorageVolume -VolumeId 1
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/Volume.v1_2_0.json
#>   
[CmdletBinding()]
    param(
        [string] $StorageServiceID='',
        
        [string] $VolumeId
    )
    process{
        $LocalCol=@() 
        foreach($link in Get-SwordFishStorageService -StorageServiceID $StorageServiceID  )
            {   $VolLocUri=$base + (($Link).Volumes).'@odata.id'
                write-verbose "VolLocUri = $VolLocUri"
                $VsSet=(invoke-restmethod2 -uri $VolLocUri).Members
                write-verbose "VsSet = $VsSet"
                foreach ($Vol in $VsSet)
                    {   $VolUri=$base + ($Vol).'@odata.id'
                        write-verbose "VolUri = $VolUri"
                        $LocalDataVol = invoke-restmethod2 -uri $VolUri
                        if ( ( ($LocalData).id -like $VolumeID ) -or ( $VolumeId -eq '' ) )
                            {   write-verbose "Adding to the collection+"
                                $LocalCol+=$LocalDataVol
                            }
                    }
                     
            }
        return $LocalCol
    }
}
