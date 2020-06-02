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
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordFishStorageDrive

    @Redfish.Copyright : Copyright 2020 HPE and DMTF
    @odata.id          : /redfish/v1/Chassis/AC-109032/Drives/DiskShelf0Location16
    @odata.type        : #Drive.v1_6_0.Drive
    Id                 : 2c2b4bd8361b856bbc0001000000000b0000001000
    Name               : HPENimbleDrives
    IndicatorLED       : Lit
    Model              : HUS724030ALS640
    Revision           : A1C4
    Status             : @{State=in use; Health=okay}
    CapacityBytes      : 3000592982016
    FailurePredicted   : okay
    Protocol           : SAS
    MediaType          : HDD
    Manufacturer       : Nimble
    SerialNumber       : P8K5L5JW
    PartNumber         : Nimble_HUS724030ALS640
    AssetTag           : P8K5L5JW
    CapableSpeedGbs    : 6
    NegotiatedSpeedGbs : 6
    Multipath          : True
    StoragePools       : {@{@odata.id=/redfish/v1/Storage/AC-109032/StoragePools/Default}}
    Chassis            : @{@odata.id=/redfish/v1/Chassis/AC-109032}

    { Only a single drive is shown, and the many drives output is far too long}
.EXAMPLE
    PS:> Get-SwordfishDrive -DriveId DiskShelf0Location16

    { They output from this command is limited to only this individual drive, but looks identical to example 1 output }

.EXAMPLE
    PS:> Get-SwordFishStorageDrive -ChassisId AC-102345
.EXAMPLE
    PS:> Get-SwordFishStorageDrive -StorageId AC-102345
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
        [Parameter(ParameterSetName='ByChassisID')] [boolean]   $ReturnCollectionOnly =   $False
    )
    
    process
    {   $FullDriveCollection=@()
        if ( -not $StorageID )
            {   $ChassisUri = Get-SwordfishURIFolderByFolder "Chassis"
                write-verbose "Folder = $ChassisUri"
                $ChassisData = invoke-restmethod2 -uri $ChassisUri
                # Search for the drives by detecting them from /redfish/v1/Chassis/{id}/Drives
                foreach($Chas in ($ChassisData).Members )
                    {   write-verbose "Walking the Chassis's"
                        $MyChasObj = $Chas.'@odata.id'
                        $MyChasSplit = $MyChasObj.split('/')
                        $MyChasName= $MyChasSplit[ ($MyChasSplit.Length -1 ) ]
                        write-verbose "Chassis = $MyChasName"
                        $DriveCol = Invoke-RestMethod2 -uri ( $base + ($Chas).'@odata.id' + '/Drives' )
                        foreach( $Drive in ( $DriveCol).Members )
                            {   $MyDriveURI     =   $Drive.'@odata.id'
                                $MyDrive        =   Invoke-RestMethod2 -uri ( $base + $MyDriveURI )
                                $MyDriveSplit   =   $MyDriveURI.split('/')
                                $MyDriveName    =   $MyDriveSplit[ ( $MyDriveSplit.length -1) ] 
                                if( ( $ChassisID -eq $MyChasName ) -or ( -not $ChassisID ) )
                                    {   # Only add the resulting drive if the Chassis ID matches or was not set.
                                        if ( ( $MyDriveName -like $DriveID) -or ( -not $DriveID ))
                                            {   # Only add the resulting drive if the Drive ID matches or was not set
                                                $FullDriveCollection += $MyDrive
                                            }
                                    }
                            }
                    }
            } else 
            {   $StorageUri = Get-SwordfishURIFolderByFolder "Storage"
                write-verbose "Folder = $StorageUri"
                $StorageData = invoke-restmethod2 -uri $StorageUri
                foreach($Stor in ($StorageData).Members )
                {   write-verbose "Walking the StorageID's"
                    $MyStorObj = $Stor.'@odata.id'
                    $MyStorSplit = $MyStorObj.split('/')
                    $MyStorageName= $MyStorSplit[ ( $MyStorSplit.Length -1 ) ]
                    write-verbose "Storage = $MyStorageName"
                    $DriveCol = Invoke-RestMethod2 -uri ( $base + ($Stor).'@odata.id' + '/Drives' )
                    foreach( $Drive in ( $DriveCol).Members )
                        {   $MyDriveURI =   $Drive.'@odata.id'
                            $MyDrive    =   Invoke-RestMethod2 -uri ( $base + $MyDriveURI )
                            $MyDriveSplit = $MyDriveURI.split('/')
                            $MyDriveName =   $MyDriveSplit[ ( $MyDriveSplit.length -1) ] 
                            if( ( $ByStorageID -eq $MyStorName ) -or ( -not $ByStorageID ) )
                                {   # Only add the resulting drive if the Storage ID matches or was not set.
                                    if ( ( $MyDriveName -like $DriveID) -or ( -not $DriveID ))
                                        {   # Only add the resulting drive if the Drive ID matches or was not set
                                            $FullDriveCollection += $MyDrive
                                        }
                                }
                        }
                } 
            }
        if ( $ReturnCollectionOnly )
            {   return $DriveCol
            } else 
            {    return $FullDriveCollection
            }
    }
}