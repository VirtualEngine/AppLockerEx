$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent;

#region LocalizedData
$culture = 'en-US'
if (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath $PSUICulture)) {
    $culture = $PSUICulture
}
$importLocalizedDataParams = @{
    BindingVariable = 'localized';
    Filename = 'AppLockerEx.Resources.psd1';
    BaseDirectory = $moduleRoot;
    UICulture = $culture;
}
Import-LocalizedData @importLocalizedDataParams;
#endregion LocalizedData

## Import the \Src files. This permits loading of the module's functions for unit testing, without having to unload/load the module.
$moduleSrcPath = Join-Path -Path $moduleRoot -ChildPath 'Src';
Get-ChildItem -Path $moduleSrcPath -Include *.ps1 -Exclude '*.Tests.ps1' -Recurse |
    ForEach-Object {
        Write-Verbose -Message ('Importing library\source file ''{0}''.' -f $_.FullName);
        ## https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
        . ([System.Management.Automation.ScriptBlock]::Create(
                [System.IO.File]::ReadAllText($_.FullName)
            ));
    }

Import-Module -Name (Join-Path -Path $moduleRoot -ChildPath 'Lib\XmlEx') -Force;
