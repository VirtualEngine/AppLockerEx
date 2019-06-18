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
                $appLockerPolicyElement = XmlElement -Name RuleCollection -XmlElement $AppLockerPolicyDocument.FirstChild -PassThru {
                    XmlAttribute -Name Type -Value $Collection;
                    XmlAttribute -Name EnforcementMode -Value 'NotConfigured';
                }
            }

            XmlElement -Name 'FilePublisherRule' -XmlElement $appLockerPolicyElement -PassThru:$PassThru {
                XmlAttribute -Name 'Id' -Value $Id;
                XmlAttribute -Name 'Name' -Value $Name;
                XmlAttribute -Name 'Description' -Value $Description;
                XmlAttribute -Name 'UserOrGroupSid' -Value $UserOrGroupSid;
                XmlAttribute -Name 'Action' -Value $Action;
                XmlElement -Name 'Conditions' {
                    XmlElement -Name 'FilePublisherCondition' {
                        XmlAttribute -Name 'PublisherName' -Value $Publisher;
                        XmlAttribute -Name 'ProductName' -Value $ProductName;
                        XmlAttribute -Name 'BinaryName' -Value $BinaryName;
                        XmlElement -Name 'BinaryVersionRange' {
                            if ($MinimumBinaryVersion -and $MaximumBinaryVersion) {
                                XmlAttribute -Name 'LowSection' -Value $MinimumBinaryVersion;
                                XmlAttribute -Name 'HighSection' -Value $MaximumBinaryVersion;
                            }
                            elseif ($MinimumBinaryVersion) {
                                XmlAttribute -Name 'LowSection' -Value $MinimumBinaryVersion;
                                XmlAttribute -Name 'HighSection' -Value '*';
                            }
                            elseif ($ExactBinaryVersion) {
                                XmlAttribute -Name 'LowSection' -Value $ExactBinaryVersion;
                                XmlAttribute -Name 'HighSection' -Value $ExactBinaryVersion;
                            }
                            elseif ($MaximumBinaryVersion) {
                                XmlAttribute -Name 'LowSection' -Value '*';
                                XmlAttribute -Name 'HighSection' -Value $MaximumBinaryVersion;
                            }
                            else {
                                XmlAttribute -Name 'LowSection' -Value '*';
                                XmlAttribute -Name 'HighSection' -Value '*';
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
