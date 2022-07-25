# This script will connect to the various options of Redfish Servers so that additional commands can be used to generate examples and tests.
function Get-RedfishLabManager
{   
    param(  [Switch]    $WriteExampleFile, 
            [Switch]    $ReturnCollectionOnly

         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   if ( $ReturnCollectionOnly ) 
                        {   $Result = Get-RedfishManager -returncollectiononly -erroraction stop
                            $RCO = '-ReturnCollectionOnly'
                        }
                        else 
                        {   $Result = Get-RedfishManager -erroraction Stop 
                            $RCO = ''
                        }
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishManager ' + $RCO + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishManager ' + $RCO + ' | ConvertTo-JSON' + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Manager\Get-RedfishManager ' + $RCO + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Manager\Get-RedfishManager ' + $RCO + '.Example.' + $Vendor + '.json'
                    $OutName1  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile1)
                    $OutName2  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile2)
                    write-verbose "The file to be written would be $OutName1 and $OutName2"
                    write-verbose "The Content to send to the file would be `n $MyString1 $MyString2"
                    if ( $WriteExampleFile -and $result )
                            {   Write-output "The File will be written."
                                $MyString1 | out-file -filepath $OutName1
                                $MyString2 | out-file -filepath $OutName2
                            } 
                        else 
                            {   if ( $result) 
                                {   write-host $MyString1
                                    write-host $MyString2
                                }
                            }
                }
        catch   {   Write-warning 'The Command returned an error. No file written.'
                }
        
        return
    }
}

function Get-RedfishLabManagerComponent
{   
    param(  [Parameter(mandatory=$true)]
            [ValidateSet ('CommandShell', 'EthernetInterfaces', 'GraphicalConsole', 'HostInterfaces', 'LogServices', 
                            'NetworkProtocol', 'SerialConsole', 'Status', 'VirtualMedia')]  
                                                                            [string]    $SubComponent, 
                                                                            [Switch]    $WriteExampleFile,  
                                                                            [switch]    $ReturnCollectionOnly    
         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   if ( $ReturnCollectionOnly ) 
                            {   $Result = Get-RedfishManagerComponent -ReturnCollectionOnly -SubComponent $SubComponent -erroraction stop
                                $RCO = '-ReturnCollectionOnly'
                            }
                        else 
                            {   $Result = Get-RedfishManagerComponent -SubComponent $SubComponent -erroraction Stop 
                                $RCO = ''
                            }
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishManagerComponent -SubComponent ' + $SubComponent + ' ' + $RCO + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishManagerComponent -SubCompoenet ' + $SubComponent + ' ' + $RCO + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Manager\Get-RedfishManagerComponent.' + $SubComponent + $RCO + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Manager\Get-RedfishManagerComponent.' + $SubComponent + $RCO + '.Example.' + $Vendor + '.json'
                    $OutName1  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile1)
                    $OutName2  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile2)
                    write-verbose "The file to be written would be $OutName1 and $OutName2"
                    write-verbose "The Content to send to the file would be `n $MyString1 $MyString2"
                    if ( $WriteExampleFile -and $Result )
                            {   Write-output "The File will be written."
                                $MyString1 | out-file -filepath $OutName1
                                $MyString2 | out-file -filepath $OutName2
                            } 
                        else 
                            {   if ( $result) 
                                {   write-host $MyString1
                                    write-host $MyString2
                                }                            
                            }
                }
        catch   {   Write-warning 'The Command returned an error. No file written.'
                }
        
        return
    }
}