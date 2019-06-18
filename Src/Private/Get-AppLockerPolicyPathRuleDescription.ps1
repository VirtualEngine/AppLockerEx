function Get-AppLockerPolicyPathRuleDescription {
<#
    .SYNOPSIS
        Auto-generates an AppLocker policy description from rule properties.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlDocument')]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlElement')]
        [Alias('XmlElement')]
        [System.Xml.XmlElement] $AppLockerPolicyElement,

        [Parameter(Mandatory)]
        [System.String] $Path,

        [Parameter()]
        [System.String] $Name = $Path,

        [Parameter()]
        [System.String] $Id = (New-Guid).ToString(),

        [Parameter()]
        [System.String] $Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Appx','Dll','Exe','Msi','Script')]
        [System.String] $RuleType = 'Exe',

        [Parameter()]
        [System.String] $UserOrGroup = 'S-1-1-0',

        [Parameter()]
        [ValidateSet('Allow','Deny')]
        [System.String] $Action = 'Allow'
    )
    process {



    } #end process
} #end function
