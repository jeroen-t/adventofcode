BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocVerb' {
    BeforeAll {
        $data = import-aocData -day X -dummy
    }
    Context 'Does something' {
        it 'Returns X' {
            Get-aocVerb $data | should -Be X
        }
    }
    Context 'Does something' {
        it 'Returns X' {
            Get-aocVerb $data | should -Be X
        }
    }
}