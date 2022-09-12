function Get-SwordfishIOConnectivityLoSCapabilities{
<#
.SYNOPSIS
    Retrieve The list of valid IO Connectivity LoS Capabilities from the Swordfish Target.
.DESCRIPTION
    This command will either return the complete collection of IO Connectivity LoS Capabilities that 
    exist across all of the Storage Services, unless a  specific Storage Services ID is used to limit it, or a 
    specific IO Connectivity LoS Capabilities ID is directly requested. It will search the following 
    locations; /refish/v1/StorageServices/id/IOConnectivityLoSCapabilities.
.PARAMETER StorageServiceId
    The StorageService ID name for a specific Storage Service, otherwise the command will return Volumes for 
    all Storage Services and/or Storage Systems.
.PARAMETER DSLOSCId
    The IO Connectivity LoS Capabilities ID name for a specific IO Connectivity LoS Capabilities, otherwise the 
    command will return all of the IO Connectivity LoS Capabilities within all of the Storage Services.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishIOConnectivityLoSCapabilities -ReturnCollectionOnly

    @odata.context      : /redfish/v1/$metadata#IOConnectivityLoSCapabilitiesCollection.IOConnectivityLoSCapabilitiesCollection
    @odata.type         : #IOConnectivityLoSCapabilitiesCollection.IOConnectivityLoSCapabilitiesCollection
    @odata.id           : /redfish/v1/StorageServices/S1/IOConnectivityLoSCapabilities
    Name                : IOConnectivityLoSCapabilities Collection
    Members@odata.count : 0
    Members             : {}
.EXAMPLE
    Get-SwordfishIOConnectivityLoSCapabilities

    @odata.context           : /redfish/v1/$metadata#IOConnectivityLoSCapabilities.IOConnectivityLoSCapabilities
    @odata.id                : /redfish/v1/StorageServices/S1/IOConnectivityLoSCapabilities/IOCLOSC
    @odata.type              : #IOConnectivityLoSCapabilities.v1_0_2.IOConnectivityLoSCapabilities
    Id                       : IOCLOSC
    Name                     : IO Connectivity Line Of Service Capabilities
    SupportedAccessProtocols : {iSCSI}
    SupportedLinesOfService  : {@{@odata.context=/redfish/v1/$metadata#IOConnectivityLineOfService.IOConnectivityLineOfService; 
                               @odata.id=/redfish/v1/StorageServices/S1/ClassesOfService/DefaultCOS/IOConnectivityLineOfService/IOCLOS;
                               @odata.type=#IOConnectivityLineOfService.v1_0_2.IOConnectivityLineOfService; Id=IOCLOS;
                               Name=IO Connectivity Line Of Service; AccessProtocols=System.Object[]}}


.LINK
    http://redfish.dmtf.org/schemas/Swordfish/v1/IOConnectivityLineOfService.v1_2_1.json
#> 

[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByStorageServiceID')]  [string]    $StorageServiceID,
                
        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [switch]    $ReturnCollectionOnly,

        [Parameter(ParameterSetName='ByStorageServiceID')]
        [Parameter(ParameterSetName='Default')]             [string]    $IOCLoSCId
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {     'Default'         {   foreach ( $SSID in (Get-SwordfishStorageServices).id )
                                        {   [array]$DefDSLOSCCol += Get-SwordfishIOConnectivityLoSCapabilities -StorageServiceID $SSID -ReturnCollectionOnly:$ReturnCollectionOnly
                                        }
                                    if ( $IOCLoSCId )
                                        {   return ( $DefDSLOSCCol | where-object { $_.id -eq $IOCLoSCId } ) 
                                        } else 
                                        {   return $DefDSLOSCCol
                                        } 
                                }
            'ByStorageServiceID'{   $PulledData = Get-SwordfishStorageServices -StorageID $StorageServiceID
                                }
        }
    if ( $PSCmdlet.ParameterSetName -ne 'Default' )
        {   $MemberSet = $ItemMemberOrCollection = $PulledData.IOConnectivityLoSCapabilities
            [array]$FullItemSet = $ItemColOrItems = Invoke-RestMethod2 -uri ( $base + ( $MemberSet.'@odata.id' ) )
            $odataraw = $ItemColorItems.'@odata.id'
            $odataProcessed = $odataRaw.substring( 0, $odataRaw.lastIndexOf( '/' ) )
            [array]$FullDSLOSCCollectionOnly += Invoke-RestMethod2 -uri ( $base + $odataProcessed )
            if ( $ReturnCollectionOnly )
                {   return $FullDSLOSCCollectionOnly 
                } else 
                {   if ( $IOCLoSCId )
                        {   return $FullItemSet | where-object { $_.id -eq $IOCLoSCId }
                        } else 
                        {   return $FullItemSet
                        }
                }
            
        }
}}
