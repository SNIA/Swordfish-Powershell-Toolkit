function Get-SwordFishDrive{
<#
.SYNOPSIS
    Retrieve The list of valid Drives from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Drives that exist across all of the Storage Systems, 
    unless a specific Storage Service ID or Storage System IDof ChassisID is used to limit it, or a specific Drive ID is directly requested. 
.PARAMETER StorageId
    by default behavior of the command will return all drives connected to all chassis, this option
    tells the command instead to only search for drives assigned to a specific Storage system. Assumes that the Storage ID contains a 
    DriveCollection that points to all of its drives
.PARAMETER ChassisId
    The deafult behavior of the command will discover all chassisIDs and return all drives connected
    to each ChassisID. By specifying a ChassisID you can filter the results to only present drives from 
    a single specified ChassisID
.PARAMETER DriveId
    The Drive ID will limit the returned data to the single drive specified, otherwise the command will return all Drives.
.EXAMPLE
     Get-SwordFishStorageDrive
.EXAMPLE
     Get-SwordFishStorageDrive -ChassisId AC-102345
.EXAMPLE
     Get-SwordFishStorageDrive -StorageId AC-102345
.EXAMPLE
     Get-SwordFishStorageDrive -DriveId 1
.LINK
    http://redfish.dmtf.org/schemas/swordfish/v1/Drive.v1_2_0.json
#>   
    [CmdletBinding(DefaultParameterSetName='Default')]
    param(
        [Parameter(ParameterSetName='ByStorageID')] [string]    $StorageID,

        [Parameter(ParameterSetName='ByChassisID')] [string]    $ChassisID,

        [Parameter(ParameterSetName='ByStorageID')]
        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]     [string]    $DriveId,

        [Parameter(ParameterSetName='ByStorageID')]
        [Parameter(ParameterSetName='ByChassisID')] [boolean]   $ReturnDriveCollectionOnly =   $False
    )
    
    process
    {   $FullDriveCollection=@()
        if ( -not $StorageID )
            {   $ChassisUri = Get-SwordfishURIFolderByFolder "Chassis"
                write-verbose "Folder = $ChassisUri"
                $ChassisData = invoke-restmethod2 -uri $ChassisUri
                # Search for the drives by detecting them from /redfish/v1/Chassis/{id}/Drives
                foreach($Chas in ($ChassisData).Members )
                    {   write-host "Walking the Chassis's"
                        $MyChasObj = $Chas.'@odata.id'
                        $MyChasSplit = $MyChasObj.split('/')
                        $MyChasName= $MyChasSplit[ ($MyChasSplit.Length -1 ) ]
                        write-host "Chassis = $MyChasName"
                        $DriveCol = Invoke-RestMethod2 -uri ( $base + ($Chas).'@odata.id' + '/Drives' )
            
                        foreach( $Drive in ( $DriveCol).Members )
                            {   $MyDriveURI =   $Drive.'@odata.id'
                                $MyDrive    =   Invoke-RestMethod2 -uri ( $base + $MyDriveURI ) 
                                if( ( $ByChassisID -eq $MyChasName ) -or ( -not $ByChassisID ) )
                                    {   # Only add the resulting drive if the Chassis ID matches or was not set.
                                        if ( ( $MyDrive.id -like $DriveID) -or ( -not $DriveID ))
                                            {   # Only add the resulting drive if the Drive ID matches or was not set
                                                $FullDriveCollection += $MyDrive
                                            }
                                    }
                            }
                    }
            } else 
            {   $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
                write-verbose "Folder = $StorageUri"
                $StorageData = invoke-restmethod2 -uri $ChassisUri
                foreach($Stor in ($StorageData).Members )
                {   write-host "Walking the StorageID's"
                    $MyStorObj = $Stor.'@odata.id'
                    $MyStorSplit = $MyStorObj.split('/')
                    $MyStorageName= $MyStorSplit[ ($MyStorSplit.Length -1 ) ]
                    write-host "Storage = $MyStorageName"
                    $DriveCol = Invoke-RestMethod2 -uri ( $base + ($Stor).'@odata.id' + '/Drives' )
                    foreach( $Drive in ( $DriveCol).Members )
                        {   $MyDriveURI =   $Drive.'@odata.id'
                            $MyDrive    =   Invoke-RestMethod2 -uri ( $base + $MyDriveURI ) 
                            if( ( $ByStorageID -eq $MyStorName ) -or ( -not $ByStorageID ) )
                                {   # Only add the resulting drive if the Storage ID matches or was not set.
                                    if ( ( $MyDrive.id -like $DriveID) -or ( -not $DriveID ))
                                        {   # Only add the resulting drive if the Drive ID matches or was not set
                                            $FullDriveCollection += $MyDrive
                                        }
                                }
                        }
                } 
            }
        if ( $ReturnDriveCollectionOnly )
            {   return $DriveCol
            } else 
            {    return $FullDriveCollection
            }
    }
}