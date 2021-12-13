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

function Get-aocSyntaxScore {
    Param (
        [string[]]$data
    )
    Begin {
        $stack = New-Object 'System.Collections.Generic.Stack[string]'
        $pairs = @{')'='(';']'='[';'}'='{';'>'='<'}
        $points1 = @{')'=3;']'=57;'}'=1197;'>'=25137}
        $points2 = @{'('=1;'['=2;'{'=3;'<'=4}
    }
    Process {
        $p1 = 0
        $out = foreach($chunk in $data) {
            $stack.Clear()
            [string[]]$chunk.ToCharArray() | ForEach-Object {
                if ($_ -in @('{','[','(','<')) {
                    $stack.Push("$_")
                } elseif ($_ -in @('}',']',')','>')) {
                    if ($pairs["$_"] -eq $stack.Peek()) {
                        $stack.Pop() | Out-Null
                    } else {
                        $p1 += $points1["$_"]
                        continue
                    }
                }
            }
            if ($stack.Count -gt 0) {
                $p2 = 0
                $stack | ForEach-Object {
                    $p2 *= 5
                    $p2 += $points2["$_"]
                }
                $p2
            }
        }
        [PSCustomObject]@{
            ErrorScore = $p1
            AutoCompleteScore = ($out | Sort-Object)[($out.Count / 2)]
        }
    }
}

$data = Import-aocData -day 10

$a = Get-aocSyntaxErrorScore $data
"[Day 10] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a.ErrorScore,$a.AutoCompleteScore