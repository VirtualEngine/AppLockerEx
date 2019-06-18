$moduleManifestName = 'AppLockerEx.psd1'
$moduleManifestPath = "$PSScriptRoot\..\..\..\..\$moduleManifestName"
Import-Module -FullyQualifiedName $moduleManifestPath -Force

Describe 'Unit\New-AppLockerPolicyDocument' {

    It 'Creates [XmlDocument]' {

        $result = New-AppLockerPolicyDocument

        $result -is [System.Xml.XmlDocument] | Should Be $true
        $result.AppLockerPolicy -is [System.Xml.XmlElement] | Should Be $true
    }

    It 'Creates default ruleset' {

        $result = New-AppLockerPolicyDocument -CreateDefaultRuleset -EnforcementMode Enabled

        $result.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='Appx']") -is [System.Xml.XmlElement] | Should Be $true
        $result.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='Exe']") -is [System.Xml.XmlElement] | Should Be $true
        $result.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='Msi']") -is [System.Xml.XmlElement] | Should Be $true
        $result.SelectSingleNode("/AppLockerPolicy/RuleCollection[@Type='Script']") -is [System.Xml.XmlElement] | Should Be $true
    }
}
