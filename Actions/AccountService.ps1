function Set-RedfishAccountService {
<#
.SYNOPSIS
    The command will allow you to set the read/write values in the specified Chassis
.DESCRIPTION
    The command will allow you to set the read/write values in the specified Chassis
.PARAMETER AccountLockoutCounterResetAfter 
    The period of time, in seconds, between the last failed login attempt and the reset 
    of the lockout threshold counter. This value must be less than or equal to the 
    AccountLockoutDuration value. A reset sets the counter to 0 
.PARAMETER AccountLockoutCounterReset
    An indication of whether the threshold counter is reset after AccountLockoutCounterResetAfter expires. 
    If true , it is reset. If false , only a successful login resets the threshold counter and if the user 
    reaches the AccountLockoutThreshold limit, the account will be locked out indefinitely and only an 
    administrator-issued reset clears the threshold counter. If this property is absent, the default is true 
.PARAMETER AccountLockoutDuration
    The period of time, in seconds, that an account is locked after the number of failed login attempts 
    reaches the account lockout threshold, within the period between the last failed login attempt and 
    the reset of the lockout threshold counter. If this value is 0 , no lockout will occur. If the 
    AccountLockoutCounterResetEnabled value is false , this property is ignored.
.PARAMETER AccountLockoutThreshold 
    The number of allowed failed login attempts before a user account is locked for a specified duration. 
    If 0 , the account is never locked
.PARAMETER AuthFailureLoggingThreshold 
    The number of authorization failures per account that are allowed before the failed attempt is logged 
    to the manager log.
.PARAMETER LocalAccountAuth
    An indication of how the service uses the accounts collection within this account service as part of 
    authentication. The enumerated values describe the details for each mode. For the possible property values,
    see LocalAccountAuth in Property details.
.PARAMETER MaxPasswordLength
    The maximum password length for this account service.
.PARAMETER MinPasswordLength 
    The minimum password length for this account service
.PARAMETER PasswordExpirationDays 
    The number of days before account passwords in this account service will expire.
.PARAMETER ServiceEnabled
    An indication of whether the account service is enabled. If true , it is enabled. If false , it is disabled and 
    users cannot be created, deleted, or modified, and new sessions cannot be started. However, established sessions 
    might still continue to run. Any service, such as the session service, that attempts to access the disabled account 
    service fails. However, this does not affect HTTP Basic Authentication connections.
.LINK 
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding()]
param(                                          [int]       $AccountLockoutCounterResetAfter,
                                                [boolean]   $AccountLockoutCounterReset,
                                                [boolean]   $AccountLockoutCounterResetEnabled,
                                                [int]       $AccountLockoutDuration,
                                                [int]       $AccountLockoutThreshold,
                                                [int]       $AuthFailureLoggingThreshold, 
        [ValidateSet('Enabled','Disabled','Fallback','LocalFirst')]
                                                [string]    $LocalAccountAuth,
                                                [int]       $MaxPasswordLength,
                                                [int]       $MinPasswordLength,
                                                [int]       $PasswordExpirationDays,
                                                [Boolean]   $ServiceEnabled  
         )
process {   $CData = Get-RedfishChassis -ChassisID $ChassisId
            $CBody = @()
            if ( $PSBoundParameters.ContainsKey('AccountLockoutCounterResetAfter'))   { $CBody += @{ AccountLockoutCounterResetAfter   = $AccountLockoutCounterResetAfter   } }
            if ( $PSBoundParameters.ContainsKey('AccountLockoutCounterReset'))        { $CBody += @{ AccountLockoutCounterReset        = $AccountLockoutCounterReset        } }
            if ( $PSBoundParameters.ContainsKey('AccountLockoutCounterResetEnabled')) { $CBody += @{ AccountLockoutCounterResetEnabled = $AccountLockoutCounterResetEnabled } }
            if ( $PSBoundParameters.ContainsKey('AccountLockoutDuration'))            { $CBody += @{ AccountLockoutDuration            = $AccountLockoutDuration            } }
            if ( $PSBoundParameters.ContainsKey('AccountLockoutThreshold'))           { $CBody += @{ AccountLockoutThreshold           = $AccountLockoutThreshold           } }
            if ( $PSBoundParameters.ContainsKey('AuthFailureLoggingThreshold'))       { $CBody += @{ AuthFailureLoggingThreshold       = $AuthFailureLoggingThreshold       } }
            if ( $PSBoundParameters.ContainsKey('LocalAccountAuth'))                  { $CBody += @{ LocalAccountAuth                  = $LocalAccountAuth                  } }
            if ( $PSBoundParameters.ContainsKey('MaxPasswordLength'))                 { $CBody += @{ MaxPasswordLength                 = $MaxPasswordLength                 } }
            if ( $PSBoundParameters.ContainsKey('MinPasswordLength'))                 { $CBody += @{ MinPasswordLength                 = $MinPasswordLength                 } }
            if ( $PSBoundParameters.ContainsKey('PasswordExpirationDays'))            { $CBody += @{ PasswordExpirationDays            = $PasswordExpirationDays            } }
            if ( $PSBoundParameters.ContainsKey('ServiceEnabled'))                    { $CBody += @{ ServiceEnabled                    = $ServiceEnabled                    } }
            $Result = invoke-restmethod2 -uri ( $base + $CData.'@odata.id' ) -body $MyBody -Method 'POST'
            return $Result
        }        
}