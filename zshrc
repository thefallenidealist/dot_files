# Created probably in 2006
#  vim: set ft=zsh ts=4 sw=4 tw=0 fdm=marker noet :
HISTFILE=~/.history.zsh
HISTSIZE=1000
SAVEHIST=1000
setopt no_beep		#ne bi bilo lose da doista radi
fpath+=~/.zfunc	# additional complete zsh_plugins
autoload -Uz compinit
compinit
autoload colors ; colors
setopt histignoredups			# Ignore duplicated entries in history
setopt histignorespace			# and with trailing spaces

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# include per-host configuration
if [ -e ~/.zshrc_local ]; then
	source ~/.zshrc_local
else
	print "~/.zshrc_local not found."
fi

export LD_LIBRARY_PATH=$HOME/.opt/lib:$LD_LIBRARY_PATH
# TOOLCHAIN_ARM=`find /usr/local -maxdepth 1 -type d -name "gcc-arm*"`/bin # find arm-none-eabi- tools
TOOLCHAIN_ARM=/usr/local/gcc-arm-embedded-7-2017-q4-major/bin	# faster sh startup, needs manual update
export PATH="$PATH:$HOME/.opt:$HOME/.opt/bin:$HOME/.opt/sbin:$HOME/.opt/scripts"
export PATH="$PATH:/opt/scripts:/opt/bin"
export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"
# export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.fzf/bin"
export PATH="$PATH:$TOOLCHAIN_ARM"
# Thumb toolchain (and GDB -python)

export MANPATH="$HOME/.opt/share/man:
	$HOME/toolchains/nightly-x86_64-unknown-freebsd:
	$(manpath -q)"

# ------------------ prompt - PS1, PS2, RightPS ---------------------------- {{{
case $(whoami) in
	root)
		# hostname in black on red
		PS1="$(print '%{\e[0;30;41m%}%M%#%{\e[0m%}') "
		unset MANPATH	# root doesn't need to read man pages from ~/rust
		;;
esac
PS2="$(print '%{\e[0;31m%}>%{\e[0m%}') "
# right
RPS1="$(print '%{\e[0;33m%}[%~]%{\e[0;32m%}[%y]%{\e[0;31m%}%{\e[0;31m%}[%D{%y.%m.%d. %H:%M:%S}]%{\e[0m%}')"
# -------------------------------------------------------------------------- }}}

#export DISPLAY=`hostname`:0.0	#zajeb s DHCPom i /etc/hosts fileom
#export DISPLAY=localhost:0.0
# koristi sockete umjesto TCP/IP
export DISPLAY=:0
#export EDITOR=`which vim`
export EDITOR=`which nvim`
export PAGER='less -XMr'
#export CC=/usr/bin/cc

export LANG=POSIX				# da datumi budu na eng
#export LC_CTYPE=hr_HR.UTF-8
#export LC_COLLATE=POSIX
#export LC_ALL=hr_HR.UTF-8		# palatali u shellu, datumi su hr	prevodi dosta toga
export LC_ALL=en_US.UTF-8
#LC_ALL=hr palatali i hrvatski datumi, LC_ALL=C - nema palatala, eng datumi, LANG nema neku ulogu

# For colourful man pages, navodno RedHat sytle, nije lose
export LESS_TERMCAP_md=$'\E[01;31m'	# uppercase boldana slova postaju crvena, overidea .Xdefault: *VT100.colorBD
export LESS_TERMCAP_se=$'\E[0m'		# smanji sirinu status bara gdje pise less ili more
export LESS_TERMCAP_so=$'\E[01;44;33m'	# plavi status bar gdje pise less ili more

#export COLORFGBG="green;black"	# da mutt ima normalne boje

# Don't expand files matching:
fignore=(.c~ .old)
export TOP="-CHP"	# flags for top(1)
export XDG_CONFIG_HOME="$HOME/.config"

# ------------------ key bindings ------------------------------------------ {{{
bindkey -e			# Emacs shortcuts
#binkdey -v		# vi bindkey, zanimljivo za naucit koristit i rijesit se emacs precaca

bindkey "${terminfo[khome]}"	beginning-of-line
bindkey "${terminfo[kend]}"		end-of-line
# info mapping Delete will break <BS> and <C-h>
bindkey "[1;5D"				backward-word
bindkey "[1;5C"				forward-word
bindkey "[3~"					delete-char		# xterm*deleteIsDEL: false

# <S-Tab> for reverse menu completition
# INFO 171229: my xterm + tmux + zsh won't recognize Alt-S-h, but I prefer to use C-w anyway
bindkey '^[[Z' reverse-menu-complete

# Ctrl-W: delete word backword up to slash char (not the whole line)
autoload -U select-word-style
select-word-style bash

# -------------------------------------------------------------------------- }}}
# ------------------ auto completition ------------------------------------- {{{
# menu style when completing, only when there is more than $(select) entries
zstyle ':completion:*' menu select=5
zstyle ':completion:*' list-colors "no=00" "fi=00" menu select=5
zstyle ':completion:*' list-colors '=%*=01;31' menu select=5
# completion colors (a little different than /bin/ls
#autoload complist
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# green
# INFO http://stackoverflow.com/questions/23152157/how-does-the-zsh-list-colors-syntax-work
#zstyle ':completion:*:parameters'  list-colors '=*=32'
# commands are in bolded red
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
#LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
#export LS_COLORS
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# colors same as ls(1)
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# -------------------------------------------------------------------------- }}}

# ------------------ alias - global ---------------------------------------- {{{
# Global aliases -- These do not have to be at the beginning of the command line.
# only for zsh
alias -g L='| less -XMr'
alias -g Zsh='~/.zshrc'
alias -g Vim='~/.vimrc'
alias -g Tmux='~/.tmux.conf'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep --color'
alias -g C='| wc -l'
alias -g S='> /dev/null 2>&1'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - system utils----------------------------------- {{{
# alias cpu='top -HS'
alias cpu="ps aux | sort -nrk 3,3 | head -n 5"
alias mem='top -b -o res'

alias s2r='sync; acpiconf -s 3'
alias s2d='sync; acpiconf -s 4'	# Neb reka da bas radi, bit ce da mu treba pravi swap
alias reboot='shutdown -r now'
alias su='su -l'

alias sw0="swapoff /dev/gpt/swap"
alias sw1="swapon  /dev/gpt/swap"
alias sw2='sw0; sw1'

alias zsnap_used="zfs get -o name,value used |grep @"
alias zsnap_destroy_all="zfs list -H -o name -t snapshot | xargs -n1 zfs destroy"
alias beadm=bectl	# 12.0 has beadm tool in base system as bectl
alias zdf="zpool list -o name,size,allocated,capacity"

# ------------------ 3rd party system utils --------------------------------
alias freec='freecolor -mt'
alias rsync="rsync -avshu --exclude .zfs"
alias port="nmap -p N hostname | grep open"
alias ip="w3m www.whatismyip.com | grep 'Your IP Address Is:' | cut -d ':' -f 2 | sed 's/ //'"
alias pstree='pstree -g 2'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - unix tools ------------------------------------ {{{
alias l='ls'
alias ll='ls -l'
alias llt='ls -lt'
alias lltr='ls -ltr'
alias la='ls -A'
alias cp='cp -ia'
alias mv='mv -i'
alias less='less -XMr'

alias df='df -Th'
alias du='du -h'

#alias grep='grep --color -i'
alias grep='grep --color --exclude=tags'
alias which='which -a'
alias whereis="whereis -a"

#override shell built-in commands
alias pwd='/bin/pwd'
alias kill='/bin/kill'

alias date='/bin/date +"%a %y.%m.%d. %H:%M:%S"'
alias d='/bin/date +'%y%m%d''
alias h='/bin/date +'%H:%M''

alias p='/bin/pwd'
alias pp='echo `/usr/bin/whoami`@$HOST"["$TTY"]":`/bin/pwd`'

alias mnt='mount | column -t'
alias mnt="mount | sed 's/on//g' | sed -e 's/([^()]*)//g' | column -t"

alias msg="grc cat /var/log/messages | grep -v 'wpa_supplicant\|dhclient\|wlan0: link state'"
alias lsof='fstat | grep -i '
alias u='(date && uname -a && uptime)'
alias uu='(date && uname -a && uptime) > `uname -r | cut -b 1-3`.`/bin/date +'%y%m%d'`'
alias xxd="hexdump -C"		# xxd is part of vim package
# -------------------------------------------------------------------------- }}}
# ------------------ alias - archivers ------------------------------------- {{{
alias untar='tar xvf'
alias mktar='tar cvf'
alias mkgz='gunzip -d'
alias ungz='gzip -d'
alias untgz='tar -xvzf'
alias mktgz='tar -cvzf'
alias untbz2='tar -xvjf'
alias mktbz2='tar -cvjf'
alias mkzip='zip -r'
alias unzip='/usr/local/bin/unzip'
alias unrar='unrar -idc'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - pkg ------------------------------------------- {{{
alias pkgI='pkg info -f'
alias pkgl='pkg info -l'
alias pkgq='pkg which'
alias pkgd='pkg delete'
alias pkgdd='pkg info -d'
alias pkgD='pkg info -r'	# which packages depends on that package
alias pkga='pkg info -a'	# all installed packages

#alias bup0='portaudit -Faq'
alias bup0='pkg audit -Fq'
alias bup1o='portsnap fetch update'
alias bup1='cd /usr/ports ; git pull ; make fetchindex ; cd -'
alias bup2="pkg version -v | grep -v '='"
alias bup3='portmaster -dHa'
alias bup3f='portmaster -Fa'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - network --------------------------------------- {{{
alias pg='ping www.google.com'
alias pgg='ping guglo'
alias pr='ping 192.168.1.1'
alias pd='ping 8.8.8.8'
alias nr='/etc/rc.d/netif restart'
alias rr='/etc/rc.d/routing restart'

alias wls='ifconfig wlan0 scan'
alias wco='ifconfig wlan0 ssid'
alias wif='ifconfig wlan0 | grep ssid | cut -d " " -f 2'
alias ssid='ifconfig wlan0 | grep ssid | cut -d " " -f 2'
alias wip='ifconfig wlan0 | grep inet | cut -d " " -f 2'      # nece pokazat nista ako nema IP adresu
alias wst='ifconfig wlan0 | grep status | cut -d " " -f 2'
alias ws='echo `wst; ssid; echo "  IP: "; wip`'

alias w='wget --no-check-certificate'
#alias w='wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" --no-check-certificate'

# find IPs: nmap -sP 192.168.2.1/24
# -------------------------------------------------------------------------- }}}
# ------------------ alias - user programs --------------------------------- {{{
alias vi=nvim
alias vimdiff="nvim -d"
#alias s='screen -U'
alias s='tmux'
alias history='history -Ef'	# pretty history with European dates"

alias cal='/usr/local/bin/cal -e -nod'
alias feh="feh -d -B black"
alias kf='killall feh'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

alias fkomanda='find . -type f -exec chmod 644 {} +'
alias dkomanda='find . -type d -exec chmod 755 {} +'
alias makni20="for i in *20*; do n=`echo $i|sed 's/%20/\ /g'`; mv $i $n; done"

alias mpa='\mplayer -vo null'
alias video2audio="mplayer -vc null -vo null -ao pcm "
alias avi2wav="mplayer -ao pcm:fast:file=audio.wav -vo null -vc null video.avi"
alias wav2mp3="lame -b 320 audio.wav"
alias mplayer=mpv	# muscle memory
alias mpvtest="mpv --input-test --force-window --idle"

alias freerouter="java -jar ~/kicad/bin/FreeRouter.jar"
alias autorouter="java -jar ~/kicad/bin/FreeRouter.jar"

# rename BSG S02E20 Lay Down Your Burdens Part 1 (1080p x265 Joy)_en.srt to
#        BSG S02E20 Lay Down Your Burdens Part 1.srt
alias rename_sub="for i in *;  do n=`echo $i |  sed  's/(//g;s/)//;s/ 1080p x265 Joy.*\././g'`; echo $n ; done"

# colorized cat, but slow
alias pcat="pygmentize -f terminal256 -O style=native -g"

# alias gdbA="arm-none-eabi-gdb --data-directory=/usr/local/share/gdb7121"
alias gdbA="tmux rename-window gdbA; arm-none-eabi-gdb --data-directory=~/.local/share/gdb-arm/data-directory"

alias grip="grip --norefresh"	# GitHub readme preview, don't auto refresh because GitHubs limitation of 60 refresh in hour
alias md="grip --norefresh"	# GitHub readme preview, don't auto refresh because GitHubs limitation of 60 refresh in hour

#echo "ibase=16; FFF"|bc
#echo "obase=16; 10"|bc
alias gg='gmake clean && gmake'
alias ggu='gmake clean && gmake -j4 && gmake upload'
# -------------------------------------------------------------------------- }}}

# ------------------ custom fuction - zsnap -------------------------------- {{{
function zsnap()
{
	# make recursive snapshots of specific pool or all available pools
	if [ ! -z $1 ]; then
		# make snapshot for one pool (given as argument to the function)
		zfs snapshot -r $1@`/bin/date +%y%m%d`_`/bin/date +%H%M`
	else # if called without arguments
		# make snapshot for all pools: pool@<date>
		TIMESTAMP="`/bin/date +%y%m%d`_`/bin/date +%H%M`"

		echo "Making snaphosts [ @$TIMESTAMP ] for pools:"
		for i in `zpool list -Ho name,health | grep -v UNAVAIL | cut -f 1` ; do
			echo $i
			# zfs snapshot -r $i@`/bin/date +%y%m%d`_`/bin/date +%H%M` ;
			zfs snapshot -r $i@$TIMESTAMP ;
		done
	fi
}
# -------------------------------------------------------------------------- }}}
# ------------------ custom function - ssh --------------------------------- {{{
ssh()
{
	if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
		tmux rename-window "ssh $(echo $* | cut -d . -f 4)"
		#tmux rename-window "$*"
		command ssh "$@"
		tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		command ssh "$@"
	fi
}
# -------------------------------------------------------------------------- }}}
# ------------------ custom function - man --------------------------------- {{{
# better man colors:
man() {
	# man termcap:
	# mb - turn on blinking
	# md - turn on bold (extra bright) mode
	# me - turn off all atributes
	# se - exit standout mode
	# so - 
	# ue - 
	# us - 
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}
# -------------------------------------------------------------------------- }}}


#da cron ne salje mailove
MAILTO=""

fpath=(~/.zsh_plugins/zsh-completions/src $fpath)


# test za tmux + vim fini font, ne radi
LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
# TERM=screen-256color	# treba, inace izlazak iz vima nece obrisat ekran

#To find and play audio straight from your terminal with mm "search terms" put the following function in your .bashrc:
function mm() {
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch10:"$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh korisno TODO
# setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
# setopt extended_history # save timestamp of command and duration
# setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
# setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
# setopt hist_ignore_space # remove command line from history list when first character on the line is a space
# setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
# setopt correct # spelling correction for commands
# setopt correctall # spelling correction for arguments
# pogledat funkcije
# https://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

fpath=($HOME/.zsh-completions $fpath)
