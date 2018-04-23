$psPerfMEM = new-object System.Diagnostics.PerformanceCounter("Memory","Available Mbytes")
$psPerfMEM.NextValue() | Out-Null
$box=get-WMIobject Win32_ComputerSystem
$physMB=$box.TotalPhysicalMemory / 1024 /1024
$logpath = 'C:\randomfile\rameater\'

New-Item -f -Path $logpath  -ItemType directory

#RAM eater
#####################
$a = "a" * 512MB
$growArray = @()
$growArray += $a
# leave 512Mb for the OS to survive.
$HEADROOM=512
$bigArray = @()
$ram = $physMB - $psPerfMEM.NextValue()
$MAXRAM=$physMB - $HEADROOM
$k=0
while ($ram -lt $MAXRAM) {
  $bigArray += ,@($k,$growArray)
  $k += 1
  $growArray += $a
$ram = $physMB - $psPerfMEM.NextValue()
$myfilepath = (join-path $logpath $ram )

$ram | Out-File -FilePath $myfilepath

}

Remove-Item C:\randomfile\rameater\*

$bigArray.clear()
remove-variable bigArray
$growArray.clear()
remove-variable growArray
[System.GC]::Collect()