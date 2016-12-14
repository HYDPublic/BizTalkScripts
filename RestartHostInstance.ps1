param
(
	[string] $HostInstanceName
)

try
{
	$HostInstanceNames = $HostInstanceName.Split(",").Trim();

	foreach($HostInstanceName in $HostInstanceNames)
	{
		$HostInstance = get-wmiobject MSBTS_HostInstance -namespace 'root\MicrosoftBizTalkServer' | where { $_.HostName -in $HostInstanceName }

		if($HostInstance)
		{
			$HostInstanceState = $HostInstance.GetState().State

			"Current state of " + $HostInstance.Name + " Host Instance: '$HostInstanceState'"
			# 1=Stopped, 2=Start pending, 3=Stop pending, 4=Running, 8=Unknown

			if ($HostInstanceState -eq 1) 
			{
				"Host Instance is currently stopped and will be started"
				$HostInstance.Start() 
			}
			elseif ($HostInstanceState -eq 4) 
			{
				"Host Instance will be restarted"
				$HostInstance.Stop() 
				$HostInstance.Start()
			}
	
			"New state of " + $HostInstance.Name + " Host Instance: " + $HostInstance.GetState().State
		}
		else
		{
			$error = "Cannot find a instance with name " + $HostInstanceName
			Write-Error $error
			exit 1
		}
	} 
}
catch [System.Exception] {
	$_.Exception;
	Write-Error "Exception: $($_.Exception)";
	exit 1;
}
