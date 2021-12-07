Param (
    [parameter(Mandatory)]
    [int]$day
)

$path = Join-Path $PSScriptRoot ".\2021\template"

Get-ChildItem $path | ForEach-Object {
    $newName = $_.Name -replace 'X',"$day"
    Copy-Item -Path $_ -Destination $path\..\$newName
}

"https://adventofcode.com/2021/day/$day"