function Get-SwordfishDrive
{
<#
.SYNOPSIS
    Retrieve The list of valid Drives from the Swordfish or Redfish Target.
.DESCRIPTION
    This command will either return the a complete collection of Drives that exist across all of the Storage Systems or Servers, 
    unless a specific Storage Service ID or Storage System ID or ChassisID is used to limit it, or a specific Drive ID is directly requested.
    By default without specifying an ID, the command will search the following locations for /redfish/v1/Storage, /redfish/v1/StorageServices, /redfish/v1/Chassis
    and it will detect if Members points to either a drive collection or points to individual drives. 
.PARAMETER StorageId
    This will limit the drives or drive collections returned to only those that are subordinate or referenced by the afformentioned StorageID
.PARAMETER StorageServiceId
    This will limit the drives or drive collections returned to only those that are subordinate or referenced by the afformentioned StorageID
.PARAMETER ChassisId
    This will limit the drives or drive collections returned to only those that are subordinate or referenced by the afformentioned ChassisID
.PARAMETER DriveId
    This will limit the drives or drive collections returned to only those that are subordinate or referenced by the afformentioned DriveID
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    PS:> Get-SwordfishDrive

    @odata.context     : /redfish/v1/$metadata#Drive.Drive
    @odata.id          : /redfish/v1/StorageServices/S1/Drives/1.14
    @odata.type        : #Drive.v1_5_2.Drive
    Id                 : 1.14
    Name               : 1.14
    CapacityBytes      : 1800360124416
    FailurePredicted   : False
    RotationSpeedRPM   : 10000
    BlockSizeBytes     : 512
    SerialNumber       : WBN0QP9D0000C904A7RP
    Revision           : C003
    NegotiatedSpeedGbs : 12.000000
    Protocol           : SAS
    MediaType          : HDD
    Manufacturer       : SEAGATE
    PartNumber         : ST1800MM0129
    IndicatorLED       : Off
    EncryptionAbility  : None
    EncryptionStatus   : Unencrypted
    Operations         : {@{OperationName=NoUtilityRunning; PercentageComplete=94}}
    PhysicalLocation   : @{PartLocation=}
    Status             : @{State=Enabled; Health=OK}
    Identifiers        : {@{DurableNameFormat=NAA; DurableName=disk_01.14}}
    Links              : @{Chassis=; Endpoints=System.Object[]}

    { Only a single drive is shown, and the many drives output is far too long}
.EXAMPLE
    PS:> Get-SwordfishDrive -DriveId 1.14
    { They output from this command is limited to only this individual drive, but looks identical to example 1 output }
.EXAMPLE
    PS:> Get-SwordfishStorageDrive -ChassisId enclosure_1
.EXAMPLE
    PS:> Get-SwordfishStorageDrive -StorageId AC-102345
.EXAMPLE
    PS:> Get-SwordfishStorageDrive -StorageServiceId S1
.EXAMPLE
    PS:> Get-SwordfishStorageDrive -returnCollectionOnly $True
    @odata.context      : /redfish/v1/$metadata#DriveCollection.DriveCollection
    @odata.type         : #DriveCollection.DriveCollection
    @odata.id           : /redfish/v1/StorageServices/S1/Drives
    Name                : Drive Collection
    Members@odata.count : 14
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/Drives/1.1},
                           @{@odata.id=/redfish/v1/StorageServices/S1/Drives/1.2},
                           @{@odata.id=/redfish/v1/StorageServices/S1/Drives/1.3},
                           @{@odata.id=/redfish/v1/StorageServices/S1/Drives/1.4}...}
.LINK
    https://redfish.dmtf.org/schemas/v1/Drive.v1_11_0.json
    The Drives and Drives Collections will existing in the following Locations    
        /redfish/v1/Chassis/{ChassisId}/Drives/{DriveId}
        /redfish/v1/Storage/{StorageId}/Drives/{DriveId}
        /redfish/v1/Systems/{ComputerSystemId}/Storage/{StorageId}/Drives/{DriveId}
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(
        [Parameter(ParameterSetName='ByStorageID')] [string]           $StorageID,
        [Parameter(ParameterSetName='ByStorageServiceID')] [string]    $StorageServiceID,
        [Parameter(ParameterSetName='ByChassisID')] [string]           $ChassisID,
        [Parameter(ParameterSetName='RootCollection')] [string]        $RootCollection,

        [Parameter(ParameterSetName='ByStorageID')]
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='ByChassisID')]
        [Parameter(ParameterSetName='Default')]     [string]           $DriveId,

        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='ByStorageID')]        
        [Parameter(ParameterSetName='Default')]
        [Parameter(ParameterSetName='ByChassisID')] [switch]           $ReturnCollectionOnly

    )
process
{   switch ($PSCmdlet.ParameterSetName )
        {   'Default'           {   $DefDriveCol = @()
                                    foreach ( $ChasID in Get-SwordfishChassis )
                                        {   $DefDriveCol += Get-SwordfishDrive -ChassisID $ChasID.id -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $StorID in Get-SwordfishStorage )
                                        {   $DefDriveCol += Get-SwordfishDrive -StorageID $StorID.id -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $SSID in Get-SwordfishStorageServices )
                                        {   $DefDriveCol += Get-SwordfishDrive -StorageServiceID $SSID.id -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $SSID in Get-SwordfishStorageServices )
                                        {   $DefDriveCol += Get-SwordfishDrive -StorageServiceID $SSID.id -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $DriveID )
                                        {   return ( $DefDriveCol | where-object { $_.id -eq $DriveID } )
                                        } else 
                                        {   return ( $DefDriveCol )
                                        }  
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices  -StorageID $StorageServiceID
                                }
            'ByStorageID'       {   $PulledData = Get-SwordfishStorage          -StorageID $StorageID
                                }
            'ByChassisID'       {   $PulledData = Get-SwordfishChassis          -ChassisID $ChassisID
                                }
        }
    $FullDriveSet=@()
    $FullDriveCollectionOnly=@()
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   if ( ($PulledData.Links).Drives ) 
                    { $PulledData = $PulledData.Links }
            foreach ( $DriveData in $PulledData.Drives )
                {   $MyDrive = Invoke-RestMethod2 -uri ( $base + ($DriveData.'@odata.id') )
                    if ( $MyDrive.Members )
                        {   foreach ( $SingleDriveData in $MyDrive.members )
                                {   $MySingleDrive = Invoke-RestMethod2 -uri ( $base + ($SingleDriveData.'@odata.id') ) 
                                    $FullDriveCollectionOnly += $MyDrive
                                    $FullDriveSet += $MySingleDrive
                                }
                        } else 
                        {   $FullDriveCollectionOnly += $PulledData 
                            $FullDriveSet += $MyDrive
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return ( $FullDriveCollectionOnly | get-unique ) 
                } else 
                {   if ( $DriveID )
                        {   return ( $FullDriveSet | where-object { $_.id -eq $DriveID } )
                        } else 
                        {   return ( $FullDriveSet )
                        }
                }
        }    
}
}
Set-Alias -Name 'Get-RedfishDrive' -value 'Get-SwordfishDrive'