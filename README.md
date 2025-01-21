# Video Compression PowerShell Script

A PowerShell script that allows you to easily compress multiple video files using FFmpeg. The script provides a user-friendly interface to select videos and compress them with different quality presets.

## Features

- Interactive video selection interface
- Support for multiple video formats (mp4, avi, mov, mkv, wmv)
- Multiple quality presets (low, medium, high)
- Detailed compression statistics
- Batch processing capability
- Color-coded output for better readability

## Prerequisites

1. **PowerShell**: Windows 10 and 11 come with PowerShell pre-installed.
2. **FFmpeg**: The script requires FFmpeg to be installed and accessible from the command line.

### Installing FFmpeg

1. Download FFmpeg from the official website: https://ffmpeg.org/download.html
   - For Windows, you can use the pre-built binaries from https://github.com/BtbN/FFmpeg-Builds/releases
2. Extract the downloaded archive
3. Add FFmpeg to your system's PATH:
   - Copy the path to the `bin` folder (e.g., `C:\ffmpeg\bin`)
   - Open System Properties → Advanced → Environment Variables
   - Under System Variables, find and select "Path"
   - Click "Edit" → "New"
   - Paste the FFmpeg bin folder path
   - Click "OK" to save changes

## Installation

1. Create a folder for PowerShell scripts (if it doesn't exist):
```powershell
New-Item -ItemType Directory -Path "$HOME\Documents\WindowsPowerShell\Scripts" -Force
```

2. Copy the script to the PowerShell scripts folder:
```powershell
Copy-Item "vidcompression.ps1" -Destination "$HOME\Documents\WindowsPowerShell\Scripts\vidcompression.ps1"
```

3. Add the scripts folder to your PowerShell profile (to make it accessible from anywhere):
   - First, check if a PowerShell profile exists:
   ```powershell
   Test-Path $PROFILE
   ```
   - If it returns False, create the profile:
   ```powershell
   New-Item -ItemType File -Path $PROFILE -Force
   ```
   - Open the profile in a text editor:
   ```powershell
   notepad $PROFILE
   ```
   - Add this line to the profile:
   ```powershell
   $env:Path += ";$HOME\Documents\WindowsPowerShell\Scripts"
   ```

4. Create an alias for easier access (optional, add to your PowerShell profile):
```powershell
Set-Alias -Name compress-video -Value vidcompression.ps1
```

5. Restart your PowerShell terminal for changes to take effect.

## Usage

### Basic Usage

Navigate to a folder containing videos and run:
```powershell
vidcompression.ps1
```
Or if you set up the alias:
```powershell
compress-video
```

### With Parameters

Specify input folder:
```powershell
vidcompression.ps1 -InputFolder "C:\Videos"
```

Specify quality preset:
```powershell
vidcompression.ps1 -Quality high
```

Combine parameters:
```powershell
vidcompression.ps1 -InputFolder "C:\Videos" -Quality low
```

### Quality Presets

The script offers three quality presets:

1. **Low** (Faster, smaller file size)
   - CRF: 28
   - Preset: faster
   - Best for: Archiving, storage-constrained scenarios

2. **Medium** (Default, balanced)
   - CRF: 23
   - Preset: medium
   - Best for: Most use cases, good balance of quality and size

3. **High** (Slower, better quality)
   - CRF: 18
   - Preset: slow
   - Best for: When quality is priority over file size

### Video Selection

When the script runs, it will:
1. List all video files in the specified directory
2. Prompt you to select videos for compression
3. You can select videos in two ways:
   - Type 'a' to select all videos
   - Enter specific numbers separated by commas (e.g., "1,3,4")

### Output

- Compressed videos are saved in the same directory as the originals
- Output filename format: `originalname_compressed.extension`
- The script provides detailed information for each compressed video:
  - Original size
  - Compressed size
  - Space savings percentage

## Troubleshooting

1. **"FFmpeg is not installed or not in PATH"**
   - Verify FFmpeg is installed correctly
   - Check if FFmpeg is in your system's PATH
   - Try running `ffmpeg -version` in terminal

2. **Script not accessible globally**
   - Verify the script is in the correct folder
   - Check your PowerShell profile is set up correctly
   - Ensure you've restarted PowerShell after making changes

3. **Permission Issues**
   - Run PowerShell as Administrator
   - Check execution policy:
   ```powershell
   Get-ExecutionPolicy
   ```
   - If restricted, you may need to change it:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Notes

- The script preserves the original files and creates new compressed versions
- Processing time depends on video size, quality settings, and your system's capabilities
- Higher quality presets will take longer to process but produce better results
