function Get-SwordFishVolume{
<#
.SYNOPSIS
    Retrieve The list of valid Volumes from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Volumes that exist across all of 
    the Storage Services and/or Storage Systems, unless a  specific Storage Services ID or Storage Systems ID is used to limit it, or a specific 
    Volume ID is directly requested. 
.PARAMETER StorageId
    The Storage Service ID name for a specific Storage Service, otherwise the command
    will return Volumes for all Storage Services and/or Storage Systems.
.PARAMETER VolumeId
    The Storage Group ID will limit the returned data to the type specified, otherwise the command will return all Volumes.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordFishStorageVolume
.EXAMPLE
    Get-SwordFishStorageVolume -StorageId AC-102345
.EXAMPLE
    Get-SwordFishStorageVolume -VolumeId 1
.EXAMPLE
    Get-SwordFishStorageVolume -ReturnCollectionOnly    
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/Volume.v1_2_0.json
#>   
[CmdletBinding()]
    param(  [string]    $StorageId,
            [string]    $VolumeId,
            [boolean]   $ReturnCollectionOnly   =   $False
        )
    process{
        $MyVolsCol=@()
        $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
        write-verbose "Storage Folder = $StorageUri"
        $StorageData = invoke-restmethod2 -uri $StorageUri
        foreach( $StorageSys in ( $StorageData ).Members )
            {   $MyStorageSysURI = $Base + $StorageSys.'@odata.id' + '/Volumes'
                write-verbose "MyStorageSysURI = $MyStorageSysURI"
                #Gotta find my Array Name to see if it matches passed in filter
                $MyStorageSysObj   = $StorageSys.'@odata.id'
                $MyStorageSysArray = $MyStorageSysObj.split('/')
                $MyStorageSysName  = $MyStorageSysArray[ ($MyStorageSysArray.length -1) ]
                write-verbose "MyStorageSysName = $MyStorageSysName"
                if ( ($StorageId -like $MyStorageSysName) -or ( -not $StorageId ) )
                    {   $MyVolCollection = invoke-restmethod2 -uri ( $MyStorageSysURI )
                        foreach( $MyVol in ($MyVolCollection.Members) )
                            {   #Gotta find my Pool name to see if it matches passed in filter
                                $MyVolObj   = $MyVol.'@odata.id'
                                $MyVolArray = $MyVolObj.split('/')
                                $MyVolName  = $MyVolArray[ ($MyVolArray.length -1) ]
                                write-verbose "MyVolumeName = $MyVolName"
                                if ( ($VolumeId -like $MyVolName) -or (-not $VolumeId) )
                                    {   $Volume = invoke-restmethod2 -uri ( $Base + $MyVol.'@odata.id' )
                                        $MyVolsCol+=$Volume
                                        $ReturnColl = $MyVolCollection
                                    }                                 
                            }
                    }
            }
        if ( $ReturnCollectionOnly )
            {   return $ReturnColl
            } else 
            {   return $MyVolsCol            
            }
    }
}

