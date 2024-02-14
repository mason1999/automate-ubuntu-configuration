#! /usr/bin/bash

######################################## Tmux Installation ########################################
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

cat <<'EOF' > "${HOME}/.tmux.conf"
# Get rid of tmux nvim lag from escaping
set -sg escape-time 0

# Change the prefix
set -g prefix C-a
unbind C-b
bind-key C-a send-prefix

# Use <C-a>n to split terminal vertically
unbind %
bind n split-window -h

# Use <C-a>N to split the terminal horizontally
unbind '"'
bind N split-window -v

# Use <C-a>r to reload the tmux configuration file
unbind r
bind r source-file ~/.tmux.conf

# Use <C-a>[h|j|k|l] to resize the pane by 5 units
# Use <C-a>m to maximise the tmux pane
# Enable the mouse to be able to maximise
bind -r j resize-pane -D 5
bind -r k resize-pane -U 5
bind -r l resize-pane -R 5
bind -r h resize-pane -L 5
bind -r m resize-pane -Z
set -g mouse on

# Use <C-a>t to create a new window
unbind t
bind t new-window

# Use <C-n> and <C-p> to go to the next and previous window
unbind C-h
unbind C-l
bind-key -n C-n previous-window
bind-key -n C-p next-window

# Use <C-a>q to kill the pane
unbind q
bind q kill-pane

# Enable vi mode in tmux and use <C-a>v to enter it
unbind v
bind v copy-mode
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe 'xclip -in -selection clipboard'
unbind -T copy-mode-vi MouseDragEnd1Pane

# After executing git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Tmux plugin manager
set -g @plugin 'tmux-plugins/tpm'

# Naviagating tmux panes
set -g @plugin 'christoomey/vim-tmux-navigator'

# Themes for tmux
set -g @plugin 'jimeh/tmux-themepack'
set -g @themepack 'powerline/default/cyan'

# Initalize TMUX plugin manager (keep this line at the very bootom of the tmux.conf file)
# To reload: <C-a>r
# To install plugins: <C-a>I
run '~/.tmux/plugins/tpm/tpm'
EOF
