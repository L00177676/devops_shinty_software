<#
    .Synopsis
    Networking(PowerShell) 
    .DESCRIPTION
    This script will run several network tests commands and display an exception 
    if the server is not configured to receive Inbound calls or added as a 
    TrustedHost. 
    The following needs to be configured on each server
    1. Run Enable-PSRemoting
    2. Windows Remote Management (HTTP-In) needs to be enables, use NetFirewallRule to set the firewall rules.
    3. Configure WinRM and allow your client PC as a TrustedHost
    4. Run Test-WsMan ComputerName to test if WinRM is correctly setup
    NOTE: Please update the IPAddresses.txt file with your own IP addresses or 
    Computer Names, and also ensure that you have the Settings.ini file.
    
    .EXAMPLE
    Another example of how to use this cmdlet when using multiple servers
    . .\NetworkTests.ps1
    .NOTES
    Filename: NetworkTests.ps1
    Setting File: Settings.ini 
#>

Get-Content ".\Settings.ini" | foreach-object 
Begin { 
    $settings = @{} 
} Process { 
    $k = [regex]::split($_, '='); if (($k[0].CompareTo("") -ne 0) -and 
        ($k[0].StartsWith("[") -ne $True)) { $settings.Add($k[0], $k[1]) } 
}

$computerNames = Get-Content $settings.Get_Item("IPAddressesFile")
#Calling the Main function to carry out network tests
Network-Tests $computerNames

#Region Network-Tests
<# 
    .Synopsis
     Main Function doing network tests. 
    .DESCRIPTION
     This function will call all the other functions to carry out network tests.
    .PARAMETERS
     $ServerNames: Pass a list of server names as String Array
    #>
function Test-Network {
    Param(
        [Parameter()]
        [string[]]
        $ServerNames)
    Begin {
        $computerNames = $ServerNames
        # Creating objects to be used
        $serverArray = @()
        $errorOutputArray = @()
        $networkInformationArray = @()
        $checkOpenPortsArray = @()
        # Ports to check
        $portList = $settings.PortsToValidate.Split(",") # Split the string into a 
        an array
        # Start to write to the Log File. All output will be written in the Log File
        Start-Transcript -Path $settings.Get_Item("LogFile")
    } Process {
        #TODO: I need to send the list of $computerNames to the next part of 
        the process (ForEach-Object). 
        #Which command should I use?
        # Start Process
        Foreach ($computerName in $computerNames) {
            # Test the connection to the ComputerName or Ip Address Given
            if (Test-Connection -ComputerName $computerName -Count 1 -Quiet) { 
                # Get User Logged onto the server
                $serverArray += Get-UserDetail $computerName
                # Check if any security errors or warning was log to the eventlog
                $errorOutputArray += Check-WarningsErrors $computerName
                # Get Network Information
                $networkInformationArray += Get-NetworkInfo $computerName
                # Check for open ports as per list given
                $checkOpenPortsArray += Check-OpenPorts $computerName $portList
     
            }
            else {
                $server = [ordered]@{
                    ComputerName = $computerName
                    UserName     = "Remote Server Not Available" 
                }
                $serverArray += New-Object -TypeName PSObject -Property $server
            }
        } # bottom of foreach loop
    }
    End {
        # Printing all the objects
        "*" * 50
        Write-Output "* Servers Information"
        "*" * 50
        $serverArray | Format-Table -AutoSize
        "*" * 50
        Write-Output "* EventLog - Errors and Warnings"
        "*" * 50
        $errorOutputArray | Format-Table -AutoSize
        "*" * 50
        Write-Output "* Network Information"
        "*" * 50
        $networkInformationArray | Format-Table -AutoSize
        "*" * 50
        Write-Output "* Open Ports"
        "*" * 50
        $checkOpenPortsArray | Format-Table -AutoSize
        Stop-Transcript
    }
}
#endregion
