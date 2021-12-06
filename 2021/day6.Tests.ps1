BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Get-aocLanternfish' {
    BeforeAll {
        $data = Import-aocData -day 6 -dummy
    }
    Context 'Population after 80 days' {
        BeforeAll {
            $result = Get-aocLanternfish -fishies $data -days 80
        }
        It 'Result should be a total of 5934 lanternfish' {
            $result | Should -Be 5934
        }
    }
    Context 'Population after 256 days' {
        BeforeAll {
            $result = Get-aocLanternfish -fishies $data -days 256
        }
        It 'Result should be a total of 26984457539 lanternfish' {
            $result | Should -Be 26984457539
        }
    }
}