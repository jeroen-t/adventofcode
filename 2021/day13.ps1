function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
    }
    $data,$instructions = (Get-Content $path -raw) -split "\r\n\r\n"
    [PSCustomObject]@{
        data = -split($data)
        instructions = $instructions -replace 'fold along ','' -split "\r\n"
    }
}

function Get-aocDots ([string[]]$data) {
    $dots = $data | ForEach-Object {
        [int]$x,[int]$y = $_.split(',')
        [PSCustomObject]@{
            x = $x
            y = $y
            loc = "$x,$y"
        }
    }
    $dots
}

function Get-aocFolds ([string[]]$data) {
    $folds = $data | ForEach-Object {
        [string]$axis,[int]$digit = $_.split('=')
        [PSCustomObject]@{
            axis = $axis
            digit = $digit
        }
    }
    $folds
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy


$dots = Get-aocDots $data.data
$folds = Get-aocFolds $data.instructions

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2