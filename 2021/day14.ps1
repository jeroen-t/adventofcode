function Import-aocData ([int]$day,[switch]$dummy) {
    if ($dummy.IsPresent) {
        $path = Join-Path $PSScriptRoot "..\input\2021\input_day$day`_dummy.txt"
        $data = (Get-Content $path -raw).Trim()
        [string]$template,$pairs = $data -split "\r\n\r\n"
        $pairs = $pairs -split("\r\n")
    } else {
        $path = Join-path $PSScriptRoot "..\input\2021\input_day$day`.txt"
        $data = (Get-Content $path -raw).Trim()
        [string]$template,$pairs = $data -split "\n\n"
        $pairs = $pairs -split("\n")
    }
    $patterns = @{}
    foreach($pair in $pairs) {
        $src,$dest = $pair.Split(' -> ')
        $patterns[$src] = $dest
    }
    $template,$patterns
}

$X = $($MyInvocation.MyCommand.Name).Split('.')[0] -replace "[^0-9]",''
$template,$patterns = Import-aocData -day $X #-dummy

$pair_counts = @{}
for ($i = 0; $i -lt $template.Length - 1; $i++) {
    $pair_counts[-join($template[$i..$($i+1)])] += 1
}

for ($i = 0; $i -lt 10; $i++) {
    $new_counts = @{}
    $char_counts = @{}
    foreach ($kv in $pair_counts.Keys) {
        $new_counts["$($kv[0])$($patterns[$kv])"] += $pair_counts.Item($kv)
        $new_counts["$($patterns[$kv])$($kv[1])"] += $pair_counts.Item($kv)

        $char_counts["$($kv[0])"] += $pair_counts.Item($kv)
        $char_counts["$($patterns[$kv])"] += $pair_counts.Item($kv)
    }

    $pair_counts = $new_counts
}
$char_counts["$($template[-1])"] += 1
$values = $char_counts.Values | Sort-Object
$a1 = $values[-1] - $values[0]

$pair_counts = @{}
for ($i = 0; $i -lt $template.Length - 1; $i++) {
    $pair_counts[-join($template[$i..$($i+1)])] += 1
}

for ($i = 0; $i -lt 40; $i++) {
    $new_counts = @{}
    $char_counts = @{}
    foreach ($kv in $pair_counts.Keys) {
        $new_counts["$($kv[0])$($patterns[$kv])"] += $pair_counts.Item($kv)
        $new_counts["$($patterns[$kv])$($kv[1])"] += $pair_counts.Item($kv)

        $char_counts["$($kv[0])"] += $pair_counts.Item($kv)
        $char_counts["$($patterns[$kv])"] += $pair_counts.Item($kv)
    }

    $pair_counts = $new_counts
}
$char_counts["$($template[-1])"] += 1
$values = $char_counts.Values | Sort-Object
$a2 = $values[-1] - $values[0]

"[Day $X] My answer for part 1 is: {0}, and for part 2 is: {1}." -f $a1,$a2