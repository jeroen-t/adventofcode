function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = Get-Content $path -raw
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path -raw
    }
    Write-Output $data
}