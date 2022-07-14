
function Set-RedfishTaskService
{
<#
.SYNOPSIS
    Modifies the values for the Task Service for the system that this redfish implementation represents.
.DESCRIPTION
    Invoke a System Reset for the system that this redfish implementation represents.
.PARAMETER ServiceEnabled
    An indication of whether this service is enabled
.PARAMETER TaskAutoDeleteTimeoutMinutes
    The number of minutes after which a completed task is deleted by the service.
.NOTES
#>   
[CmdletBinding()]
param(  [boolean]   $ServiceEnabled,

        [int]       $TaskAutoDeleteTimeoutMinutes
)
process
 {  $SystemData = Get-RedfishTaskService
    if ( $PSBoundParameters.ContainsKey('ServiceEnabled'))
        {    if ( ($SystemData).ServiceEnabled )
                    {   $MyBody = @{  ServiceEnabled = $ServiceEnabled  
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No ServiceEnabled section found for this Task Service"
                        return
                    }
            return $Result
        }
    if ( $PSBoundParameters.ContainsKey('TaskAutoDeleteTimeoutMinutes'))
        {   if ( ($SystemData).TaskAutoDeleteTimeoutMinutes )
                    {   $MyBody = @{  TaskAutoDeleteTimeoutMinutes = $TaskAutoDeleteTimeoutMinutes 
                                   }
                        invoke-restmethod2 -uri ( $base + $SystemData.'@odata.id') -body $MyBody -Method 'PUT'
                    }  
                else 
                    {   write-error "No TaskAutoDeleteTimeoutMinutes Local Offset section found for this Task Service"
                        return
                    }
            return $Result
        }

 }
}

