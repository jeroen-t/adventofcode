function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
    }
    $data = Get-Content $path
    Write-Output $data
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X #-dummy

# visualization

for ($r = 0; $r -lt $data.Count; $r++) {
    for ($c = 0; $c -lt $data[0].Length; $c++) {
        Write-host $data[$r][$c] -NoNewline
    }
    ""
}

# weights

$weights = New-Object 'int[,]' $data.Count,$data[0].Length
for ($r = 0; $r -lt $data.Count; $r++) {
    for ($c = 0; $c -lt $data[0].Length; $c++) {
        [int]$weights[$r,$c] = 0
    }
}

#neighbors

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

[string[]]$grid = $data
$grid[0] = $grid[0] -replace "^.","0"
$pq = New-Object System.Collections.Generic.PriorityQueue["PSObject,Int"]
$pq.Enqueue((0,0),0)
while ($pq) {
    ($r, $c) = $pq.Dequeue()
    if ("$r,$c" -notin $directions.Keys) {
        continue
    } else {
        $verts = $directions["$r,$c"]
        $directions.Remove("$r,$c")
    }

    $verts | ForEach-Object {
        $ry,$cx = $_ -split ','
        if (-not($weights[$ry,$cx]) -or $weights[$r,$c]+$data[$ry][$cx]-48 -lt $weights[$ry,$cx]) {
            $weights[$ry,$cx] = $weights[$r,$c]+$data[$ry][$cx]-48
            $pq.Enqueue(($ry,$cx), $($weights[$ry,$cx]))
        }
    }
    if ($pq.Count -eq 0) {
        break
    }
}
$weights[-1,-1]

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2