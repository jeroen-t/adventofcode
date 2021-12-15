BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Verb-aocNoun' {
    BeforeAll {
        $data = import-aocData -day 12 -dummy
        $edges = Get-aocEdges $data
        $result = Get-aocPossiblePaths $edges
    }
    Context 'Does something' {
        it 'Does X' {
            $result | should -Be 10
        }
    }
    Context 'Does something' {
        it 'Does X' {
            Verb-aocNoun $data | should -Be X
        }
    }
}