function Get-aocSubmarineDirections {
    Param (
        [parameter(Mandatory)]
        [string]$course
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
        [int]$Value
    )
    Begin {
        $position = [PSCustomObject]@{
            Depth       =   [int]0
            Horizontal  =   [int]0
            Location    =   [int]0
        }
    }
    Process {
        switch($Directions)
        {
            'down'      {$position.Depth += $Value}
            'forward'   {$position.Horizontal += $Value}
            'up'        {$position.Depth -= $Value}
        }
    }
    End {
        $position.Location = $position.Depth * $position.Horizontal
        return $position
    }
}

Get-aocSubmarineDirection $(Get-Content .\input\input_day2.txt) | Move-aocSubmarine