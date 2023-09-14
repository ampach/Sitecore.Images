Get-ChildItem -Path "C:\temp\src\*\*\items" -Directory| ForEach-Object {
    $dest = "C:\serialization\src\$($_.FullName.SubString((Get-Item -Path 'C:\temp\src').FullName.Length+1))"
    $folderPath = $dest.SubString(0,$dest.Length-6)
    if(!(Test-Path -Path $folderPath -PathType Container)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }
    Copy-Item $_.FullName -Destination $folderPath -Force -Recurse
}