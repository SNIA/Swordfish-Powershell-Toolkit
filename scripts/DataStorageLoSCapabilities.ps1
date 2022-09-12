function Get-SwordfishDataStorageLoSCapabilities{
<#
.SYNOPSIS
    Retrieve The list of valid Data Storage Lines Of Service Capabilities from the Swordfish Target.
.DESCRIPTION
    This command will either return the complete collection of Data Storage Lines Of Service Capabilities that 
    exist across all of the Storage Services, unless a  specific Storage Services ID is used to limit it, or a 
    specific Data Storage Lines Of Service Capabilities ID is directly requested. It will search the following 
    locations; /refish/v1/StorageServices/id/DataStorageLoSCapabilities.
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command will return Volumes for 
    all Storage Services and/or Storage Systems and all pools.
.PARAMETER DSLOSCId
    The Data Storage Lines Of Service Capabilities ID name for a specific Data Storage Lines Of Service 
    Capabilities, otherwise the command will return all of the Data Storage Lines Of Service Capabilities 
    within all of the Storage Services.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishDataStorageLoSCapabilities -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#DataStorageLoSCapabilitiesCollection.DataStorageLoSCapabilitiesCollection
    @odata.type         : #DataStorageLoSCapabilitiesCollection.DataStorageLoSCapabilitiesCollection
    @odata.id           : /redfish/v1/StorageServices/S1/DataStorageLoSCapabilities
    Name                : DataStorageLoSCapabilities Collection
    Members@odata.count : 0
    Members             : {}
.EXAMPLE
    Get-SwordfishDataStorageLoSCapabilities

    @odata.context              : /redfish/v1/$metadata#DataStorageLoSCapabilities.DataStorageLoSCapabilities
    @odata.id                   : /redfish/v1/StorageServices/S1/DataStorageLoSCapabilities/DSLOSC
    @odata.type                 : #DataStorageLoSCapabilities.v1_0_2.DataStorageLoSCapabilities
    Id                          : DSLOSC
    Name                        : Data Storage Line Of Service Capabilities
    SupportedAccessCapabilities : {Read, Write}
    SupportsSpaceEfficiency     : False
    SupportedLinesOfService     : {@{@odata.context=/redfish/v1/$metadata#DataStorageLineOfService.DataStorageLineOfService;
                                  @odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/DefaultCOS/DataStorageLineOfService/DSLOS;
                                  @odata.type=#DataStorageLineOfService.v1_1_0.DataStorageLineOfService; Id=DSLOS; Name=Data Storage Line of Service;
                                  AccessCapabilities=System.Object[]; IsSpaceEfficient=False}}
.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/DataProtectionLoSCapabilities.v1_1_3.json
#> 

[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
                
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [switch]    $ReturnCollectionOnly,

        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [string]    $DSLoSCId
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {     'Default'         {   foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefDSLOSCCol += Get-SwordfishDataStorageLoSCapabilities -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $DSLoSCId )
                                        {   return ( $DefDSLOSCCol | where-object { $_.id -eq $DSLoSCId } ) 
                                        } else 
                                        {   return $DefDSLOSCCol
                                        } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $ItemMemberOrCollection = $PulledData.DataStorageLoSCapabilities
            [array]$FullItemSet = $ItemColOrItems = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
            $odataraw = $ItemColorItems.'@odata.id'
            $odataProcessed = $odataRaw.substring( 0, $odataRaw.lastIndexOf( '/' ) )
            [array]$FullDSLOSCCollectionOnly += Invoke-RestMethod2 -uri ( $base + $odataProcessed )
            if ( $ReturnCollectionOnly )
                {   return $FullDSLOSCCollectionOnly 
                } else 
                {   if ( $DSLoSCId)
                        {   return $FullItemSet | where-object { $_.id -eq $DSLoSCId }
                        } else 
                        {   return $FullItemSet
                        }
                }
            
        }
}}
