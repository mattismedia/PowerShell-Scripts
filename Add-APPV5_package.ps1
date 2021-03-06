﻿cls
$package = Add-AppvClientPackage -Path "C:\APPV50062_T-DOC_Client\APPV50062_T-DOC_Client.appv" | Publish-AppvClientPackage

$i=0;
Start-Job {Get-AppvClientPackage $args[0] | Mount-AppvClientPackage} -ArgumentList @($($package.Name))
while (($percentLoaded = $package.PercentLoaded) -lt 100) {
    Write-Output "PercentLoaded for $($package.Name) is $percentLoaded";
    $i++;
    sleep(1);
};


Write-Output "$($package.Name) loaded in $i seconds.";

$startTime = (Get-Date).AddMinutes(-1)
$EventLogs = Get-WinEvent -FilterHashTable @{LogName = “Microsoft-AppV-Client/Operational” ; ID=4004,1003; StartTime=$StartTime} -ErrorAction SilentlyContinue -MaxEvents 20
$EventLogs | Format-Table -Wrap -AutoSize

