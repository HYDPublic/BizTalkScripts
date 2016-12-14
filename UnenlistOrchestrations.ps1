# Example: .\UnenlistOrchestrations.ps1 "SERVER=.;DATABASE=BizTalkMgmtDb;Integrated Security=SSPI" "BI001.ARX.Qlickview" "BI001.ARX.Qlickview.Processing.GetARX_ZoneEventExport"

param
(
	[string] $ConnectionString,
	[string] $ApplicationName,
	[string] $OrchestrationNames
)

try {
	"Start UnenlistOrchestrations.";
	"Connectionstring: $ConnectionString";
	"ApplicationName: $ApplicationName";

	[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
	$catalog = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
	$catalog.ConnectionString = $ConnectionString

	"Unenlisting the following orchestrations in application ${ApplicationName}:"
	$names = $OrchestrationNames.Split(",")
	$names | ForEach-Object { $_ }

	foreach ($name in $names) {
		$orchestration = $catalog.Applications[$ApplicationName].Orchestrations[$name]
		if ($orchestration) {
			$orchestration.Status = [Microsoft.BizTalk.ExplorerOM.OrchestrationStatus] "Unenlisted"
		} else {
			"No orchestration named ${name} exists.";
		}
	}

	$catalog.SaveChanges();

	"End UnenlistOrchestrations.";
}
catch [System.Exception] {
	$_.Exception;
	Write-Error "Exception: $($_.Exception)";
	exit 1;
}

"Unenlist successful."