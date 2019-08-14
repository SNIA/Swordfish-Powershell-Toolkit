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
        $LocalUri = Get-SwordfishURIFolderByFolder "StorageServices"
        write-verbose "Folder = $LocalUri"
        $LocalData = invoke-restmethod2 -uri $LocalUri
        # Now must find if this contains links or directly goes to members. 
        $Links = (($LocalData).Links).Members + ($LocalData).Members
        $LocalCol=@()  
        foreach($link in $Links)
            {   $SingletonUri=($link).'@odata.id'
                $Singleton=$base+$SingletonUri
                if ( ( (invoke-restmethod2 -uri $Singleton).id -like $StorageServiceID ) -or ( $StorageServiceID -eq '' ) )
                    {   $LocalCol+=invoke-restmethod2 -uri $Singleton 
                    } 
            }
        return $LocalCol
    }
}