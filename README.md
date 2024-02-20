# Summary of usage
To automate your vanilla ubuntu operating system, simply run the `main.sh` file.

# Post Installation Steps
## Enabling Docker on WSL
1. Enable integration from the Docker Host (On Windows) to the WSL distribution on Docker Desktop
2. Run the command to enable the host Docker backend:
   ```
   sudo chmod 666 /var/run/docker.sock
   ```
