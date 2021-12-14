Param (
    [parameter(Mandatory)]
    [int]$day,

    [int]$year = $((Get-Date).Year)
)

$path = Join-Path $PSScriptRoot ".\$year\template"

Get-ChildItem $path | ForEach-Object {
    $newName = $_.Name -replace 'X',"$day"
    Copy-Item -Path $_ -Destination $path\..\$newName
}

"https://adventofcode.com/$year/day/$day"