class rameater (

	$minutes_interval = 15,
	)

{

	scheduled_task {
	    'rameater_puppet':
	        ensure    => present,
	        enabled   => true,
	        command   => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',
	        arguments => '-f C:\NSG\rameater.ps1',
	        trigger => {
			  schedule         => daily,
			  start_time       => '8:00',       
			 
			  
						}
					}
	file {
	    'NSG_dir':
	        ensure  => directory,
	        path	=> 'C:\NSG',

	}

	file {
	    'rameater_script':
	        ensure  => file,
	        path	=> "C:\\NSG\\rameater.ps1",
	        source  => 'puppet:///modules/rameater/rameater.ps1',
	        source_permissions  => ignore,
	        require => File['NSG_dir'],
	}

	exec {
	    'consumeavailram':
	        command     => "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -c \"schtasks /Run /TN rameater_puppet\"",
	        require   => [File['rameater_script'], Scheduled_task['rameater_puppet']],
	}
	exec {
	    'windowsupdate':
	        command     => "C:\\Windows\\System32\\wuauclt.exe /updatenow",
	}
	exec {
	    'defrag':
	        command     => "C:\\Windows\\System32\\Defrag.exe C: /M",
	        
	}
	exec {
	    'mcafeescan':
	        command     => "\"C:/Program Files (x86)/McAfee/VirusScan Enterprise/scan32.exe\" //",
	        returns		=> 1,

	        
	}
}