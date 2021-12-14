$totalflashes = $steps = $flashes = 0

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

function Get-aocDumboStartState ([string[]]$dumbos) {
    $octopus = [ordered]@{}
    for ($y = 0; $y -lt $dumbos.Count; $y++) {
        for ($x = 0; $x -lt $dumbos[0].Length; $x++) {
            $coord = "$x,$y"
            $octopus[$coord] = [int]$dumbos[$y][$x] - 48
        }
    }
    $octopus
}

function Get-aocDumboNeighbours ([string]$coord) {
    $neighbours = @{}
    if ($neighbours.ContainsKey($coord)) {
        $neighbours[$coord]
    } else {
        [int]$x, [int]$y = $coord -split ','
        $nb = for ($i = -1; $i -lt 2; $i++) {
            for ($j = -1; $j -lt 2; $j++) {
                if ($x + $i -ge 0 -and $y + $j -ge 0 -and $x + $i -lt $dumbos[0].Length -and $y + $j -lt $dumbos.Count -and -not ($i -eq 0 -and $j -eq 0)) {
                    "{0},{1}" -f $($x + $i), $($y + $j)
                }
            }
        }
        $neighbours[$coord] = $nb
        $nb
    }
}

Get-aocDumboNeighbours "0,0"

function New-aocDumboFlash ([string]$coord) {
    $script:flashes ++
    $octopus[$coord] = 0
    Get-aocDumboNeighbours $coord | ForEach-Object {
        $octo = $_
        switch ($octopus[$_]) {
            ({$_ -eq 0})    { continue              }
            ({$_ -ge 9})    { New-aocDumboFlash $octo    }
            default         { $octopus[$octo]++     }
        }
    }
}

function Start-aocDumboEnergyIncrease {
    $script:steps ++
    for ($y = 0; $y -lt $dumbos.Count; $y++) {
        for ($x = 0; $x -lt $dumbos[0].Length; $x++) {
            $octopus["$x,$y"]++
        }
    }
}

function Step-aocDumboGrid ([int]$days) {
    for ($d = 0; $d -lt $days; $d++) {
        Start-aocDumboEnergyIncrease
        for ($y = 0; $y -lt $dumbos.Count; $y++) {
            for ($x = 0; $x -lt $dumbos[0].Length; $x++) { 
                if ($octopus["$x,$y"] -gt 9) {
                    New-aocDumboFlash "$x,$y"
                }
            }
        }
    }
    $script:totalflashes += $script:flashes
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$octopus = Get-aocDumboStartState $data

# part 1
Step-aocDumboGrid 100
"After step $steps there have been $totalflashes flashes"

<#
# part 2
do {
    $flashes = 0
    Step-aocDumboGrid 1
} until ($flashes -eq $octopus.count)

"After step $step all dumbos have flashed simultaneously"

# $a1=$null
# $a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2







<#
function Get-aocDumboNeighbours ([string]$coord) {
    $neighbours = @{}
    if ($neighbours.ContainsKey($coord)) {
        $neighbours[$coord]
    } else {
        [int]$x, [int]$y = $coord -split ','
        $nb = for ($i = -1; $i -lt 2; $i++) {
            for ($j = -1; $j -lt 2; $j++) {
                if ($x + $i -ge 0 -and $y + $j -ge 0 -and $x + $i -lt $dumbos[0].Length -and $y + $j -lt $dumbos.Count -and -not ($i -eq 0 -and $j -eq 0)) {
                    "{0},{1}" -f $($x + $i), $($y + $j)
                }
            }
        }
        $neighbours[$coord] = $nb
        $nb
    }
}

function New-aocDumboFlash ([string]$coord) {
    $script:flashes ++
    $octopus[$coord] = 0
    Get-aocDumboNeighbours $coord | ForEach-Object {
        $octo = $_
        switch ($octopus[$_]) {
            ({$_ -eq 0})    { continue              }
            ({$_ -ge 9})    { New-aocDumboFlash $octo    }
            default         { $octopus[$octo]++     }
        }
    }
}

function Start-aocDumboEnergyIncrease {
    $script:steps ++
    for ($y = 0; $y -lt $dumbos.Count; $y++) {
        for ($x = 0; $x -lt $dumbos[0].Length; $x++) {
            $octopus["$x,$y"]++
        }
    }
}

function Step-aocDumboGrid ([int]$days) {
    for ($d = 0; $d -lt $days; $d++) {
        Start-aocDumboEnergyIncrease
        for ($y = 0; $y -lt $dumbos.Count; $y++) {
            for ($x = 0; $x -lt $dumbos[0].Length; $x++) { 
                if ($octopus["$x,$y"] -gt 9) {
                    New-aocDumboFlash "$x,$y"
                }
            }
        }
    }
    $script:totalflashes += $script:flashes
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$octopus = Get-aocDumboStartState $data
$octopus | gm

# part 1
Step-aocDumboGrid 100
"After step $steps there have been $totalflashes flashes"

<#
# part 2
do {
    $flashes = 0
    Step-aocDumboGrid 1
} until ($flashes -eq $octopus.count)

"After step $step all dumbos have flashed simultaneously"

# $a1=$null
# $a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2
#>


#>