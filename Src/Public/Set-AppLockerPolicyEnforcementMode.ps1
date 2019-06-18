<#
    .SYNOPSIS
        Sets the AppLocker policy document rule enforcement mode on the specified collection(s).
#>
function Set-AppLockerPolicyEnforcementMode
{
    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param (
        ## AppLocker XmlDocument to prepend the comment to.
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('AuditOnly','Enabled','NotConfigured')]
        [System.String] $EnforcementMode,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Appx','Dll','Exe','Msi','Script')]
        [System.String[]] $Collection = @('Appx','Dll','Exe','Msi','Script')
    )
    process
    {
        try
        {
            foreach ($ruleCollection in $Collection)
            {
                $appLockerPolicyElement = $AppLockerPolicyDocument.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='$Collection']");
                if ($null -eq $AppLockerPolicyElement)
                {
                    $appLockerPolicyElement = Add-XmlExElement -Name RuleCollection -XmlElement $AppLockerPolicyDocument.FirstChild -PassThru {
                        Add-XmlExAttribute -Name Type -Value $ruleCollection;
                        Add-XmlExAttribute -Name EnforcementMode -Value $EnforcementMode;
                    }
                }
                else
                {
                    $null = $appLockerPolicyElement.SetAttribute('EnforcementMode', $EnforcementMode)
                }
            } #foreach ruleCollection
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    } #process
} #function
