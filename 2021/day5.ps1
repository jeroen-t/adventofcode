function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path
    }
    $out = $data | ForEach-Object {
        ,[int[]]($_ -replace ' -> ', ',' -split ',')
    }
    Write-Output $out
}

function Get-aocVents {
    Param (
        [object[]]$entries,
        [ValidateSet('Diag','NonDiag','All')]
        [string]$direction
    )
    switch ($direction)
    {
        'Diag' {
            $entries = $entries | Where-Object {
                ($_[0] -ne $_[2]) -and ($_[1] -ne $_[3])
            }
        }
        'NonDiag' {
            $entries = $entries | Where-Object {
                ($_[0] -eq $_[2]) -or ($_[1] -eq $_[3])
            }
        }
        'All' {}
    }
    $locs = foreach ($entry in $entries) {
        $x1 = $entry[0]
        $y1 = $entry[1]
        $x2 = $entry[2]
        $y2 = $entry[3]

        do {
            Write-Output "$x1.$y1"
        
            if ($x1 -ne $x2) {
                if ($x1 -le $x2) {
                    $x1++
                } else {
                    $x1--
                }
            }
            if ($y1 -ne $y2) {
                if ($y1 -le $y2) {
                    $y1++
                } else {
                    $y1--
                }
            }
        } while (($x1 -ne $x2) -or ($y1 -ne $y2))

        Write-Output "$x1.$y1"
    }
    ($locs | Group-Object -NoElement | Where-Object {$_.Count -gt 1}).Count
}

$data = import-aocData -day 5
$a1 = get-aocVents -entries $data -direction NonDiag
$a2 = get-aocVents -entries $data -direction All

"[Day 5] My result to answer 1 is: {0}, and answer 2 is: {1}." -f $a1,$a2