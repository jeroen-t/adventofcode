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
    $octopus = @{}
    for ($y = 0; $y -lt 10; $y++) {
        for ($x = 0; $x -lt 10; $x++) {
            $coord = "$x,$y"
            $octopus[$coord] = [int]$dumbos[$y][$x] - 48
        }
    }
    $octopus
}

function Get-aocDumboNeighbor ([string]$coord) {
    [int]$r,[int]$c = $coord.split(',')
    $offsets =@((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1))
    $neigh = foreach($off in $offsets) {
        $y,$x = $off[0],$off[1]
        if ($r + $y -ge 0 -and $r + $y -le 9 -and $c + $x -ge 0 -and $c + $x -le 9) {
            $ry = $r + $y
            $cx = $c + $x
            ,@($ry,$cx)
        }
    }
    $neigh
}

function Start-aocDumboFlash ([string]$coord) {
    $script:flash++
    $octopus[$coord] = 0
    Get-aocDumboNeighbor $coord | ForEach-Object {
        $n = "$($_[0]),$($_[1])"
        switch($octopus["$($_[0]),$($_[1])"])
        {
            ({$PSItem -eq 0}) {
                continue
            }
            ({$PSItem -ge 9}) {
                Start-aocDumboFlash $n
            }
            default {
                $octopus[$n]++
            }
        }
    }
}

function Step-aocDumboOctopus ([int]$day) {
    for ($d = 1; $d -le $day; $d++) {
        if ($octopus) {
            foreach($octo in $($octopus.Keys)) {
                $octopus[$octo]++
            }
        } else {
            $octopus = Get-aocDumboStartState $data
        }
        for ($y = 0; $y -lt 10; $y++) {
            for ($x = 0; $x -lt 10; $x++) {
                if ($octopus["$x,$y"] -gt 9) {
                    Start-aocDumboFlash "$x,$y"
                }
            }
        }
    }
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$octopus = Get-aocDumboStartState $data
$flash = 0
Step-aocDumboOctopus -day 100
$a1 = $flash

$octopus = Get-aocDumboStartState $data
$steps = 0
do {
    $steps++
    $flash = 0
    Step-aocDumboOctopus -day 1
} until ($flash -eq 100)
$a2 = $steps

"[Day 11] My answer for part 1 is: {0}, and for part 2 is: {1}" -f $a1,$a2