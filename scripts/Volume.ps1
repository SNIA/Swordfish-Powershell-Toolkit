function Get-SwordFishVolume{
    <#
    .SYNOPSIS
        Retrieve The list of valid Volumes from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        Volumes that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific 
        Volume ID is directly requested. 
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Storage Groups for all Storage Services.
    .PARAMETER VolumeId
        The Storage Group ID will limit the returned data
        to the type specified, otherwise the command will return all Volumes.
    .EXAMPLE
         Get-SwordFishStorageVolume
    .EXAMPLE
         Get-SwordFishStorageVolume -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStorageVolume -StorageServiceId AC-102345 -VolumeId 2
    .EXAMPLE
         Get-SwordFishStorageVolume -VolumeId 1
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/Volume.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [string] $VolumeId
    )
    process{
        # SS(s) = Storage Service(s)
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $VsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   $Data = invoke-restmethod -uri $SSUri
                        $SSsCol+=invoke-restmethod -uri $SSUri 
                        # V(s) = Volume(s)
                        $VRoot = (($Data).Volumes).'@odata.id'
                        $VsUri=$base+$VRoot
                        $VsData = invoke-restmethod -uri $VsUri
                        $Vs = $($VsData).Members
                        foreach($V in $Vs)
                        {   $VRawUri=$(($V).'@odata.id')
                            $VUri=$base+$VRawUri
                            if ( ( (invoke-restmethod -uri $VUri).id -like $VolumeId) -or ( $VolumeId -eq '' ) )             
                                {   $VsCol+=invoke-RestMethod -uri $VUri 
                                    # Write-Error "The StoragePool is not implemented in the Simulator yet, so cant test yet"
                                }
                        }    
                    } 
            }
        return $VsCol
    }
}