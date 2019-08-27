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
        [string] $StorageServiceID='',

        [Validateset('Initiator','Target','')]
        [string] $EndPointRole=''
    )
    process{
        $EPsCol=@() 
        foreach($link in (Get-SwordFishStorageService -StorageServiceID $StorageServiceID))
            {   $EPsURI = $base + (($link).Endpoints).'@odata.id'
                write-verbose "Opening URI EPsURI = $EPsURI"
                $EPsData = invoke-restmethod2 -uri $EPsURI
                $EPs = $EPsData.members
                foreach ($EP in $EPs )
                {   $EPuri = $Base+ ($EP.'@odata.id')
                    write-verbose "Opening URI EPuri = $EPuri"
                    $EPData = invoke-restmethod2 -uri $EPuri
                    if  ( ( $EPData.EndpointRole -like $EndPointRole ) -or ( $EndPointRole -eq '') ) 
                            {   $EPsCol+=$EPData
                            }
            }   }   
        return $EPsCol
    }
}