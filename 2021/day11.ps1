function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path
    }
    Write-Output $data
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$border = @('X' * 10)
$data += $border

$array = $border + $data
$array = foreach ($row in $array) {
    'X' + $row + 'X'
}

<#

XXXXXXXXXXXX
X5483143223X
X2745854711X
X5264556173X
X6141336146X
X6357385478X
X4167524645X
X2176841721X
X6882881134X
X4846848554X
X5283751526X
XXXXXXXXXXXX

1..10

Each step..
- Energy level of each octopus +1
- Energy level -gt 9 { FLASH! and adjacent octopus +1. If adjacent octopus -gt 9 also FLASH! loops til all are done (octopus flashes once per step)}
- if octopus flashes then its energy is set to 0 as all its energy is used


how many flashes are there after 100 steps?
#>

$array[1][10]

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2