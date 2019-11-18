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
         Get-SwordFishStoragePool -StorageSystemId AC-102345
    .EXAMPLE
         Get-SwordFishStoragePool -StorageServiceId AC-102345 -EndpointRole Target
    .EXAMPLE
         Get-SwordFishStoragePool -EndpointRole Initiator
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StoragePool.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID='',

        [string] $StoragePoolId
    )
    process{
        $SPsCol=@() 
        $StorageClasses=@("StorageSystems","StorageServices")
        # This allows me to do a search first for the Non-Class of Service Swordfish, then do the search for Class-of-Service type swordfish.
        # StorageSystems is service/less, thusly doesnt require class-of-service as specified in Swordfish 1.1.0+
        foreach ($StorageClass in $StorageClasses)
        {   if ($StorageClass -like "StorageSystems")
                {   $Links = Get-SwordFishStorageService -StorageServiceID $StorageServiceID
                } else 
                {   $Links = Get-SwordFishStorageSystem -SystemID $StorageSystemId
                }
            foreach($link in $Links)
            {   $SPsURI = $base + (($link).StoragePools).'@odata.id'
                write-verbose "Opening URI SPsURI = $SPsURI"
                $SPsData = invoke-restmethod2 -uri $SPsURI
                if ( $SPsData.members )
                    {   $SPs = $SPsData.members
                    } else 
                    {   $SPs = $SPsData   
                    }
                write-verbose "SPs = $SPs"
                foreach ($SP in $SPs )
                {   $SPuri = $Base+ ($SP.'@odata.id')
                    write-verbose "Opening URI SPuri = $SPuri"
                    $SPData = invoke-restmethod2 -uri $SPuri
                    if  ( ( $SPData.id -like $StoragePoolId ) -or ( $StoragePoolId -eq '') ) 
                        {   write-verbose "++++Adding $SPData"
                            $SPsCol+=$SPData
            }   }       }
        }
        return $SPsCol
    }
}