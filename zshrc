# ~/.zshrc - Optimized for faster bootup

# 1. ZSH Performance Tuning (added)
# Disable glob dots to improve filename completion performance
setopt NO_GLOB_DOTS

# Disable flow control (ctrl-s/ctrl-q) for better terminal experience
setopt NO_FLOW_CONTROL

# Use hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# 2. Environment and Path - Consolidated
export PATH="$HOME/.codeium/windsurf/bin:$HOME/opt/lua-5.1/bin:/opt/homebrew/opt/postgresql@17/bin:/opt/homebrew/bin:$PATH"
export EDITOR=nvim
export DB_PASSWORD="postgres"

# 3. Lazy-load Functions (reduces initial load time)

# Python Virtualenv Auto-Loader - Optimized to run only when needed
autoload -U add-zsh-hook
load_virtualenv() {
  if [[ -n $VIRTUAL_ENV && $PWD != ${VIRTUAL_ENV:h}* ]]; then
    deactivate 2>/dev/null
  elif [[ -z $VIRTUAL_ENV ]]; then
    for d in venv .venv env .env; do
      if [[ -e ./$d/bin/activate ]]; then
        source ./$d/bin/activate
        break
      fi
    done
  fi
}
add-zsh-hook chpwd load_virtualenv

# 4. Deferred Initialization for ZInit
# Store original directory
typeset -g ZSH_ORIG_PWD=$PWD

# Check if zinit is installed, install if not
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}Installing Zinit…%f"
  mkdir -p "$HOME/.local/share/zinit"
  chmod g-rwX "$HOME/.local/share/zinit"
  git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &> /dev/null && \
    print -P "%F{33}Zinit installed.%f" || print -P "%F{160}Zinit clone failed.%f"
fi

# Load zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 5. Zinit Plugins - All with turbo mode
# Use 'wait' ice modifier to defer loading until after prompt
zinit wait lucid for \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# Load only essential annexes
zinit wait"2" lucid light-mode for \
  zdharma-continuum/zinit-annex-bin-gem-node

# 6. Restore original directory
cd "$ZSH_ORIG_PWD" 2>/dev/null || true

# 7. Prompt - Starship (faster than most prompts)
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# 8. Tools - Lazy Loading
# Zoxide (better cd) - Initialize right away for reliability
eval "$(zoxide init zsh)"
alias cd="z"

# FZF - Lazy loaded
_load_fzf() {
  # Only source if files exist
  [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh
  [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  _fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
  _fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }
  export FZF_CTRL_T_OPTS="--preview '[[ -d {} ]] && eza --tree --color=always {} | head -200 || bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
  [[ -f ~/fzf-git.sh/fzf-git.sh ]] && source ~/fzf-git.sh/fzf-git.sh
  
  # Replace the loader function with the actual command
  unfunction _load_fzf fzf
  
  # Execute the current fzf command
  command fzf "$@"
}
fzf() { _load_fzf "$@" }

# TheFuck - Lazy loaded
fuck() {
  eval "$(thefuck --alias)"
  # Replace with the actual command
  unfunction fuck
  # Run the command
  fuck "$@"
}

# 9. Aliases and Utility Functions
alias vu='osascript -e "set volume output volume (output volume of (get volume settings) + 10)"'
alias vd='osascript -e "set volume output volume (output volume of (get volume settings) - 10)"'
alias volg='osascript -e "output volume of (get volume settings)"'
vol() {
  [[ ! $1 =~ ^[0-9]+$ ]] && { echo "Usage: vol <0-100>"; return 1; }
  (( $1 < 0 || $1 > 100 )) && { echo "Error: must be 0–100"; return 1; }
  osascript -e "set volume output volume $1"
}

# Use eza only if it exists, otherwise fallback to ls
if command -v eza &>/dev/null; then
  alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
fi

# Neovim shortcuts
alias v='nvim'
alias vl='NVIM_APPNAME=nvim-lazyvim nvim'
alias vq='NVIM_APPNAME=nvim-quarto nvim'
alias vk='NVIM_APPNAME=nvim-kickstart nvim'
alias vc='NVIM_APPNAME=nvim-chad nvim'

# Navigate to iCloud Drive
# Function to navigate to iCloud Drive
function icloud() {
    cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/
}

# navigate to obsidian vault
function obsidian() {
    cd ~/areas/Obsidian/
}



# Quick open files
todo() { (cd ~/areas/Obsidian/ && nvim .todo.md); }
qn() { (cd ~/areas/Obsidian && nvim quicknote.md); }
cheat() { (cd ~ && nvim .cheatsheet.md); }
pydict() { (cd ~ && nvim .pydict.md); }
colordict() { (cd ~/resources && nvim colordict.md); }
myvimrc() { (cd ~/.config/nvim && nvim init.lua); }
myghosttyrc() { (cd ~/.config/ghostty && nvim config); }
myweztermrc() { (cd ~/.config/wezterm/ && nvim wezterm.lua); }
myzshrc() { (cd ~ && nvim .zshrc); }
passwords() { (cd ~ && nvim .passwords.md); }
snote() { (cd ~/archive/strata/ && nvim stratanote.md)}
rez() { exec zsh; } # More efficient than source
alias dv='deactivate'
alias zed="open -a /Applications/Zed.app -n"

# Git shortcuts
alias gs="git status"
alias gaa="git add -A"
alias gcm="git commit -m"
alias gp="git push"
alias gpl="git pull"

# Yazi file manager - Kept as is
y() {
  local tmp=$(mktemp -t "yazi-cwd.XXXXXX") cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd=$(<"$tmp") && [[ -n $cwd && $cwd != $PWD ]]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# 10. Deferred Loading for JS Tools
# Bun - Lazy loaded
_load_bun() {
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  unfunction _load_bun bun
  command bun "$@"
}
bun() { _load_bun "$@" }

# NVM - Conditionally loaded (already lazy)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # Predefine nvm and node commands that will trigger lazy loading
  nvm() {
    unset -f nvm node npm npx
    . "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
  
  for cmd in node npm npx; do
    eval "$cmd() { unset -f nvm node npm npx; . \"\$NVM_DIR/nvm.sh\"; $cmd \"\$@\"; }"
  done
fi

# Run virtualenv loader once on initial shell
load_virtualenv

eval $(thefuck --alias)
