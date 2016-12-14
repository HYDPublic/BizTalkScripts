param
(
	[string] $ApplicationName,
	[string] $Path,
	[string] $Destination,
	[string] $Server,
	[string] $Database
)

try {
	"Add .NET assembly to application `"$ApplicationName`" on server `"$Server`" and database `"$Database`".";
	"Path: $Path";
	"Destination: $Destination";

	$ret = & "C:\Program Files (x86)\Microsoft BizTalk Server 2016\btstask.exe" `
	AddResource `
	/ApplicationName:"$ApplicationName" `
	/Type:System.BizTalk:Assembly `
	/Overwrite `
	/Source:"$Path" `
	/Destination:"$Destination" `
	/Options:"GacOnAdd,GacOnInstall,GacOnImport" `
	/Server:$Server `
	/Database:$Database

	$ret;

	if ($LASTEXITCODE -gt 0) {
		Write-Error "btstask failed! $ret";
		exit $LASTEXITCODE;
	}

	"Resource added.";
}
catch [System.Exception] {
	$_.Exception;
	Write-Error "Exception: $($_.Exception)";
	exit 1;
}
