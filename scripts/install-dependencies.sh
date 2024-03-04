#! /usr/bin/bash

#################### Installing Dependencies ####################
sudo apt-get update --fix-missing
sudo apt-get update
sudo apt-get install -y curl
sudo apt-get install -y git
sudo apt-get install -y zsh
sudo apt-get install -y tmux
sudo apt-get install -y file
sudo apt-get install -y iproute2
sudo apt-get install -y xclip # For nvim to work
sudo apt-get install -y unzip jq # For ohmyposh
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash # For AZ CLI

# For gh cli and it's dependencies
type -p curl >/dev/null || (sudo apt-get update && sudo apt-get install curl -y) && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install gh -y

# For PowerShell and it's dependencies
sudo apt-get install -y wget apt-transport-https software-properties-common && \
    source /etc/os-release && \
    wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y powershell

# Install Azure Powershell
sudo pwsh -Command Install-Module -Name Az -Repository PSGallery -Scope AllUsers -Force

# Install terraform
sudo apt-get install -y gnupg software-properties-common && \
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint && \
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && \
sudo apt-get update && \
sudo apt-get install terraform

# Install nodejs
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \
sudo apt-get install -y nodejs

# Install pip for python
curl -o script.py https://bootstrap.pypa.io/get-pip.py
echo '#! /usr/bin/python3' > install-pip.py
tail -n +2 script.py >> install-pip.py
chmod u+x install-pip.py
./install-pip.py
rm -rf script.py install-pip.py

# Install pyenv
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

pyenv install 3.11
pyenv install 3.12
pyenv global 3.12

# Install pipenv
pip install pipenv --user
