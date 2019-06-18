$moduleManifestName = 'AppLockerEx.psd1'
$moduleManifestPath = "$PSScriptRoot\..\..\$moduleManifestName"

Describe 'Integration\AppLockerEx' {

    It 'Loads module without error' {

        { Import-Module -FullyQualifiedName $moduleManifestPath -Force } | Should Not Throw
    }

    It 'Passes Test-ModuleManifest' {

        Test-ModuleManifest -Path $moduleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}
