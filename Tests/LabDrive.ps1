# This script will connect to the various options of Redfish Servers so that additional commands can be used to generate examples and tests.
function Get-RedfishLabDrive
{   
    param(  [Switch]    $WriteExampleFile, 
            [Switch]    $ReturnCollectionOnly

         )
    process
    {   # Command assumes $Model, $Vendor, and $MyPath already exist
        try     {   if ( $ReturnCollectionOnly ) 
                        {   $Result = Get-RedfishDrive -returncollectiononly -erroraction stop
                            $RCO = '-ReturnCollectionOnly'
                        }
                        else 
                        {   $Result = Get-RedfishDrive -erroraction Stop 
                            $RCO = ''
                        }
                    $MyString  = '.EXAMPLE ' + "`n" + 'This example shows connecting to a ' + $Model + ' server.' + "`n"            
                    $MyString1 = $MyString + 'PS:> Get-RedfishDrive ' + $RCO + "`n"
                    $MyString2 = $MyString + 'PS:> Get-RedfishDrive ' + $RCO + ' | ConvertTo-JSON' + "`n"
                    $MyString1 = $MyString1 + ( $Result | Out-String )
                    $MyString2 = $MyString2 + ( $Result | ConvertTo-JSON | Out-String )
                    $MyFile1   = 'Examples\Get-RedfishDrive ' + $RCO + '.Example.' + $Vendor + '.txt'
                    $MyFile2   = 'Examples\Get-RedfishDrive ' + $RCO + '.Example.' + $Vendor + '.json'
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
