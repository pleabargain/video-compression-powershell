# Video Compression Script
param (
    [Parameter(Mandatory=$false)]
    [string]$InputFolder = ".",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("low", "medium", "high")]
    [string]$Quality = "medium"
)

# Quality presets
$QualityPresets = @{
    "low" = @{
        crf = "28"
        preset = "faster"
    }
    "medium" = @{
        crf = "23"
        preset = "medium"
    }
    "high" = @{
        crf = "18"
        preset = "slow"
    }
}

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Check if FFmpeg is installed
try {
    $null = Get-Command ffmpeg -ErrorAction Stop
} catch {
    Write-ColorOutput Red "Error: FFmpeg is not installed or not in PATH"
    Write-Output "Please install FFmpeg and make sure it's added to your system's PATH"
    exit 1
}

# Get all video files
$videos = Get-ChildItem -Path $InputFolder -File | Where-Object { $_.Extension -match '\.(mp4|avi|mov|mkv|wmv)$' }

if ($videos.Count -eq 0) {
    Write-ColorOutput Yellow "No videos found in $InputFolder"
    exit 0
}

# Display list of video files with numbers
Write-ColorOutput Cyan "`nAvailable video files:"
Write-ColorOutput Cyan "----------------------"
for ($i = 0; $i -lt $videos.Count; $i++) {
    Write-Output "$($i + 1). $($videos[$i].Name)"
}

# Prompt for selection
Write-Host "`nSelect videos to compress:"
Write-Host "- Type 'a' to select all videos"
Write-Host "- Type numbers separated by commas (e.g., 1,3,4)"
Write-Host "Selection: " -NoNewline
$selection = Read-Host

# Process selection
$selectedVideos = @()
if ($selection.ToLower() -eq 'a') {
    $selectedVideos = $videos
} else {
    $selectedIndices = $selection.Split(',') | ForEach-Object { $_.Trim() }
    foreach ($index in $selectedIndices) {
        if ([int]::TryParse($index, [ref]$null)) {
            $arrayIndex = [int]$index - 1
            if ($arrayIndex -ge 0 -and $arrayIndex -lt $videos.Count) {
                $selectedVideos += $videos[$arrayIndex]
            } else {
                Write-ColorOutput Yellow "Warning: Invalid selection number: $index"
            }
        }
    }
}

if ($selectedVideos.Count -eq 0) {
    Write-ColorOutput Yellow "No valid videos selected"
    exit 0
}

Write-ColorOutput Cyan "`nSelected $($selectedVideos.Count) videos to compress"
Write-ColorOutput Cyan "Using $Quality quality preset"
$currentPreset = $QualityPresets[$Quality]

foreach ($video in $selectedVideos) {
    # Create output filename
    $outputPath = Join-Path $video.DirectoryName ($video.BaseName + "_compressed" + $video.Extension)
    
    Write-ColorOutput Yellow "`nProcessing: $($video.Name)"
    
    try {
        # Build FFmpeg command
        $ffmpegCommand = "ffmpeg -i `"$($video.FullName)`" -c:v libx264 -crf $($currentPreset.crf) -preset $($currentPreset.preset) -c:a aac -b:a 128k -y `"$outputPath`""
        
        # Execute FFmpeg command
        $result = cmd /c $ffmpegCommand '2>&1'
        
        if (Test-Path $outputPath) {
            $originalSize = (Get-Item $video.FullName).Length / 1MB
            $compressedSize = (Get-Item $outputPath).Length / 1MB
            $savings = (1 - ($compressedSize / $originalSize)) * 100
            
            Write-ColorOutput Green "Successfully compressed: $($video.Name)"
            Write-Output "Original size: $($originalSize.ToString('0.00')) MB"
            Write-Output "Compressed size: $($compressedSize.ToString('0.00')) MB"
            Write-Output "Space savings: $($savings.ToString('0.00'))%"
        } else {
            Write-ColorOutput Red "Error compressing $($video.Name)"
            Write-Output $result
        }
    } catch {
        Write-ColorOutput Red "Error processing $($video.Name): $_"
        Write-Output $result
    }
}

Write-ColorOutput Green "`nCompression complete!"
