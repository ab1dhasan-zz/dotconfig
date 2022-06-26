#menuselection
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

#history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

#shows git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

#keybindings
bindkey -- "^[[H" beginning-of-line #home
bindkey -- "^[[F" end-of-line #end
bindkey -- "^[[3;5~" kill-word #ctrl-delete
bindkey -- "^[[3~" delete-char #delete
bindkey -- "^[[Z" reverse-menu-complete #shift-tab
bindkey -- "^[[A" up-line-or-beginning-search #up
bindkey -- "^[[B" down-line-or-beginning-search #down
bindkey -- "^[[1;5D" backward-word #ctrl-left
bindkey -- "^[[1;5C" forward-word #ctrl-right
bindkey -- "^[[1;3D" backward-word #alt-left
bindkey -- "^[[1;3C" forward-word #alt-right

#shows hidden directory on tab selection
setopt globdots

#terminal escap sequences
autoload -Uz add-zsh-hook
function reset_broken_terminal() {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
add-zsh-hook -Uz precmd reset_broken_terminal

#terminal title
function term_title_precmd() {
	print -Pn -- '\e]2;%n@%m %~\a'
}
function term_title_preexec() {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
}
if [[ "$TERM" == (Eterm*|alacritty*|aterm*|gnome*|konsole*|kterm*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd term_title_precmd
	add-zsh-hook -Uz preexec term_title_preexec
fi

#prompt
setopt PROMPT_SUBST
PROMPT='%F{green}%n%f%B@%b%F{white}%m%f %F{blue}%B%~%b%f${vcs_info_msg_0_}%F{red}%(?.. [%?])%f> '
#RPROMPT='%F{red}%(?..[%?])%f'

#syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
