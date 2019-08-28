function Get-SwordFishEndpointGroup{
    <#
    .SYNOPSIS
        Retrieve The list of valid Endpoint Groups from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Endpoint Group objects that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific Endpoint Group ID 
        is directly requested. You may also limit the serch to only return server/target endpoint groups
        or client/initiator endpoints using the GroupType
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Endpoints for all Storage Services.
    .PARAMETER GroupType
        The group contains only endpoints of a given type Client/Initiator or Server/Target.  
        If this endpoint group represents a SCSI target group, the value of GroupType shall be Server.
    .EXAMPLE
         Get-SwordFishEndpoint
    .EXAMPLE
         Get-SwordFishEndpointGroup -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishEndpointGroup -StorageServiceId AC-102345 -GroupType Client
    .EXAMPLE
         Get-SwordFishEndpointGroup -GroupType Initiator
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/EndpointGroup.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID='',

        [Validateset('Client','Server','')]
        [string] $GroupType=''
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
                    if  ( ( $EPData.GroupType -like $GroupType ) -or ( $GroupType -eq '') ) 
                            {   $EPsCol+=$EPData
                            }
            }   }   
        return $EPsCol
    }
}