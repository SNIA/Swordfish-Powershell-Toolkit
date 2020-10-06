function Connect-SwordFishTarget {
<#
.SYNOPSIS
    Connects to a SNIA SwordFish API enabled device.
.DESCRIPTION
    Connect-SwordFishTarget is an advanced function that provides the initial connection to a SwordFish
    so that other subsequent commands can be run without having to authenticate individually.
.PARAMETER Target
    The DNS name or IP address of the SwordFish Target Device.
.PARAMETER Port
    The DNS name or IP address of the SwordFish Target Device.
.PARAMETER Protocol
    Can be used to force the toolkit to use either HTTP or HTTPS. Either the Port can be specified, or the HTTPs protocol since the HTTPS protocol will use port 443.
.EXAMPLE
    PS:> Connect-SwordFish -Target 192.168.1.50 -port 5000
        
    @odata.Copyright : Copyright 2020 HPE and DMTF
    @odata.type      : #ServiceRoot.v1_3_0.ServiceRoot
    @odata.id        : /redfish/v1
    RedfishVersion   : 1.0.2
    Id               : RootService
    Name             : Root Service
    Chassis          : @{@odata.id=/redfish/v1/Chassis}
    Storage          : @{@odata.id=/redfish/v1/Storage}
    AccountService   : @{@odata.id=/redfish/v1/AccountService}
    EventService     : @{@odata.id=/redfish/v1/EventService}
    LineOfService    : @{@odata.id=/redfish/v1/LineOfService}
    Fabrics          : @{@odata.id=/redfish/v1/Fabrics}
.EXAMPLE
    Connect-SwordFish -Target 192.168.1.50 -port 5000 | ConvertTo-Json
    
    {
        "@odata.Copyright":  "Copyright 2020 HPE and DMTF",
        "@odata.type":  "#ServiceRoot.v1_3_0.ServiceRoot",
        "@odata.id":  "/redfish/v1",
        "RedfishVersion":  "1.0.2",
        "Id":  "RootService",
        "Name":  "Root Service",
        "Chassis":  {
                        "@odata.id":  "/redfish/v1/Chassis"
                    },
        "Storage":  {
                        "@odata.id":  "/redfish/v1/Storage"
                    },
        "AccountService":  {
                               "@odata.id":  "/redfish/v1/AccountService"
                           },
        "EventService":  {
                             "@odata.id":  "/redfish/v1/EventService"
                         },
        "LineOfService":  {
                              "@odata.id":  "/redfish/v1/LineOfService"
                          },
        "Fabrics":  {
                        "@odata.id":  "/redfish/v1/Fabrics"
                    }
    }
.NOTES
    By default if the port is not given, it assumes port 5000, and if no hostname is given it assumes localhost.
#>
        [cmdletbinding()]
        param   (
            [Parameter(position=0)]
            [string]$Target="192.168.1.201",
            
            [Parameter(position=1)]
            [string]$Port="5000",
            
            [Parameter(position=1)]
            [string]$Protocol="http"
            
        )
        Process{
            if ( $Protocol -eq 'http')
                {   $Global:Base = "http://$($Target):$($Port)"
                } else 
                {   $Global:Base = "https://$($Target)"                
                }
            $Global:RedFishRoot = "/redfish/v1/"
            $Global:BaseUri = $Base+$RedfishRoot
            $Global:MOCK = $false
            Write-Verbose "Base URI = $BaseUri"
            Try     {   $ReturnData = invoke-restmethod -uri "$BaseUri" 
                    }
            Catch   {   $_
                    }
            if ( $ReturnData )
            {   return $ReturnData
            }
            else 
            {   Write-Error "No RedFish/SwordFish target Detected or wrong port used at that address"
            }
        }
    }
 
function Connect-SwordFishMockup {
<#
.SYNOPSIS
    Connects to the SNIA Swordfish Mockup as if were a SwordFish Target.
.DESCRIPTION
    Connect-SwordMockup is an advanced function that provides the initial connection to a SwordFish
    so that other subsequent commands can be run without having to authenticate individually.
.EXAMPLE
     Connect-SwordFishMockup
.NOTES
    The site http://swordfishmockups.com/redfish/v1/ site is hard coded into this command.
#>
    [CmdletBinding()]
    param   (   
            )
    Process {
        $Global:Base = "http://swordfishmockups.com"
        $Global:RedFishRoot = "/redfish/v1/"
        $Global:BaseUri = $Base+$RedfishRoot
        if ( Invoke-SwordFishDependancySeleniumCheck -and Invoke-SwordFishDependancyChromeCheck )
        {   Try
            {               write-verbose "Creating Option Object"
                $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
                            start-sleep -Seconds 1
                            write-verbose "Adding Headless to Option Object"
                $ChromeOptions.addArguments('headless')
                            start-sleep -Seconds 1
                            write-verbose "Creating Chrome Object"
                $ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions) 
                            start-sleep -Seconds 1
                            write-verbose "Navigate to $BaseUri"           
                $ChromeDriver.Navigate().GoToURL($BaseUri)
                            start-sleep -Seconds 1
                            write-verbose "De-Json the data"
                $ReturnData = StripHTMLCode -RawCode ($ChromeDriver.Pagesource) 
                            start-sleep -Seconds 1
                            write-verbose "Close Chrome Driver"
                $ChromeDriver.Close()
                            start-sleep -Seconds 1
                            write-verbose "Quit Chrome Driver"
                $ChromeDriver.quit()
                            start-sleep -Seconds 1
                $Global:MOCK = $true
                            Write-verbose "Base URI = $BaseUri"
                        }
                Catch   {   $_
                        }
                if ( $ReturnData )
                {   $ReturnObj= $ReturnData | ConvertFrom-JSON
                    $ReturnObj.pstypenames.clear()
                    $ReturnObj.pstypenames.insert(0,'Swordfish.StorageServices')
                    return $ReturnObj
                }
                else 
                {   Write-Error "No RedFish/SwordFish target Detected or wrong port used at that address"
                }

            }
            
        }
    }

function Invoke-SwordFishDependancySeleniumCheck{   
    if ( get-module -name Selenium )
        {   write-verbose "Check: Selenium is installed and imported"
            $returncode=$true
        }
        else 
        {   if ( (get-module -listavailable selenium) )
            {   import-module Selenium
                $returncode=$true
            } else 
            {   write-error "Selenium Must be installed for this command to work; Use the following command to install: Find-Module Selenium | Install-Module"
                $returncode=$false
            }    
        }
    return $returncode
}
function Invoke-SwordFishDependancyChromeCheck{   
    $x86 = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue( "DisplayName" ) -like "*Chrome*" } ).Length -gt 0;
    $x64 = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_.GetValue( "DisplayName" ) -like "*Chrome*" } ).Length -gt 0;
    if ( $x86 -or $x64 )
    {   write-verbose "Check: Chrome is installed"
        $returncode=$true
    }
    else 
    {   write-error "Chrome Must be installed for this command to work; Please install Chrome and re-run this command."
        $returncode=$false  
    }
    return $returncode
}

function StripHTMLCode{
   param   (   [Parameter(position=0)]
                [string]$RawCode
            )
    $StartCurly=$RawCode.IndexOf('{')
    $EndCurly=$RawCode.LastIndexOf('}')
    $EndLength=$EndCurly-$StartCurly+1
    $RawCode = $RawCode.Substring($StartCurly,$EndLength)
    return $RawCode       
}

function invoke-restmethod2{

    [cmdletbinding()]
    param   (   [string] $Uri
            )
    process {   try {   if ( -not $MOCK)
                        {   write-verbose "Getting Result in Invoke-RestMethod2 Function using URI $Uri"
                            if ( -not $XAuthToken ) 
                                {   $XAuthToken = ""
                                }
                            $XHead = @{ 'X-Auth-Token'   = $XAuthToken }
                            write-verbose "Headers Object is $XHead"
                            $ReturnObj = invoke-restmethod -Uri $Uri -headers $XHead
                        } else
                        {   $ReturnObj = invoke-Mockup -MockupURI $Uri
                        }
                        return $ReturnObj
                    }
                catch { write-verbose "Invoke of $Uri failed"
                    }
            }
}
function Invoke-Mockup
{   [cmdletbinding()]
    param   ( [string] $MockupURI
            )
    $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
    $ChromeOptions.addArguments('headless')
    $ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)

    start-sleep -Seconds 1
    $ChromeDriver.Navigate().GoToURL($MockupURI)
    write-verbose "Navigating to $MockupURI"
    start-sleep -Seconds 1
    $ReturnData = StripHTMLCode -RawCode ($ChromeDriver.Pagesource) 
    write-verbose "Returning $ReturnData RAW"
    start-sleep -Seconds 1
    $ChromeDriver.Close()

    start-sleep -Seconds 1
    $ChromeDriver.quit()

    start-sleep -Seconds 1
    try     {   $ReturnObj = $ReturnData | ConvertFrom-JSON
                $ODataTypeName = Get-SwordFishODataTypeName $ReturnObj
                write-verbose "Odata type name is $ODataTypeName"
                return $ReturnObj
            }
    catch   {   write-verbose "Invalid JSON: Returning nothing"
                return
            }
}

function Get-SwordFishODataTypeName 
{   [cmdletbinding()]
    param   ( $DataObject
            )
    if ( $ReturnType = $DataObject.'@odata.type')
    {   # clip the first hash mark from the type name
        $ReturnType = $ReturnType.Substring(1)
        # clip everything after the first period symbol
        $ReturnType = $ReturnType.Substring(0,$ReturnType.indexof('.'))
        write-verbose "The Type name is $ReturnType"
        return $ReturnType
    } else {
        write-verbose "No Type was found"
        return
    }
}

function Get-SwordfishURIFolderByFolder
{   [cmdletbinding()]
    param ( $Folder
          )
    write-verbose "Invoke-RestMethod from Get-SwordfishURIFolderByFolder function to find folder $Folder"      
    $GetRootLocation = invoke-restmethod2 -uri "$BaseUri" 
    
    if ( ((($GetRootLocation).links).$($Folder)).'@odata.id')
        {   $FolderUri = $Base + ((($GetRootLocation).links).$($Folder)).'@odata.id'
        } else 
        {   $FolderUri = $Base + (($GetRootLocation).$($Folder)).'@odata.id'
        } 
    return $FolderUri

}