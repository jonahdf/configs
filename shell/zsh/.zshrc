# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# OH-MY-ZSH CONFIGURATION
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true" # Removes ~18ms delay from update checks
ZSH_DISABLE_COMPFIX="true" # Skips security checks on completion files (significant speedup)
DISABLE_MAGIC_FUNCTIONS="true" # Removes bracketed-paste-magic and url-quote-magic utilities

# Only rebuild completion cache once a day
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# HOMEBREW COMPLETION PREP
# Add Homebrew completions to FPATH before OMZ initializes so it picks them up
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
  FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

# PLUGINS
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Fixes issue where pasting doesn't disable autocomplete
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# INITIALIZE OH-MY-ZSH
source "$ZSH/oh-my-zsh.sh"

# THEME
eval "$(oh-my-posh init zsh --config /Users/jonahdf/.zsh/themes/powerlevel10k_rainbow.omp.json)"

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Yazi configuration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}