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



(-join($data.ToCharArray() | ForEach-Object {
    [System.Convert]::ToString([System.Convert]::ToInt32("$_", 16),2).PadLeft(4, '0')
})) #.substring(0,3)


$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2