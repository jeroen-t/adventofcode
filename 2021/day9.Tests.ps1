BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Find-aocLowPoints' {
    BeforeAll {
        $data = import-aocData -day 9 -dummy
    }
    Context 'Finds the low points - the locations that are lower than any of its adjacent locations' {
        it 'Returns a sum of the risk levels of all low points of 15' {
            Find-aocLowPoints $data | should -Be 15
        }
    }
}

describe 'Find-aocLargestBasins' {
    BeforeAll {
        $data = import-aocData -day 9 -dummy
    }
    Context 'Finds the largest basins' {
        it 'Multiplying the sizes of the three largest basins should result in a value of 1134' {
            Find-aocLargestBasins $data | should -Be 1134
        }
    }
}