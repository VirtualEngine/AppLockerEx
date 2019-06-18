@{
    RootModule = 'AppLockerEx.psm1';
    ModuleVersion = '1.0.0';
    GUID = 'a735e702-e122-458e-ac05-57353dab35b2';
    Author = 'Iain Brighton';
    CompanyName = 'Virtual Engine';
    Copyright = '(c) 2019 Virtual Engine Limited. All rights reserved.';
    Description = 'Programmatcally create AppLocker Policy (XML) documents with PowerShell.';
    PowerShellVersion = '3.0';
    RequiredModules = @('AppLocker');
    FunctionsToExport = @(
                            'Add-AppLockerPolicyComment',
                            'Add-AppLockerPolicyHashRule',
                            'Add-AppLockerPolicyPathRule',
                            'Add-AppLockerPolicyPublisherRule',
                            'New-AppLockerPolicyDocument',
                            'Set-AppLockerPolicyEnforcementMode'
                        );
    PrivateData = @{
        PSData = @{
            Tags       = @('VirtualEngine','Virtual','Engine','PowerShell','AppLocker','Extension');
            LicenseUri = 'https://github.com/VirtualEngine/AppLockerEx/blob/master/LICENSE';
            ProjectUri = 'https://github.com/VirtualEngine/AppLockerEx';
        }
    }
}
