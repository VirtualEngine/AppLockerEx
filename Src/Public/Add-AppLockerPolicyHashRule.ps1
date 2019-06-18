function Add-AppLockerPolicyHashRule {
<#
    .SYNOPSIS
        Adds an AppLocker policy file hash rule to an AppLocker policy document.
    .DESCRIPTION
        Adds a hash rule to an existing AppLocker policy document [XmlDocument]. If not specified, hashes are only
        applied to the 'Exe' rule collection and allowed for all users ('S-1-1-0).
    .EXAMPLE
        Add-AppLockerPolicyHashRule -AppLockerPolicyDocument $appLockerPolicy -Name 'BadApp 1.0.0: BAD.exe' -Data '0x9E21F97CA6A5215E2728BBE844BF8655D22FA17EA463383E9DEACCEAA39A2FA5' -SourceFileLength 205824 -SourceFileName '%PROGRAMFILES%\BADAPP\BAD.exe -Type 'SHA256'

        Adds the specified 'Exe' rule collection SHA256 hash to the AppLocker policy [XmlDocument] in the '$appLockerPolicy' variable.
#>
    [CmdletBinding()]
    param (
        ## AppLocker XmlDocument to append the hash rule to.
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        ## AppLocker rule name.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## File hash data.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Data,

        ## Soruce file length (in bytes).
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Int32] $SourceFileLength,

        ## Source file name.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $SourceFileName,

        ## File hash type.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Type,

        ## Rule Id.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Id = ([System.Guid]::NewGuid().ToString()),

        ## Rule description.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Description,

        ## Windows Security Identifier to apply the rule to.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $UserOrGroupSid = 'S-1-1-0',

        ## Permit or restrict execution of the file.
        [Parameter(ValueFromPipelineByPropertyName)]
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

            XmlElement -Name FileHashRule -XmlElement $appLockerPolicyElement -PassThru:$PassThru {
                XmlAttribute -Name 'Id' -Value $Id;
                XmlAttribute -Name 'Name' -Value $Name;
                XmlAttribute -Name 'Description' -Value $Description;
                XmlAttribute -Name 'UserOrGroupSid' -Value $UserOrGroupSid;
                XmlAttribute -Name 'Action' -Value $Action;
                XmlElement -Name 'Conditions' {
                    XmlElement -Name 'FileHashCondition' {
                        XmlElement -Name 'FileHash' {
                            XmlAttribute -Name 'Type' -Value $Type;
                            XmlAttribute -Name 'Data' -Value $Data;
                            XmlAttribute -Name 'SourceFileName' -Value $SourceFileName;
                            XmlAttribute -Name 'SourceFileLength' -Value $SourceFileLength;
                        }
                    } #end FileHashCondition
                } #end Conditions
            } #end FilePathRule
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    } #process
} #function
