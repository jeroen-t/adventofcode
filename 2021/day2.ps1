function Get-aocSubmarineDirections {
    Param (
        [parameter(Mandatory)]
        [string[]]$course
    )
    Process {
        $Directions = $course -split '\n' | ForEach-Object {
            $Objective = [PSCustomObject]@{
                Directions = [string]($_ -split " ")[0]
                Value = [int]($_ -split " ")[1]
            }
            Write-Output $Objective
        }
        return $Directions
    }
}

function Move-aocSubmarine {
    [CmdletBinding()]
    Param (
        [Parameter (Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('down','forward','up')]
        [string]$Directions,

        [Parameter (Mandatory,ValueFromPipelineByPropertyName)]
        [int]$Value,

        [switch]$IncludeAim
    )
    Begin {
        $position = [PSCustomObject]@{
            Depth       =   [int]0
            Horizontal  =   [int]0
            Location    =   [int]0
        }
        if ($IncludeAim.IsPresent) {
            $position | Add-Member -NotePropertyName Aim -NotePropertyValue 0
        }
    }
    Process {
        switch($Directions)
        {
            'down'
                {
                    if ($IncludeAim.IsPresent) {
                        $position.Aim += $Value
                    } else {
                        $position.Depth += $Value
                    }
                }
            'forward'
                {
                    if ($IncludeAim.IsPresent) {
                        $position.Horizontal += $Value;
                        $position.Depth += ($position.Aim * $Value)
                    } else {
                        $position.Horizontal += $Value
                    }
                }
            'up'
                {
                    if ($IncludeAim.IsPresent) {
                        $position.Aim -= $Value
                    } else {
                        $position.Depth -= $Value
                    }
                }
        }
    }
    End {
        $position.Location = $position.Depth * $position.Horizontal
        return $position
    }
}

$path = Join-Path $PSScriptRoot ..\input\2021\input_day2.txt
$course = Get-Content -Path $path

$location1 = (Get-aocSubmarineDirections $course | Move-aocSubmarine).Location
$location2 = (Get-aocSubmarineDirections $course | Move-aocSubmarine -IncludeAim).Location
"[Day 2] first answer: {0}, second answer: {1} " -f $location1,$location2