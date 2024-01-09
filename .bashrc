# .bashrc

# source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# user specific aliases and functions

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
export LC_ALL="en_US.UTF-8"
export FTP_PASSIVE_MODE="YES"
export GOPATH=$HOME/lib/go
export FACTERLIB=/opt/puppetlabs/puppet/cache/lib/facter
if [ -z "${PATH-}" ] ; then
      PATH=$HOME/bin:$HOME/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$GOPATH/bin:/opt/puppet/bin:/opt/puppetlabs/bin
else
    TEST_PATH=(
        /bin
        /sbin
        /usr/bin
        /usr/sbin
        /usr/local/bin
        /usr/local/sbin
        $GOPATH/bin
        /opt/puppet/bin
        /opt/puppetlabs/bin
        $HOME/bin
        $HOME/sbin
    )
    for I in ${TEST_PATH[@]}; do
        if ! echo "${PATH}" | grep -E -q "(^|:)${I}:"; then
            PATH=${I}:${PATH}
        fi
    done
fi
export PATH="${PATH}"

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
    if [[  ${EUID} == 0 ]]; then
        # role
        if ! [[ -s $HOME/.info/role ]]; then
            install -o $USER -d $HOME/.info/
            FACTERLIB="/var/lib/puppet/lib/facter" facter role > $HOME/.info/role
        fi
        ROLE=$( cat $HOME/.info/role )
        if [[ -z $ROLE ]]; then
            ROLE='prod'
        fi
    fi
    export FULL_HOSTNAME=$( hostname -f 2>/dev/null || hostname )
    if [[ ${EUID} == 0 && $ROLE == 'prod' ]]; then
        PROMT_COLOR="\[\033[01;31m\]"
    elif [[ ${EUID} == 0 && $ROLE != 'prod' ]]; then
        PROMT_COLOR="\[\033[01;33m\]"
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
    alias la='ls -Ah --color=auto'
    alias l='ls -CFh --color=auto'
    alias ltr='ls -ltrh --color=auto'
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

# banner
if [[ $- == *i* ]] ; then
    if [[ -d /etc/motd ]]; then
        COUNT=$(ls /etc/motd/ | wc -l)
        cat /etc/motd/cats_$(echo $((RANDOM%$COUNT+1)) )
        alias randomcat="cat /etc/motd/cats_\$(echo \$((RANDOM%$COUNT+1)) )"
    fi
fi

# save ssh
PARENT="$(ps -o comm --no-headers $PPID 2>/dev/null)"
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
        if [[ -s $HOME/.ssh/keep_vars ]]; then
            source $HOME/.ssh/keep_vars
            # this command must be run from shell within detached and re-attached screen session
            # to interact with ssh-agent properly
            alias fixssh="source $HOME/.ssh/keep_vars"
            alias ssh='source $HOME/.ssh/keep_vars; ssh'
            alias scp='source $HOME/.ssh/keep_vars; scp'
        fi
        ;;
esac

# paste
pastecorp() {
    do_usage_pastecorp(){
        cat <<EOF 1>&1
Usage:
    pastecorp exp=100 /tmp/test.md
    cat /tmp/test.md | pastecorp
EOF
    }
    local EXPIRE=1 # default 1 day
    # args {{
    for ARG in $@; do
        if echo "$ARG" | grep -qP -- "^(--help|-h|help)$"; then
            do_usage_pastecorp
            return 1
        elif echo $ARG | grep -qP "^(exp|expire|EXP|EXPIRE)="; then
            local EXPIRE=$( echo "$ARG" | sed 's|^.*=||')
        elif [[ -s $ARG ]]; then
            FILES+=($ARG)
        fi
        shift
    done
    # }}

    # curl {{
    if which .curl &> /dev/null; then
        local CURL=$( which .curl )
    else
        local CURL=$( which curl )
    fi
    # }}
    # name {{
    if test -z $MR_USERNAME; then
        local USERNAME=$USER
    else
        local USERNAME=$MR_USERNAME
    fi
    local NAME="${USERNAME}@$(hostname -s)"
    # }}

    if [[ -z $FILES ]]; then
        read -d '' DATA_SOURCE
        local DATA="text="${DATA_SOURCE}""
        $CURL \
            --request POST \
            --data-urlencode "$DATA" \
            --data "name=${NAME}" \
            --data "expire=${EXPIRE}" \
            --silent \
            "https://paste.corp.mail.ru/api/create"
    else
        for FILE in ${FILES[@]}; do
            local DATA="text@$FILE"
            $CURL \
                --request POST \
                --data-urlencode "$DATA" \
                --data "name=${NAME}" \
                --data "expire=${EXPIRE}" \
                --silent \
                "https://paste.corp.mail.ru/api/create"
        done
        unset FILES
    fi
}

# git completion {{
GIT_VERSION=$( git version 2>/dev/null | awk '{print $3}' )
if [[ $( echo -e "2.0.0.0\n$GIT_VERSION" | sort -V | tail -1 ) == "2.0.0.0" ]]; then
    GIT_COMPLETION="$HOME/.git-completion.sh"
else
    GIT_COMPLETION="$HOME/.git-completion.bash"
fi
if [[ -f $GIT_COMPLETION ]]; then
    source $GIT_COMPLETION
fi
# }}

# git promt {{
GIT_PROMPT_ONLY_IN_REPO=1
if [[ -f $HOME/.bash-git-prompt/gitprompt.sh ]]; then
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
# }}

# screen settings
export SCREENDIR=$HOME/.screen

# puppet
alias pagent='puppet agent -t'
alias pagent_noop='puppet agent -t --noop'
alias pagentmyenv='puppet agent -t --environment=gefimov'
alias pagentmyenv_noop='puppet agent -t --environment=gefimov --noop'
if [[ -s /etc/puppet/puppet.conf ]]; then
    if grep -qw environment /etc/puppet/puppet.conf; then
        PUPPET_ENV=$( grep -w environment /etc/puppet/puppet.conf | head -1 | awk '{print $NF}' )
        alias pagentpenv_noop="puppet agent -t --environment=gefimov_$PUPPET_ENV --noop"
        alias pagentpenv="puppet agent -t --environment=gefimov_$PUPPET_ENV"
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

# load other rc
if [[ -d $HOME/.bashrc.d ]]; then
    for FILE in $( ls $HOME/.bashrc.d/ ); do
        if [[ -s $HOME/.bashrc.d/$FILE ]]; then
            source $HOME/.bashrc.d/$FILE
        fi
    done
fi

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# child process pids
function getcpid() {
    cpids=$( pgrep -P $1| xargs )
    for cpid in $cpids; do
        echo "$cpid"
        getcpid $cpid
    done
}
