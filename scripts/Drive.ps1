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
    The Following is an example from the HPE MSA 2060 Gen 6 in the SNIA Labs
    
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
    The following example is a single drive from a HPE ProLiant DL360 Gen 10 in the SNIA Labs

    PS:> Get-RedfishDrive

    @odata.context                : /redfish/v1/$metadata#Drive.Drive
    @odata.etag                   : W/"DFABD58A"
    @odata.id                     : /redfish/v1/Systems/1/Storage/DA000008/Drives/DA000008/
    @odata.type                   : #Drive.v1_1_0.Drive
    Id                            : DA000008
    Actions                       : @{#Drive.Reset=}
    CapacityBytes                 : 2000398000000
    FailurePredicted              : False
    IndicatorLED                  : Off
    Location                      : {@{Info=1:1; InfoFormat=Box:Bay}}
    MediaType                     : SSD
    Model                         : INTEL SSDPE2ME020T4P
    Name                          : Secondary Storage Device
    Oem                           : @{Hpe=}
    PredictedMediaLifeLeftPercent : 85
    Protocol                      : NVMe
    Revision                      : 4IFDHP02
    SerialNumber                  : CVMD4316001T2P0JGN
    Status                        : @{Health=Warning}
.EXAMPLE
    The following is an example of a drive in a Dell R640 in the SNIA Labs.

    PS:> Get-RedfishDrive

    @odata.context                : /redfish/v1/$metadata#Drive.Drive
    @odata.id                     : /redfish/v1/Systems/System.Embedded.1/Storage/RAID.Slot.1-1/Drives/Disk.Bay.0:Enclosure.Internal.0-0:RAID.Slot.1-1
    @odata.type                   : #Drive.v1_9_0.Drive
    Actions                       : @{#Drive.SecureErase=}
    Assembly                      : @{@odata.id=/redfish/v1/Chassis/System.Embedded.1/Assembly}
    BlockSizeBytes                : 512
    CapableSpeedGbs               : 12
    CapacityBytes                 : 599550590976
    Description                   : Disk 0 in Backplane 0 of RAID Controller in Slot 1
    EncryptionAbility             : None
    EncryptionStatus              : Unencrypted
    FailurePredicted              : False
    HotspareType                  : None
    Id                            : Disk.Bay.0:Enclosure.Internal.0-0:RAID.Slot.1-1
    Identifiers                   : {@{DurableName=5000c5009925026d; DurableNameFormat=NAA}}
    Identifiers@odata.count       : 1
    Links                         : @{Chassis=; PCIeFunctions=System.Object[]; PCIeFunctions@odata.count=0; Volumes=System.Object[]; Volumes@odata.count=0}
    Location                      : {}
    Manufacturer                  : SEAGATE
    MediaType                     : HDD
    Model                         : ST600MP0036
    Name                          : Physical Disk 0:0:0
    NegotiatedSpeedGbs            : 12
    Oem                           : @{Dell=}
    Operations                    : {}
    Operations@odata.count        : 0
    PartNumber                    : CN0FPW68726226CT00DPA00
    PhysicalLocation              : @{PartLocation=}
    PredictedMediaLifeLeftPercent :
    Protocol                      : SAS
    Revision                      : KT37
    RotationSpeedRPM              : 15000
    SerialNumber                  : SAF00RGY
    Status                        : @{Health=OK; HealthRollup=OK; State=Enabled}
    WriteCacheEnabled             : False
.EXAMPLE
    The following is an example from the Intel Reference Architecture Server in the SNIA Labs
    PS:> Get-RedfishDrive

    BlockSizeBytes                : 512
    CapacityBytes                 : 800166076416
    Protocol                      : SAS
    EncryptionAbility             : None
    PartNumber                    : D7A09335
    NegotiatedSpeedGbs            : 12
    PredictedMediaLifeLeftPercent : 100
    EncryptionStatus              : Unencrypted
    Description                   : This resource is used to represent a drive for a Redfish implementation.
    Links                         : @{PCIeFunctions=System.Object[]; Chassis=; Volumes=System.Object[]}
    CapableSpeedGbs               : 12
    StatusIndicator               : OK
    SerialNumber                  : 83X7905P
    Status                        : @{State=Enabled; Health=OK}
    SKU                           : 01GV822
    Identifiers                   : {@{DurableNameFormat=UUID; DurableName=}}
    Model                         : MZILS800HEHPV3
    @odata.id                     : /redfish/v1/Systems/1/Storage/RAID_Slot4/Drives/Disk.0
    Oem                           : @{Lenovo=}
    MediaType                     : SSD
    Name                          : 800GB 12Gbps SAS 2.5 SSD
    @odata.type                   : #Drive.v1_9_1.Drive
    FailurePredicted              : False
    RotationSpeedRPM              : 65535
    Manufacturer                  : Samsung
    Revision                      : CH41
    @odata.etag                   : "a8ceeffa44bd34a437ccd"
    AssetTag                      :
    PhysicalLocation              : @{InfoFormat@Redfish.Deprecated=The property is deprecated. Please use PartLocation instead.; Info@Redfish.Deprecated=The property is deprecated.
                                    Please use PartLocation instead.; Info=Slot 0; PartLocation=; InfoFormat=Slot Number}
    HotspareType                  : None
    Id                            : Disk.0
.EXAMPLE

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
        {   if ( ($PulledData.Links).Drives )               # Sometimes the Drives are listed at the root of Chassis or Storage, other times they are listed under Links
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