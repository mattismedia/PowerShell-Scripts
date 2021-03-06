﻿# install msi software using Invoke-WMIMethod
# M. Balzan
function Install_Server_MSI {
<#
.Synopsis
   Install msi on a remote device
.DESCRIPTION
   Install msi on a remote device
.EXAMPLE
   Install msi on a remote device called SERVER1
   
   Install_Server -ComputerName SERVER1 -msi
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String[]]$ComputerName,
    [parameter(Mandatory=$true)]
    [ValidateSet(32,64)]
    [String[]]$msi
        ) 

$servers = Get-Content $listpath

ForEach ($server in $servers) {
    Write-Output "Processing $server..." | out-file c:\iso\SnowInstalls.log

    $OS = (Get-WmiObject Win32_OperatingSystem -computername $server).OSArchitecture | Out-File $listpath\Server_OS.txt

If ($OS -eq "32-bit"){
    Write-Output "OS Architecture is $OS" | out-file c:\iso\SnowInstalls.log -Append
    $file = "\\xggc\ggcdata\sccmsource\Package\app-d0385\GlasgowNHS_3704_x86.msi"
    $msi = "GlasgowNHS_3704_x86.msi"
    }
Else {
    Write-Output "OS Architecture is $OS" | out-file c:\iso\SnowInstalls.log -Append
    $file = "\\xggc\ggcdata\sccmsource\Package\app-d0385\GlasgowNHS_3704_x64.msi"
    $filename = "GlasgowNHS_3704_x64.msi"
    }
        
    Copy-Item $file -Destination \\$server\C$ -Force | out-file c:\iso\SnowInstalls.log -Append
    $installpath = "\\$server\c$\$filename"  
    Invoke-WMIMethod -path Win32_Product -Name Install -ComputerName $server -ArgumentList @($true,$null,$installpath) | Select ReturnValue | out-file c:\iso\SnowInstalls.log -Append
}

}