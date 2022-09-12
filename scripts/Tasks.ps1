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
param(  [Parameter(ParameterSetName='ByTaskID')]        [string]    $TaskID,
        [Parameter(ParameterSetName='ReturnCollection')][Switch]    $ReturnCollectionOnly
     )
process{    $DefTaskCol=@()
            if ( $(Get-SwordfishTaskService).Tasks )
                    {   $MyTasks = ($(Get-SwordfishTaskService).Tasks).'@odata.id'
                        $ReturnColl = $( Get-RedfishByURL $MyTasks )
                        foreach ( $OneTask in ($ReturnColl).Members )
                            {   $DefTaskCol += $( Get-RedfishByURL $OneTask )
                            }
                    }
            if ( $ReturnCollectionOnly )
                    {   return $ReturnColl
                    }
                else 
                    {   if ( $TaskID )
                                {   return ( $DefTaskColl | where {$_.id -eq $TaskID })
                                }
                            else 
                                {  return   $DefTaskColl    
                                }
                    }
        }
}
Set-Alias -Name 'Get-RedfishTask' -Value 'Get-SwordfishTask'

function Get-SwordfishTaskService
{
<#
.SYNOPSIS
    Retrieve The Task Service from the Redfish or Swordfish Target.
.DESCRIPTION
    Retrieve The Task Service from the Swordfish Target. 
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
param(  
    )
process{
    return (invoke-restmethod2 -uri ( Get-SwordfishURIFolderByFolder "Tasks" ) )
        }
    
}
Set-Alias -Name 'Get-RedfishTaskService' -Value 'Get-SwordfishTaskService'