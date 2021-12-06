function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path -raw
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path -raw
    }
    $data = $data -split "\r?\n\r?\n"

    [int[]]$balls = $data[0].Split(',')

    $n = $data.Length
    $data = $data[1..$n]

    [PSCustomObject]@{
        Balls = $balls
        Sheets = $data
    }
}

$data = import-aocData -day 4 -dummy

$Balls = $data.Balls
$sheets = $data.Sheets