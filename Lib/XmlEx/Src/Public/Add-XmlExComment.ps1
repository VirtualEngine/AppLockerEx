function Add-XmlExComment {
<#
    .SYNOPSIS
        Adds a XmlComment
    .DESCRIPTION
        The Add-XmlExComment cmdlet adds a System.Xml.XmlComment to a XmlEx
        document or existing System.Xml.XmlDocument object.
#>
    [CmdletBinding(DefaultParameterSetName = 'XmlEx')]
    [Alias('XmlComment')]
    [OutputType([System.Xml.XmlComment])]
    param (
        ## Comment to insert into the Xml document
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlEx')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = 'XmlElement')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Comment,

        ## Existing Xml element to add the comment to
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'XmlElement')]
        [ValidateNotNull()]
        [System.Xml.XmlElement] $XmlElement,

        ## Adds the comment as the first child of the specified element.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Prepend,

        ## Returns the XmlComment to the pipeline. By default, this cmdlet does not generate any output.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'XmlElement') {

            Write-Debug ("Inferring document from element '{0}'," -f $Name);
            $_xmlExCurrentDocument = $XmlElement.OwnerDocument;
            $_xmlExCurrentElement = $XmlElement;
        }

        if ($null -eq $_xmlExCurrentDocument) {
            throw ($localized.XmlExDocumentNotFoundError);
        }

        if ($null -eq $_xmlExCurrentElement) {
            throw ($localized.XmlExElementNotFoundError);
        }

    } #end begin
    process {

        $padding = '';
        if ($_xmlExCurrentElementIndent) {
            $padding = ''.PadRight($_xmlExCurrentElementIndent +1);
        }
        $paddedMessage = '{0}{1}' -f $padding, ($localized.AddingComment -f $_xmlExCurrentElement.LocalName);
        Write-Verbose -Message $paddedMessage;

        $xmlComment = $_xmlExCurrentDocument.CreateComment($Comment);
        if ($Prepend) {
            [ref] $null = $_xmlExCurrentElement.PrependChild($xmlComment);
        }
        else {
            [ref] $null = $_xmlExCurrentElement.AppendChild($xmlComment);
        }

        if ($PassThru) {
            Write-Output -InputObject $xmlComment;
        }

    } #end process
} #end function XmlComment

# SIG # Begin signature block
# MIIX1gYJKoZIhvcNAQcCoIIXxzCCF8MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3LGGmT9ltkt2yBsGU74aoBcq
# V7ygghMJMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggUwMIIEGKADAgECAhAECRgbX9W7ZnVTQ7VvlVAIMA0GCSqGSIb3DQEBCwUAMGUx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9v
# dCBDQTAeFw0xMzEwMjIxMjAwMDBaFw0yODEwMjIxMjAwMDBaMHIxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNp
# Z25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD407Mcfw4R
# r2d3B9MLMUkZz9D7RZmxOttE9X/lqJ3bMtdx6nadBS63j/qSQ8Cl+YnUNxnXtqrw
# nIal2CWsDnkoOn7p0WfTxvspJ8fTeyOU5JEjlpB3gvmhhCNmElQzUHSxKCa7JGnC
# wlLyFGeKiUXULaGj6YgsIJWuHEqHCN8M9eJNYBi+qsSyrnAxZjNxPqxwoqvOf+l8
# y5Kh5TsxHM/q8grkV7tKtel05iv+bMt+dDk2DZDv5LVOpKnqagqrhPOsZ061xPeM
# 0SAlI+sIZD5SlsHyDxL0xY4PwaLoLFH3c7y9hbFig3NBggfkOItqcyDQD2RzPJ6f
# pjOp/RnfJZPRAgMBAAGjggHNMIIByTASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1Ud
# DwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzB5BggrBgEFBQcBAQRtMGsw
# JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcw
# AoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElE
# Um9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDov
# L2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDBP
# BgNVHSAESDBGMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93
# d3cuZGlnaWNlcnQuY29tL0NQUzAKBghghkgBhv1sAzAdBgNVHQ4EFgQUWsS5eyoK
# o6XqcQPAYPkt9mV1DlgwHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8w
# DQYJKoZIhvcNAQELBQADggEBAD7sDVoks/Mi0RXILHwlKXaoHV0cLToaxO8wYdd+
# C2D9wz0PxK+L/e8q3yBVN7Dh9tGSdQ9RtG6ljlriXiSBThCk7j9xjmMOE0ut119E
# efM2FAaK95xGTlz/kLEbBw6RFfu6r7VRwo0kriTGxycqoSkoGjpxKAI8LpGjwCUR
# 4pwUR6F6aGivm6dcIFzZcbEMj7uo+MUSaJ/PQMtARKUT8OZkDCUIQjKyNookAv4v
# cn4c10lFluhZHen6dGRrsutmQ9qzsIzV6Q3d9gEgzpkxYz0IGhizgZtPxpMQBvwH
# gfqL2vmCSfdibqFT+hKUGIUukpHqaGxEMrJmoecYpJpkUe8wggU4MIIEIKADAgEC
# AhAPxQCJrE9ObGzkCRS7EwyyMA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25p
# bmcgQ0EwHhcNMTcwNTI2MDAwMDAwWhcNMTkwOTI3MTIwMDAwWjB1MQswCQYDVQQG
# EwJHQjETMBEGA1UECBMKR2Fyc2luZ3RvbjEPMA0GA1UEBxMGT3hmb3JkMR8wHQYD
# VQQKExZWaXJ0dWFsIEVuZ2luZSBMaW1pdGVkMR8wHQYDVQQDExZWaXJ0dWFsIEVu
# Z2luZSBMaW1pdGVkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnB1O
# DV2jw/aMIUWnD9f9RCbAoiJ8LQcznYo42P22YEi6g7QY+kKmAzGgEhbsE4UVuGWS
# el4y6FxGWq51SK5P/gqgZgzyP8FkIUzLxsCrtx9OBnsPPeL+/An5CpcsKsl2lCSz
# NMwcz16hjcE0vCLio1NOcwvfO65qdNT2gRIEnIYhRX88dG3V30BH2aKWG5X9t1IW
# RmozjZ8I7iLEoWFJWQSuICSGyvyiPqnXF3nxdroE8O4fc1U90x5qefX0RlwKeq47
# UFuI0Y/59pB3/jss5BYvAXp3g+6EKlDwgW1a/MLVsLQbdzlALFUv5YxEqkXA8IEM
# xpwgBjm117SmyZ98QQIDAQABo4IBxTCCAcEwHwYDVR0jBBgwFoAUWsS5eyoKo6Xq
# cQPAYPkt9mV1DlgwHQYDVR0OBBYEFL5NkOqMm0S8AyuXI1EZIdoK9DD/MA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzB3BgNVHR8EcDBuMDWgM6Ax
# hi9odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLWNzLWcxLmNy
# bDA1oDOgMYYvaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1j
# cy1nMS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAwEwKjAoBggrBgEFBQcCARYc
# aHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwgYQGCCsGAQUF
# BwEBBHgwdjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME4G
# CCsGAQUFBzAChkJodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRT
# SEEyQXNzdXJlZElEQ29kZVNpZ25pbmdDQS5jcnQwDAYDVR0TAQH/BAIwADANBgkq
# hkiG9w0BAQsFAAOCAQEAQC8qzSz1bIoEqbjDx3VtYDjtUjuFEVDFYi9+vREl6jM+
# iqOiNiwCXUkbxGTuDrWW9I1YOn8a7SCCYapZ+T0G3RMa+rQHXFYKbYTmXC3C41Cd
# MQzZn4wTuGRNQLTgNSuclwMnNmFVe7K5S/0Dv+GaLSKuRLAxpcPxeTtmRZIIBXF7
# wwRS0+V28jB9VyeSOdqsPIFYf5GSfu7KcIhmNQ/DUroulaS5JIrPUhwkf1LZMm0B
# /0adpaPbFy95M1emij96rrgy2hX8N/FrWBh13/81V6NO3b8mhCfjqb632dG4EUTi
# FXDvqP2hpWw0nO/pFZsMsEK88eiV93XDDEG/MjAApzGCBDcwggQzAgEBMIGGMHIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJ
# RCBDb2RlIFNpZ25pbmcgQ0ECEA/FAImsT05sbOQJFLsTDLIwCQYFKw4DAhoFAKB4
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFAMXVPYqYw3Rvv7An/cRtIjo55scMA0GCSqGSIb3DQEBAQUABIIBAEWRX/pU
# ROiCaT1JHlPri5Oi/zhjQCJ09u3EMoqfetS931xiLjZDcp31cDSBuekFVg8BAUL+
# UHsfunUykkGRZVX7SKol+EpHTSNTF8OkQpROsOKwaKaeooWPJ6zkaeE6W8I7Mr7W
# JzMM8HTQjNst8+B38eH2vj46ev73b29l5o9pHXLc/m0zGW3q52M+uvBmU6nan7Fg
# +BTCn8gDputj01i7hkOM7yPb0zU3h1TjylZA2d948YTOGCkM5sYlNdQeqR/NAYbY
# EClnVlKDSRNUCODk/fZHZzQfWXSTwRFMH6siultTPMhNjT+Pf9YFg+WyHVsjjdUz
# QAlanAGa5WRwWdyhggILMIICBwYJKoZIhvcNAQkGMYIB+DCCAfQCAQEwcjBeMQsw
# CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNV
# BAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMgIQDs/0
# OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3
# DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkwNjE4MTY1NzE3WjAjBgkqhkiG9w0BCQQx
# FgQUE3uRjbpRkqPCQDskwLvzRYCqrrYwDQYJKoZIhvcNAQEBBQAEggEAIYFXOC/D
# 42L6kGZ/v62d2FeHrnhOAMcgAU1eqLN6gmDt6tI52xvWBfaJtrMxhtXhNsExLR4l
# BBtMZH9Shw7l67NICybYgYkhRrbmpswBGwOqBFwnkSs3sBlNfvsdV7zTiUcVBL6U
# MbCNpXlJsehy85b2x+vm1+GWqBW5IMcHvpgVTQCyV91ywVxyBOMeshbsYtsGKGEM
# uLDAYxfGQWv7UjuMTsqm6K4HRaSEfpk72G8SwjOATYeCs2I7DXSyYuHYi4oxppms
# /T0wcQPNxJ0ZHLJAha2Rb62kxzcBOkNw+SSJm/CzaqopFvdOSriYTgq+3Uz4j7qY
# s5jTkPCKna8FdA==
# SIG # End signature block