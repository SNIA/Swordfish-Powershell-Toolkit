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
         Get-SwordFishStorageGroup -StorageGroupId 1
    .LINK
        http://redfish.dmtf.org/schemas/swordfish/v1/StorageGroup.v1_2_0.json
    #>   
    [CmdletBinding()]
    param(
        [string] $StorageServiceID='',

        [string] $StorageGroupId=''
    )
    process{
        $SGsCol=@() 
        foreach($link in Get-SwordfishStorageService -StorageServiceID $StorageServiceID)
            {   $SGsUri = $base + (($link).StorageGroups).'@odata.id'
                write-host "SGSURI = $SGsUri"
                $SGsData = invoke-restmethod2 -uri $SGsUri
                $SGs = $($SGsData).Members
                foreach($SG in $SGs)
                {   $SGRawUri=$(($SG).'@odata.id')
                    $SGUri=$base+$SGRawUri
                    $SGData=invoke-RestMethod2 -uri $SGUri 
                    if ( ( ($SGData).id -like $StorageGroupId ) -or ( $StorageGroupId -eq '' ) )
                        {   $SGsCol+=$SGData
                        }
                }    
            } 
        return $SGsCol
    }
}