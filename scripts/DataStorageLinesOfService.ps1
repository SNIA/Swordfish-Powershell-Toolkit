function Get-SwordfishDataStorageLinesOfService{
<#
.SYNOPSIS
    The command will return Data Storage Lines of service deined under Classes of Service in a Storage Service Model.
.DESCRIPTION
    This command will either return the a complete collection of Data Protection Lines of Service that exist across all of 
    the Storage Services and Classes of Service, unless a  specific Storage Services ID or Class ID is used to limit it, or a specific 
    DSLOS ID is directly requested. It will search the following locations; /refish/v1/StorageServices/id/ClassesOfService
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command will return Data Protection lines of 
    Service for all Storage Services and all Classes of Service.
.PARAMETER ClassId
    The Class ID name for a specific Class of Service, otherwise the command will return Data Protection lines of Service 
    for all Storage Services and all Classes of Service.
.PARAMETER DSLOSId
    The Storage Group ID will limit the returned data to the type specified, otherwise the command will return all 
    Data Storage Lines of Service.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishDataStorageLinesOfService

    @odata.context     : /redfish/v1/$metadata#DataStorageLineOfService.DataStorageLineOfService
    @odata.id          : /redfish/v1/StorageServices/S1/ClassesOfService/DefaultCOS/DataStorageLineOfService/DSLOS
    @odata.type        : #DataStorageLineOfService.v1_1_0.DataStorageLineOfService
    Id                 : DSLOS
    Name               : Data Storage Line of Service
    AccessCapabilities : {Read, Write}
    IsSpaceEfficient   : False
.EXAMPLE
    Get-SwordfishDataStorageLinesOfService -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#DataStorageLineOfServiceCollection.DataStorageLineOfServiceCollection
    @odata.type         : #DataStorageLineOfServiceCollection.DataStorageLineOfServiceCollection
    @odata.id           : /redfish/v1/StorageServices/S1/ClassesOfService/DefaultCOS/DataStorageLineOfService
    Name                : DataStorageLineOfService Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/DefaultCOS/DataStorageLineOfService/DSLOS}}

.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/DataStorageLineOfService.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
    param(  [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
                
            [Parameter(ParameterSetName='ByClassId')]           [string]    $ClassId,
    
            [Parameter(ParameterSetName='ByClassId')]
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='Default')]             [string]    $DSLOSId,

            [Parameter(ParameterSetName='ByClassId')]
            [Parameter(ParameterSetName='ByStorageServiceID')]
            [Parameter(ParameterSetName='Default')]             [switch]   $ReturnCollectionOnly 
         )
process{
    switch ($PSCmdlet.ParameterSetName )
        {   'Default'           {   foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefDSLOSCol += Get-SwordfishDataStorageLinesOfService -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    foreach ( $CLAID in (Get-SwordfishClassesOfService).id )
                                        {   [array]$DefDSLOSCol += Get-SwordfishDataStorageLinesOfService -ClassID $CLA -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $DSLOSID )
                                        {   return ( $DefDSLOSCol | get-unique | where-object {$_.id -eq $DSLOSId} ) 
                                        } else 
                                        {   return ( $DefDSLOSCol | get-unique )
                                        } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishClassesOfService -StorageServiceID $StorageServiceID
                                }
            'ByClassID'         {   $PulledData = Get-SwordfishClassesOfService -ClassID $ClassID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   foreach( $Subitem in $PulledData ) 
            {   $MemberSet = $DSLOSMemberOrCollection = $Subitem.DataStorageLinesOfService
                $DSLOSColOrDSLOSs = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
                if ( $DSLOSColOrDSLOSs.Members ) 
                    {   $DSLOSMemberOrCollection = $DSLOSColOrDSLOSs.Members    
                    }
                # [array]$FullDSLOSCollectionOnly += $DSLOSColOrDSLOSs    
                foreach ( $DSLOSorDSLOSC in $Memberset )
                    {   foreach ( $MyDSLOSData in $DSLOSMemberOrCollection )
                            {   [array]$FullDSLOSSet += Invoke-RestMethod2 -uri ( $base + ($MyDSLOSData.'@odata.id') )
                            }
                    }
            }
            foreach ( $Col in ( $FullDSLOSSet | Get-Unique ) )
            {   $odataraw = $Col.'@odata.id'
                $odataProcessed = $odataRaw.substring( 0, $odataRaw.lastIndexOf( '/' ) )
                [array]$FullDSLOSCollectionOnly += Invoke-RestMethod2 -uri ( $base + $odataProcessed )
            }
            if ( $ReturnCollectionOnly )
                    {   return $FullDSLOSCollectionOnly
                    } else 
                    {   if ( $DSLOSID)
                        {   return $FullDSLOSSet | where-object { $_.id -eq $DSLOSID }
                        } else 
                        {   return ( $FullDSLOSSet | get-unique )
    }}  }           }   }  