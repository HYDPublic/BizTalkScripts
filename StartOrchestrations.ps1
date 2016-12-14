# Example: .\StartOrchestrations.ps1 "SERVER=.;DATABASE=BizTalkMgmtDb;Integrated Security=SSPI" "BI001.ARX.Qlickview" "BI001.ARX.Qlickview.Processing.GetARX_ZoneEventExport"

param
(
	[string] $ConnectionString,
	[string] $ApplicationName,
	[string] $OrchestrationNames
)

try
{
	"Start StartOrchestrations.";
	"Connectionstring: $ConnectionString";
	"ApplicationName: $ApplicationName";

	[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
	$catalog = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
	$catalog.ConnectionString = $ConnectionString

	"Starting the following orchestrations in application ${ApplicationName}:"
	$names = $OrchestrationNames.Split(",")
	$names | ForEach-Object { $_ }

	foreach ($name in $names) {
		$orchestration = $catalog.Applications[$ApplicationName].Orchestrations[$name]
		$orchestration.Status = [Microsoft.BizTalk.ExplorerOM.OrchestrationStatus] "Started"
	}

	$catalog.SaveChanges();

	"End StartOrchestrations.";
}
catch [System.Exception] {
	$_.Exception;
	Write-Error "Exception: $($_.Exception)";
	exit 1
}

"Start successful."