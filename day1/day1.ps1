[CmdletBinding()]
param(
    $Path = 'input.txt'
) # end param

$desiredSum = 2020

$entries = (Get-Content -Path $Path).foreach{ $_ -as [int] }
Write-Verbose "$Path has $($entries.Count) entries"

$i, $j, $sum, $iterations = 0, 0, 0, 0

:outer foreach( $i in $entries ) {
    foreach( $j in $entries ) {
        $iterations += 1
        $sum = $i + $j

        if( $sum -eq $desiredSum ) {
            Write-Debug -Message ("{0}: {1} + {2} = {3} in {4} iterations" -f $iterations, $i, $j, $sum, $iterations)
            break outer
        }
    }
}

Write-Host "Part 1:"
Write-Host ("{0} * {1} = $($i * $j) in {2} iterations" -f $i, $j, $iterations)

$iterations = 0
:outer foreach( $k in $entries ) {
    foreach( $l in $entries ) {
        if( $k + $m -lt $desiredSum ) {
            foreach( $m in $entries ) {
                $iterations += 1
                $sum = $k + $l + $m

                if( $sum -eq $desiredSum ) {
                    Write-Debug -Message ("{0}: {1} + {2} + {3} = {4} in {5} iterations" -f $iterations, $k, $l, $m, $sum, $iterations)
                    break outer
                }
            }
        }
    }
}

Write-Host ""
Write-Host "Part 2:"
Write-Host ("{0} * {1} * {2} = $($k * $l * $m) in {3} iterations" -f $k, $l, $m, $iterations)