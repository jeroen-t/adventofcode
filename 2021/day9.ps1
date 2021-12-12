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

function Find-aocLowPoints ($data) {
    $row = $data.Count - 1
    $col = $data[0].Length - 1

    $offsets = (-1,0),(0,-1),(0,1),(1,0)

    $out = 0..$row | ForEach-Object {
        $r = $_
        0..$col | ForEach-Object {
            $c = $_
            $val = $data[$r][$c]
            $adj = $offsets.Where({
                $rn = $r + $_[0]
                $cn = $c + $_[1]
                $rn -ge 0 -and $cn -ge 0 -and $rn -le $row -and $cn -le $col -and $data[$rn][$cn] -le $val
            }, 'First')
            if (-not $adj) {
                $data[$r][$c] - 47
            }
        }
    }
    ($out | Measure-Object -sum).Sum
}

function Find-aocLargestBasins ($data) {
    # $row = $data.Count
    # $col = $data[0].Length
}

$data = Import-aocData -day 9

$a1 = Find-aocLowPoints $data
$a2 = Find-aocLargestBasins $data
"[Day 9] My answer for part 1 is: {0}, and for part 2 is {1}" -f $a1, $a2
