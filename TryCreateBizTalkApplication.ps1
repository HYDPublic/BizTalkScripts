param
(
	[string] $ConnectionString,
	[string] $ApplicationName
)

try
{
	"Start TryCreateApplication.";
	"Connectionstring: $ConnectionString";
	"ApplicationName: $ApplicationName";

	[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
	$catalog = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
	$catalog.ConnectionString = $ConnectionString

	$existing =  @($catalog.Applications | where Name -eq $ApplicationName).Count -gt 0
	if (-not $existing) {
		$catalog.AddNewApplication().Name = $ApplicationName;
		$catalog.SaveChanges();
	}

	"End TryCreateApplication."
}
catch [System.Exception] {
	$_.Exception;
	Write-Error "Exception: $($_.Exception)";
	exit 1;
}

