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

function Get-aocUniqueSegments ($data) {
    $output = foreach($line in $data) {
        $line.Split('|')[1].Split(" ")
    }
    $length = foreach ($word in $output) {
        $word.Length
    }
    $oneofus = 0
    switch ($length)
    {
        2 {$oneofus++}
        3 {$oneofus++}
        4 {$oneofus++}
        7 {$oneofus++}
    }
    $oneofus
}

function Resolve-aocSignalWireMapping {
    Param (
        [string[]]$entries
    )
    foreach ($entry in $entries) {
        $sig,$output = $entry -split ' \| '
        $signals = $sig.Split() | ForEach-Object {
            -join (Write-Output @_ | Sort-Object)
        }
        $dictionary = [ordered]@{}
        $dictionary["1"] = $signals | Where-Object Length -eq 2
        $dictionary["4"] = $signals | Where-Object Length -eq 4
        $dictionary["7"] = $signals | Where-Object Length -eq 3
        $dictionary["8"] = $signals | Where-Object Length -eq 7

        $dictionary["6"] = $signals | Where-Object Length -eq 6 | Where-Object {
            ($_.ToCharArray() | Where-Object {$dictionary["1"].ToCharArray() -contains $_}).count -eq 1
        }
        $dictionary["9"] = $signals | Where-Object Length -eq 6 | Where-Object {
            ($_.ToCharArray() | Where-Object {$dictionary["4"].ToCharArray() -contains $_}).Count -eq 4
        }
        $dictionary["0"] = $signals | Where-Object Length -eq 6 | Where-Object {
            $_ -notin $dictionary.Values
        }

        $dictionary["3"] = $signals | Where-Object Length -eq 5 | Where-Object {
            ($_.ToCharArray() | Where-Object {$dictionary["1"].ToCharArray() -contains $_}).Count -eq 2
        }    
        $dictionary["2"] = $signals | Where-Object Length -eq 5 | Where-Object {
            ($_.ToCharArray() | Where-Object {$dictionary["4"].ToCharArray() -contains $_}).Count -eq 2
        }
        $dictionary["5"] = $signals | Where-Object Length -eq 5 | Where-Object {
            $_ -notin $dictionary.Values
        }

        -join ($output.Split() | ForEach-Object {
            -join (Write-Output @_ | Sort-Object) | ForEach-Object {
                $word = $_
                ($dictionary.GetEnumerator() | Where-Object {$_.Value -eq $word}).Key
            }
        })
    }
}

$data = Import-aocData -day 8

$a1 = Get-aocUniqueSegments $data
$a2 = (Resolve-aocSignalWireMapping $data | Measure-Object -Sum).Sum
"[Day 8] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2



