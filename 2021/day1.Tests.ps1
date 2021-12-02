BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocSonarSweep counts the number of times a depth measurement increases' {
    BeforeAll {
        [System.Int32[]]$measurements = 199,200,208,210,200,207,240,269,260,263
    }
    Context 'Counts measurements that are larger then the previous measurement' {
        it 'Returns 7 total increases' {
            Get-aocSonarSweep -Measurements $measurements | should -Be 7
        }
    }
    Context 'Considers sums of a three-measurement sliding window' {
        it 'Returns 5 total increases' {
            Get-aocSonarSweep -Measurements $measurements -IncludeThree | should -Be 5
        }
    }
}