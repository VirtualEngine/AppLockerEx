<#
    .SYNOPSIS
        Adds default AppLocker rules to an XmlElement node.
#>
function Add-AppLockerPolicyDefaultRuleset {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateSet('AuditOnly','Enabled','NotConfigured')]
        [System.String] $EnforcementMode
    )
    process {

        Set-AppLockerPolicyEnforcementMode -AppLockerPolicyDocument $AppLockerPolicyDocument -EnforcementMode $EnforcementMode

        $addAppLockerPolicyPublisherRuleParams1 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = 'a9e18c21-ff8f-43cf-b9fc-db40eed693ba';
            Name = '(Default Rule) All signed packaged apps';
            Description = 'Allows members of the Everyone group to run packaged apps that are signed.'
            UserOrGroupSid = 'S-1-1-0';
            Action = 'Allow';
            Publisher = '*';
            ExactBinaryVersion = '*';
            Collection = 'Appx';
        }
        Add-AppLockerPolicyPublisherRule @addAppLockerPolicyPublisherRuleParams1;

        $addAppLockerPolicyPathRuleParams1 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = '921cc481-6e17-4653-8f75-050b80acca20';
            Path = '%PROGRAMFILES%\*';
            Name = '(Default Rule) All files located in the Program Files folder';
            Description = 'Allows members of the Everyone group to run applications that are located in the Program Files folder.'
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Collection = 'Exe';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams1;

        $addAppLockerPolicyPathRuleParams2 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = 'a61c8b2c-a319-4cd0-9690-d2177cad7b51';
            Path = '%WINDIR%\*';
            Name = '(Default Rule) All files located in the Windows folder';
            Description = 'Allows members of the Everyone group to run applications that are located in the Windows folder.'
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Collection = 'Exe';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams2;

        $addAppLockerPolicyPathRuleParams3 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = 'fd686d83-a829-4351-8ff4-27c7de5755d2';
            Path = '*';
            Name = '(Default Rule) All files';
            Description = 'Allows members of the local Administrators group to run all applications.'
            UserOrGroup = 'S-1-5-32-544';
            Action = 'Allow';
            Collection = 'Exe';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams3;

        $addAppLockerPolicyPublisherRuleParams2 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = 'b7af7102-efde-4369-8a89-7a6a392d1473';
            Name = '(Default Rule) All digitally signed Windows Installer files';
            Description = 'Allows members of the Everyone group to run digitally signed Windows Installer files.'
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Publisher = '*';
            ExactBinaryVersion = '*';
            Collection = 'Msi';
        }
        Add-AppLockerPolicyPublisherRule @addAppLockerPolicyPublisherRuleParams2;

        $addAppLockerPolicyPathRuleParams4 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = '5b290184-345a-4453-b184-45305f6d9a54';
            Path = '%WINDIR%\Installer\*';
            Name = '(Default Rule) All Windows Installer files in %systemdrive%\Windows\Installer';
            Description = 'Allows members of the Everyone group to run all Windows Installer files located in %systemdrive%\Windows\Installer.'
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Collection = 'Msi';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams4;

        $addAppLockerPolicyPathRuleParams5 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = '64ad46ff-0d71-4fa0-a30b-3f3d30c5433d';
            Path = '*.*';
            Name = '(Default Rule) All Windows Installer files';
            Description = 'Allows members of the local Administrators group to run all Windows Installer files.'
            UserOrGroup = 'S-1-5-32-544';
            Action = 'Allow';
            Collection = 'Msi';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams5;

        $addAppLockerPolicyPathRuleParams6 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = '06dce67b-934c-454f-a263-2515c8796a5d';
            Path = '%PROGRAMFILES%\*';
            Name = '(Default Rule) All scripts located in the Program Files folder';
            Description = 'Allows members of the Everyone group to run scripts that are located in the Program Files folder.'
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Collection = 'Script';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams6;

        $addAppLockerPolicyPathRuleParams7 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = '9428c672-5fc3-47f4-808a-a0011f36dd2c';
            Path = '%WINDIR%\*';
            Name = '(Default Rule) All scripts located in the Windows folder';
            Description = 'Allows members of the Everyone group to run scripts that are located in the Windows folder.';
            UserOrGroup = 'S-1-1-0';
            Action = 'Allow';
            Collection = 'Script';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams7;

        $addAppLockerPolicyPathRuleParams8 = @{
            AppLockerPolicyDocument = $AppLockerPolicyDocument;
            Id = 'ed97d0cb-15ff-430f-b82c-8d7832957725';
            Path = '*';
            Name = '(Default Rule) All scripts';
            Description = 'Allows members of the local Administrators group to run all scripts.';
            UserOrGroup = 'S-1-5-32-544';
            Action = 'Allow';
            Collection = 'Script';
        }
        Add-AppLockerPolicyPathRule @addAppLockerPolicyPathRuleParams8;

    } #end process
} #end function
