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

function Show-Menu {
    $originalForegroundColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = "Green"

    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "       **** File Monitoring Tool **** " 
    Write-Host "----------------------------------------"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "    1) Create New Baseline"
    Write-Host "    2) Start File Monitoring"
    Write-Host "    3) Exit"
    Write-Host ""

    $Host.UI.RawUI.ForegroundColor = $originalForegroundColor
}


Show-Menu
$response = Read-Host -Prompt "Please select an option (1/2/3)"

switch ($response) {
    "1" {
        Erase-Baseline-If-Already-Exists
        Write-Host "Calculating hash values and creating a new baseline..."

        $files = Get-ChildItem -Path .\Files

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
    "2" {
        $fileHashDictionary = @{}

        if (Test-Path -Path .\original_hashcodes.txt) {
            Write-Host "Loading baseline hash values..."
            $filePathsAndHashes = Get-Content -Path .\original_hashcodes.txt

            foreach ($f in $filePathsAndHashes) {
                $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
            }

            Write-Host "Baseline loaded successfully. Monitoring started." -ForegroundColor DarkYellow

            while ($true) {
                Start-Sleep -Seconds 1
                $files = Get-ChildItem -Path .\Files

                foreach ($f in $files) {
                    $hash = Calculate-File-Hash $f.FullName

                    if ($fileHashDictionary[$hash.Path] -eq $null) {
                        Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
                    } else {
                        if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                            # The file has not changed
                        } else {
                            Write-Host "$($hash.Path) has changed!!!" -ForegroundColor  Magenta
                        }
                    }
                }

                foreach ($key in $fileHashDictionary.Keys) {
                    $baselineFileStillExists = Test-Path -Path $key
                    if (-Not $baselineFileStillExists) {
                        Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed
                    }
                }
            }
        } else {
            Write-Host "Baseline file not found. Please create a baseline first."
        }
    }
    "3" {
        Write-Host "Exiting the File Monitoring Tool."
        return
    }
    default {
        Write-Host "Invalid option. Please select a valid option."
    }
}
