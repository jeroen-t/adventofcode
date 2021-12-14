BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Verb-aocNoun' {
    BeforeAll {
        $data = import-aocData -day X -dummy
    }
    Context 'Does something' {
        it 'Does X' {
            Verb-aocNoun $data | should -Be X
        }
    }
    Context 'Does something' {
        it 'Does X' {
            Verb-aocNoun $data | should -Be X
        }
    }
}