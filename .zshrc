# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="re5et"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

HIST_IGNORE_ALL_DUPS="true"
HIST_FIND_NO_DUPS="true"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github ruby rvm gem screen debian knife history-substring-search vagrant perl python)

source $ZSH/oh-my-zsh.sh
source /home/poly/.rvm/scripts/rvm

vim_func() {
	rxvt -geometry 182x70+0+0 -e vim "$@" &
}

16to2_func() {
	echo "ibase=16;obase=2;$@" | bc
}

16to10_func() {
	echo "ibase=16;obase=10;$@" | bc
}

10to2_func() {
	echo "ibase=10;obase=2;$@" | bc
}

10to16_func() {
	echo "ibase=10;obase=16;$@" | bc
}

2to10_func() {
	echo "ibase=2;obase=10;$@" | bc
}

2to16_func() {
	echo "ibase=2;obase=16;$@" | bc
}

alias 16to2='16to2_func'
alias 16to10='16to10_func'
alias 10to2='10to2_func'
alias 10to16='10to16_func'
alias 2to10='2to10_func'
alias 2to16='2to16_func'
alias vi='vim_func'
alias ls='ls -h --color --time-style="+%d-%m-%Y %H:%M" --group-directories-first'

#function precmd() {
#	print -Pn "\e]2;What is thy bidding, my Master\a"
#}

#function preexec() {
#	print -Pn "\e]2;aaa\a"
#}

# Customize to your needs...
export PATH=/home/poly/.rvm/gems/ruby-1.9.2-p320/bin:/home/poly/.rvm/gems/ruby-1.9.2-p320@global/bin:/home/poly/.rvm/rubies/ruby-1.9.2-p320/bin:/home/poly/.rvm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/junkyard/android-sdk/tools:/junkyard/android-sdk/platform-tools:/usr/games:/home/poly/proggies:/home/poly/.rvm/bin

export EDITOR=vi
export TERM=rxvt-256color
