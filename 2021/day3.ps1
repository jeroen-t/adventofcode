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

function Get-aocSubmarineDiagnostics {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$diagnosticReport
    )
    Begin {
        $limit = ($diagnosticReport | Measure-Object -Maximum -Property Length).Maximum
        $br = ($diagnosticReport.Count * (49 + 48)) / 2
    }
    Process {
        $i = 0
        $result = for ($i; $i -lt ($limit); $i++) {
            [int[]]$output = foreach ($line in $diagnosticReport) {
                $line.ToCharArray()[$i]
            }
            if (($output | Measure-Object -Sum).Sum -gt $br) {
                $Gamma = 1; $Epsilon = 0
            } else {
                $Gamma = 0; $Epsilon = 1
            }
            $obj = [PSCustomObject]@{
                Gamma   = $Gamma
                Epsilon = $Epsilon
            }
            $obj
        }
    }
    END {
        $gammaRate = [Convert]::ToInt32(-join($result.Gamma),2)
        $epsilonRate = [Convert]::ToInt32(-join($result.Epsilon),2)
        $powerConsumption = $gammaRate * $epsilonRate

        $consumption = [PSCustomObject]@{
            GammaRate           = $gammaRate
            EpsilonRate         = $epsilonRate
            PowerConsumption    = $powerConsumption
        }
        Write-Output $consumption
    }
}

function Get-aocSubmarineRating {
    Param (
        [parameter(Mandatory)]
        [string[]]$diagnosticReport,

        [parameter(Mandatory)]
        [ValidateSet('oxygen','CO2')]
        [string]$Rating
    )
    Begin {
        $i = 0
        $limit = ($diagnosticReport | Measure-Object -Maximum -Property Length).Maximum
    
        switch($rating)
        {
            'oxygen'    {$desc=$true}
            'CO2'       {$desc=$false}
        }
    }
    Process {
        for ($i; $i -lt $limit; $i++) {
            if ($diagnosticReport.Length -eq 1) {
                break
            }
            [int[]]$output = foreach ($line in $diagnosticReport) {
                $line.ToCharArray()[$i]
            }

            if (($output | Group-Object | Sort-Object Count,Name -Descending:$desc)[0].Name -eq '49') {
                $diagnosticReport = $diagnosticReport | Select-String -Pattern "^.{$i}1" | Select-Object -ExpandProperty Line
            } else {
                $diagnosticReport = $diagnosticReport | Select-String -Pattern "^.{$i}0" | Select-Object -ExpandProperty Line
            }
        }
    }
    End {
        [Convert]::ToInt32($diagnosticReport,2)
    }
}

$diagnosticReport = import-aocData -day 3
$a1 = (Get-aocSubmarineDiagnostics -diagnosticReport $diagnosticReport).PowerConsumption
$r1 = Get-aocSubmarineRating -diagnosticReport $diagnosticReport -Rating CO2
$r2 = Get-aocSubmarineRating -diagnosticReport $diagnosticReport -Rating oxygen
$a2 = $r1 * $r2

"[Day 3] first answer: {0}, second answer: {1} " -f $a1,$a2