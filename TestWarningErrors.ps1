#Region Check-warningsErrors
<#
    .Synopsis
     Check for warnings or errors 
    .DESCRIPTION
     This function will check if any warnings or errors is on the server EventLog
    .PARAMETERS
     $ComputerName: A Valid Computer Name or IP Address
#>
    function Test-WarningErrors {
        [CmdletBinding()]
        [Alias()]
        [OutputType([array])]
        Param(
            [Parameter()]
            [string]
            $ComputerName
        )
        # Date before and after to check 24 hours worth of data
        $DateBefore = (Get-Date)
        $DateAfter = (Get-Date).AddDays(-1)
        $errorOutputArray = @()

        try {
            # Check if any security errors or warning was log to the eventlog
            $EventLogTest = Get-EventLog -ComputerName $ComputerName -LogName 
            Security -Before $DateBefore -After $DateAfter | Where-Object { $_.EntryType -like 'Error' -or $_.EntryType -like 'Warning' }
            #$EventLogTest = Get-EventLog -LogName System -Newest 5 @TEST
            If (-ne $null $EventLogTest ) {
                # If Warnings or Errors found, then write it out to the log file
                Foreach ($eventLog in $EventLogTest) {
                    $errorOutput = [ordered]@{
                        ComputerName = $ComputerName
                        EntryType    = $eventLog.EntryType
                        Index        = $eventLog.Index 
                        Source       = $eventLog.Source
                        InstanceID   = $eventLog.InstanceID
                        Message      = $eventLog.Message 
                    }
                    $errorOutputArray = New-Object -TypeName PSObject -Property 
                    $errorOutput
                }
            }
            else {
                # If no errors where found
                $errorOutput = [ordered]@{
                    ComputerName = $ComputerName
                    EntryType    = ""
                    Index        = "" 
                    Source       = ""
                    InstanceID   = ""
                    Message      = "No Warning or Errors found on this server" 
                }
                $errorOutputArray = New-Object -TypeName PSObject -Property 
                $errorOutput
            }
        }
        catch { 
            $errorOutput = [ordered]@{
                ComputerName = $ComputerName
                EntryType = "" ; Index = "" ; Source = ""
                InstanceID = ""
                Message = "(Check-WarningsErrors) Server Error: " + 
                $_.Exception.Message + " : " + $_.FullyQualifiedErrorId 
            }
            $errorOutputArray = New-Object -TypeName PSObject -Property 
            $errorOutput
        }
        return $errorOutputArray 
         
    }
#endregion
    