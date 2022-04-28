function Get-SwordfishTask
{
<#
.SYNOPSIS
    Retrieve The list of Tasks or the Task Service collection from the Swordfish Target.
.DESCRIPTION
    Retrieve The list of Tasks or the Task Service collection from the Swordfish Target. 
.PARAMETER TaskId
    The TaskId will limit the returned data to ONLY the single Task specified if it exists. Without 
    this argument, the command will attempt to retrieve all tasks.
.PARAMETER ReturnCollectioOnly
    This switch will return the Task Service collection instead of an array of the 
    tasks.
.EXAMPLE
    Get-SwordfishTask -ReturnCollectionOnly

    @odata.context                  : /redfish/v1/$metadata#TaskService.TaskService
    @odata.id                       : /redfish/v1/TaskService
    @odata.type                     : #TaskService.v1_0_0.TaskService
    Id                              : TaskService
    Name                            : Task Service
    CompletedTaskOverWritePolicy    : Manual
    LifeCycleEventOnTaskStateChange : False
    Status                          : @{State=Disabled; Health=OK}
    ServiceEnabled                  : False
.EXAMPLE
    Get-SwordfishTask
    
    WARNING: No Individual Tasks were detected

.EXAMPLE
    Get-SwordfishTask -Task 1

    WARNING: The Specified Task was not detected
.LINK
    https://redfish.dmtf.org/schemas/v1/TaskCollection.json
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByTaskID')]          [string]    $TaskID,
      
        [Parameter(ParameterSetName='ReturnCollection')]          
                                                        [Switch]    $ReturnCollectionOnly,

        [Parameter(ParameterSetName='Default')]         [switch]        $DisallowRecursion
    )
process{
    switch ($PSCmdlet.ParameterSetName )
    {   'Default'   {   
                        if (-not $DisallowRecursion) 
                            {   foreach ( $MyTaskID in ( Get-SwordfishTask -DisallowRecursion ).id )
                                    {   [array]$DefTaskCol += Get-SwordfishTask -TaskID $MyTaskID 
                                    }
                                if ( $ReturnCollectionData )
                                    {   [array]$DefTaskCol += Get-SwordfishTask  -ReturnCollectionOnly:$ReturnCollectionOnly

                                    }
                                if ( -not $DefMyTaskCol )
                                { write-warning "No Individual Tasks were detected"}
                                return $DefMyTaskCol
                            } 
                    }
        'ReturnCollection'  {   return (invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Tasks" ) )
                            } 
        'ByTaskID'  {   $PulledData = invoke-restmethod2 -uri (Get-SwordfishURIFolderByFolder "Tasks")
                        foreach ( $SingleTaskLink in $PulledData.Task )
                            {   [Array]$FullTaskSet += Invoke-RestMethod2 -uri ( $base + ( $SingleTaskLink.'@odata.id' ) )
                            }
                        [array]$ReturnSet = ( $FullTaskSet | where-object { $_.id -eq $TaskID } ) 
                        if ( -not $ReturnSet )
                            {   write-warning "The Specified Task was not detected"                
                            } else
                            {   return $ReturnSet 
                            }
                    }
    }
}}
Set-Alias -Name 'Get-RedfishTask' -Value 'Get-SwordfishTask'