function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path -raw
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path -raw
    }
    [System.Int32[]]$measurements = Get-Content -Path $path
    Write-Output $measurements
}

function Get-aocSonarSweep {
    [CmdletBinding()]
    param (
        [System.Int32[]]$Measurements,
        [switch]$IncludeThree
    )

    if($IncludeThree.IsPresent) {
        $j = 2
    }
    $output = for ($i = 1; $i -lt $Measurements.Length-$j; $i++) {
        if ($Measurements[$i+$j] -gt $Measurements[$i-1]) {
            1
        }
    }

    return ($output | Measure-Object -Sum).Sum
}

$measurements = import-aocData -day 1
$r1 = Get-aocSonarSweep -Measurements $measurements
$r2 = Get-aocSonarSweep -Measurements $measurements -IncludeThree

"My answer for the first half is: {0} and for the second half is: {1}." -f $r1,$r2