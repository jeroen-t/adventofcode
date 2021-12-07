function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path -raw
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path -raw
    }
    [int[]]$data = $data -split ","
    Write-Output $data
}

function Get-Median ([double[]]$num) {
    $num = $num | Sort-Object
    if ($num.Length % 2) {
        $med = $num[[math]::Floor($num.Length / 2)]
    } else {
        $med = ($num[$num.Length / 2], $num[$num.Length / (2-1)] |
            Measure-Object -Average).Average
    } 
    Write-Output $med
}

function Get-aocCrabsAllignmentPositionMinimalCost {
    Param (
        [Parameter(Mandatory)]
        [double[]]$CrabLocations,

        [switch]$UseProperCrabEngineering
    )
    switch ($UseProperCrabEngineering.IsPresent)
    {
        $true   {
            $mean = ($CrabLocations | Measure-Object -Average).Average
            $pos = [math]::Floor($mean), [math]::Round($mean)
            ($pos | ForEach-Object {
                $pos = $_
                ($CrabLocations | ForEach-Object {
                    $n = [math]::Abs($pos - $_)
                    $n * ($n + 1) / 2
                } | Measure-Object -Sum).Sum
            } | Measure-Object -Minimum).Minimum
        }
        $false  {
            $pos = Get-Median $CrabLocations
            ($CrabLocations | ForEach-Object {
                [math]::Abs($pos - $_)
            } | Measure-Object -Sum).Sum
        }
    }
}

$data = Import-aocData -day 7
$a1 = Get-aocCrabsAllignmentPositionMinimalCost -CrabLocations $data
$a2 = Get-aocCrabsAllignmentPositionMinimalCost -CrabLocations $data -UseProperCrabEngineering

"[Day 7] My answer for part 1 is: {0}, and part 2 is: {1}. Thank god for proper Crab Engineering!" -f $a1,$a2