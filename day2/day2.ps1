[CmdletBinding()]
param(
    $Path = 'input.txt'
) # end param

$passwords = Get-Content -Path $Path
Write-Verbose "$Path has $($passwords.Count) passwords"

$validPasswordsPart1 = New-Object -TypeName System.Collections.Generic.List[String]
$validPasswordsPart2 = New-Object -TypeName System.Collections.Generic.List[String]

foreach( $line in $passwords ) {
    $rep, $letter, $password = $line -split ':? '
    $minrep, $maxrep = $rep -split '-'
    $firstIndex = $minrep
    $secondIndex = $maxrep

    # part 1:
    # password is valid if there are between $minrep and $maxrep (inclusive)
    # repitiions of the given letter in the password
    $letterCount = ($password.ToCharArray() -match $letter).Count

    if( $letterCount -ge $minrep -and $letterCount -le $maxrep ) {
        $validPasswordsPart1.Add($password)
    }

    # part 2:
    # password is valid if the given letter is in only one of the 1-based indexes
    # provided. if it is present multiple times, the password is not valid
    $firstChar = $password[$firstIndex-1]
    $secondChar = $password[$secondIndex-1]
    $letterCount = ( ($firstChar + $secondChar).ToCharArray() -match $letter).Count

    if( ( ($firstChar -eq $letter) -or ($secondChar -eq $letter) ) -and ( $letterCount -eq 1 ) ) {
        $validPasswordsPart2.Add($password)
    }
}

Write-Host ("Part 1: There are {0} valid passwords in {1} total passwords" -f $validPasswordsPart1.Count, $passwords.Count)
Write-Host ("Part 2: There are {0} valid passwords in {1} total passwords" -f $validPasswordsPart2.Count, $passwords.Count)