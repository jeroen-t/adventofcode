function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path
    }
    [int[]]$out = $data -split ','
    Write-Output $out
}

function Get-aocLanternfish {
    param (
        [int[]]$fishies,
        [int]$days
    )
    $fishfamily = New-Object 'system.collections.generic.dictionary[int,long]'
    0..8 | ForEach-Object {
        $fishfamily.Add($_,0)
    }
    $fishies | ForEach-Object {
        $fishfamily[$_]++
    }
    for ($i = 0; $i -lt $days; $i++) {
        $egg = $fishfamily[0]
        1..8 | ForEach-Object {
            $fishfamily[$_-1] = $fishfamily[$_]
        }
        $fishfamily[8] = $egg
        $fishfamily[6] += $egg
    }
    ($fishfamily.Values | Measure-Object -Sum).Sum
}

$data = import-aocData -day 6
$a1 = Get-aocLanternfish -fishies $data -days 80
$a2 = Get-aocLanternfish -fishies $data -days 256
"[Day 6] My answer for part 1 is: {0}, and part 2 is: {1}." -f $a1,$a2