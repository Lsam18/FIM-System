Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\original_hashcodes.txt

    if ($baselineExists) {
        Write-Host "Deleting existing baseline file..."
        Remove-Item -Path .\original_hashcodes.txt -Force
    }
}

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    1) Collect new Baseline"
Write-Host "    2) Begin monitoring files with saved Baseline"
Write-Host ""
$response = Read-Host -Prompt "Please enter the number (1 or 2) corresponding to your choice"
Write-Host ""

if ($response -eq "1") {
    # Delete original_hashcodes.txt if it already exists
    Erase-Baseline-If-Already-Exists

    Write-Host "Calculating hash values and creating a new baseline..."

    # Collect all files in the target folder
    $files = Get-ChildItem -Path .\Files

    # For each file, calculate the hash, and write to original_hashcodes.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\original_hashcodes.txt -Append
    }

    if (Test-Path -Path .\original_hashcodes.txt) {
        Write-Host "New baseline created successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to create the new baseline." -ForegroundColor red
    }

}

elseif ($response -eq "2") {
    
    $fileHashDictionary = @{}

    # Load file|hash from original_hashcodes.txt and store them in a dictionary
    if (Test-Path -Path .\original_hashcodes.txt) {
        Write-Host "Loading baseline hash values..."
        $filePathsAndHashes = Get-Content -Path .\original_hashcodes.txt
    
        foreach ($f in $filePathsAndHashes) {
            $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
        }

        Write-Host "Baseline loaded successfully. Monitoring started."

        # Begin (continuously) monitoring files with saved Baseline
        while ($true) {
            Start-Sleep -Seconds 1

            $files = Get-ChildItem -Path .\Files

            # For each file, calculate the hash, and compare with original_hashcodes.txt
            foreach ($f in $files) {
                $hash = Calculate-File-Hash $f.FullName

                # Notify if a new file has been created
                if ($fileHashDictionary[$hash.Path] -eq $null) {
                    Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
                }
                else {
                    # Notify if a file has been changed
                    if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                        # The file has not changed
                    }
                    else {
                        Write-Host "$($hash.Path) has changed!!!" -ForegroundColor  Magenta
                    }
                }
            }

            # Check if any files in the baseline have been deleted
            foreach ($key in $fileHashDictionary.Keys) {
                $baselineFileStillExists = Test-Path -Path $key
                if (-Not $baselineFileStillExists) {
                    Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed
                }
            }
        }
    }
    else {
        Write-Host "Baseline file not found. Please create a baseline first."
    }
}
