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
$data = Import-aocData -day $X -dummy

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




$allpaths = @()
#$allpaths = 0
$todo = New-Object System.Collections.Queue
$todo.Enqueue(@('start'))
while($todo.Count -ne 0) {
    $path = $todo.Dequeue()

    if ($path[-1] -eq 'end') {
        $allpaths += $path
        #$allpaths ++
        $double_cave = $null
        continue
    }

    foreach ($cand in $edges[$path[-1]]) {
        if (-not($cand -ceq $cand.ToLower())) { #uppercase mag zo vaak als ie wil
            $todo.Enqueue(@($path) + @($cand))
        } elseif (-not($cand -in $path) -or $cand -ceq $double_cave) { #niet uppercase, lowercase nog niet aan de beurt geweest of double cave
            if ($null -eq $double_cave -and $cand -ne 'start') { # nog geen double cave en niet 'start'
                $double_cave = $cand
                $todo.Enqueue(@($path) + @($cand))
            } elseif ($cand -ceq $double_cave -and ($path.Where({$_ -eq $double_cave},'Default')).count -eq 1) { # cand is double cave en double gave is 1 keer eerder geweest
                $todo.Enqueue(@($path) + @($cand))
                continue
                #$double_cave = $null
            } else { 
                $todo.Enqueue(@($path) + @($cand))
            }
        }
    }
}
$a2 = $allpaths
$a2



   
# #$allpaths = 0
# $allpaths = @()
# $todo = New-Object System.Collections.Queue
# $todo.Enqueue((@('start'),$false))
# while($todo.Count -ne 0) {
#     $path, $double_cave = $todo.Dequeue()

#     if ($path[-1] -eq 'end') {
#         $allpaths += $path
#         #$allpaths ++
#         continue
#     }

#     foreach ($cand in $edges[$path[-1]]) {
#         if ($cand -eq 'start') {
#             continue
#         } elseif ($cand -ceq $cand.ToUpper() -or $cand -notin $path) {
#             $todo.Enqueue(($path + @($cand), $double_cave))
#         } elseif (-not($double_cave) -and ($path.Where({$_ -eq $cand},'Default').count) -eq 1) {
#             $todo.Enqueue(($path + @($cand), $true))
#         }
#     }
# }
# #$a2 = $allpaths
# $allpaths

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2