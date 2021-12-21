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

$test = ConvertTo-aocBinary "38006F45291200"
$binary = $test

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
        $convert.Invoke($binary.Substring($i+1,15))
        #$binary[22..$binary.Length]

        # 00111000000000000110111101000101001010010001001000000000
        # VVVTTTILLLLLLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBBBBBB
        $binary.Substring(22,$binary.Length-22)
    } elseif ($binary[$i] -eq '1') {
        # If the length type ID is 1, then the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
        $convert.Invoke($binary.Substring($i+1,11))

        # 11101110000000001101010000001100100000100011000001100000
        # VVVTTTILLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBCCCCCCCCCCC

    }
}

<#
For now, parse the hierarchy of the packets throughout the transmission and add up all of the version numbers.

Here are a few more examples of hexadecimal-encoded transmissions:

8A004A801A8002F478 represents an operator packet (version 4) which contains an operator packet (version 1) which contains an operator packet (version 5) which contains a literal value (version 6); this packet has a version sum of 16.

620080001611562C8802118E34 represents an operator packet (version 3) which contains two sub-packets; each sub-packet is an operator packet that contains two literal values. This packet has a version sum of 12.

C0015000016115A2E0802F182340 has the same structure as the previous example, but the outermost packet uses a different length type ID. This packet has a version sum of 23.

A0016C880162017C3686B18A3D4780 is an operator packet that contains an operator packet that contains an operator packet that contains five literal values; it has a version sum of 31.
#>


$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X -dummy

$a1=$null
$a2=$null

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2