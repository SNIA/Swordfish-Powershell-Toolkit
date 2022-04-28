function Get-SwordfishClassesOfService
{
<#
.SYNOPSIS
    Retrieve The list of valid Classes of Service from the Swordfish Target.
.DESCRIPTION
    This command will either return the complete collection of Classes of Service that exist across all of 
    the Storage Services, unless a  specific Storage Services ID is used to limit it, or a specific Class ID
    is directly requested. It will search the following locations; /refish/v1/StorageServices/id/ClassesOfService.
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command
    will return Volumes for all Storage Services and/or Storage Systems and all pools.
.PARAMETER ClassId
    The Class ID name for a specific Class of Service, otherwise the command will return all of the classes 
    of service within all of the Storage Services.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishDataStorageLinesOfService

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/RAID1
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : RAID1
    Name                      : RAID1 Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID1/DataStorageLineOfService/DSLOS}}

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/RAID5
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : RAID5
    Name                      : RAID5 Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID5/DataStorageLineOfService/DSLOS}}

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/RAID6
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : RAID6
    Name                      : RAID6 Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID6/DataStorageLineOfService/DSLOS}}

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/RAID10
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : RAID10
    Name                      : RAID10 Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID10/DataStorageLineOfService/DSLOS}}

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/MSA-DP+
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : MSA-DP+
    Name                      : MSA-DP+ Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/MSA-DP+/DataStorageLineOfService/DSLOS}}
 .EXAMPLE
    Get-SwordfishClassesOfService -StorageServiceID S1
 
    { Output is similar to the previous example output }
.EXAMPLE
    Get-SwordfishClassesOfService -ClassId MSA-DP+

    @odata.context            : /redfish/v1/$metadata#ClassOfService.ClassOfService
    @odata.id                 : /redfish/v1/StorageServices/S1/ClassesOfService/MSA-DP+
    @odata.type               : #ClassOfService.v1_1_1.ClassOfService
    Id                        : MSA-DP+
    Name                      : MSA-DP+ Class of Service
    DataStorageLinesOfService : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/MSA-DP+/DataStorageLineOfService/DSLOS}}
.EXAMPLE
    Get-SwordfishClassesOfService -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#ClassOfServiceCollection.ClassOfServiceCollection
    @odata.type         : #ClassOfServiceCollection.ClassOfServiceCollection
    @odata.id           : /redfish/v1/StorageServices/S1/ClassesOfService
    Name                : ClassOfService Collection
    Members@odata.count : 5
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID1},
                          @{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID5},
                          @{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID6},
                          @{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/RAID10}...}
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/ClassOfService.v1_2_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
                
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [string]    $ClassId,
    
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [switch]    $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {     'Default'         {   foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefClassCol += Get-SwordfishClassesOfService -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $ClassID )
                                        {   return ( $DefClassCol | where-object {$_.id -eq $ClassId} ) 
                                        } else 
                                        {   return $DefClassCol
                                        } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $ClassMemberOrCollection = $PulledData.ClassesOfService
            $ClassColOrClasses = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
            if ( $ClassColOrClasses.Members ) 
                {   $ClassMemberOrCollection = $ClassColOrClasses.Members    
                }
            [array]$FullClassCollectionOnly += $ClassColOrClasses    
            foreach ( $CorCC in $Memberset )
                {   foreach ( $MyClassData in $ClassMemberOrCollection )
                        {   [array]$FullClassSet += Invoke-RestMethod2 -uri ( $base + ($MyClassData.'@odata.id') )
                        }
                }
            if ( $ReturnCollectionOnly )
                {   return $FullClassCollectionOnly
                } else 
                {   if ( $ClassID)
                    {   return $FullClassSet | where-object { $_.id -eq $ClassID }
                    } else 
                    {   return $FullClassSet
}}      }       }   }            