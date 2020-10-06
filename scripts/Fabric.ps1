function Get-SwordfishSystem{
<#
.SYNOPSIS
    Retrieve The list of valid Fabrics from the SwordFish Target.
.DESCRIPTION
    This command will either return the a complete collection of Fabrics objects that exist or if a single 
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
    Get-SwordfishFabric -ReturnCollectionOnly $true
    
    @odata.context      : /redfish/v1/$metadata#ComputerSystemCollection.ComputerSystemCollection
    @odata.type         : #ComputerSystemCollection.ComputerSystemCollection
    @odata.id           : /redfish/v1/ComputerSystem
    Name                : ComputerSystem Collection
    Members@odata.count : 1
    Members             : {@{@odata.id=/redfish/v1/ComputerSystem/00C0FF5038E8}}
.EXAMPLE
    PS:> Get-SwordfishSystem -ReturnCollectionOnly $True | ConvertTo-Json
.LINK
#>   
[CmdletBinding()]
            param(
                [string]    $FabricID,
                [boolean]   $ReturnCollectionOnly   =   $False
            )
            process{
                $SystemUri = Get-SwordfishURIFolderByFolder "Fabrics"
                $SystemData = invoke-restmethod2 -uri $SystemUri
                $SysCol=@()  
                foreach($Sys in ($SystemData).Members )
                    {   $SysCol     +=  invoke-restmethod2 -uri ( $base + ($Sys.'@odata.id') ) 
                        $ReturnColl =   $SystemData 
                    }
                if ( $ReturnCollectionOnly )
                    {   return $ReturnColl
                    } else 
                    {   if ( $FabricID )
                        {   return ( $SysCol | where-object { $_.id -eq $FabricId } )
                        } else 
                        {   return ( $SysCol )
    
                        }
                    }        
            }
        }
    