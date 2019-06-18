function Add-AppLockerPolicyPublisherRule {
<#
    .SYNOPSIS
        Adds an AppLocker policy publisher rule to an AppLocker policy document.
    .DESCRIPTION
        Adds a publisher rule to an existing AppLocker policy document [XmlDocument]. If not specified, publisher
        authorizations are only applied to the 'Exe' rule collection and by default allowed for all users ('S-1-1-0).
    .EXAMPLE
        Add-AppLockerPolicyPublisherRule -AppLockerPolicyDocument $appLockerPolicy -Name 'BadApp 1.0.0: BAD.exe' -Publisher 'O=VIRTUAL ENGINE LIMITED, L=OXFORD, S=GARSINGTON, C=GB'

        Adds the 'O=VIRTUAL ENGINE LIMITED, L=OXFORD, S=GARSINGTON, C=GB' publisher rule to the 'Exe' rule collection to the AppLocker policy [XmlDocument] in the '$appLockerPolicy' variable.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlDocumentMinimum')]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlDocumentExact')]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlDocumentMaximum')]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'XmlDocumentMinimumMaximum')]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Publisher,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Id = ([System.Guid]::NewGuid().ToString()),

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $ProductName = '*',

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $BinaryName = '*',

        [Parameter(Mandatory, ParameterSetName = 'XmlDocumentMinimum')]
        [Parameter(Mandatory, ParameterSetName = 'XmlDocumentMinimumMaximum')]
        [System.String] $MinimumBinaryVersion,

        [Parameter(Mandatory, ParameterSetName = 'XmlDocumentExact')]
        [System.String] $ExactBinaryVersion,

        [Parameter(Mandatory, ParameterSetName = 'XmlDocumentMaximum')]
        [Parameter(Mandatory, ParameterSetName = 'XmlDocumentMinimumMaximum')]
        [System.String] $MaximumBinaryVersion,

        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $UserOrGroupSid = 'S-1-1-0',

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
                $appLockerPolicyElement = Add-XmlExElement -Name RuleCollection -XmlElement $AppLockerPolicyDocument.FirstChild -PassThru {
                    Add-XmlExAttribute -Name Type -Value $Collection;
                    Add-XmlExAttribute -Name EnforcementMode -Value 'NotConfigured';
                }
            }

            Add-XmlExElement -Name 'FilePublisherRule' -XmlElement $appLockerPolicyElement -PassThru:$PassThru {
                Add-XmlExAttribute -Name 'Id' -Value $Id;
                Add-XmlExAttribute -Name 'Name' -Value $Name;
                Add-XmlExAttribute -Name 'Description' -Value $Description;
                Add-XmlExAttribute -Name 'UserOrGroupSid' -Value $UserOrGroupSid;
                Add-XmlExAttribute -Name 'Action' -Value $Action;
                Add-XmlExElement -Name 'Conditions' {
                    Add-XmlExElement -Name 'FilePublisherCondition' {
                        Add-XmlExAttribute -Name 'PublisherName' -Value $Publisher;
                        Add-XmlExAttribute -Name 'ProductName' -Value $ProductName;
                        Add-XmlExAttribute -Name 'BinaryName' -Value $BinaryName;
                        Add-XmlExElement -Name 'BinaryVersionRange' {
                            if ($MinimumBinaryVersion -and $MaximumBinaryVersion) {
                                Add-XmlExAttribute -Name 'LowSection' -Value $MinimumBinaryVersion;
                                Add-XmlExAttribute -Name 'HighSection' -Value $MaximumBinaryVersion;
                            }
                            elseif ($MinimumBinaryVersion) {
                                Add-XmlExAttribute -Name 'LowSection' -Value $MinimumBinaryVersion;
                                Add-XmlExAttribute -Name 'HighSection' -Value '*';
                            }
                            elseif ($ExactBinaryVersion) {
                                Add-XmlExAttribute -Name 'LowSection' -Value $ExactBinaryVersion;
                                Add-XmlExAttribute -Name 'HighSection' -Value $ExactBinaryVersion;
                            }
                            elseif ($MaximumBinaryVersion) {
                                Add-XmlExAttribute -Name 'LowSection' -Value '*';
                                Add-XmlExAttribute -Name 'HighSection' -Value $MaximumBinaryVersion;
                            }
                            else {
                                Add-XmlExAttribute -Name 'LowSection' -Value '*';
                                Add-XmlExAttribute -Name 'HighSection' -Value '*';
                            }
                        } #binaryVersionRange
                    } #filePublisherCondition
                } #conditions
            } #filePublisherRule
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    } #process
} #function
