[CmdletBinding()]
param(
    $Path = 'input.txt'
) # end param

function IsPassportValid {
    [CmdletBinding()]
    param(
        [String]$Passport
    )

    $ht = @{}
    $fieldSet = New-Object -TypeName System.Collections.Generic.HashSet[String]
    $Passport.replace("`r`n",' ').split().foreach{
        if( $_ -ne '' ) {
            $k, $v = $_.split(':')
            $ht.add($k, $v)
            [void]$fieldSet.Add($k)
        }
    }

    # passports need to have:
    # byr, iyr, eyr, hgt, hcl, ecl, pid, and optionally cid to be valid
    $requiredFieldSet = New-Object -TypeName System.Collections.Generic.HashSet[String]
    @( 'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid' ).foreach{ [void]$requiredFieldSet.Add($_) }

    $fieldsValidated = $fieldSet.IsSupersetOf($requiredFieldSet)
    $byrValidated = $ht.ContainsKey('byr') -and ( $ht['byr'] -match '^\d{4}$' ) -and ( ($ht['byr'] -as [int]) -in 1920..2002 )
    $iyrValidated = $ht.ContainsKey('iyr') -and ( $ht['iyr'] -match '^\d{4}$' ) -and ( ($ht['iyr'] -as [int]) -in 2010..2020 )
    $eyrValidated = $ht.ContainsKey('eyr') -and ( $ht['eyr'] -match '^\d{4}$' ) -and ( ($ht['eyr'] -as [int]) -in 2020..2030 )
    $hclValidated = $ht.ContainsKey('hcl') -and ( $ht['hcl'] -cmatch '^#[0-9a-f]{6}$' )
    $eclValidated = $ht.ContainsKey('ecl') -and ( $ht['ecl'] -in @( 'amb','blu','brn','gry','grn','hzl','oth' ) )
    $pidValidated = $ht.ContainsKey('pid') -and ( $ht['pid'] -match '^[0-9]{9}$' )
    $hgtValidated = $ht.ContainsKey('hgt') -and ( $ht['hgt'] -match '^\d+(in|cm)$' ) -and (
        ( $ht['hgt'] -like '*cm' ) ?
            ( ($ht['hgt'].trim('cm') -as [int]) -in 150..193 ) :
            ( ($ht['hgt'].trim('in') -as [int]) -in 59..76 )
    )

    [pscustomobject]@{
        'FieldsPresent' = $fieldsValidated
        'DataValid'     = $fieldsValidated -and $byrValidated -and $iyrValidated -and $eyrValidated -and $hclValidated -and $eclValidated -and -$pidValidated -and $hgtValidated
    }
}

$passports = Get-Content -Path $Path
Write-Verbose -Message "$($passports.Count) lines in passport file"

$line, $validPassportCount, $validatedPassportCount, $passportCount = 0, 0, 0, 0
$passportData = New-Object -TypeName System.Collections.Generic.List[String]
$passports.foreach{
    if( $_ -eq '' ) {
        Write-Debug "$line` is empty line: $_"
        $passportCount += 1

        $passportValidated = IsPassportValid -Passport $passportData
        if( $passportValidated.FieldsPresent ) {
            $validPassportCount += 1
        }

        if( $passportValidated.DataValid ) {
            $validatedPassportCount += 1
        }

        $passportData.Clear()
    } else {
        Write-Debug "$line` has data: $_"
        [void]$passportData.Add( $_ )
    }

    $line += 1
}

if( $null -ne $passportData ) {
    $passportCount += 1

    $passportValidated = IsPassportValid -Passport $passportData
    if( $passportValidated.FieldsPresent ) {
        $validPassportCount += 1
    }

    if( $passportValidated.DataValid ) {
        $validatedPassportCount += 1
    }
}


Write-Output "Part 1: $validPassportCount valid passports out of $passportCount passports"
Write-Output "Part 2: $validatedPassportCount validated passports out of $passportCount passports"
