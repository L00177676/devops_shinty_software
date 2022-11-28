#Region Get-UserDetail
<#
    .Synopsis
     Get User Detail
    .DESCRIPTION
     This function will get the current user logged onto the server.
    .PARAMETERS
     $ComputerName: A Valid Computer Name or IP Address
#>
    function Get-UserDetail {
        [CmdletBinding()]
        [Alias()]
        [OutputType([array])]
        Param(
            [Parameter()]
            [string]
            $ComputerName
        )
        $serverArray = @()
        try {
            # Get the UserName logged onto the server
            $userName = (Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName).UserName
            # Add the server found to the server Array
            $server = [ordered]@{
                ComputerName = $ComputerName
                UserName     = $UserName
            }
            $serverArray = New-Object -TypeName PSObject -Property $server
        }
        catch
        { 
            $server = [ordered]@{
                ComputerName = $computerName
                UserName     = "(Get-UserDetail) Server Error: " + $_.Exception.Message + 
                " : " + $_.FullyQualifiedErrorId
            }
            $serverArray = New-Object -TypeName PSObject -Property $server
        }
        return $serverArray 
         
    }
#endRegion
    