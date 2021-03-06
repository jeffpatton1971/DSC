function Get-TargetResource
{
    [CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Source,
		[parameter(Mandatory = $true)]
		[System.String]
		$Destination,
		[parameter(Mandatory = $true)]
		[System.String]
		$Filter
	)
	$returnValue = @{
		Source = $Source
		Destination = $Destination
		Filter = $Filter
	    }
	Return $returnValue
    }
function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Source,
		[parameter(Mandatory = $true)]
		[System.String]
		$Destination,
		[parameter(Mandatory = $true)]
		[System.String]
		$Filter,
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    if ($Ensure -ieq "Present")
    {
        $Files = Get-ChildItem -Path $Source -Filter $Filter
        foreach ($File in $Files)
        {
            Copy-Item -Path $File.FullName -Destination $Destination
            }
        }
    if ($Ensure -ieq "Absent")
    {
        $Files = Get-ChildItem -Path $Destination -Filter $Filter
        foreach ($File in $Files)
        {
            Remove-Item -Path $File.FullName
            }
        }
    }
function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Source,
		[parameter(Mandatory = $true)]
		[System.String]
		$Destination,
		[parameter(Mandatory = $true)]
		[System.String]
		$Filter,
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    Write-Debug $Source
    Write-Debug $Destination
    Write-Debug $Filter
    Write-Debug $Ensure
    if ($Ensure -ieq "Present")
    {
        $SourceFiles = Get-ChildItem -Path $Source -Filter $Filter |Sort-Object
        Write-Verbose $SourceFiles
        $DestinationFiles = Get-ChildItem -Path $Destination -Filter $Filter |Sort-Object
        Write-Verbose $DestinationFiles
        if (($SourceFiles) -and ($DestinationFiles))
        {
            @(Compare-Object $SourceFiles $DestinationFiles -SyncWindow 0).length -eq 0
            Write-Verbose @(Compare-Object $SourceFiles $DestinationFiles -SyncWindow 0).length -eq 0
            }
        else
        {
            return $false
            }
        }
    if ($Ensure -ieq "Absent")
    {
        $SourceFiles = Get-ChildItem -Path $Source -Filter $Filter |Sort-Object
        Write-Verbose $SourceFiles
        $DestinationFiles = Get-ChildItem -Path $Destination -Filter $Filter |Sort-Object
        Write-Verbose $DestinationFiles
        if (($SourceFiles) -and ($DestinationFiles))
        {
            (!@(Compare-Object $SourceFiles $DestinationFiles -SyncWindow 0).length -eq 0)
            Write-Verbose (!@(Compare-Object $SourceFiles $DestinationFiles -SyncWindow 0).length -eq 0)
            }
        else
        {
            return $true
            }
        }
    }
Export-ModuleMember -Function *-TargetResource