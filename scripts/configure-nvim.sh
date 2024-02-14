#! /usr/bin/bash

######################################## Configure nvim ########################################
# define your username
username="mason"

# Install neovim
cd /
sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && sudo chmod u+x nvim.appimage && sudo ./nvim.appimage --appimage-extract
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# Make the folder structure for the nvim configuration
cd "${HOME}"
mkdir -p "${HOME}/.config/nvim/lua/${username}/core"
mkdir -p "${HOME}/.config/nvim/lua/${username}/plugins"
mkdir -p "${HOME}/.config/nvim/plugin"

# Make the core configurations
# Options
cat <<'EOF' > "${HOME}/.config/nvim/lua/${username}/core/options.lua"
local opt = vim.opt -- for conciseness

-- allow mouse
opt.mouse = "a"

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- show absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4 -- Four spaces for tabs (prettier default)
opt.shiftwidth = 4 -- Four spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-insensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or datk will be made dark
opt.signcolumn = "yes" -- show sign column so that text does not shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

EOF

# Colorscheme
cat <<'EOF' > "${HOME}/.config/nvim/lua/${username}/core/colorscheme.lua"
-- set colorscheme to nightfly with protected in case nightfly is not installed
local status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then 
    print("Colorscheme not found!")
    return
end

EOF

# Keymaps
cat <<'EOF' > "${HOME}/.config/nvim/lua/${username}/core/keymaps.lua"
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

--------------------
-- General Keymaps
--------------------

-- Clear search highlights
keymap.set("n", "<leader>nh", ":set nohls<CR>")
keymap.set("n", "<leader>hh", ":set hls<CR>")

-- Delete single character without copying into register
keymap.set("n", "x", "_x")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split windows vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split windows horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sq", ":close<CR>") -- close current split window

-- Open keybindings for tmux and nvim for window navigation
keymap.set("n", "<C-n>", "<Nop>") -- gonna use this to navigate to previous window
keymap.set("n", "<C-p>", "<Nop>") -- gonna use this to navigate to next window

-- keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
-- keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
-- keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
-- keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

--------------------
-- Plugin Keybinds
--------------------

-- -- vim-maximizer
-- keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization
-- 
-- -- nvim-tree
-- keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
-- 
-- -- telescope
-- keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>") -- find files within current working directory, respect .gitignore
-- keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>") -- find string in current working directory as you type
-- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<CR>") -- find string under cursor in current working directory
-- keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>") -- list open buffers in current neovim instance
-- keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>") -- list available help tags
-- 
-- -- telescope git commands (not on youtube nvim video)
-- keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>") -- list all git commits (use <CR> to checkout) ["gc" for git commits]
-- keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<CR>") -- list git commits for current file/buffer (use <CR> to checkout) ["gfc" for git file commits]
-- keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>") -- list git branches (use <CR> to checkout) ["gb" for git branch]
-- keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>") -- list current changes per file with diff preview ["gs" for git status]
-- 
-- -- restart lsp server (not on youtube nvim video)
-- keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary
EOF

# Setting up plugins
cat <<'EOF' > "${HOME}/.config/nvim/lua/${username}/plugins-setup.lua"
-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then 
    return
end

-- add list of plugins to install
return packer.startup(function(use)
    -- packer can manage itself
    use("wbthomason/packer.nvim")
    use("bluz71/vim-nightfly-guicolors") -- preferred coloscheme
    use("christoomey/vim-tmux-navigator") -- tmux & split windows navigation
    use("tpope/vim-surround") -- essential plugin
    use("vim-scripts/ReplaceWithRegister") -- essential plugin
    use("numToStr/Comment.nvim") -- Commenting with gc
    if packer_bootstrap then
        require("packer").sync()
    end
end)
EOF

# Comments plugin
cat <<'EOF' > "${HOME}/.config/nvim/lua/${username}/plugins/comment.lua"
local setup, comment = pcall(require, "Comment")
if not setup then
    return
end

comment.setup()
EOF

# Config
cat <<EOF > "${HOME}/.config/nvim/init.lua"
require("${username}.plugins-setup")
require("${username}.core.options")
require("${username}.core.colorscheme")
require("${username}.core.keymaps")
require("${username}.plugins.comment")
EOF
