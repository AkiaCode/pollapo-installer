Write-Output "Installing Chocolatey"
if (Get-Command -Name choco) {
    Write-Output "Chocolatey already exists"
} else {
    Write-Output "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
Write-Output "Installing Github cil (gh), Git, Deno"
choco install gh git deno

Write-Output "Cloning riiid/pbkit repo"

if (Test-Path -Path (Join-Path (Get-Location) 'pbkit')) {
    Write-Output "'pbkit' folder already exists"
    $input = Read-Host "Delete 'pbkit' folder and Clone riiid/pbkit repo? (y/n)"

    switch ($input) {
        'y'  { Write "`nOkay, Delete 'pbkit' folder and Clone riiid/pbkit repo" }
        'n'  { Write "`nNext..." }
    }

    if (-not ($input -eq "y" -or $input -eq "n")) { Write-Output "`nIt's not y or n" }

    if ($input -eq "y") {
        Remove-Item (Join-Path (Get-Location) 'pbkit') -Recurse -Force
        git clone https://github.com/riiid/pbkit.git
    }

    Write-Output "Installing pollapo"
    deno install -n pollapo -f -A --unstable pbkit/cli/pollapo/entrypoint.ts

} else {
    git clone https://github.com/riiid/pbkit.git
    Write-Output "Installing pollapo"
    deno install -n pollapo -f -A --unstable pbkit/cli/pollapo/entrypoint.ts
}

Remove-Item (Join-Path (Get-Location) 'pbkit') -Recurse -Force

Write-Output  "`n`npollapo was installed successfully"
Write-Output  "Run 'pollapo --help' to get started"