

typeset -U path cdpath fpath manpath

function source_if_exists() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}

for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/9bgw2q3kqylgvsi8gdv31np04rbdaacp-zsh-5.8/share/zsh/$ZSH_VERSION/help"

# Use emacs keymap as the default.
bindkey -e

eval "$(/opt/homebrew/bin/brew shellenv)"

eval $(gdircolors -b ~/.config/LS_COLORS)
PROMPT='$(shell-prompt "$?" "${__shadowenv_data%%:*}" "${__dev_source_dir}")'

gpg-agent --daemon >/dev/null 2>&1
function kick-gpg-agent {
  pid=$(ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
  export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent:${pid}:1
}
kick-gpg-agent
export GPG_TTY=$(tty)

function g8r() {
  git rebase -i "$(git merge-base HEAD "${1:-master}")"
}

function g8u() {
  git rebase "${1:-origin/master}"
}

gh() { cd  "$(gh  "$@")" }
ghs() { cd "$(ghs "$@")" }
ghb() { cd "$(ghb "$@")" }
]gs() { cd "$(]gs "$@")" }
]gb() { cd "$(]gb "$@")" }
ghs() { dev clone $1 }
]g()  { dev cd "$@" }
]gs() { dev cd "$@" }
]gb() { dev cd "burke/$@" }

# Fancy substitutions in prompts
setopt prompt_subst

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename
# generation, etc.  (An initial unquoted ‘~’ always produces named directory
# expansion.)
setopt EXTENDED_GLOB

# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument  list. This also applies to file
# expansion of an initial ‘~’ or ‘=’.
setopt NOMATCH

# no Beep on error in ZLE.
setopt NO_BEEP

# Remove any right prompt from display when accepting a command line. This may
# be useful with terminals with other cut/paste methods.
setopt TRANSIENT_RPROMPT

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD

setopt auto_pushd
setopt append_history

# Show a highlighted '%' when the final line of output lacks a trailing
# newline. Without this, the prompt overdraws that final line.
setopt PROMPT_SP

# I don't use the !!/etc. commands, so this means I don't have to carefully
# quote/escape '!' in (e.g.) git commit messages.
unsetopt PROMPT_BANG

unsetopt MULTIOS

PATH="$HOME/bin:$HOME/bin/_git:$PATH"

path+="$HOME/.zsh/plugins/zsh-autosuggestions"
fpath+="$HOME/.zsh/plugins/zsh-autosuggestions"
path+="$HOME/.zsh/plugins/zsh-syntax-highlighting"
fpath+="$HOME/.zsh/plugins/zsh-syntax-highlighting"


# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes sight start up slowdown
# as all $fpath entries will be traversed again.
autoload -U compinit && compinit

# Environment variables
source_if_exists "/Users/burke/.nix-profile/etc/profile.d/hm-session-vars.sh"
export DEV_ALLOW_ITERM2_INTEGRATION="1"
export EDITOR="vim"
export GIT_EDITOR="vim"
export GOPATH="$HOME"
export HOME_MANAGER_CONFIG="/b/etc/nix/home.nix"
export NVIM_TUI_ENABLE_TRUE_COLOR="1"
export PATH="$HOME/.emacs.d/bin:$HOME/bin:$PATH"
export VISUAL="vim"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3"

source_if_exists "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source_if_exists "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="50000"
SAVEHIST="50000"
HISTFILE="$HOME/.local/share/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


# This script was automatically generated by the broot function
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    f=$(mktemp)
    (
        set +e
        broot --outcmd "$f" "$@"
        code=$?
        if [ "$code" != 0 ]; then
            rm -f "$f"
            exit "$code"
        fi
    )
    code=$?
    if [ "$code" != 0 ]; then
        return "$code"
    fi
    d=$(cat "$f")
    rm -f "$f"
    eval "$d"
}

autoload -Uz promptinit
promptinit
# zsh-mime-setup
autoload colors
colors
autoload -Uz zmv # move function
autoload -Uz zed # edit functions within zle
zle_highlight=(isearch:underline)

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

typeset WORDCHARS="*?_-.~[]=&;!#$%^(){}<>"

zle-dev-open-pr() /opt/dev/bin/dev open pr
zle -N zle-dev-open-pr
bindkey 'ø' zle-dev-open-pr # Alt-O ABC Extended
bindkey 'ʼ' zle-dev-open-pr # Alt-O Canadian English

zle-dev-open-github() /opt/dev/bin/dev open github
zle -N zle-dev-open-github
bindkey '©' zle-dev-open-github # Alt-G ABC Extended & Canadian English

zle-dev-open-shipit() /opt/dev/bin/dev open shipit
zle -N zle-dev-open-shipit
bindkey 'ß' zle-dev-open-shipit # Alt-S ABC Extended & Canadian English

zle-dev-open-app() /opt/dev/bin/dev open app
zle -N zle-dev-open-app
bindkey '®' zle-dev-open-app # Alt-R ABC Extended & Canadian English

zle-dev-cd(){ dev cd ${${(z)BUFFER}}; zle .beginning-of-line; zle .kill-line; zle .accept-line }
zle -N zle-dev-cd
bindkey 'ð' zle-dev-cd # Alt-D ABC Extended
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-spin() { LBUFFER+="꩜  " }
zle -N zle-spin
bindkey '¡' zle-spin # Alt-1

zle-dev-cd() {
  dev cd "${${(z)BUFFER}}"
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-dev-cd
bindkey '∂' zle-dev-cd # Alt-D Canadian English

zle-checkout-branch() {
  local branch
  branch="$(git branch -l | fzf -f "${${(z)BUFFER}}" | awk '{print $1; exit}')" 
  git checkout "${branch}" >/dev/null 2>&1
  zle .beginning-of-line
  zle .kill-line
  zle .accept-line
}
zle -N zle-checkout-branch
bindkey '∫' zle-checkout-branch # Alt-B Canadian English

# Figure out the closure size for a certain package
nix-closure-size() {
  nix-store -q --size $(nix-store -qR $(readlink -e $1) ) \
    | awk '{ a+=$1 } END { print a }' \
    | nix run nixpkgs.coreutils -c numfmt --to=iec-i
}

ggg() {
  gaac "$*" && ggn
}

source_if_exists ~/.iterm2_shell_integration.zsh
source_if_exists ~/.nix-profile/etc/profile.d/nix.sh

if [[ -n "${SCREENCAST}" ]]; then
  HISTFILE=$(mktemp)
fi

export KUBECONFIG=/Users/burke/.kube/config.shopify.cloudplatform

source_if_exists /opt/dev/dev.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }


# Aliases
alias @='cn -h 1'
alias a='ag'
alias aa='ag -a'
alias aai='ag -ai'
alias ai='ag -i'
alias bi='bundle install'
alias bo='bundle open'
alias bs='bundle show'
alias bu='bundle update'
alias bx='bundle exec'
alias c1='cn 1'
alias c1h='cn -h 1'
alias c2='cn 2'
alias c2h='cn -h 2'
alias c3='cn 3'
alias c3h='cn -h 3'
alias c4='cn 4'
alias c4h='cn -h 4'
alias c5='cn 5'
alias c5h='cn -h 5'
alias c6='cn 6'
alias c6h='cn -h 6'
alias c7='cn 7'
alias c7h='cn -h 7'
alias c8='cn 8'
alias c8h='cn -h 8'
alias c9='cn 9'
alias c9h='cn -h 9'
alias chx='chmod +x'
alias ctr='ctags -R .'
alias dld='dev load-dev --no-backend'
alias dls='dev load-system --no-backend'
alias do,pr='dev open pr'
alias do,s='dev open shipit'
alias g='grep'
alias ga='git add'
alias gaac='git add -A .; gac'
alias gap='git add -p'
alias gav='git commit -av'
alias gb='git branch'
alias gbd='git branch -D'
alias gbl='git branch -l'
alias gcaar='git add -A .; git commit -a --reuse-message=HEAD --amend'
alias gcar='git commit -a --reuse-message=HEAD --amend'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='gco master'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gd='git pull'
alias gf='git diff'
alias gfc='git diff --cached'
alias ggn='gug && do,pr'
alias git-fuck-everything='git-abort ; git reset . ; git checkout . ; git clean -f -d'
alias gl='git log'
alias glp='git log -p'
alias glpr='git log -p --reverse'
alias glr='git log --reverse'
alias gm='git merge'
alias gma='git merge --abort'
alias gn='git clone'
alias gr='git reset HEAD'
alias gr1='git reset '\''HEAD^'\'''
alias gr2='git reset '\''HEAD^^'\'''
alias gra='git rebase --abort'
alias grbog='grbom && gufg'
alias grbom='gcom && gfrom && git reset --hard FETCH_HEAD && gco - && git rebase master'
alias grc='git rebase --continue'
alias grh='git reset --hard HEAD'
alias grh1='git reset --hard '\''HEAD^'\'''
alias grh2='git reset --hard '\''HEAD^^'\'''
alias grho='git reset --hard'
alias gri='git rebase -i'
alias gro='git reset'
alias gs='git stash'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gt='git status -sb'
alias gtl='git tag -l'
alias gtr='gotags -R . > tags'
alias gu='git push'
alias gut='git push --tags'
alias gutf='git push --tags -f'
alias gwc='git whatchanged'
alias gzD='git branch -l | fzf | xargs git branch -D'
alias gzb='git branch -l | fzf | xargs git checkout'
alias gzd='git branch -l | fzf | xargs git branch -d'
alias gzri='git log -30 --format=oneline | fzf | cut -d '\'' '\'' -f 1 | xargs git rebase -i'
alias gzt='git tag -l | fzf | xargs git checkout'
alias h1='h 1'
alias h10='h 10'
alias h15='h 15'
alias h2='h 2'
alias h20='h 20'
alias h3='h 3'
alias h30='h 30'
alias h4='h 4'
alias h40='h 40'
alias h5='h 5'
alias h50='h 50'
alias h6='h 6'
alias h60='h 60'
alias h7='h 7'
alias h8='h 8'
alias h9='h 9'
alias jc='journalctl'
alias k9='kill -9'
alias ka9='killall -9'
alias l='l1'
alias l1='tree --dirsfirst -ChFL 1'
alias l2='tree --dirsfirst -ChFL 2'
alias l3='tree --dirsfirst -ChFL 3'
alias less='/usr/bin/less -FXRS'
alias ll='ll1'
alias ll1='tree --dirsfirst -ChFupDaL 1'
alias ll2='tree --dirsfirst -ChFupDaL 2'
alias ll3='tree --dirsfirst -ChFupDaL 3'
alias ls='gls --color=auto -F'
alias m='hostname-fix ; mutt'
alias mi='gem install'
alias mu='gem uninstall'
alias mutt='kick-gpg-agent && command mutt'
alias note='ghb notes'
alias sc='systemctl'
alias shop='dev cd shopify'
alias sruby='gh ruby ruby'
alias t1='t 1'
alias t10='t 10'
alias t15='t 15'
alias t2='t 2'
alias t20='t 20'
alias t3='t 3'
alias t30='t 30'
alias t4='t 4'
alias t40='t 40'
alias t5='t 5'
alias t50='t 50'
alias t6='t 6'
alias t60='t 60'
alias t7='t 7'
alias t8='t 8'
alias t9='t 9'
alias th='tail -n+2'
alias tmux='/usr/bin/env TERM=screen-256color-bce tmux'
alias tree='command tree -I '\''Godep*'\'' -I '\''node_modules*'\'''
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias x1='xargs -n1'
alias xk9='xargs kill -9'
alias ꩜='dev spin'

# Global Aliases


# Named Directory Hashes


[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
