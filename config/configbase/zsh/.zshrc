# zstyle must be set before "antigen use prezto", since modules are
# initialized on that line.
zstyle ':prezto:*:*' case-sensitive 'yes'
zstyle ':prezto:*:*' color 'yes'

source "$HOME/.config/zsh/antigen/antigen.zsh"

_zdotdir_set=${+parameters[ZDOTDIR]}
if (( _zdotdir_set )); then
    _old_zdotdir=$ZDOTDIR
fi

antigen use prezto

antigen bundle sorin-ionescu/prezto modules/environment
antigen bundle sorin-ionescu/prezto modules/terminal
antigen bundle sorin-ionescu/prezto modules/editor
antigen bundle sorin-ionescu/prezto modules/history
antigen bundle sorin-ionescu/prezto modules/directory
antigen bundle sorin-ionescu/prezto modules/spectrum
antigen bundle sorin-ionescu/prezto modules/utility
antigen bundle sorin-ionescu/prezto modules/completion
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle Tarrasch/zsh-bd
antigen bundle supercrabtree/k
antigen bundle jocelynmallon/zshmarks

antigen apply

if (( _zdotdir_set )); then
    ZDOTDIR=$_old_zdotdir
else
    unset ZDOTDIR
    unset _old_zdotdir
fi;
unset _zdotdir_set

for f in $HOME/.config/zsh/config/modules/***/main.zsh(.N);
do
    ZSH_MOD_FOLDER=$(dirname $f)
    source $f
done

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Vim binding
bindkey -v

# Home bin
if [ -d "$HOME/bin" ]
then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/bin/common" ]
then
  PATH="$HOME/bin/common:$PATH"
fi

# Local bin
if [ -d "$HOME/.local/bin" ]
then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ]
then
  PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if [ -d "$HOME/.yarn/bin" ]
then
  PATH="$HOME/.yarn/bin:$PATH"
fi

# Ruby gem path
if hash ruby 2>/dev/null; then
  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# npm bin
if [ -d "$HOME/node_modules/.bin" ]
then
  PATH="$HOME/node_modules/.bin:$PATH"
fi

# rustup bin
if [ -d "$HOME/.cargo/bin" ]
then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# go bin
if [ -d "$HOME/go" ]
then
  GOPATH="$HOME/go"
  PATH="$HOME/go/bin:$PATH"
fi

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d "$HOME/.nvm" ]
then
  NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export TERMINFO=/usr/share/terminfo
export TERM=tmux-256color
