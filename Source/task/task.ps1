[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {
    # Parse the entry parameters.
    [string] $command = Get-VstsInput -Name command -Require
    [bool] $installCliTool = Get-VstsInput -Name installCliTool -AsBool -Default true
    [bool] $installCliPrerelease = Get-VstsInput -Name installCliPrerelease -AsBool -Default false
    
    # Parse the conditional parameters and build the list of command line arguments.
    $arguments = @($command)

    switch ($command) {
        keypair {
            [string] $publicKeyFile = Get-VstsInput -Name publicKeyFile -Require
            [string] $privateKeyFile = Get-VstsInput -Name privateKeyFile -Require
            [string] $privateKeyPassword = Get-VstsInput -Name privateKeyPassword -Require

            $arguments += "--public ""${publicKeyFile}"""
            $arguments += "--private ""${privateKeyFile}"""
            $arguments += "--password ""${privateKeyPassword}"""
        }

        template {  
            [string] $templateFile = Get-VstsInput -Name templateFile -Require
            [string] $format = Get-VstsInput -Name format -Require

            $arguments += "--template ""${templateFile}"""
            $arguments += "--format ""${format}"""
        }

        sign {  
            [string] $templateFile = Get-VstsInput -Name templateFile -Require
            [string] $licenseFile = Get-VstsInput -Name licenseFile -Require
            [string] $format = Get-VstsInput -Name format -Require
            [string] $privateKeyFile = Get-VstsInput -Name privateKeyFile -Require
            [string] $privateKeyPassword = Get-VstsInput -Name privateKeyPassword -Require

            $arguments += "--template ""${templateFile}"""
            $arguments += "--license ""${licenseFile}"""
            $arguments += "--format ""${format}"""
            $arguments += "--private ""${privateKeyFile}"""
            $arguments += "--password ""${privateKeyPassword}"""
        }

        validate {  
            [string] $licenseFile = Get-VstsInput -Name licenseFile -Require
            [string] $format = Get-VstsInput -Name format -Require
            [string] $publicKeyFile = Get-VstsInput -Name publicKeyFile -Require

            $arguments += "--license ""${licenseFile}"""
            $arguments += "--format ""${format}"""
            $arguments += "--public ""${publicKeyFile}"""
        }

        Default {
            [string] $message = "Unknown command '${command}'."
            Write-VstsTaskError -Message $message
            exit
        }
    }

    # Install the CLI tool (if requested).
    if ($installCliTool) {
        Write-Host ("Install CLI tool...")
        # dotnet tool install --global equadrat.Licensing.CLI --prerelease
        $cmd = "dotnet"
        $cliPackageName = "equadrat.Licensing.CLI"
        $installCliArgs = @("tool", "install", $cliPackageName, "--global")
        if ($installCliPrerelease) { $installCliArgs += "--prerelease" }
        Start-Process -Wait -FilePath $cmd -NoNewWindow -ArgumentList $installCliArgs
        Write-Host ("CLI tool installed.")
    }

    # Run the CLI tool.
    $cmd = "equadrat.licensing"
    Start-Process -Wait -FilePath $cmd -NoNewWindow -ArgumentList $arguments
}
finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
