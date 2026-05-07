<#
Improved setup script:
- Ensures script runs with Administrator privileges
- Uses script-relative paths so it can be invoked from anywhere
- Creates and activates a venv, installs requirements with logging
- Invokes GPU detection helper if present
#>

# Check for Administrator privileges
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $IsAdmin) {
    Write-Host "Please re-run PowerShell as Administrator." -ForegroundColor Red
    exit 1
}

# Move to repository root (scripts is expected to be in ./scripts)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location (Join-Path $scriptDir "..")

Write-Host "Working directory: $(Get-Location)" -ForegroundColor Cyan

# Ensure Python is available
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    Write-Host "Python not found in PATH. Install Python 3.11+ and add to PATH." -ForegroundColor Red
    exit 1
}

# Create virtual environment if missing
if (!(Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Cyan
    python -m venv venv
}

# Activate the venv
$activate = Join-Path (Get-Location) "venv\Scripts\Activate.ps1"
if (Test-Path $activate) {
    Write-Host "Activating virtual environment..." -ForegroundColor Cyan
    . $activate
} else {
    Write-Host "Activation script not found at $activate" -ForegroundColor Red
    exit 1
}

Write-Host "Installing Python dependencies (this may take a while)..." -ForegroundColor Cyan
# Install and log output
try {
    pip install -r requirements.txt 2>&1 | Tee-Object -FilePath setup.log
    if ($LASTEXITCODE -ne 0) { throw "pip install returned non-zero exit code" }
} catch {
    Write-Host "Dependency installation failed. See setup.log for details." -ForegroundColor Red
    exit 1
}

# Run GPU detection helper if available
$gpuHelper = Join-Path (Join-Path $scriptDir "scripts") "detect_gpu_and_set_modelfile.ps1"
if (Test-Path $gpuHelper) {
    Write-Host "Running GPU detection helper..." -ForegroundColor Cyan
    & $gpuHelper
}

Write-Host "`nSetup Complete! To start the app, run:" -ForegroundColor Green
Write-Host "streamlit run app.py" -ForegroundColor Yellow