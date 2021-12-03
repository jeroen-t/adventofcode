BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Get-aocSubmarineDiagnostics' {
    BeforeAll {
        $path = Join-Path $PSScriptRoot ..\input\2021\input_day3_dummy.txt
        $diagnosticReport = Get-Content -Path $path
        $result = Get-aocSubmarineDiagnostics -diagnosticReport $diagnosticReport
    }
    Context 'Returns the correct results' {
        it 'Returns a gamma rate of 22' {
            $result.GammaRate | Should -Be 22
        }
        it 'Returns a epsilon rate of 9' {
            $result.EpsilonRate | Should -Be 9
        }
        it 'Returns a power consumption of 198' {
            $result.PowerConsumption | Should -Be 198
        }
    }
}

Describe 'Get-aocSubmarineRating' {
    BeforeAll {
        $path = Join-Path $PSScriptRoot ..\input\2021\input_day3_dummy.txt
        $diagnosticReport = Get-Content -Path $path
    }
    Context 'Returns the oxygen generator rating' {
        BeforeAll {
            $result = Get-aocSubmarineRating -diagnosticReport $diagnosticReport -Rating oxygen
        }
        it 'Returns a oxygen generator rating of 23' {
            $result | Should -Be 23
        }
        it 'Multiplies with the CO2 scrubber rating for a life support rating of 230' {
            $result * 10 | Should -Be 230
        }
    }
    Context 'Returns the CO2 scrubber rating' {
        BeforeAll {
            $result = Get-aocSubmarineRating -diagnosticReport $diagnosticReport -Rating CO2
        }
        it 'Returns a CO2 scrubber rating of 10' {
            $result | Should -Be 10
        }
        it 'Multiplies with the oxygen generator rating for a life support rating of 230' {
            $result * 23 | Should -Be 230
        }
    }
}