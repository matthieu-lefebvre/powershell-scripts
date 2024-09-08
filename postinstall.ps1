# Set execution policy to Bypass for this session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Continue with the rest of your script
# Install Chocolatey package manager
try {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} catch {
    Write-Error "Failed to install Chocolatey: $_"
    exit 1
}

# Install choco packages and reload path
try {
    choco install -y git
    choco install -y pwsh
    choco install -y python3
    choco install -y miniconda3 --params="'/InstallationType:[AllUsers]'"
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} catch {
    Write-Error "Failed to install one or more packages: $_"
    exit 1
}

# Configure Winrm
try {
    Enable-PSRemoting -Force
    winrm quickconfig -q
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    winrm set winrm/config/client/auth '@{Basic="true"}'
    winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
    netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow
    Set-Service winrm -startuptype "auto"
    Restart-Service winrm
} catch {
    Write-Error "Failed to configure WinRM: $_"
    exit 1
}
