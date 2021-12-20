BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocSafestPath' {
    BeforeAll {
        $data = import-aocData -day 15 -dummy
    }
    Context 'Calculates the lowest total risk of any path form the top left to the bottom right of the cave' {
        it 'Returns a total risk of 40' {
            Get-aocSafestPath $data | should -Be 40
        }
    }
    Context 'Calculates the lowest total risk of any path form the top left to the bottom right of the cave using the full map' {
        it 'Returns a total risk of 315' {
            Get-aocSafestPath $data -EntireCave | should -Be 315
        }
    }
}