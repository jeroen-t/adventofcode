BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'New-aocTransparentPaperFold' {
    BeforeAll {
        $data = import-aocData -day 13 -dummy
        $instructions = $data.instructions
        $dots = Get-aocDots $data.data
    }
    Context 'Returns the amount of dots after X folds' {
        it 'Returns 17 visible dots' {
            New-aocTransparentPaperFold -dots $dots -instructions $instructions[0] | should -Be 17
        }
    }
}