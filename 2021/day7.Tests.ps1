BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocCrabsAllignmentPositionMinimalCost' {
    BeforeAll {
        $data = import-aocData -day 7 -dummy
    }
    Context 'Determine the horizontal position that the crabs can align to using the least fuel possible' {
        it 'Returns a fuel cost total of 37' {
            Get-aocCrabsAllignmentPositionMinimalCost -CrabLocations $data | should -Be 37
        }
    }
    Context 'Determine the horizontal position that the crabs can align to using the least fuel possible using proper crab engineering' {
        it 'Returns a fuel cost total of 168' {
            Get-aocCrabsAllignmentPositionMinimalCost -CrabLocations $data -UseProperCrabEngineering | should -Be 168
        }
    }
}