<#
    .SYNOPSIS
        Creates a new AppLocker Policy document.
#>
function New-AppLockerPolicyDocument {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Xml.XmlDocument])]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param (
        [Parameter(ParameterSetName = 'DefaultRuleset')]
        [System.Management.Automation.SwitchParameter] $CreateDefaultRuleset,

        [Parameter(Mandatory, ParameterSetName = 'DefaultRuleset')]
        [ValidateSet('AuditOnly','Enabled','NotConfigured')]
        [System.String] $EnforcementMode
    )
    process
    {
        $appLockerPolicyDocument = XmlDocument {
            XmlElement -Name AppLockerPolicy -PassThru {
                XmlAttribute -Name Version -Value '1';
            }
        }
        if ($CreateDefaultRuleset)
        {
            Add-AppLockerPolicyDefaultRuleset -AppLockerPolicyDocument $appLockerPolicyDocument -EnforcementMode $EnforcementMode;
        }
        return $appLockerPolicyDocument
    } #process
} #function
