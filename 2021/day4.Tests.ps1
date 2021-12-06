BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Get-aocBingo' {
    BeforeAll {
        $data, $numbers = Import-aocData -day 4 -dummy
    }
    Context 'Score result of the winning board' {
        BeforeAll {
            $result = Get-aocBingo -balls $data -numbers $numbers -result W
        }
        It 'Final score result should be 4512' {
            $result | Should -Be 4512
        }
    }
    Context 'Score result of the last winning board (biggest loser)' {
        BeforeAll {
            $result = Get-aocBingo -balls $data -numbers $numbers -result L
        }
        It 'Final score result should be 1924' {
            $result | Should -Be 1924
        }
    }
}