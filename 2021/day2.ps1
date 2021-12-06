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

$course = import-aocData -day 2 -dummy
$a1 = (Get-aocSubmarineDirections $course | Move-aocSubmarine).Location
$a2 = (Get-aocSubmarineDirections $course | Move-aocSubmarine -IncludeAim).Location

"[Day 2] first answer: {0}, second answer: {1} " -f $a1,$a2