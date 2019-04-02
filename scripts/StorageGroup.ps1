function Get-SwordFishStorageGroup{
    <#
    .SYNOPSIS
        Retrieve The list of valid Storage Groups from the SwordFish Target.
    .DESCRIPTION
        This command will either return the a complete collection of 
        storage groups that exist across all of the Storage Services, unless a 
        specific Storage Service ID is used to limit it, or a specific Storage Group ID 
        is directly requested. 
    .PARAMETER StorageServiceId
        The Storage Service ID name for a specific Storage Service, otherwise the command
        will return Storage Groups for all Storage Services.
    .PARAMETER StorageGroupId
        The Storage Group ID will limit the returned data
        to the type specified, otherwise the command will return all storage groups.
    .EXAMPLE
         Get-SwordFishStorageGroup
    .EXAMPLE
         Get-SwordFishStorageGroup -StorageServiceId AC-102345
    .EXAMPLE
         Get-SwordFishStorageGroup -StorageServiceId AC-102345 -StorageGroupId 2
    .EXAMPLE
         Get-SwordFishStorageGroup -StorageGrouIdp 1
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StorageGroup.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID,

        [string] $StorageGroupId
    )
    process{
        # SS(s) = Storage Service(s)
        $ReturnData = invoke-restmethod -uri "$BaseUri"  
        $SSsUri = $Base + ((($ReturnData).links).StorageServices).'@odata.id'
        $SSsData = invoke-restmethod -uri $SSsUri
        $SSsLinks = ($SSsData).Members
        $SSsCol=@()
        $SGsCol=@() 
        foreach($SS in $SSsLinks)
            {   $SSRawUri=$(($SS).'@odata.id')
                $SSUri=$base+$SSRawUri
                if ( ( (invoke-restmethod -uri $SSUri).id -like $StorageServiceId ) -or ( $StorageServiceId -eq '' ) )
                    {   $Data = invoke-restmethod -uri $SSUri
                        $SSsCol+=invoke-restmethod -uri $SSUri 
                        # SG(s) = StorageGroup(s)
                        $SGRoot = (($Data).StorageGroups).'@odata.id'
                        $SGsUri=$base+$SGRoot
                        write-host "SGSURI = $SGsUri"
                        $SGsData = invoke-restmethod -uri $SGsUri
                        $SGs = $($SGsData).Members
                        foreach($SG in $SGs)
                        {   $SGRawUri=$(($SG).'@odata.id')
                            $SGUri=$base+$SGRawUri
                            if ( ( (invoke-restmethod -uri $SGUri).id -like $StorageGroupId) -or ( $StorageGroupId -eq '' ) )             
                                {   $SGsCol+=invoke-RestMethod -uri $SGUri 
                                    # Write-Error "The StoragePool is not implemented in the Simulator yet, so cant test yet"
                                }
                        }    
                    } 
            }
        return $SGsCol
    }
}