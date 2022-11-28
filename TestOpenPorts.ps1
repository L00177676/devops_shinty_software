#Region Check-OpenPorts - Test-OpenPorts

<#
    .Synopsis
     
    .DESCRIPTION
     
    .PARAMETERS 
#>

# TODO: - fix this
# fill in appropriate comments for the method as per the section above this comment refers to the 

# check-openports function renamed to Test-OpenPorts
function Test-OpenPorts {
    [CmdletBinding()]
    [Alias()]
    [OutputType([array])]
    Param(
        [Parameter()]
        [string]
        $ComputerName,
        [Parameter()]
        [string[]]
        $PortList
    )
    $checkOpenPortsArray = @()
    Try {
        # TODO: - fix this
        # We need an iterator here to go through all $ports in $PortList
        # Write in the single line of code to iterate through the port list
        {
     
            #TODO: - Fix this
            # $portConnected =
            # finish the above line of code using the Test-NetConnection command and then uncomment.
            #check by port $port, and the computer name $ComputerName.
            # add an action of SilentlyContinue if a warning occurs
            # this is one line of code only!
            $ports = [ordered]@{
                ComputerName = $ComputerName
                Port         = $port
                Open         = $portConnected.TcpTestSucceeded
            }
            $checkOpenPortsArray += New-Object -TypeName PSObject -Property 
            $ports
        }
    }
    catch { 
        $ports = [ordered]@{
            ComputerName = $ComputerName
            Port         = $port
            Open         = "(Check-OpenPorts) Server Error: " + $_.Exception.Message + 
            " : " + $_.FullyQualifiedErrorId
        }
        $checkOpenPortsArray = New-Object -TypeName PSObject -Property 
        $ports
    }
    return $checkOpenPortsArray 
}
#endregion