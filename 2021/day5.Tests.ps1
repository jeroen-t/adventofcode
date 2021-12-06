BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Get-aocVents' {
    BeforeAll {
        $entries = Import-aocData -dummy
    }
    Context 'Considering only horizontal and vertical lines' {
        BeforeAll {
            $result = Get-aocVents -entries $entries -direction NonDiag
        }
        It 'Returns a total of 5 points' {
            $result | Should -Be 5
        }
    }
    Context 'Considering all lines' {
        BeforeAll {
            $result = Get-aocVents -entries $entries -direction All
        }
        It 'Returns a total of 12 points' {
            $result | Should -Be 12
        }
    }
}