export TERM=rxvt-256color
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="re5et"
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time)
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
POWERLEVEL9K_SHOW_CHANGESET=true

POWERLEVEL9K_VCS_STAGED_ICON="\u00b1"
POWERLEVEL9K_VCS_UNTRACKED_ICON="\u25CF"
POWERLEVEL9K_VCS_UNSTAGED_ICON="\u00b1"
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON="\u2193"
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON="\u2191"
POWERLEVEL9K_SHOW_CHANGESET="true"

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
PROMPT_EOL_MARK=""

HIST_IGNORE_ALL_DUPS="true"
HIST_FIND_NO_DUPS="true"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github ruby rvm gem screen debian knife history-substring-search vagrant perl python systemd)

source $ZSH/oh-my-zsh.sh
source /opt/az/bin/az.completion.sh

vim_func() {
	rxvt -geometry 180x63+0+0 -e vim "$@" &
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

deploy_func() {
	if [ "$#" -ne 2 ]; then
		echo "deploy <reponame> <enviroment>"
		return 100
	else
		if [ "$2" != "production" ] && [ "$2" != "preprod" ] && [ "$2" != "sandbox" ]; then
			echo "Wrong enviroment"
			return 200
		else
			case $2 in
				"production")
					enviroment="production"
					;;
				"preprod")
					enviroment="preproduction"
					;;
				"sandbox")
					enviroment="sandbox"
					;;
			esac
			case $1 in
				"admin-webapp")
					srvgroup="frontends"
					;;
				"checkout-button")
					srvgroup="frontends"
					;;
				"checkout-webapp")
					srvgroup="frontends"
					;;
				"dashboard-webapp")
					srvgroup="frontends"
					;;
				"fresque")
					srvgroup="fresque"
					;;
				"checkout")
					srvgroup="backends"
					;;
				"soapserver")
					srvgroup="backends"
					;;
				"api")
					srvgroup="backends"
					;;
				"mqclient")
					srvgroup="backends"
					;;
				"all")
					for i in admin-webapp checkout-button checkout-webapp dashboard-webapp fresque checkout soapserver api mqclient; do
						deploy $i $2
					done
					;;
				*)
					echo "Wrong repository"
					return 300
					;;
			esac
			if [ $1 != "all" ]; then
				[[ $enviroment != "sandbox" ]] && { enviroment="${enviroment}-${srvgroup}" } || { srvgroup="${enviroment}"; unset enviroment }
				cd ~/ansible
				if [ -z $enviroment ]; then
					ansible-playbook -i ${srvgroup} ${srvgroup}.yml --tags deploy -e "reponame=torawallet-$1" -e "branch=master"
				else
					ansible-playbook -i ${srvgroup} ${srvgroup}.yml --tags deploy -e "reponame=torawallet-$1" -e "branch=master" -l ${enviroment}
				fi
			fi
		fi
	fi
}

alias 16to2='16to2_func'
alias 16to10='16to10_func'
alias 10to2='10to2_func'
alias 10to16='10to16_func'
alias 2to10='2to10_func'
alias 2to16='2to16_func'
alias vi='vim_func'
alias ls='ls -h --color --time-style="+%d-%m-%Y %H:%M" --group-directories-first'
alias grep='grep --color=auto'
alias genpasswd="tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1"
alias sl='ls'
alias ssh='TERM=rxvt-unicode ssh'
alias deploy='deploy_func'

precmd() {
	# Restore tmux-title to 'zsh'
	printf "\033kzsh\033\\"
	# Restore urxvt-title to 'zsh'
	print -Pn "\e]2;zsh:%~\a"
}

preexec() {
	# set tmux-title to running program
	printf "\033k$(echo "$1" | cut -d" " -f1)\033\\"
	# set urxvt-title to running program
	print -Pn "\e]2;zsh:$(echo "$1" | cut -d" " -f1)\a"
}

#function precmd() {
#	print -Pn "\e]2;What is thy bidding, my Master\a"
#}

#function preexec() {
#	print -Pn "\e]2;aaa\a"
#}

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/games:/home/poly/proggies

export EDITOR=vi
