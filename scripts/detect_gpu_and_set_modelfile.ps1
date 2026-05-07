<#
Detect NVIDIA GPU and update the Modelfile accordingly.
Writes an uncommented `PARAMETER num_gpu 999` when GPU present,
or comments it out when absent. Operates on Modelfile or Modelfile.txt.
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Join-Path $scriptDir ".."

# Resolve candidate modelfile paths
$candidates = @(Join-Path $repoRoot "Modelfile" , Join-Path $repoRoot "Modelfile.txt")
$modelfile = $null
foreach ($c in $candidates) { if (Test-Path $c) { $modelfile = $c; break } }

if (-not $modelfile) {
    Write-Host "Modelfile not found in repository root. Expected Modelfile or Modelfile.txt" -ForegroundColor Yellow
    exit 0
}

Write-Host "Using Modelfile: $modelfile" -ForegroundColor Cyan

# Detect nvidia-smi availability
$nvidiaCmd = Get-Command nvidia-smi -ErrorAction SilentlyContinue
$hasGpu = $false
if ($nvidiaCmd) { $hasGpu = $true }

$content = Get-Content $modelfile -Raw
if ($hasGpu) {
    Write-Host "NVIDIA GPU detected. Enabling GPU offload in Modelfile." -ForegroundColor Green
    # Uncomment any existing num_gpu parameter lines
    $new = $content -replace '^[ \t]*#\s*(PARAMETER\s+num_gpu\s+\d+)', '$1' -replace 'PARAMETER\s+num_gpu\s+\d+', 'PARAMETER num_gpu 999'
} else {
    Write-Host "No NVIDIA GPU detected. Commenting out num_gpu parameter in Modelfile." -ForegroundColor Yellow
    # Comment out any present num_gpu parameter line
    if ($content -match '^[ \t]*PARAMETER\s+num_gpu\s+\d+') {
        $new = $content -replace '^[ \t]*(PARAMETER\s+num_gpu\s+\d+)', '# $1'
    } else {
        $new = $content
    }
}

Set-Content -Path $modelfile -Value $new -Encoding UTF8
Write-Host "Modelfile updated." -ForegroundColor Cyan
