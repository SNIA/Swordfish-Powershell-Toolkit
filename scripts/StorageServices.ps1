function Get-SwordFishStorageService{
    <#
    .SYNOPSIS
        Retrieve The list of valid Storage Services from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Storage Service objects that exist or if a single Storage Service is selected, 
        it will return only the single Storage Service ID.
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return all Storage Services.
    .EXAMPLE
         Get-SwordFishStorageService
    .EXAMPLE
         Get-SwordFishStorageService -StorageServiceId AC-102345
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StorageService.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID
    )
    process{
        # SS(s) = Storage Service(s)
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()  
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   $SSsCol+=invoke-restmethod -uri $SSUri 
                    } 
            }
        return $SSsCol
    }
}