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

function ConvertTo-aocBinary ($data) {
    -join($data.ToCharArray() | ForEach-Object {
        [System.Convert]::ToString([System.Convert]::ToInt32("$_", 16),2).PadLeft(4, '0')
    })
}

$binary = ConvertTo-aocBinary $data
$convert = { Param ($bits) [System.Convert]::ToInt32($bits, 2)}

$Version = $convert.Invoke($binary.Substring(0,3))
$Type = $convert.Invoke($binary.Substring(3,3))

if ($Type -eq 4) {
    $i = 6
    while ($binary[$i] -eq '1') {
        $i += 5
    }
    # 110100101111111000101000
    # VVVTTTAAAAABBBBBCCCCC

    # So, this packet represents a literal value with binary representation 011111100101, which is 2021 in decimal.
    $convert.Invoke(-join($binary.Substring(6, $i-1) -split '(\w{5})' | ? {$_} | % {$_.substring(1,4)}))
} else {
    $i = 6
    if ($binary[$i] -eq '0') {
        # If the length type ID is 0, then the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
        $convert.Invoke($binary.Substring($i+1,$i+15))

    } elseif ($binary[$i] -eq '1') {
        # If the length type ID is 1, then the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
        $convert.Invoke($binary.Substring($i+1,$i+11))
    }
}



$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2