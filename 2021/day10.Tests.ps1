BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Get-aocSyntaxScore' {
    BeforeAll {
        $data = import-aocData -day 10 -dummy
        $result = Get-aocSyntaxScore $data
    }
    Context 'Returns the syntax error score for a chunk' {
        it 'Returns a total syntax error score of 26397 for the sample error data' {
            $result.ErrorScore | should -Be 26397
        }
    }
    Context 'Returns the syntax autocompletion score for a chunk' {
        it 'Returns the winning (middle) autocompletion score with a score of 288957' {
            $result.AutoCompleteScore | should -Be 288957
        }
    }
}