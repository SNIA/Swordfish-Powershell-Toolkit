function Get-SwordFishStorageSystem{
    <#
    .SYNOPSIS
        Retrieve The list of valid Storage Systems from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Storage System objects that exist or if a single Storage System is selected, 
        it will return only the single Storage System ID.
    .PARAMETER StorageServiceId
        The Storage System ID name for a specific Storage System, otherwise the command
        will return all Storage Systems.
    .EXAMPLE
         Get-SwordFishStorageSystem
    .EXAMPLE
         Get-SwordFishStorageSystem -StorageSystemId AC-102345
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StorageSystem.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageSystemID
    )
    process{
        $LocalUri = Get-SwordfishURIFolderByFolder "StorageSystems"
        write-verbose "Folder = $LocalUri"
        $LocalData = invoke-restmethod2 -uri $LocalUri
        # Now must find if this contains links or directly goes to members. 
        $Links = (($LocalData).Links).Members + ($LocalData).Members
        $LocalCol=@()  
        foreach($link in $Links)
            {   $SingletonUri=($link).'@odata.id'
                $Singleton=$base+$SingletonUri
                if ( ( (invoke-restmethod2 -uri $Singleton).id -like $StorageSystemID ) -or ( $StorageSystemID -eq '' ) )
                    {   $LocalCol+=invoke-restmethod2 -uri $Singleton 
                    } 
            }
        return $LocalCol
    }
}