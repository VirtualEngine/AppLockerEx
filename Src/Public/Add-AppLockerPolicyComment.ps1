function Add-AppLockerPolicyComment {
<#
    .SYNOPSIS
        Adds a comment to an AppLocker policy docoument.
    .EXAMPLE
        Add-AppLockerPolicyComment -AppLockerPolicyDocument $appLockerPolicy -Comment 'Created by AppLockerEx'

        Prepends the 'Created by AppLockerEx' comment to the AppLocker policy [XmlDocument] in the '$appLockerPolicy' variable.
#>
    [CmdletBinding()]
    param (
        ## AppLocker XmlDocument to prepend the comment to.
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('XmlDocument')]
        [System.Xml.XmlDocument] $AppLockerPolicyDocument,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Comment,

        ## Returns the created XmlElement object to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        try
        {
            $appLockerPolicyElement = $AppLockerPolicyDocument.SelectSingleNode("/AppLockerPolicy");
            XmlComment -Comment $Comment -XmlElement $appLockerPolicyElement -Prepend -PassThru:$PassThru
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    } #process
} #function
