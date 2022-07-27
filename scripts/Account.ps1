function Get-SwordfishAccount
{
<#
.SYNOPSIS
    Retrieve The list of valid Account Information from the Redfish Account Services.
.DESCRIPTION
    This command will either return the a complete collection of Account objects that exist or the collection. 
.PARAMETER AccountId
    The AccountID name for a specific Storage System to query, otherwise the command will return all managers 
    defined in the /redfish/v1/AccountServices/x/{Accountid}/.
.PARAMETER ReturnCollectioOnly
    This switch will return the collection instead of an array of the actual objects if set.
.EXAMPLE    
    The following is a Generic example. For very specific examples see the Examples folder in this module
    PS> Get-RedfishAccount

    @odata.context         : /redfish/v1/$metadata#ManagerAccount.ManagerAccount
    @odata.etag            : W/"226E6C7B"
    @odata.id              : /redfish/v1/AccountService/Accounts/1
    @odata.type            : #ManagerAccount.v1_3_0.ManagerAccount
    Id                     : 1
    Description            : iLO User Account
    Links                  : @{Role=}
    Name                   : User Account
    Password               :
    PasswordChangeRequired : False
    RoleId                 : Administrator
    UserName               : Administrator

    @odata.context         : /redfish/v1/$metadata#ManagerAccount.ManagerAccount
    @odata.etag            : W/"FDF5720D"
    @odata.id              : /redfish/v1/AccountService/Accounts/2
    @odata.type            : #ManagerAccount.v1_3_0.ManagerAccount
    Id                     : 2
    Description            : iLO User Account
    Links                  : @{Role=}
    Name                   : User Account
    Password               :
    PasswordChangeRequired : False
    RoleId                 : Administrator
    UserName               : admin
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='Default')]                 [string]    $AccountID,      
        [Parameter(ParameterSetName='ReturnCollectionOnly')]    [Switch]    $ReturnCollectionOnly
     )
process{
    switch ($PSCmdlet.ParameterSetName )
        {   'ReturnCollectionOnly'  {   [array]$DefMgrCol = ( Get-RedfishByURL -URL "/redfish/v1/AccountService/Accounts" ) 
                                        return $DefMgrCol
                                    }
            'Default'               {   foreach ( $MgrLink in ( Get-RedfishByURL -URL '/redfish/v1/AccountService/Accounts' ).members )
                                            {   # $MgrLink | convertto-json | out-string
                                                $Mgr = (Get-RedfishByURL -URL ($MgrLink).'@odata.id')
                                                [array]$DefMgrCol += $Mgr 
                                            }
                                        if ( $AccountID )
                                            {   return ( $DefMgrCol | Where-Object { $_.id -eq "$AccountID" } )
                                            } else
                                            {   return ( $DefMgrCol )
                                            }
                                    }
        }
}
}
Set-Alias -Name 'Get-RedfishAccount' -value 'Get-SwordfishAccount'

function Get-SwordfishAccountService
{
<#
.SYNOPSIS
    Retrieve The Account Service Information from the Redfish Target.
.DESCRIPTION
    Retrieve The Account Service Information from the Redfish Target.
.EXAMPLE
    The following is a Generic example. For very specific examples see the Examples folder in this module
    PS > Get-RedfishAccountService

    @odata.context    : /redfish/v1/$metadata#AccountService.AccountService
    @odata.id         : /redfish/v1/AccountService
    @odata.type       : #AccountService.v1_5_0.AccountService
    Id                : AccountService
    Accounts          : @{@odata.id=/redfish/v1/AccountService/Accounts}
    ActiveDirectory   : @{AccountProviderType=ActiveDirectoryService; Authentication=; RemoteRoleMapping=System.Object[];
                        ServiceAddresses=System.Object[]; ServiceEnabled=False}
    Description       : iLO User Accounts
    LDAP              : @{AccountProviderType=ActiveDirectoryService; Authentication=; Certificates=; LDAPService=;
                        RemoteRoleMapping=System.Object[]; ServiceAddresses=System.Object[]; ServiceEnabled=False}
    LocalAccountAuth  : Enabled
    MinPasswordLength : 8
    Name              : Account Service
    Oem               : @{Vendor=}
    Roles             : @{@odata.id=/redfish/v1/AccountService/Roles}
.LINK
    https://www.dmtf.org/sites/default/files/standards/documents/DSP2046_2022.1.pdf
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param( )
process{    return ( Get-RedfishByURL -URL "/redfish/v1/AccountService" ) 
       }
}
Set-Alias -Name 'Get-RedfishAccountService' -value 'Get-SwordfishAccountService'

