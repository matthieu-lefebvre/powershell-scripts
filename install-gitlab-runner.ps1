# Installer GitLab Runner
Invoke-WebRequest -Uri https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe -OutFile gitlab-runner.exe
Move-Item -Path gitlab-runner.exe -Destination "C:\Program Files\GitLab-Runner"
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Program Files\GitLab-Runner", [System.EnvironmentVariableTarget]::Machine)
Start-Process "C:\Program Files\GitLab-Runner\gitlab-runner.exe" -ArgumentList "install" -NoNewWindow -PassThru

# Créer un modèle de configuration
$configTemplate = @"
concurrent = 1
check_interval = 0

[[runners]]
  name = "$RunnerDescription"
  url = "$GitLabUrl"
  token = "$RunnerToken"
  executor = "shell"
  shell = "pwsh"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "$DockerImage"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
"@

$configTemplate | Out-File -FilePath "C:\Program Files\GitLab-Runner\config.toml" -Force

# Enregistrer GitLab Runner
Start-Process "C:\Program Files\GitLab-Runner\gitlab-runner.exe" -ArgumentList "register --non-interactive --url $GitLabUrl --registration-token $RunnerToken --description $RunnerDescription --tag-list $RunnerTag --executor shell --docker-image $Docker_Image" -NoNewWindow -PassThru
