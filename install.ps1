$temp = "$env:TEMP\vxTweeks.exe"

Invoke-WebRequest `
-Uri "https://github.com/abduilhameed1206-tech/vxTweeks/releases/download/v1.0/vxTweeks.exe" `
-OutFile $temp

Start-Process $temp -Verb RunAs