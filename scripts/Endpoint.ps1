function Get-SwordFishEndpoint{
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
         Get-SwordFishEndpoint
    .EXAMPLE
         Get-SwordFishEndpoint -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishEndpoint -StorageServiceId AC-102345 -EndpointRole Target
    .EXAMPLE
         Get-SwordFishEndpoint -EndpointRole Initiator
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/Endpoint.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [Validateset('Initiator','Target')]
        [string] $EndPointRole
    )
    process{
        # SS(s) = Storage Service(s)
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $EPsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   $Data = invoke-restmethod -uri $SSUri
                        $SSsCol+=invoke-restmethod -uri $SSUri 
                        # EP(s) = Endpoint(s)
                        $EPRoot = (($Data).Endpoints).'@odata.id'
                        $EPsUri=$base+$EPRoot
                        $EPsData=Invoke-RestMethod -uri $EPsUri
                        $EPs = $($EPsData).Members
                        foreach($EP in $EPs)
                        {   $EPRawUri=$(($EP).'@odata.id')
                            $EPUri=$base+$EPRawUri
                            if ( ( (invoke-restmethod -uri $EPUri).EndpointRole -like $EndpointRole) -or ( $EndpointRole -eq '' ) )             
                                {   $EPsCol+=invoke-RestMethod -uri $EPUri 
                                }
                        }    
                    } 
            }
        return $EPsCol
    }
}