function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
    }
    $data = Get-Content $path
    Write-Output $data
}

function New-aocGrid ($data) {
    $grid = New-Object 'int[,]' $data.Count,$data[0].Length
    $weights = New-Object 'int[,]' $data.Count,$data[0].Length
    for ($r = 0; $r -lt $data.Count; $r++) {
        for ($c = 0; $c -lt $data[0].Length; $c++) {
            [int]$grid[$r,$c] = $data[$r][$c] - 48
            [int]$weights[$r,$c] = 0
        }
    }
    $grid[0,0] = 0
    $grid, $weights
}

function Get-aocNeighborVertices ($data) {
    $offsets = @((0, 1),(0,-1),(1,0),(-1,0))
    $directions = @{}
    for ($r = 0; $r -lt $data.Count; $r++) {
        for ($c = 0; $c -lt $data[0].Length; $c++) {
            $offsets | ForEach-Object {
                $ry,$cx = $_
                if ($r + $ry -ge 0 -and $r + $ry -lt $data.Count -and $c + $cx -ge 0 -and $c + $cx -lt $data[0].Length) {
                    $directions["$r,$c"] += @("$($r+$ry),$($c+$cx)")
                }
            }
        }
    }
    $directions
}

function Get-aocSafestPath ($data,[switch]$EntireCave) {
    if ($EntireCave.IsPresent) {
        $data = foreach($i in 0..4) {
            $data | ForEach-Object {
                -join $(foreach ($j in 0..4) { echo @_ | ForEach-Object {
                    1 + ( $_ - 49 + $j + $i) % 9 }
                })
            }
        }
    }
    $grid, $weights = New-aocGrid $data
    $directions = Get-aocNeighborVertices $data
    $pq = New-Object System.Collections.Generic.PriorityQueue["PSObject,Int"]
    $pq.Enqueue((0,0),0)
    while ($pq.Count -gt 0) {
        ($r, $c) = $pq.Dequeue()
        if ("$r,$c" -notin $directions.Keys) {
            continue
        } else {
            $verts = $directions["$r,$c"]
            $directions.Remove("$r,$c")
        }

        $verts | ForEach-Object {
            $ry,$cx = $_ -split ','
            if (-not($weights[$ry,$cx]) -or $weights[$r,$c]+$grid[$ry,$cx] -lt $weights[$ry,$cx]) {
                $weights[$ry,$cx] = $weights[$r,$c]+$grid[$ry,$cx]
                $pq.Enqueue(($ry,$cx), $($weights[$ry,$cx]))
            }
        }
    }
    $weights[-1,-1]
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X #-dummy

$a1 = Get-aocSafestPath $data
$a2 = Get-aocSafestPath $data -EntireCave

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2