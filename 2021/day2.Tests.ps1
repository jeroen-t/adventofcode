BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $course = import-aocData -day 2 -dummy
}

Describe 'Get-aocSubmarineDirections' {
    Context 'Returns the correct results' {
        BeforeAll {
            $result = Get-aocSubmarineDirections -Course $course
        }
        it 'Returns 6 directions' {
            $result.Count | Should -Be 6
        }
        it 'Returns the correct variable types' {
            $result[0].Directions | Should -BeOfType 'string'
            $result[0].Value | Should -BeOfType 'int'
        }
    }
}

Describe 'Move-aocSubmarine' {
    BeforeAll {
        $result = Get-aocSubmarineDirections -Course $course
    }
    Context 'Has required parameters' {
        BeforeAll {
            $cmd = Get-Command -Name 'Move-aocSubmarine'
        }
        it 'Mandatory ''Directions'' parameter of type string' {
            $cmd | Should -HaveParameter 'Directions' -Type 'string' -Mandatory
        }
        it 'Mandatory ''Value'' parameter of type integer' {
            $cmd | Should -HaveParameter 'Value' -Type 'int' -Mandatory
        }
        it '(optional) ''IncludeAim'' parameter of switch type' {
            $cmd | Should -HaveParameter 'IncludeAim' -Type 'switch'
        }
    }
    Context 'Returns the correct results without aim' {
        BeforeAll {
            $result1 = $result | Move-aocSubmarine
        }
        it 'Horizontal position should be 15' {
            $result1.Horizontal | Should -be 15
        }
        it 'Depth position should be 10' {
            $result1.Depth | Should -be 10
        }
        it 'Location should be 150' {
            $result1.Location | Should -be 150
        }
    }
    Context 'Returns the correct results with aim set' {
        BeforeAll {
            $result2 = $result | Move-aocSubmarine -IncludeAim
        }
        it 'Horizontal position should be 15' {
            $result2.Horizontal | Should -be 15
        }
        it 'Depth position should be 60' {
            $result2.Depth | Should -be 60
        }
        it 'Location should be 900' {
            $result2.Location | Should -be 900
        }
    }
}