# Sample Input
# [System.Int32[]]$measurements = 199,200,208,210,200,207,240,269,260,263

# Actual Input
$path = Join-Path $PSScriptRoot \input\input_day1.txt
[System.Int32[]]$measurements = Get-Content -Path $path

# Day 1 - First Half

$output = for ($i = 1; $i -lt $measurements.Length; $i++) {
    if ($measurements[$i] -gt $measurements[$i-1]) {
        1
    }
}
"Day 1 - First Half answer: $(($output | Measure-Object -Sum).Sum)"

# Day 2 - Second Half

$output = for ($i = 1; $i -lt $measurements.Length-2; $i++) {
    if ($measurements[$i+2] -gt $measurements[$i-1]) {
        1
    }
}
"Day 1 - Second Half 2nd answer: $(($output | Measure-Object -Sum).Sum)"