[CmdletBinding()]
param(
    $Path = 'input.txt'
) # end param

$map = Get-Content -Path $Path
Write-Verbose "$Path has $($map.Count) rows"

$lineLength = $map[0].Length

$slopes = @(
    @{ xSlope = '3'; ySlope = '1' }
    @{ xSlope = '1'; ySlope = '1' }
    @{ xSlope = '5'; ySlope = '1' }
    @{ xSlope = '7'; ySlope = '1' }
    @{ xSlope = '1'; ySlope = '2' }
)

foreach( $slope in $slopes ) {

    $trees = 0
    $xSlope = $slope['xSlope']
    $ySlope = $slope['ySlope']

    for( ($x = 0), ($y = 0); $y -lt $map.Count; ($x += $xSlope), ($y += $ySlope) ) {
        $line = $map[$y]

        # increment trees by 1 if the current coordinates in the map is a # character
        # the map pattern repeats, so we'll determine the current x position with modulus artithmetic
        $mapX = $x % $lineLength
        $xChar = $line[$mapX]

        switch ($xChar) {
            '#' {
                $trees += 1
            }

            default {}
        }
        Write-Debug "$x,$y => $mapX = $xChar`: $altLine"
    }

    $slope['trees'] = $trees
}

Write-Output "Part 1: $($slopes[0]['trees']) trees"

$part2 = 1
$slopes.foreach{ $part2 *= $_.trees }
Write-Output "Part 2: $part2"