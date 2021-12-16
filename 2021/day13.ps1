function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data,$instructions = (Get-Content $path -raw) -split "\r\n\r\n"
        [PSCustomObject]@{
            data = -split($data)
            instructions = $instructions -replace 'fold along ','' -split "\r\n"
        }
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data,$instructions = (Get-Content $path -raw) -split "\n\n"
        [PSCustomObject]@{
            data = -split($data)
            instructions = $instructions -replace 'fold along ','' -split "\n"
        }
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

function Show-aocTransparentPaper ($dots) {
    $maxy = ($dots.y | Measure-Object -Maximum).Maximum+1
    $maxx = ($dots.x | Measure-Object -Maximum).Maximum+1
    for ($y = 0; $y -lt $maxy; $y++) {
        for ($x = 0; $x -lt $maxx; $x++) {
            #$array[$x,$y] = '.'
            if ("$x,$y" -in $dots.loc) {
                write-host "#" -NoNewline
            } else {
                Write-Host " " -NoNewline
            }
        }
        ""
    }
}

function New-aocTransparentPaperFold ($dots,$instructions,[switch]$paper) {
    foreach($line in $instructions) {
        $axis, $n_s = $line.split('=')
        $n = [int]$n_s
        
        if ($axis -eq 'x') {
            $dots = $dots = foreach ($obj in $dots) {
                $x = $obj.x
                $y = $obj.y
                $x = ($x -lt $n) ? $x : ($n - ($x - $n))
                [PSCustomObject]@{
                    x = $x
                    y = $y
                    loc = "$x,$y"
                }
            }
        } elseif ($axis -eq 'y') {
            $dots = foreach ($obj in $dots) {
                $x = $obj.x
                $y = $obj.y
                $y = ($y -lt $n) ? $y : ($n - ($y - $n))
                [PSCustomObject]@{
                    x = $x
                    y = $y
                    loc = "$x,$y"
                }
            }
        }
        $dots = $dots | Sort-Object loc -Unique
    }
    if ($Paper.IsPresent) {
        Show-aocTransparentPaper $dots
    } else {
        $dots.Count
    }
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X #-dummy

$instructions = $data.instructions
$dots = Get-aocDots $data.data

$a1 = New-aocTransparentPaperFold -dots $dots -instructions $instructions[0]
New-aocTransparentPaperFold -dots $dots -instructions $instructions -paper

<#
###  #### #  # #### #    ###   ##  #  #
#  #    # # #     # #    #  # #  # #  #
#  #   #  ##     #  #    #  # #    ####
###   #   # #   #   #    ###  # ## #  #
# #  #    # #  #    #    #    #  # #  #
#  # #### #  # #### #### #     ### #  #
#>

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: ASCII ART." -f $a1