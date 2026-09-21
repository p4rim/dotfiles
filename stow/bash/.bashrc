#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cx='codex --yolo'
alias hypr='start-hyprland'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# >>> Codex installer >>>
export PATH="/home/zen/.local/bin:$PATH"
# <<< Codex installer <<<
