function Add-AppLockerPolicyPathRule {
<#
    .SYNOPSIS
        Adds an AppLocker policy file hash rule to an AppLocker policy document.
    .DESCRIPTION
        Adds a path rule to an existing AppLocker policy document [XmlDocument]. If not specified, path authorizations
        are only applied to the 'Exe' rule collection and by default allowed for all users ('S-1-1-0).
    .EXAMPLE
        Add-AppLockerPolicyPathRule -AppLockerPolicyDocument $appLockerPolicy -Name 'BadApp 1.0.0: BAD.exe' -Path '%PROGRAMFILES%\BADAPP\BAD.exe'

        Adds the path rule to the 'Exe' rule collection to the AppLocker policy [XmlDocument] in the '$appLockerPolicy' variable.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory)]
        [System.String] $Path,

        [Parameter(Mandatory)]
        [System.String] $Name,

        [Parameter()]
        [System.String] $Id = ([System.Guid]::NewGuid().ToString()),

        [Parameter()]
        [System.String] $Description,

        [Parameter()]
        [System.String] $UserOrGroupSid = 'S-1-1-0',

        [Parameter()]
        [ValidateSet('Allow','Deny')]
        [System.String] $Action = 'Allow',

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Appx','Dll','Exe','Msi','Script')]
        [System.String] $Collection = 'Exe',

        ## Returns the created XmlElement object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        try
        {
            $appLockerPolicyElement = $AppLockerPolicyDocument.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='$Collection']");
            if ($null -eq $appLockerPolicyElement)
            {
                $appLockerPolicyElement = XmlElement -Name RuleCollection -XmlElement $AppLockerPolicyDocument.FirstChild -PassThru {
                    XmlAttribute -Name Type -Value $Collection;
                    XmlAttribute -Name EnforcementMode -Value 'NotConfigured';
                }
            }

            XmlElement -Name 'FilePathRule' -XmlElement $appLockerPolicyElement -PassThru:$PassThru {
                XmlAttribute -Name 'Id' -Value $Id;
                XmlAttribute -Name 'Name' -Value $Name;
                XmlAttribute -Name 'Description' -Value $Description;
                XmlAttribute -Name 'UserOrGroupSid' -Value $UserOrGroupSid;
                XmlAttribute -Name 'Action' -Value $Action;
                XmlElement -Name 'Conditions' {
                    XmlElement -Name 'FilePathCondition' {
                        XmlAttribute -Name 'Path' -Value $Path; ## TODO: check if its a leaf object and append '\*' if not?
                    }
                } #conditions
            } #filePathRule
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    } #process
} #function
