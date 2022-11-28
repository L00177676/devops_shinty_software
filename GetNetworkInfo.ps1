# Region Get-NetworkInfo
<#
    .Synopsis
     Get Network Info
    .DESCRIPTION
     This function will get detailed network information
    .PARAMETERS
     $ComputerName: A Valid Computer Name or IP Address
#>
    function Get-NetworkInfo {
        [CmdletBinding()]
        [Alias()]
        [OutputType([array])]
        Param(
            # TODO: students - fix this
            # a parameter should be added here for the string variable named 
            $ComputerName
        )
        $networkInformationArray = @()
        try {
            $networkInfo = Test-NetConnection -InformationLevel Detailed -
            ComputerName $computerName 
            $networkInfoOutput = [ordered]@{
                ComputerName          = $networkInfo.ComputerName
                RemoteAddress         = $networkInfo.RemoteAddress
                NameResolutionResults = $networkInfo.NameResolutionResults
                InterfaceAlias        = $networkInfo.InterfaceAlias
                SourceAddress         = $networkInfo.SourceAddress
                NetRoute              = $networkInfo.NetRoute
                PingSucceeded         = $networkInfo.PingSucceeded
                PingReplyDetails      = $networkInfo.PingReplyDetails 
            }
            $networkInformationArray = New-Object -TypeName PSObject -
            Property $networkInfoOutput
        }
        catch { 
            $networkInfo = Test-NetConnection -InformationLevel Detailed -
            ComputerName $computerName 
            $networkInfoOutput = [ordered]@{
                ComputerName          = $networkInfo.ComputerName
                RemoteAddress         = "(Get-NetworkInfo) Server Error: " + 
                $_.Exception.Message + " : " + $_.FullyQualifiedErrorId
                NameResolutionResults = ""
                InterfaceAlias        = ""
                SourceAddress         = ""
                NetRoute              = ""
                PingSucceeded         = ""
                PingReplyDetails      = "" 
            }
            $networkInformationArray = New-Object -TypeName PSObject -
            Property $networkInfoOutput
        }
        return $networkInformationArray 
    }
#endregion
    
    