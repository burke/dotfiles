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
