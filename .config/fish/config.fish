set -gx fish_greeting ''

set -gx TERM xterm-256color

# theme
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G --color=auto"
alias la "ls -A --color=auto"
alias ll "ls -l --color=auto"
alias :q exit
alias g git

# vim
set -gx EDITOR nvim

# path
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

