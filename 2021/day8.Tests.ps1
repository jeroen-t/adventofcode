BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocUniqueSegments' {
    BeforeAll {
        $data = import-aocData -day 8 -dummy
    }
    Context 'Returns the instances of digits that use a unique number of segments' {
        it 'Returns 26' {
            Get-aocUniqueSegments $data | should -Be 26
        }
    }
}

describe 'Resolve-aocSignalWireMapping' {
    BeforeAll {
        $data = import-aocData -day 8 -dummy
    }
    Context 'Decodes the output value of each signal pattern' {
        it 'Adding all of the output values produceses 61229' {
            (Resolve-aocSignalWireMapping $data | Measure-Object -Sum).Sum | Should -Be 61229
        }
    }
}