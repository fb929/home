# .bashrc

# source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# user specific aliases and functions

# залипуха c TERM для c5
if [[ -f /etc/redhat-release ]]; then
	CENTOS_VER=$( cat /etc/redhat-release  | awk '{print $3}' | cut -d "." -f 1 )
	if ! [[ -z $CENTOS_VER ]]; then
		if [[ $CENTOS_VER == 5 ]]; then
			TERM=xterm
		fi
	fi
fi

# prompt settings
CHECK_SHELL=$( echo $SHELL | sed 's/^.*\///' )
if [ x"$CHECK_SHELL" = xbash ]; then
	export FULL_HOSTNAME=$( hostname -f 2>/dev/null || hostname )
	if [ ${EUID} == 0 ] ; then
		PROMT_COLOR="\[\033[01;31m\]"
	else
		PROMT_COLOR="\[\033[01;32m\]"
	fi
	# prompt formattings
	PS1="\[\033[0;33m\]\t\[\033[01;34m\] \w\n$PROMT_COLOR\u@$FULL_HOSTNAME\[\033[01;34m\] \$\[\033[00m\] "
	GIT_PROMPT_START_ROOT="\[\033[0;33m\]\t\[\033[01;34m\] \w\[\033[00m\]"
	GIT_PROMPT_END_ROOT="\n$PROMT_COLOR\u@$FULL_HOSTNAME\[\033[01;34m\] \$\[\033[00m\] "
	GIT_PROMPT_START_USER=$GIT_PROMPT_START_ROOT
	GIT_PROMPT_END_USER=$GIT_PROMPT_END_ROOT
fi
case $TERM in
	screen*)
		PROMPT_COMMAND='echo -ne "\033k$HOSTNAME\033\\"'
		;;
	*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
		;;
esac

# history settings
export HISTCONTROL=ignoreboth
shopt -s histappend
export HISTTIMEFORMAT='%Y.%m.%d %H:%M:%S '
HISTSIZE=9999999

# aliases
if [ x$(uname) = xLinux ]; then
	alias ll='ls -alFh --color=auto'
	alias la='ls -A --color=auto'
	alias l='ls -CF --color=auto'
	alias ltr='ls -ltr --color=auto'
else
	alias ll='ls -alGh'
fi
alias rm='rm -i'
alias cp='cp -v'
alias mv='mv -v'
alias grep='grep --colour=auto'
[ -f /usr/local/bin/vim ] && alias vi='/usr/local/bin/vim'
[ -f /usr/bin/vim ] && alias vi='/usr/bin/vim'
alias les='vi -R'
alias less='less -x4'
alias mtr='mtr -t'
alias svndi='svn di -x -w -r base:head'
alias gpull='git pull origin master'
alias gst='git status'
alias gci='git pull origin master && git add . && git commit -a && git push origin master;'
alias ginit='git init && git add . && git commit -m "init"'
alias ssh-keygen='ssh-keygen -C $( whoami )@$( hostname -f )'
alias s='su -m'
alias zepstat='curl 127.0.0.1:10001/status/'
alias lock='co -l'
alias unlock='ci -u'
alias xat='cat'

# env
export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;31m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[01;44;33m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[01;32m'
export SVN_EDITOR="vi"
export GIT_EDITOR="vi"
export EDITOR="vi"
export GIT_SSL_NO_VERIFY="true"
export LANG="en_US.UTF-8"
export FTP_PASSIVE_MODE="YES"
export GOPATH=$HOME/lib/go
export PATH=$HOME/bin:$HOME/sbin:$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin:/opt/local/bin:$GOPATH/bin:/cloud/bin:/usr/site/bin

# banner
if [[ $- == *i* ]] ; then
	if [[ -d /etc/motd ]]; then
		COUNT=$(ls /etc/motd/ | wc -l)
		cat /etc/motd/cats_$(echo $((RANDOM%$COUNT+1)) )
		alias randomcat="cat /etc/motd/cats_\$(echo \$((RANDOM%$COUNT+1)) )"
	fi
fi

# save ssh
PARENT="$(ps -o comm --no-headers $PPID)"
case $PARENT in
	sshd)
		KEEP_VARS="SSH_CLIENT SSH_TTY SSH_AUTH_SOCK SSH_CONNECTION DISPLAY XAUTHORITY"
		install -m 0700 -d $HOME/.ssh
		touch $HOME/.ssh/keep_vars
		chmod 600 $HOME/.ssh/keep_vars
		for VAR in $KEEP_VARS; do
			(eval echo export $VAR=\\\'\$$VAR\\\')
		done > $HOME/.ssh/keep_vars
		;;
	screen)
		source $HOME/.ssh/keep_vars
		# this command must be run from shell within detached and re-attached screen session
		# to interact with ssh-agent properly
		alias fixssh="source $HOME/.ssh/keep_vars"
		alias ssh='source $HOME/.ssh/keep_vars; ssh'
		alias scp='source $HOME/.ssh/keep_vars; scp'
		;;
esac

# transfer over t.bk.ru
transfer() {
	if [ $# -eq 0 ];
		then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
		return 1
	fi
	TMPFILE=$( mktemp -t transferXXX )
	if which .curl &> /dev/null; then
		CURL=$( which .curl )
	else
		CURL=$( which curl )
	fi
	if tty -s; then
		BASEFILE=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
		$CURL --progress-bar --upload-file "$1" "https://t.bk.ru/$BASEFILE" >> $TMPFILE
	else
		$CURL --progress-bar --upload-file "-" "https://t.bk.ru/$1" >> $TMPFILE
	fi
	cat $TMPFILE
	rm -f $TMPFILE
}

# sources
if [[ -f $HOME/.git-completion.sh ]]; then
	source $HOME/.git-completion.sh
fi

GIT_PROMPT_ONLY_IN_REPO=1
if [[ -f $HOME/.bash-git-prompt/gitprompt.sh ]]; then
	source $HOME/.bash-git-prompt/gitprompt.sh
fi

# screen settings
export SCREENDIR=$HOME/.screen

# puppet
alias pagent='puppet agent -t --pluginsync'
alias pagent_noop='puppet agent -t --pluginsync --noop'
alias pagentMyenv='puppet agent -t --pluginsync --environment=gefimov'
alias pagentMyenv_noop='puppet agent -t --pluginsync --environment=gefimov --noop'
alias pagentMyenvLocal='puppet agent -t --pluginsync --environment=gefimov_local'
alias pagentMyenvLocal_noop='puppet agent -t --pluginsync --environment=gefimov_local --noop'
if [[ -s /etc/puppet/puppet.conf ]]; then
	if grep -qw environment /etc/puppet/puppet.conf; then
		PUPPET_ENV=$( grep -w environment /etc/puppet/puppet.conf | head -1 | awk '{print $NF}' )
		alias pagentPenv_noop="puppet agent -t --noop --pluginsync --environment=gefimov_$PUPPET_ENV"
		alias pagentPenv="puppet agent -t --pluginsync --environment=gefimov_$PUPPET_ENV"
	fi
fi
alias pagentKill="rm -f /etc/cron.d/puppet_watchdog; service puppet stop; pkill -f '/usr/bin/puppet'; pkill -f '/usr/bin/puppet'; pkill -f '/usr/bin/puppet'; pkill -f 'puppet agent'"


# bash_completion
if [[ -s $HOME/.bash_completion ]]; then
	source $HOME/.bash_completion
fi

# gpg
export GPG_TTY=$(tty)

# python shell autocomplete
export PYTHONSTARTUP=~/.pythonrc
