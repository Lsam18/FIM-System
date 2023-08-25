# File-Integrity-Monitor-FIM-
File Integrity Monitoring: Create baselines and continuously track file changes for enhanced security.

---

# File Integrity Monitoring (FIM) System

Welcome to the File Integrity Monitoring (FIM) system! This open-source project is designed to help you monitor the integrity of your important files and detect any unauthorized changes. Whether you're a cybersecurity enthusiast or a threat hunter, this tool will provide you with real-time alerts when file modifications occur.

# Getting Started

Follow these steps to set up and run the FIM system in your own environment:

# Prerequisites

- Make sure you have PowerShell installed on your system.

# Step 1: Clone the Repository

```bash
git clone https://github.com/Lsam18/File-Integrity-Monitor-FIM-.git
cd FIM-System
```

# Step 2: Collect Baseline

1. Run the following command to delete any existing baseline file:
   ```powershell
   .\FIM-System.ps1 -Option 1
   ```

2. The script will prompt you to confirm the deletion of the existing baseline file. Type 'Y' and press Enter.

3. The script will now calculate hash values for files in the target folder and create a new baseline file called `original_hashcodes.txt`.

### Step 3: Monitor Files

1. Run the following command to start monitoring files using the saved baseline:
   ```powershell
   .\FIM-System.ps1 -Option 2
   ```

2. The system will continuously monitor the target folder for any changes to files. You'll be alerted if new files are created, files are modified, or files are deleted.

3. Keep the script running in your PowerShell terminal to receive real-time alerts.

## Acknowledgments

A big thank you to the @security blue team for their valuable insights and contributions. Your expertise has been instrumental in the development of this FIM system.

## Contributing

I welcome contributions to improve and enhance this project. Feel free to fork the repository, make your changes, and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

Thank You and enjoy! 
