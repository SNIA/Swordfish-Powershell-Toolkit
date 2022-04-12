function Get-SwordfishSystem{
<#
.SYNOPSIS
    Retrieve The list of valid Computer Systems from the Swordfish Target.
.DESCRIPTION
    This command will either return the a complete collection of System objects that exist or if a single 
    System is selected, it will return only the single System ID.
.PARAMETER ComputerSystemID
    The Computer System ID name for a specific System, otherwise the command
    will return all Computer Systems.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishSystem 

    @odata.context     : /redfish/v1/$metadata#ComputerSystem.ComputerSystem
    @odata.id          : /redfish/v1/ComputerSystem/00C0FF5038E8
    @odata.type        : #ComputerSystem.v1_6_0.ComputerSystem
    Id                 : 00C0FF5038E8
    Name               : Uninitialized Name
    Manufacturer       : HPE
    SerialNumber       : 00C0FF5038E8
    Status             : @{Health=OK}
    EthernetInterfaces : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces}
    Storage            : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/Storage}
    Links              : @{Chassis=System.Object[]; Endpoints=System.Object[]}

.EXAMPLE
    PS:> Get-SwordfishSystem -SystemId 00C0FF5038E8
    
    { Output Identical to example 1}
.EXAMPLE
    Get-SwordfishSystem -ReturnCollectionOnly $true

    @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
    @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
    @odata.id           : /redfish/v1/ComputerSystem
    Name                : ComputerSystem Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8}}
.LINK
    https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
.VERSION 1.13.0
#>   
<#PSScriptInfo
.VERSION 1.13.0
#>
[CmdletBinding()]
param(  [string]    $SystemID,
        [switch]    $ReturnCollectionOnly
     )
process{
    $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems")
    $SysCollection=@()
    foreach($Sys in ($SystemData).Members )
        {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') )  
        }
    if ( $ReturnCollectionOnly )
        {   return $SystemData
        } else 
        {   if ( $SystemID )
                {   return ( $SysCollection | where-object { $_.id -eq $SystemId } )
                } else 
                {   return ( $SysCollection )                    
}}      }       }

function Get-RedfishSystem{
    <#
    .SYNOPSIS
        Retrieve The list of valid Computer Systems from the Redfish Target.
    .DESCRIPTION
        This command will either return the a complete collection of System objects that exist or if a single 
        System is selected, it will return only the single System ID.
    .PARAMETER ComputerSystemID
        The Computer System ID name for a specific System, otherwise the command
        will return all Computer Systems.
    .PARAMETER ReturnCollectioOnly
        This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
    .EXAMPLE
        Get-RedfishSystem 
    
        PS C:\Users\chris\Desktop\Swordfish-Powershell-Toolkit> Get-SwordfishSystem

        @odata.context     : /redfish/v1/$metadata#ComputerSystem.ComputerSystem
        @odata.etag        : W/"C5688730"
        @odata.id          : /redfish/v1/Systems/1/
        @odata.type        : #ComputerSystem.v1_4_0.ComputerSystem
        Id                 : 1
        Actions            : @{#ComputerSystem.Reset=}
        AssetTag           :
        Bios               : @{@odata.id=/redfish/v1/systems/1/bios/}
        BiosVersion        : U32 v2.20 (10/31/2019)
        Boot               : @{BootOptions=; BootOrder=System.Object[]; BootSourceOverrideEnabled=Disabled; BootSourceOverrideMode=UEFI; BootSourceOverrideTarget=None;
                            BootSourceOverrideTarget@Redfish.AllowableValues=System.Object[]; UefiTargetBootSourceOverride=None;
                            UefiTargetBootSourceOverride@Redfish.AllowableValues=System.Object[]}
        EthernetInterfaces : @{@odata.id=/redfish/v1/Systems/1/EthernetInterfaces/}
        HostName           : WIN-966J9R57GOS
        IndicatorLED       : Off
        Links              : @{ManagedBy=System.Object[]; Chassis=System.Object[]}
        LogServices        : @{@odata.id=/redfish/v1/Systems/1/LogServices/}
        Manufacturer       : HPE
        Memory             : @{@odata.id=/redfish/v1/Systems/1/Memory/}
        MemoryDomains      : @{@odata.id=/redfish/v1/Systems/1/MemoryDomains/}
        MemorySummary      : @{Status=; TotalSystemMemoryGiB=32; TotalSystemPersistentMemoryGiB=0}
        Model              : ProLiant DL360 Gen10
        Name               : Computer System
        NetworkInterfaces  : @{@odata.id=/redfish/v1/Systems/1/NetworkInterfaces/}
        Oem                : @{Hpe=}
        PowerState         : On
        ProcessorSummary   : @{Count=2; Model=Intel(R) Xeon(R) Silver 4110 CPU @ 2.10GHz; Status=}
        Processors         : @{@odata.id=/redfish/v1/Systems/1/Processors/}
        SKU                : 867960-B21
        SecureBoot         : @{@odata.id=/redfish/v1/Systems/1/SecureBoot/}
        SerialNumber       : USE726CR3F
        Status             : @{Health=Warning; HealthRollup=Warning; State=Enabled}
        Storage            : @{@odata.id=/redfish/v1/Systems/1/Storage/}
        SystemType         : Physical
        TrustedModules     : {@{Oem=; Status=}}
        UUID               : 39373638-3036-5355-4537-323643523346

    
    .EXAMPLE
        PS:> Get-SwordfishSystem -SystemId 1
        
        { Output Identical to example 1}
    .EXAMPLE
        Get-SwordfishSystem -ReturnCollectionOnly $true
    
        @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
        @odata.etag         : W/"AA6D42B0"
        @odata.id           : /redfish/v1/Systems/
        @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
        Description         : Computer Systems view
        Name                : Computer Systems
        Members             : {@{@odata.id=/redfish/v1/Systems/1/}}
        Members@odata.count : 1
    
    .EXAMPLE
        PS:> Get-SwordfishSystem -ReturnCollectionOnly $True | ConvertTo-Json
        
        {   "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
            "@odata.type":  "#StorageCollection.StorageCollection",
            "@odata.id":  "/redfish/v1/Storage",
            "Name":  "Storage System Collection",
            "Members":  [
                            {
                                "@odata.id":  "/redfish/v1/Storage/AC-109032"
                            }
                        ]
        }
    .LINK
        https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
    .VERSION 1.13.0
    #>   
    <#PSScriptInfo
    .VERSION 1.13.0
    #>
    [CmdletBinding()]
    param(  [string]    $SystemID,
            [switch]    $ReturnCollectionOnly
         )
    process{
        $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems")
        $SysCollection=@()
        foreach($Sys in ($SystemData).Members )
            {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') )  
            }
        if ( $ReturnCollectionOnly )
            {   return $SystemData
            } else 
            {   if ( $SystemID )
                    {   return ( $SysCollection | where-object { $_.id -eq $SystemId } )
                    } else 
                    {   return ( $SysCollection )                    
    }}      }       }

function Get-SwordfishSystemComponent 
{
    <#
    .SYNOPSIS
        Retrieve The list of valid Subcomponents within a single Computer System.
    .DESCRIPTION
        This command will either return the a complete collection of System Components of a specific type object(s) that exist.
    .PARAMETER ComputerSystemID
        The Computer System ID name for a specific System, otherwise the command
        will return all Computer Systems.
    .PARAMETER ReturnCollectioOnly
        This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
    .PARAMETER SubComponent
        This can be a select set of different subcomponents within the sytems, the valid items are 
        Bios, Boot, EthernetInterfaces, LogServices, Memory, MemoryDomains, NetworkInterfaces, Processors, SecureBoot, Storage, TrustedModules.
    .EXAMPLE
        Get-SwordfishSystem -Subcomponent 
    
        @odata.context     : /redfish/v1/$metadata#ComputerSystem.ComputerSystem
        @odata.id          : /redfish/v1/ComputerSystem/00C0FF5038E8
        @odata.type        : #ComputerSystem.v1_6_0.ComputerSystem
        Id                 : 00C0FF5038E8
        Name               : Uninitialized Name
        Manufacturer       : HPE
        SerialNumber       : 00C0FF5038E8
        Status             : @{Health=OK}
        EthernetInterfaces : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/EthernetInterfaces}
        Storage            : @{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8/Storage}
        Links              : @{Chassis=System.Object[]; Endpoints=System.Object[]}
    
    .EXAMPLE
        PS:> Get-SwordfishSystem -SystemId 00C0FF5038E8
        
        { Output Identical to example 1}
    .EXAMPLE
        Get-SwordfishSystem -ReturnCollectionOnly $true
    
        @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
        @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
        @odata.id           : /redfish/v1/ComputerSystem
        Name                : ComputerSystem Collection
        Members@odata.count : 1
        Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8}}
    
    .EXAMPLE
        PS:> Get-SwordfishSystem -ReturnCollectionOnly $True | ConvertTo-Json
        
        {   "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
            "@odata.type":  "#StorageCollection.StorageCollection",
            "@odata.id":  "/redfish/v1/Storage",
            "Name":  "Storage System Collection",
            "Members":  [
                            {
                                "@odata.id":  "/redfish/v1/Storage/AC-109032"
                            }
                        ]
        }
    .LINK
        https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
    .VERSION 1.13.0
    #>   
    <#PSScriptInfo
    .VERSION 1.13.0
    #>
    [CmdletBinding()]
    param(  [string]    $SystemID,
            [ValidateSet ('Bios', 'Boot', 'EthernetInterfaces', 'LogServices', 'Memory', 'MemoryDomains', 
                           'NetworkInterfaces', 'Processors', 'SecureBoot', 'Storage', 'TrustedModules')]
            [string]    $SubComponent,
            [switch]    $ReturnCollectionOnly
         )
    process{
        $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems")
        $SysCollection=@()
        $SecondOrderData=@()
        foreach($Sys in ($SystemData).Members )
            {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') )  
            }

        $FirstOrderData = $SystemData
        if ( $SystemID )
                    {   $FirstOrderData = $SysCollection | where-object { $_.id -eq $SystemId } 
                    } else 
                    {   $FirstOrderData = $SysCollection                     
                    }     
        if ( $FirstOrderData )
                {   $SecondOrderDataCollection = invoke-Restmethod2 -uri ( $base + ($FirstOrderData."$SubComponent").'@odata.id' )
                    foreach ( $Mem in $SecondOrderDataCollection.Members )
                    {   write-host $Mem
                        $SecondOrderData += invoke-Restmethod2 -uri ( $base + $Mem.'@odata.id' ) 
                    } 
                } 
            else
                {   $SecondOrderDataCollection = ''
                }
        if ( -not $SecondOrderDataCollection.'Members' )
            {   # Must be a single object without a collection, return the single object 
                $SecondOrderData = $SecondOrderDataCollection
            }
        if ( $ReturnCollectionOnly)
                {   return $SecondOrderDataCollection
                } 
            else 
                {   return $SecondOrderData
                }
    }
}

function Get-RedfishSystemComponent 
{
    <#
    .SYNOPSIS
        Retrieve The list of valid Subcomponents within a single Computer System.
    .DESCRIPTION
        This command will either return the a complete collection of System Components of a specific type object(s) that exist.
    .PARAMETER ComputerSystemID
        The Computer System ID name for a specific System, otherwise the command
        will return all Computer Systems.
    .PARAMETER ReturnCollectioOnly
        This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
    .PARAMETER SubComponent
        This can be a select set of different subcomponents within the sytems, the valid items are 
        Bios, Boot, EthernetInterfaces, LogServices, Memory, MemoryDomains, NetworkInterfaces, Processors, SecureBoot, Storage, TrustedModules.
    .EXAMPLE
        Get-RedfishSystem -Subcomponent Processor
    
        @odata.context        : /redfish/v1/$metadata#Processor.Processor
        @odata.etag           : W/"86C125F2"
        @odata.id             : /redfish/v1/Systems/1/Processors/1/
        @odata.type           : #Processor.v1_0_0.Processor
        Id                    : 1
        InstructionSet        : x86-64
        Manufacturer          : Intel(R) Corporation
        MaxSpeedMHz           : 4000
        Model                 : Intel(R) Xeon(R) Silver 4110 CPU @ 2.10GHz
        Name                  : Processors
        Oem                   : @{Hpe=}
        ProcessorArchitecture : x86
        ProcessorId           : @{EffectiveFamily=179; EffectiveModel=5; IdentificationRegisters=0x06540005fbffbfeb; MicrocodeInfo=; Step=4; VendorId=Intel(R) Corporation}
        ProcessorType         : CPU
        Socket                : Proc 1
        Status                : @{Health=OK; State=Enabled}
        TotalCores            : 8
        TotalThreads          : 16

        @odata.context        : /redfish/v1/$metadata#Processor.Processor
        @odata.etag           : W/"86C125F2"
        @odata.id             : /redfish/v1/Systems/1/Processors/2/
        @odata.type           : #Processor.v1_0_0.Processor
        Id                    : 2
        InstructionSet        : x86-64
        Manufacturer          : Intel(R) Corporation
        MaxSpeedMHz           : 4000
        Model                 : Intel(R) Xeon(R) Silver 4110 CPU @ 2.10GHz
        Name                  : Processors
        Oem                   : @{Hpe=}
        ProcessorArchitecture : x86
        ProcessorId           : @{EffectiveFamily=179; EffectiveModel=5; IdentificationRegisters=0x06540005fbffbfeb; MicrocodeInfo=; Step=4; VendorId=Intel(R) Corporation}
        ProcessorType         : CPU
        Socket                : Proc 2
        Status                : @{Health=OK; State=Enabled}
        TotalCores            : 8
        TotalThreads          : 16

        In This example the Server is a two socket machine, so two records are returned.
    .EXAMPLE
        PS:> Get-SwordfishSystem -SystemId 1
        
        { Output Identical to example 1}
    .EXAMPLE
        Get-SwordfishSystem -ReturnCollectionOnly $true
    
        @odata.context      : /redfish/v1/$metadata#ProcessorCollection.ProcessorCollection
        @odata.etag         : W/"570254F2"
        @odata.id           : /redfish/v1/Systems/1/Processors/
        @odata.type         : #ProcessorCollection.ProcessorCollection
        Description         : Processors view
        Name                : Processors Collection
        Members             : {@{@odata.id=/redfish/v1/Systems/1/Processors/1/}, @{@odata.id=/redfish/v1/Systems/1/Processors/2/}}
        Members@odata.count : 2


    
    .EXAMPLE
        PS:> Get-SwordfishSystem -ReturnCollectionOnly $True | ConvertTo-Json
        
        {
            "@odata.context":  "/redfish/v1/$metadata#ProcessorCollection.ProcessorCollection",
            "@odata.etag":  "W/\"570254F2\"",
            "@odata.id":  "/redfish/v1/Systems/1/Processors/",
            "@odata.type":  "#ProcessorCollection.ProcessorCollection",
            "Description":  "Processors view",
            "Name":  "Processors Collection",
            "Members":  [
                            {
                                "@odata.id":  "/redfish/v1/Systems/1/Processors/1/"
                            },
                            {
                                "@odata.id":  "/redfish/v1/Systems/1/Processors/2/"
                            }
                        ],
            "Members@odata.count":  2
        }
    .LINK
        https://redfish.dmtf.org/schemas/v1/ComputerSystem.v1_13_0.json
    .VERSION 1.13.0
    #>   
    <#PSScriptInfo
    .VERSION 1.13.0
    #>
    [CmdletBinding()]
    param(  [string]    $SystemID,
            [ValidateSet ('Bios', 'Boot', 'EthernetInterfaces', 'LogServices', 'Memory', 'MemoryDomains', 
                           'NetworkInterfaces', 'Processors', 'SecureBoot', 'Storage', 'TrustedModules')]
            [string]    $SubComponent,
            [switch]    $ReturnCollectionOnly
         )
    process{
        $SystemData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Systems")
        $SysCollection=@()
        $SecondOrderData=@()
        foreach($Sys in ($SystemData).Members )
            {   $SysCollection +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') )  
            }

        $FirstOrderData = $SystemData
        if ( $SystemID )
                    {   $FirstOrderData = $SysCollection | where-object { $_.id -eq $SystemId } 
                    } else 
                    {   $FirstOrderData = $SysCollection                     
                    }     
        if ( $FirstOrderData )
                {   $SecondOrderDataCollection = invoke-Restmethod2 -uri ( $base + ($FirstOrderData."$SubComponent").'@odata.id' )
                    foreach ( $Mem in $SecondOrderDataCollection.Members )
                    {   write-host $Mem
                        $SecondOrderData += invoke-Restmethod2 -uri ( $base + $Mem.'@odata.id' ) 
                    } 
                } 
            else
                {   $SecondOrderDataCollection = ''
                }
        if ( -not $SecondOrderDataCollection.'Members' )
            {   # Must be a single object without a collection, return the single object 
                $SecondOrderData = $SecondOrderDataCollection
            }
        if ( $ReturnCollectionOnly)
                {   return $SecondOrderDataCollection
                } 
            else 
                {   return $SecondOrderData
                }
    }
}