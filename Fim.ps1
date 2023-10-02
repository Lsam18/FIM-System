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
    Clear-Host
    $originalForegroundColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = "Green"

    Write-Host "-------------------------------------------------------"
    Write-Host "              **** File Monitoring Tool ****"
    Write-Host "-------------------------------------------------------"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "    1) Create New Baseline"
    Write-Host "    2) Start File Monitoring"
    Write-Host "    3) Exit"
    Write-Host ""

    $Host.UI.RawUI.ForegroundColor = $originalForegroundColor
}

function Display-FileChanges($fileStatus, $filePath) {
    switch ($fileStatus) {
        "Created" {
            Write-Host "$filePath has been created!" -ForegroundColor Green
        }
        "Changed" {
            Write-Host "$filePath has changed!!!" -ForegroundColor Magenta
        }
        "Deleted" {
            Write-Host "$filePath has been deleted!" -ForegroundColor DarkRed
        }
    }
}

Show-Menu

do {
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
                Write-Host "Failed to create the new baseline." -ForegroundColor Red
            }
        }
        "2" {
            $fileHashDictionary = @{}

            if (Test-Path -Path .\original_hashcodes.txt) {
                Write-Host "Loading baseline hash values..."
                $filePathsAndHashes = Get-Content -Path .\original_hashcodes.txt

                foreach ($f in $filePathsAndHashes) {
                    $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
                }

                Write-Host "Baseline loaded successfully. Monitoring started." -ForegroundColor DarkYellow

                while ($true) {
                    Start-Sleep -Seconds 1
                    $files = Get-ChildItem -Path .\Files

                    foreach ($f in $files) {
                        $hash = Calculate-File-Hash $f.FullName
                        $filePath = $hash.Path

                        if ($fileHashDictionary.ContainsKey($filePath)) {
                            if ($fileHashDictionary[$filePath] -ne $hash.Hash) {
                                Display-FileChanges "Changed" $filePath
                                $fileHashDictionary[$filePath] = $hash.Hash
                            }
                        } else {
                            Display-FileChanges "Created" $filePath
                            $fileHashDictionary[$filePath] = $hash.Hash
                        }
                    }

                    $deletedFiles = $fileHashDictionary.Keys | Where-Object { -Not (Test-Path -Path $_) }
                    foreach ($deletedFile in $deletedFiles) {
                        Display-FileChanges "Deleted" $deletedFile
                        $fileHashDictionary.Remove($deletedFile)
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
} while ($response -ne "3")
