# This script will connect to the various options of Redfish Servers so that additional commands can be used to generate examples and tests.
function Connect-RedfishLabServer
{   
    param(  [Parameter(Mandatory=$True)]
            [ValidateSet('HPE','Dell','Lenovo','Cisco','Intel')]    [string]    $Vendor,
                                                                    [Switch]    $WriteExampleFile      
         )
    process
    {   switch($Vendor)
            {   'HPE'   {   $Global:Model    = 'HPE ProLiant DL360 Gen10'
                            $Global:Uname = 'administrator'    
                            $Global:Pword = 'compaq'
                            $DeviceIP = '10.2.119.30'
                        }
                'Dell'  {   $Global:Model    = 'Dell PowerEdge R610'
                            $Global:Uname = 'root'     
                            $Global:Pword = 'calvin'
                            $DeviceIP = '10.2.119.32'
                        }
                'Lenovo'{   $Global:Model    = 'Lenovo XCC'
                            $Global:Uname = 'USERID'     
                            $Global:Pword = 'PASSW0RD'
                            $DeviceIP = '10.2.119.34'
                        }
                'Cisco' {   $Global:Model    = 'Cisco UCS'
                            $Global:Uname = 'admin'     
                            $Global:Pword = 'Cisco_12345'
                            $DeviceIP = '10.2.119.36'
                        }
                'Intel' {   $Global:Model    = 'Intel Reference'
                            $Global:Uname = 'admin'     
                            $Global:Pword = 'Intel_BMC1'
                            $DeviceIP = '10.2.119.38'
                        }
            }
        $Global:Vendor = ($Model.split() )[0]
        $Global:MyPath    = (Get-Module SNIASwordfish).path 
        try     {   $Result = Connect-RedfishTarget -Target $DeviceIP -erroraction stop
                    $MyString  = '.EXAMPLE ' + "`n"
                    $MyString += 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString += 'PS:> Connect-RedfishTaget -Target ' + "'" + $DeviceIp + "'" + " | ConvertTo-JSON `n"
                    $MyString2 = $MyString + ( $Result | convertto-json | out-string )
                    $MyString += ( $Result | Out-String )
                    $MyFile    = 'Examples\Connect-RedfishTarget.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Connect-RedfishTarget.Example.' + $Vendor + '.json'                    
                    $OutName   = $MyPath.Replace('SNIASwordfish.psm1',$MyFile)
                    $OutName2  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile2)
                    write-verbose "The file to be written would be $OutName"
                    write-verbose "The Content to send to the file would be $MyString"
                    if ( $WriteExampleFile )
                        {   Write-output "The File will be written."
                            $MyString  | out-file -filepath $OutName
                            $MyString2 | out-file -filepath $OutName2
                        }
                }
        catch   {   Write-warning 'The Given IP Address was not detected as a Redfish or Swordfish Target. No file written.'
                }
        
  ##########################################
        try     {   $Result = Get-RedfishSessionToken -username $UName -password $Pword -erroraction stop
                    $MyString  = '.EXAMPLE ' + "`n"
                    $MyString += ('This example shows connecting to a ' + $Model + ' server.' + "`n")            
                    $MyString += 'PS:> Get-RedfishSessionToken -Username ' + "'"  + $Uname + "' -Password '" + $Pword + "'" + "`n"
                    $MyString2 = $MyString + ( $Result | Out-String )
                    $MyString += ( $Result | Out-String )
                    $MyFile    = 'Examples\Get-RedfishSessionToken.Example.' + $Vendor + '.txt'
                    $MyFile2    = 'Examples\Get-RedfishSessionToken.Example.' + $Vendor + '.json'
                    $OutName   = $MyPath.Replace('SNIASwordfish.psm1',$MyFile)
                    $OutName2   = $MyPath.Replace('SNIASwordfish.psm1',$MyFile)
                    write-verbose "The file to be written would be  `n $OutName"
                    write-verbose "The Content to send to the file would be $MyString"
                    if ( $WriteExampleFile )
                        {   Write-output "The File will be written." 
                            $MyString  | out-file -filepath $OutName
                            $MyString2 | out-file -filepath $OutName2
                    }
                }
        catch   {   write-warning "The Token was not accepted. No file written."
                }
        return
    }
}