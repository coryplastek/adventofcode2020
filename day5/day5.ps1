[CmdletBinding()]
param(
    $Path = 'input.txt'
) # end param

$passes = Get-Content -Path $Path
Write-Verbose -Message "$($passes.Count) boarding passes"

$maxSeatId, $missingSeatId = 0, 0
$seatIds = New-Object -TypeName System.Collections.Generic.HashSet[int]

$passes.foreach{
    # translate first seven characters to row number
    # F = 0, B = 1
    $row = [Convert]::ToInt32( $_.Substring(0,7).Replace('F',0).Replace('B',1), 2)

    # translate last three characters to seat number
    # R = 1, L = 0
    $column = [Convert]::ToInt32( $_.Substring(7).Replace('L',0).Replace('R',1), 2)

    $seatId = ( $row * 8 ) + $column
    [void]$seatIds.Add($seatId)

    if( $seatId -gt $maxSeatId ) { $maxSeatId = $seatId }
}

$seatIds.foreach{
    # if there's a missing seat id +1 from the current one, and the seat +2 is occupied, this could be our seat
    if( (-not $seatIds.Contains($_+1)) -and $seatIds.Contains($_+2) ) {
        $missingSeatId = $_+1
        Write-Verbose -Message "$missingSeatId is my seat!"
    }
}

Write-Output "Part 1 - max seat ID: $maxSeatId"
Write-Output "Part 2 - my seat id: $missingSeatId"