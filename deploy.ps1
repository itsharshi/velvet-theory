# Deploy the site.
#
#   .\deploy.ps1                       - saves with a default message
#   .\deploy.ps1 "fixed the About copy" - saves with your own message
#
# It rebuilds PUBLISH/, commits everything, and pushes to GitHub. Netlify
# is watching the repository, so the live site updates by itself a minute
# or so later.
#
# Nothing here is destructive: if the build fails, nothing is committed;
# if there is nothing to commit, it still pushes whatever is waiting.

param(
  [string]$Message = ""
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

Write-Output ""
Write-Output "=== 1/3  building PUBLISH ==="
& (Join-Path $root "publish.ps1")
if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) {
  Write-Output ""
  Write-Output "The build failed. Nothing has been committed or pushed."
  exit 1
}
if (-not (Test-Path -LiteralPath (Join-Path $root "PUBLISH\index.html"))) {
  Write-Output ""
  Write-Output "PUBLISH\index.html is missing after the build. Stopping."
  exit 1
}

Write-Output ""
Write-Output "=== 2/3  saving to git ==="
if (-not $Message) {
  $Message = "Update the site - {0}" -f (Get-Date -Format "d MMMM yyyy, HH:mm")
}
git add -A
$pending = git status --porcelain
if ($pending) {
  git commit -q -m $Message
  Write-Output ("  committed: {0}" -f $Message)
} else {
  Write-Output "  nothing changed since the last save"
}

Write-Output ""
Write-Output "=== 3/3  pushing to GitHub ==="
git push
if ($LASTEXITCODE -ne 0) {
  Write-Output ""
  Write-Output "The push failed. Your work IS saved locally - only the"
  Write-Output "upload did not happen. Check your connection and run:"
  Write-Output "    git push"
  exit 1
}

Write-Output ""
Write-Output "Done. Netlify will publish it within a minute or two:"
Write-Output "    https://velvet-theory.netlify.app"
Write-Output ""
Write-Output "Watch it build at https://app.netlify.com"
