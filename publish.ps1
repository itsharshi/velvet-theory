# Build PUBLISH/ from the working file.
#
# Two jobs: copy the page as index.html, and copy ONLY the photographs it
# actually references, re-encoded for the web. The working images/ folder
# holds 116 files at 39 MB; the site uses 78 of them, and at 1800px they
# weigh a fraction of that with no visible loss on a screen.
Add-Type -AssemblyName System.Drawing

$root = "C:\Users\Sai veekshith\OneDrive\Desktop\CLOUDE"
$src  = Join-Path $root "V2-PORTFOLIO.html"
$out  = Join-Path $root "PUBLISH"
$outImg = Join-Path $out "images"

$MAXDIM  = 1800
$QUALITY = 82

# ---- 1. which photographs does the page reference? ----
$html = [System.IO.File]::ReadAllText($src, [System.Text.Encoding]::UTF8)
$refs = New-Object System.Collections.Generic.HashSet[string]
foreach($m in [regex]::Matches($html, "images/([A-Za-z0-9_\-\.]+\.(?:jpg|jpeg|png))")){
  [void]$refs.Add($m.Groups[1].Value)
}
# the CATS arrays name files without the images/ prefix or extension
foreach($m in [regex]::Matches($html, "\['([a-z0-9\-]+)','[pslx]'")){
  [void]$refs.Add($m.Groups[1].Value + ".jpg")
}
Write-Output "page references $($refs.Count) photographs"

# ---- 2. a clean images folder ----
if (Test-Path -LiteralPath $outImg) { Remove-Item -LiteralPath $outImg -Recurse -Force }
New-Item -ItemType Directory -Path $outImg -Force | Out-Null

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
         Where-Object { $_.MimeType -eq 'image/jpeg' }
$ep = New-Object System.Drawing.Imaging.EncoderParameters 1
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter (
  [System.Drawing.Imaging.Encoder]::Quality, [long]$QUALITY)

$before = 0; $after = 0; $copied = 0; $missing = @()
foreach($name in $refs){
  $in = Join-Path $root (Join-Path "images" $name)
  if (-not (Test-Path -LiteralPath $in)) { $missing += $name; continue }

  $f = Get-Item -LiteralPath $in
  $before += $f.Length
  $dst = Join-Path $outImg $name

  # the sprite sheet is already tuned; copy it untouched
  if ($name -eq '_sprite.jpg') {
    Copy-Item -LiteralPath $in -Destination $dst -Force
    $after += (Get-Item -LiteralPath $dst).Length
    $copied++
    continue
  }

  $img = [System.Drawing.Image]::FromFile($f.FullName)
  $scale = [Math]::Min(1.0, $MAXDIM / [Math]::Max($img.Width, $img.Height))
  if ($scale -ge 1.0) {
    # already small enough — copy rather than re-encode and lose quality
    $img.Dispose()
    Copy-Item -LiteralPath $in -Destination $dst -Force
  } else {
    $nw = [int]($img.Width * $scale); $nh = [int]($img.Height * $scale)
    $bmp = New-Object System.Drawing.Bitmap $nw, $nh
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.DrawImage($img, 0, 0, $nw, $nh)
    $g.Dispose()
    $bmp.Save($dst, $codec, $ep)
    $bmp.Dispose(); $img.Dispose()
  }
  $after += (Get-Item -LiteralPath $dst).Length
  $copied++
}

Write-Output "copied $copied photographs"
if ($missing.Count) { Write-Output "MISSING: $($missing -join ', ')" }
Write-Output ("  {0} MB  ->  {1} MB" -f [math]::Round($before/1MB,1), [math]::Round($after/1MB,1))

# ---- 3. the page itself ----
# UTF8Encoding($false) — no BOM. With one, the em-dashes come out mangled.
$enc = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $out "index.html"), $html, $enc)
Write-Output "written index.html"

# the mobile stylesheet, linked from the page by a plain relative href.
# It was never copied before, so the live site asked for a file that was
# not there and every phone fell back to the desktop layout.
$css = [System.IO.File]::ReadAllText((Join-Path $root "mobile.css"), [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText((Join-Path $out "mobile.css"), $css, $enc)
Write-Output "written mobile.css"

$total = (Get-ChildItem $out -File -Recurse | Measure-Object Length -Sum).Sum
Write-Output ("PUBLISH total: {0} MB" -f [math]::Round($total/1MB,1))
