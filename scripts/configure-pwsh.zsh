#! /usr/bin/bash

######################################## Configure PowerShell ########################################
profile_path=$(pwsh -Command '$PROFILE' | sed 's/Microsoft.PowerShell_profile.ps1//')

mkdir -p "${profile_path}"
mkdir -p "${HOME}/oh-my-posh-themes"
curl -L -o "${HOME}/oh-my-posh-themes/blue-owl.json" "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/blue-owl.omp.json"

# modify the json file to include more leading space between the output of the prompt and the start of the next prompt
space_block=$(echo '{ "alignment": "left", "newline": true, "segments": [ { "foreground": "#ffffff", "foreground_templates": [ "{{ if gt .Code 0 }}#ff0000{{ end }}" ], "properties": { "always_enabled": true }, "style": "plain", "template": "\u0000 ", "type": "status" } ], "type": "prompt" }' | jq '.') && \
    cat "${HOME}/oh-my-posh-themes/blue-owl.json" | jq --argjson obj "${space_block}" '.blocks = [$obj] + .blocks' > temp.json && cat temp.json > "${HOME}/oh-my-posh-themes/blue-owl.json" && rm temp.json

# Configure $PROFILE to the default configuration (blue-owl)
cat <<'EOF' > "${profile_path}/Microsoft.PowerShell_profile.ps1"
$theme_name="blue-owl"
EOF

cat <<'EOF' >> "${profile_path}/Microsoft.PowerShell_profile.ps1"
oh-my-posh init pwsh --config ${HOME}/oh-my-posh-themes/${theme_name}.json | Invoke-Expression
EOF

# Create a script which helps change the appearance
cat <<'EOF' > "${HOME}/change_oh_my_posh_appearance_pwsh.sh"
#! /usr/bin/bash

# Exit on error
set -e

# ANSI color codes for some helpful coloured output
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m' # Reset color to default

# Create a directory if it does not already exist
mkdir -p "${HOME}/oh-my-posh-themes"

# Be helpful with the themes
echo -e "${BLUE}For some initiall colors, go the the url 'https://ohmyposh.dev/docs/themes' and browse the following links to see what you might like${RESET}"

read -p "Please enter the url of the oh-my-posh theme you want to change to: " url

# Use sed to obtain the theme name and the raw content url file. Basically the following lines of code will:
# 1. Replace everything up until the last "/" with nothing and replace the string ".omp.json" with nothing
# 2. Replace github.com with raw.githubusercontent.com
# 3. Replace blob/ with nothing
theme_name="$(echo ${url} | sed 's/.*\///;s/\.omp\.json//')"
raw_content_url="$(echo ${url} | sed 's/github\.com/raw.githubusercontent.com/')"
raw_content_url="$(echo ${raw_content_url} | sed 's/blob\///')"
echo "theme name: ${theme_name}"
echo "raw_content_url: ${raw_content_url}"

# Now use curl to copy the folder
curl -L -o "${HOME}/oh-my-posh-themes/${theme_name}.json" "${raw_content_url}"

space_block=$(echo '{ "alignment": "left", "newline": true, "segments": [ { "foreground": "#ffffff", "foreground_templates": [ "{{ if gt .Code 0 }}#ff0000{{ end }}" ], "properties": { "always_enabled": true }, "style": "plain", "template": "\u0000 ", "type": "status" } ], "type": "prompt" }' | jq '.') && \
cat "${HOME}/oh-my-posh-themes/${theme_name}.json" | jq --argjson obj "${space_block}" '.blocks = [$obj] + .blocks' > temp.json && cat temp.json > "${HOME}/oh-my-posh-themes/${theme_name}.json" && rm temp.json

# And then place the following code into your powershell profile
profile_path=$(pwsh -Command '$PROFILE')

cat <<EOL > "$profile_path"
\$theme_name="${theme_name}"
EOL

cat <<'EOL' >> "$profile_path"
oh-my-posh init pwsh --config ${HOME}/oh-my-posh-themes/${theme_name}.json | Invoke-Expression
EOL

echo -e "${GREEN}To see the new configuration source the powershell profile with '. \$PROFILE'."
echo -e "${YELLOW}If the fonts do not show up, please ensure that nerd fonts is installed on your host computer.${RESET}"

EOF

chmod u+x "${HOME}/change_oh_my_posh_appearance_pwsh.sh"
