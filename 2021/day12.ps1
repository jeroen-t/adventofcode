function Import-aocData {
    Param (
        [int]$day,
        
        [switch]$dummy,
        
        [ValidateSet(1,2,3)]
        [int]$sample = 1
    )
    if ($dummy.IsPresent) {
        switch($sample)
        {   
            1 { $n = $null  }
            2 { $n = 2      }
            3 { $n = 3      }
        }
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy$n`.txt"
        $data = Get-Content $path
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = Get-Content $path
    }
    Write-Output $data
}

function Get-aocEdges ([string[]]$data){
    $edges = @{}
    foreach ($line in $data) {
        $src,$dest = $line.Split('-')
        if ($edges[$src]) {
            $edges.$src += $dest
        } elseif ($src) {
            $edges.$src= @()
            $edges.$src += $dest
        }
        if ($edges[$dest]) {
            $edges.$dest += $src
        } else {
            $edges.$dest = @()
            $edges.$dest += $src
        }
        $edges.Remove('end')
    }
    $edges
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$data = Import-aocData -day $X #-dummy

$edges = Get-aocEdges $data

#$allpaths = @()
$allpaths = 0
$todo = New-Object System.Collections.Queue
$todo.Enqueue(@('start'))
while($todo.Count -ne 0) {
    $path = $todo.Dequeue()

    if ($path[-1] -eq 'end') {
        #$allpaths += $path
        $allpaths ++
        continue
    }

    foreach ($cand in $edges[$path[-1]]) {
        if (-not($cand -ceq $cand.ToLower()) -or -not($cand -in $path)) {
            $todo.Enqueue(@($path) + @($cand))
        }
    }
}
$a1 = $allpaths
$a1

#$allpaths = @()
$allpaths = 0
$todo = New-Object System.Collections.Queue
$todo.Enqueue(@('start'))
while($todo.Count -ne 0) {
    $path = $todo.Dequeue()

    if ($path[-1] -eq 'end') {
        #$allpaths += $path
        $allpaths ++
        continue
    }

    foreach ($cand in $edges[$path[-1]]) {
        if (-not($cand -ceq $cand.ToLower())) {
            $todo.Enqueue(@($path) + @($cand))
        } elseif (-not($cand -in $path) -or $double_cave[$cand]) {
            if (-not($double_cave[$cand]) -and $cand -ne 'start') {
                $double_cave = @{}
                $double_cave.add($cand,$true)
                $todo.Enqueue(@($path) + @($cand))
            } elseif ($double_cave[$cand] -and ($path.Where({$_ -eq $double_cave},'Default')).count -eq 1) {
                $todo.Enqueue(@($path) + @($cand))
                $double_cave[$cand] = $false
                #continue
            } else { 
                $todo.Enqueue(@($path) + @($cand))
            }
        }
    }
}
$a2 = $allpaths
$a2

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2