function Get-SwordFishVolumes{
    <#
    .SYNOPSIS
        Retrieve The list of valid Volumes from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Volumes objects that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific volume ID 
        is directly requested.
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return volumes for all Storage Services.
    .PARAMETER VolumeId
        The Volume ID name for a specific volume, otherwise the command
        will return all volumes.
    .EXAMPLE
         Get-SwordFishVolume
    .EXAMPLE
         Get-SwordFishVolume -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishVolume -StorageServiceId AC-102345 -VolumeId MyNewVol1
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StorageService.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID
        [string] $VolumeID
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