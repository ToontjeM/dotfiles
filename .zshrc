## Exports
export PATH="/usr/local/sbin:$HOME/bin:$PATH:$HOME/.edb-cloud-tools/bin"
export EDITOR='vim'
export VISUAL='vim'
export HOSTNAME=`hostname`

# Aliases
alias ls='ls -pG'
alias ssh='ssh -X'
alias vi='vim'

# Prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
PROMPT=\$vcs_info_msg_0_"%(?.%F{green}√.%F{red}?)%f %F{cyan}%3~%f "
#RPROMPT=%B[%F{red}%n%f%F{white}@%f%F{cyan}%m%f]%b
zstyle ':vcs_info:git:*' formats '(%b) '
zstyle ':vcs_info:*' enable git

# Dir colors
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad;
zstyle ':completion:*:default' list-colors ''
source ~/.zsh/zcolors/zcolors.plugin.zsh
source ~/.zcolors

# vi mode
bindkey -v
export KEYTIMEOUT=1

# URL encoding
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
source ~/.zsh/fzf/keybindings.zsh

# History
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILESIZE=1000000000
HISTFILE=~/.zsh_history
export HISTORY_BASE=~/.historyfiles
source ~/.zsh/per-directory-history/per-directory-history.zsh

# Extended globbing
setopt EXTENDED_GLOB
#setopt AUTOCD

## Completion
fpath=( ~/.zsh/completion $fpath )
autoload -Uz compinit && compinit -u
autoload -U +X bashcompinit && bashcompinit
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
zmodload -i zsh/complist
_comp_options+=(globdots)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/.zcompcache"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

## EDB Completion
eval "$(register-python-argcomplete edb-deployment)"

# Direnv - Put a .envrc in your directory and "direnv allow" it.
eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
