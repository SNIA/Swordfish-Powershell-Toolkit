# This script will connect to the various options of Redfish Servers so that additional commands can be used to generate examples and tests.
function Get-RedfishLabSystem
{   
    param(  [Switch]    $WriteExampleFile ,
            [switch]    $ReturnCollectionOnly     
         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   if ( $ReturnCollectionOnly ) 
                            {   $Result = Get-RedfishSystem -ReturnCollectionOnly -erroraction stop
                                $RCO = '-ReturnCollectionOnly'
                            }
                        else 
                            {   $Result = Get-RedfishSystem -erroraction Stop 
                                $RCO = ''
                            }
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishSystem ' + $RCO + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishSystem ' + $RCO + ' | ConvertTo-JSON' + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Get-RedfishSystem ' + $RCO + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Get-RedfishSystem ' + $RCO + '.Example.' + $Vendor + '.json'
                    $OutName1  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile1)
                    $OutName2  = $MyPath.Replace('SNIASwordfish.psm1',$MyFile2)
                    write-verbose "The file to be written would be $OutName1 and $OutName2"
                    write-verbose "The Content to send to the file would be `n $MyString1 $MyString2"
                    if ( $WriteExampleFile )
                            {   Write-output "The File will be written."
                                $MyString1 | out-file -filepath $OutName1
                                $MyString2 | out-file -filepath $OutName2
                            } 
                        else 
                            {   write-host $MyString1
                                write-host $MyString2
                            }
                }
        catch   {   Write-warning 'The Command returned an error. No file written.'
                }
        
        return
    }
}
function Get-RedfishLabSystemComponent
{   
    param(  [Parameter(mandatory=$true)]
            [ValidateSet ('Bios', 'Boot', 'EthernetInterfaces', 'LogServices', 'Memory', 
                          'MemoryDomains', 'NetworkInterfaces', 'Processors', 'SecureBoot', 
                          'Storage', 'TrustedModules')]  
                                                                            [string]    $SubComponent, 
                                                                            [Switch]    $WriteExampleFile,  
                                                                            [switch]    $ReturnCollectionOnly    
         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   if ( $ReturnCollectionOnly ) 
                            {   $Result = Get-RedfishSystemComponent -ReturnCollectionOnly -SubComponent $SubComponent -erroraction stop
                                $RCO = '-ReturnCollectionOnly'
                            }
                        else 
                            {   $Result = Get-RedfishSystemComponent -SubComponent $SubComponent -erroraction Stop 
                                $RCO = ''
                            }
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishChassisPower -SubComponent ' + $SubComponent + ' ' + $RCO + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishChassisPower -SubCompoenet ' + $SubComponent + ' ' + $RCO + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Get-RedfishSystemSubComponent.' + $SubComponent + $RCO + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Get-RedfishSystemSubComponent.' + $SubComponent + $RCO + '.Example.' + $Vendor + '.json'
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
                            {   Write-host $MyString1
                                Write-host $MyString2                             
                            }
                }
        catch   {   Write-warning 'The Command returned an error. No file written.'
                }
        
        return
    }
}
function Get-RedfishLabChassisThermal
{   
    param(  [Validateset("Fans","Redundancy","Temperatures","All")]  [string]    $MetricName="All", 
                                                                            [Switch]    $WriteExampleFile      
         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   $Result = Get-RedfishChassisThermal -metricname $MetricName -erroraction stop
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishChassisThermal -MetricName ' + $MetricName + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishChassisThermal -MetricName ' + $MetricName + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Get-RedfishChassisThermal-MetricName.' + $MetricName + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Get-RedfishChassisThermal-MetricName.' + $MetricName + '.Example.' + $Vendor + '.json'
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
                            {   Write-host $MyString1
                                Write-host $MyString2                             
                            }
                }
        catch   {   Write-warning 'The Command returned an error. No file written.'
                }
        
        return
    }
}
