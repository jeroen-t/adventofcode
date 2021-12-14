BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

describe 'Functions should flash the dumbo octopus population' {
    BeforeAll {
        $data = import-aocData -day 10 -dummy
        $octopus = Get-aocDumboStartState $data
        $flash = 0
        Step-aocDumboOctopus -day 100
        $flash
    }
    Context 'Should returns the amount of flashes after X days' {
        it 'After 100 steps, there should have been a total of 1656 flashes' {
            $flash | should -Be 1656
        }
    }
}