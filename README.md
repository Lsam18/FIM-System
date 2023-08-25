# File-Integrity-Monitor-FIM-
File Integrity Monitoring: Create baselines and continuously track file changes for enhanced security.

---

# File Integrity Monitoring (FIM) System

Welcome to the File Integrity Monitoring (FIM) System repository! This tool helps you monitor the integrity of your files, safeguarding your digital assets against unauthorized changes. Whether you're a cybersecurity enthusiast or just curious about maintaining data security, this tool is for you.

## Getting Started

Follow these steps to set up and use the FIM system on your local machine:

### Prerequisites

- Macintosh operating system
- Windows operating system
- PowerShell (Version 5.1 or higher)

### Installation

1. **Clone the Repository:**
   ```
   git clone https://github.com/Lsam18/FIM-System.git
   
2. Direct to the Folder FIM-SYSTEM
```
 cd FIM-System
```

2. **Navigate to the Sub Folder:**
   ```
   cd "PowerShell Scripting-FIM (File Integrity Monitor)-main"
   ```

### Usage

1. **Baseline Creation:**

   - Run PowerShell as an administrator.
   - Execute the `fim.ps1` script:
     ```
     .\fim.ps1
     ```
   - Choose option 1 to create a baseline of your files' hash values.
   - This will calculate and store hash codes of all files in the "files" folder.
   - The baseline will be saved in `original_hashcodes.txt`.

2. **Monitoring Files:**

   - Run PowerShell as an administrator.
   - Execute the `fim.ps1` script:
     ```
     .\fim.ps1
     ```
   - Choose option 2 to begin monitoring files with the saved baseline.
   - The system will continuously track changes to files in the "files" folder.
   - You'll receive notifications for new files, unchanged files, modified files, and deleted files.

### Folder Structure

- **"PowerShell Scripting-FIM (File Integrity Monitor)-main":** Main folder containing the FIM system.
  - **"files":** Contains sample files to test the FIM system.
  - **"fim.ps1":** PowerShell script for baseline creation and monitoring.
  - **"original_hashcodes.txt":** Stores the baseline hash codes.

### Colors to identify each notification or insight

🟢 Green: New files added.
🔵 Blue: Files remain unchanged.
🟣 Magenta: Files have been modified.
🔴 Dark Red: Files have been deleted.

## To interupt the running script hit: 

(ctrl + C) ## mac os | ( ctrl + Break ) ## Windows 

## Support and Feedback

If you encounter any issues or have suggestions, feel free to open an issue on the [GitHub repository] (https://github.com/Lsam18/FIM-System.git). Your feedback is valuable in improving the tool.

Let's stay proactive in securing our digital assets together! 🛡️🔒

---

Thank You and enjoy! 
