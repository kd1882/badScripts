# Check if directory name is provided as an argument
if (-not $args[0]) {
    Write-Host "Please provide a directory name"
} else {
    # Create the directory
    New-Item -ItemType Directory -Path $args[0] -Force
    Set-Location $args[0]

    # Create empty files using 'New-Item' cmdlet
    New-Item -ItemType File -Path index.html -Force
    New-Item -ItemType File -Path style.css -Force
    New-Item -ItemType File -Path script.js -Force
    New-Item -ItemType File -Path .gitignore -Force
    New-Item -ItemType Directory -Path assets -Force
    New-Item -ItemType Directory -Path resources -Force

    # Output success message
    Write-Host "Files created successfully"
}
