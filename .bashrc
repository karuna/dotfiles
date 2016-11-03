# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=erasedups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#  debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  PS1='\[\033[01;32m\]\W\[\033[00m\] \[\033[01;31m\]\$\[\033[00m\] '
else
  #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  PS1='\W \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
  #. ~/.bash_aliases
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Make Kirby dance in your command prompt
export ORIG_PS1=$PS1
export KIRBY_IDX=0
#<('o'<) ^( '-' )^ (>‘o’)> v( ‘.’ )v <(' .' )> <('.'<) ^( '.' )^ (>‘.’)> v( ‘.’ )v <(' .' )>
# ٩(●̮̮̃•̃)۶ ٩(-̮̮̃-̃)۶ ٩(͡๏̯͡๏)۶ ٩(-̮̮̃•̃)۶ ٩(×̯×)۶
KIRBY_FRAMES=("<('.'<)" "^('.')^" "(>'.')>" "^('.')^")
#KIRBY_FRAMES=("<('o'<)" "^( '-' )^" "(>‘o’)>" "v( ‘.’ )v" "<(' .' )>" "<('.'<)" "^( '.' )^" "(>‘.’)>" "v( ‘.’ )v" "<(' .' )>")
#KIRBY_FRAMES=("٩(●̮̮̃•̃)۶" "٩(-̮̮̃-̃)۶" "٩(͡๏̯͡๏)۶" "٩(-̮̮̃•̃)۶" "٩(×̯×)۶")
export PROMPT_COMMAND='export PS1="\[\033[00;93m\]${KIRBY_FRAMES[KIRBY_IDX]}\[\033[00m\] $ORIG_PS1"; export KIRBY_IDX=$(expr $(expr $KIRBY_IDX + 1) % ${#KIRBY_FRAMES[@]})'

export CFLAGS="-march=core2 -O2"
export CXXFLAGS="$CFLAGS"
export MAKEOPTS="-j3"

export VISUAL="vim"

set_python3() {
  PYTHONPREFIX=/usr
  PYTHONVERSION=3.3

  export PYTHONHOME=$PYTHONPREFIX
  export PYTHONPATH=$PYTHONPREFIX/lib/python$PYTHONVERSION
  sudo ln -s -f /usr/bin/python3 /usr/bin/python
}

set_python2() {
  PYTHONPREFIX=/usr
  PYTHONVERSION=2.7

  export PYTHONHOME=$PYTHONPREFIX
  export PYTHONPATH=$PYTHONPREFIX/lib/python$PYTHONVERSION
  sudo ln -s -f /usr/bin/python2 /usr/bin/python
}

set_gcc5() {
  export CC=gcc-5
  export CXX=g++-5
}

enterprise() {
  play -c 2 -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +10
}

karma_run() {
  export QT_QPA_PLATFORM=''
  karma start spec/js/karma.config.js --no-single-run
}

alias twurl_sandbox='twurl -H ads-api-sandbox.twitter.com'
alias twurl_ads='twurl -H ads-api.twitter.com'
alias pretty_json="underscore print --outfmt pretty"

wrapper() {
  start=$(date +%s)
  "$@"
  [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
   running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

die() {
  kill -9
}

# ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# font anti alias
export GDK_USE_XFT=1
export QT_XFT=true

#systemd
export SYSTEMD_EDITOR="/usr/bin/vim"
export EDITOR="/usr/bin/vim"
export FCEDIT="$EDITOR"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

#idea 
export PATH=/opt/idea/bin:$PATH

# Heroku
#export PATH=/usr/local/heroku/bin:$PATH
#export PATH=$PATH:$HOME/documents/heroku/bin # Add heroku-toolbelt

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# nvm node version manager
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh" # This loads NVM

# __OLD_PATH=$PATH

# updatePATHForNPM() {
#   export PATH=$(npm bin):$__OLD_PATH
# }

# node-mode() {
#   PROMPT_COMMAND=updatePATHForNPM
# }

# node-mode-off() {
#   unset PROMPT_COMMAND
#   PATH=$__OLD_PATH
# }

# dnvm dotnet version manager
#[[ -s "$HOME/.dnx/dnvm/dnvm.sh" ]] && source "$HOME/.dnx/dnvm/dnvm.sh" # Load dnvm

# rbenv
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"
#export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# rsvm
#[[ -s $HOME/.rsvm/rsvm.sh ]] && . $HOME/.rsvm/rsvm.sh # This loads RSVM
#if [ -d $HOME/.cargo/bin ]; then
#  export PATH="$HOME/.cargo/bin:$PATH"
#fi

#rustup
export PATH="$HOME/.cargo/bin:$PATH"

# swiftenv
export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$PATH"
eval "$(swiftenv init -)"

# go
export GOROOT="/usr/libgo"
export GOPATH="$HOME/job/go"

#phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# java
# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
#export JAVA_HOME="$HOME/.jenv/versions/1.8/"
export JAVA_HOME="/usr/lib/jvm/java-8-jdk"

# maven
export M2_HOME=/opt/maven
export M2=$M2_HOME/bin
export MAVEN_OPTS=-Xms256m

# vscode
export PATH="$PATH:$HOME/download/languages/editor/code"
#function __code {
  #if [ "$@x" != 'x' ]; then
    #(~/download/languages/editor/code/code "$@" &) &> /dev/null
  #else
    #(~/download/languages/editor/code/code &) &> /dev/null
  #fi
#}
                       
#alias code='__code'

# Fucking gnu coreutils maintainer think they know better by adding non standard quoting style to ls output.
# I'm gonna find whoever did this and do sd32u342utlewlwehjqwehqiweuty things to them
export QUOTING_STYLE=literal

# I can't type
# turn 'gi tadd foo' to 'git add foo'
alias gi="git"
alias gpp="g++"
eval $(dircolors -b $HOME/.dircolors)

# tabtab source for yo package
# uninstall by removing these lines or running `tabtab uninstall yo`
#[ -f /home/karuna/.nvm/versions/node/v6.0.0/lib/node_modules/yo/node_modules/tabtab/.completions/yo.bash ] && . /home/karuna/.nvm/versions/node/v6.0.0/lib/node_modules/yo/node_modules/tabtab/.completions/yo.bash

# rvm
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -r $rvm_path/scripts/completion ]] && source $rvm_path/scripts/completion


keepass_backup() {
  ORIGIN_KEEPASS=$HOME/documents/karuna.kdbx
  DESTINATION_KEEPASS=$HOME/backup/dropbox/keepass/
  echo 'Copying keepass file...'
  cp $ORIGIN_KEEPASS $DESTINATION_KEEPASS/karuna-`date +%Y%m%d`.kdbx
  echo 'Done.'
}
