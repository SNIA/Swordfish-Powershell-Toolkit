function Get-SwordfishFabric{
<#
.SYNOPSIS
    Retrieve The list of valid Fabrics from the Swordfish Target.
.DESCRIPTION
    This command will either return the a collection of Fabrics objects that exist or if a single 
    System is selected, it will return only the single fabric ID.
.PARAMETER FabricID
    The Fabric ID name for a specific Fabric, otherwise the command
    will return all Fabrics.
.PARAMETER ReturnCollectioOnly
    This directive boolean value defaults to false, but will return the collection instead of an array of the actual objects if set to true.
.EXAMPLE
    Get-SwordfishFabric    
.EXAMPLE
    PS:> Get-SwordfishFabric -FabricId 00C0FF5038E8
.EXAMPLE
    Get-SwordfishFabric -ReturnCollectionOnly
    
    @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
    @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
    @odata.id           : /redfish/v1/ComputerSystem
    Name                : ComputerSystem Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8}}
.LINK
    https://redfish.dmtf.org/schemas/v1/Fabric.v1_2_0.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='Default')] [string]   $FabricID,
        [Parameter(ParameterSetName='Default')] [switch]   $ReturnCollectionOnly
     )
process{
    $SysColOnly = invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Fabrics" )
    foreach($Sys in ($SysColOnly).Members )
        {   [array]$SysCol +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') ) 
        }
    if ( $ReturnCollectionOnly )
        {   return $SysColOnly
        } else 
        {   if ( $FabricID )
                {   return ( $SysCol | where-object { $_.id -eq $FabricId } )
                } else 
                {   return ( $SysCol )
}}      }       }    