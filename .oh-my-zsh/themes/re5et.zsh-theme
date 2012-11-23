#
#  vim: set ft=zsh:
autoload -U add-zsh-hook
autoload -Uz vcs_info

if [ "$(whoami)" = "root" ]; then CARETCOLOR="red"; else CARETCOLOR="magenta"; fi

local return_code="%(?..%{$fg_bold[red]%}Exit: %?%{$reset_color%})"
set -A altchar ${(s..)terminfo[acsc]}
PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"

function preexec() {
#This is for terminal title
	print -Pn "\e]0;$1\a"
}

function precmd() {
#reset term title for screen
	print -Pn "\\033]0\;What is thy bidding, my Master\\007"
	local TERMWIDTH
	(( TERMWIDTH = ${COLUMNS} - 1 ))
	local promptsize=${#${(%):--%n@%m:()--}}
	#local zero='%([BSUbfksu]|([FB]|){*})'
	BAR=$(zsh_path | strip_ctrl_chars.pl)
	local pwdsize=${#${(S%%)BAR}}
	#FOO=$(git_prompt_info)
	#local gitinfosize=${#${(S%%)FOO//$~zero/}} 
	#PR_FILLBAR="\${(l.((${TERMWIDTH} - ($promptsize + $pwdsize + $gitinfosize) -1))..─.)}"
	PR_FILLBAR="\${(l.((${TERMWIDTH} - ($promptsize + $pwdsize) -1))..─.)}"
}

zstyle ':vcs_info:*' actionformats \
    '%{$c8%}(%f%s)%{$c7%}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'

zstyle ':vcs_info:*' formats \
    "%{$c8%}%s%%{$c7%}❨ %{$c9%}%{$c11%}%b%{$c7%} ❩%{$reset_color%}%f"

zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd() {
	vcs_info
    dir_status="%{$(zsh_path)%}"
	PROMPT='╭─%{$fg_bold[cyan]%}%n%{$reset_color%}%{$fg[yellow]%}@%{$reset_color%}%{$fg_bold[blue]%}%m%{$reset_color%}:(%{${fg_bold[green]}%}${dir_status})%{$reset_color%}${(e)PR_FILLBAR}─╮
╰─%{${fg[$CARETCOLOR]}%}%#%{${reset_color}%} '
  if [ "${vcs_info_msg_0_}" = "" ]; then
	RPS1='${return_code}─╯'
  elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
	RPS1='${return_code} ${vcs_info_msg_0_}%{$30%} %{$bg_bold[red]%}%{$fg_bold[cyan]%}C%{$fg_bold[black]%}OMMIT%{$reset_color%}─╯'
  elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
	RPS1='${return_code} ${vcs_info_msg_0_}%{$bg_bold[red]%}%{$fg_bold[blue]%}D%{$fg_bold[black]%}IRTY%{$reset_color%}─╯'
  else
	RPS1='${return_code} ${vcs_info_msg_0_}─╯'
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}^%{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ✗"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✓"
