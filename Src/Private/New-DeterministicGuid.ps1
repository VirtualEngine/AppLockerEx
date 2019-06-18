function New-DeterministicGuid {
<#
    .SYNOPSIS
        Creates a deterministic Guid
    .DESCRIPTION
        The New-DeterministicGuid cmdlet generates a consistent 'Guid'
        from the seed value supplied.
    .EXAMPLE
        New-DeterministicGuid -Seed "ConfigurationA"
#>
    [CmdletBinding()]
    [OutputType([System.Guid])]
    Param (
        # Deterministic seed
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [AllowNull()]
        [System.String] $Seed = $null,

        # Case sensitive seed
        [System.Management.Automation.Switch] $CaseSensitive
    )
    process {

        if ([System.String]::IsNullOrEmpty($Seed)) {

            [System.Guid]::NewGuid();
        }
        else {

            if ($CaseSensitive) {

                $Seed = $Seed.ToUpper();
            }

            Write-Verbose -Message ("Generating deterministic Guid from seed '{0}'." -f $Seed);
            $md5 = [System.Security.Cryptography.MD5]::Create();
            New-Object System.Guid(,$md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Seed)));
        }

    } #end process
} #end function
