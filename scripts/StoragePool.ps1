function Get-SwordFishStoragePool{
    <#
    .SYNOPSIS
        Retrieve The list of valid Endpoint from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Endpoint objects that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific Endpoint ID 
        is directly requested. You may also limit the serch to only return target endpoints
        or initiator endpoints using the EndpointType
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Endpoints for all Storage Services.
    .PARAMETER EndpointRole
        The Endpoint Type can either be Initiator or Target and will limit the returned data
        to the type specified, otherwise the command will return all endpoints.
    .EXAMPLE
         Get-SwordFishStoragePool
    .EXAMPLE
         Get-SwordFishStoragePool -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStoragePool -StorageServiceId AC-102345 -EndpointRole Target
    .EXAMPLE
         Get-SwordFishStoragePool -EndpointRole Initiator
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StoragePool.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [string] $StoragePoolId
    )
    process{
        # SS(s) = Storage Service(s)
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $SPsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   $Data = invoke-restmethod -uri $SSUri
                        $SSsCol+=invoke-restmethod -uri $SSUri 
                        # SP(s) = StoragePool(s)
                        $SPRoot = (($Data).StoragePools).'@odata.id'
                        $SPsUri=$base+$SPRoot
                        try {   $SPsData = invoke-restmethod -uri $SPsUri
                                $SPs = $($SPsData).Members
                                foreach($SP in $SPs)
                                {   $SPRawUri=$(($SP).'@odata.id')
                                    $SPUri=$base+$SPRawUri
                                    if ( ( (invoke-restmethod -uri $SPUri).Id -like $StoragePoolId) -or ( $StoragePoolId -eq '' ) )             
                                    {   try     {   $SPsCol+=invoke-RestMethod -uri $SPUri 
                                                }
                                        catch   { Write-Error "The Storage System supports Pools but no pool exists"
                                                }
                                    }
                                }
                            }
                        catch { Write-verbose "This Storage System doesnt have a pool"
                              }    
                    } 
            }
        return $SPsCol
    }
}