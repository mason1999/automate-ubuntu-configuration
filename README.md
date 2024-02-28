# Summary of usage
To automate your vanilla ubuntu operating system, simply run the `main.sh` file.

# Post Installation Steps
## Enabling Docker on WSL
1. Enable integration from the Docker Host (On Windows) to the WSL distribution on Docker Desktop
2. Run the command to enable the host Docker backend:
   ```
   sudo chmod 666 /var/run/docker.sock
   ```
## Establish trust between wsl and vscode
To establish trust between wsl and vscode...
1. Open up powershell and go to your wsl distribution with `wsl --distribution <distribution name>`. Then go to the wsl folder path (e.g `cd \`)
2. Then type in `code .`
3. A prompt should come up to say trusted workspaces and you should just accept. If not you can do the following: command pallete (`ctrl+shift+p`) > workspace trust (`Manage workspace trust`) > `add folder`
