# Created probably in 2006
#  vim: set ft=zsh ts=4 sw=4 tw=0 fdm=marker noet :
HISTFILE=~/.history.zsh
HISTSIZE=10000	# maximum number of lines that are kept in a session
SAVEHIST=10000	# maximum number of lines that are kept in the history file
setopt no_beep
autoload -Uz compinit
compinit
autoload colors ; colors
# ------------------ history - local & global ------------------------------ {{{
setopt extended_history		# record timestamp of command in HISTFILE
setopt histignoredups		# Ignore duplicated entries in history
setopt histignorespace		# and with trailing spaces
setopt incappendhistory		# Immediately append to the history file, not just when a term is killed
# 190505 - up/down - local history, Ctrl-up/down - global history
setopt sharehistory

# # https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
# up-line-or-local-history()
# {
# 	zle set-local-history 1
# 	zle up-line-or-history
# 	zle set-local-history 0
# }
# zle -N up-line-or-local-history

# down-line-or-local-history()
# {
# 	zle set-local-history 1
# 	zle down-line-or-history
# 	zle set-local-history 0
# }
# zle -N down-line-or-local-history

# # local history
# bindkey "${terminfo[kcuu1]}" up-line-or-local-history
# bindkey "${terminfo[kcud1]}" down-line-or-local-history

# # global history
# bindkey "^[[1;5A" up-line-or-history    # [CTRL] + Cursor up
# bindkey "^[[1;5B" down-line-or-history  # [CTRL] + Cursor down

# substring history search
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward
# -------------------------------------------------------------------------- }}}
# colors																	{{{
# -----------------------------------------------------------------------------
# INFO 181203: Can be used on FreeBSD ls
# LSCOLORS="exfxcxdxbxegedabagacad";	# default, 'x' means default color
# LSCOLORS="ExGxFxdxCxDxDxhbadExEx";
# LSCOLORS="ExfxcxdxBxegedabagacad";	# dirs are bold and light blue colored
# 1.   directory
# 2.   symbolic link
# 3.   socket
# 4.   pipe
# 5.   executable
# 6.   block special
# 7.   character special
# 8.   executable with setuid bit set
# 9.   executable with setgid bit set
# 10.  directory writable to others, with sticky bit
# 11.  directory writable to others, without sticky bit
export LSCOLORS

# ------------------ auto completition ------------------------------------- {{{
# menu style when completing, only when there is more than $(select) entries
# zstyle ':completion:*' menu select=5
# zstyle ':completion:*' list-colors "no=00" "fi=00" menu select=5
# zstyle ':completion:*' list-colors '=%*=01;31' menu select=5
# green
# INFO http://stackoverflow.com/questions/23152157/how-does-the-zsh-list-colors-syntax-work
#zstyle ':completion:*:parameters'  list-colors '=*=32'
# commands are in bolded red
# zstyle ':completion:*:commands' list-colors '=*=1;31'
# zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
# zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
# zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
# zstyle ':completion:*:options' list-colors '=^(-- *)=34'
# zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# -------------------------------------------------------------------------- }}}
zstyle ':completion:*:parameters'  list-colors '=*=32'
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'	# INFO 181228: "smart case" autocomplete
# ------------------------------------------------------------------------- }}}

# include per-host configuration
if [ -e ~/.zshrc_local ]; then
	source ~/.zshrc_local
else
	print "~/.zshrc_local not found."
fi

export LD_LIBRARY_PATH=$HOME/.opt/lib:$LD_LIBRARY_PATH
export PATH="$HOME/scripts:$HOME/.opt:$HOME/.opt/bin:$HOME/.opt/sbin:$HOME/.opt/scripts:$PATH"
export PATH="$PATH:/opt/scripts:/opt/bin"
export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.opt/riscv"
# 200227 needed for root, for some reason it is not default:
export PATH="$PATH:/usr/local/sbin:/usr/local/bin"

export MANPATH=$HOME/.opt/share/man:$MANPATH
# INFO 190422: ripgrep will look for a single configuration file if and only if the RIPGREP_CONFIG_PATH environment variable is set and is non-empty.
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

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
RPS1="$(print '%{\e[0;33m%}[%~]%{\e[0;34m%}[%?]%{\e[0;32m%}[%y]%{\e[0;31m%}%{\e[0;31m%}[%D{%y.%m.%d. %H:%M:%S}]%{\e[0m%}')"
# -------------------------------------------------------------------------- }}}

if [ "$UID" -eq "0" ] ; then export DISPLAY=:0 ; fi	# enable X11 clipboard for root's vim
export EDITOR=`which nvim`
export PAGER='less -XMr'
export MANPAGER='less -s -M +Gg -i' # don't export +G to LESS because it will hang when reading large files

export LANG=POSIX				# date(1) is in english
export LC_ALL=en_US.UTF-8

# Don't expand files matching:
# fignore=(.c~ .old)
export TOP="-CH"	# flags for top(1)
export XDG_CONFIG_HOME="$HOME/.config"

# ------------------ key bindings ------------------------------------------ {{{
bindkey -e			# Emacs shortcuts

bindkey "${terminfo[khome]}"	beginning-of-line
bindkey "${terminfo[kend]}"		end-of-line
# info mapping Delete will break <BS> and <C-h>
bindkey "[1;5D"				backward-word
bindkey "[1;5C"				forward-word
bindkey "[3~"					delete-char		# xterm*deleteIsDEL: false

# <S-Tab> for reverse menu completition
# INFO 171229: my xterm + tmux + zsh won't recognize Alt-S-h, but I prefer to use C-w anyway
bindkey '^[[Z' reverse-menu-complete

bindkey '^U' backward-kill-line
bindkey "^[t" fzf-file-widget	# default was Ctrl-T

# Ctrl-W: delete word backword up to slash char (not the whole line)
autoload -U select-word-style
select-word-style bash

# -------------------------------------------------------------------------- }}}
# ------------------ auto completition ------------------------------------- {{{
# menu style when completing, only when there is more than $(select) entries
# zstyle ':completion:*' menu select=5
# zstyle ':completion:*' list-colors "no=00" "fi=00" menu select=5
zstyle ':completion:*' list-colors '=%*=01;31' menu select=5
# completion colors (a little different than /bin/ls
#autoload complist
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# green
# INFO http://stackoverflow.com/questions/23152157/how-does-the-zsh-list-colors-syntax-work
#zstyle ':completion:*:parameters'  list-colors '=*=32'
# commands are in bolded red
# zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
# -------------------------------------------------------------------------- }}}

# ------------------ alias - global ---------------------------------------- {{{
# Global aliases -- These do not have to be at the beginning of the command line.
# only for zsh
alias -g L='| less -XMr'
alias -g Zsh='~/.zshrc'
alias -g Zshl='~/.zshrc_local'
alias -g Vim='~/.vimrc'
alias -g Tmux='~/.tmux.conf'
alias -g H='| head'
alias -g T='| tail'
# alias -g G='| grep --color'
alias -g G='| rg --no-line-number --case-sensitive'
alias -g C='| wc -l'
alias -g S='> /dev/null 2>&1'
alias -g Z='| fzf'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - system utils----------------------------------- {{{
alias cpu="ps auxr"
# alias cputime="ps aux "
alias mem='TOP= top -b -o res'
alias iotopw="top -m io -o write -s 1"
alias iotopr="top -m io -o read -s 1"
alias iotop="top -m io -o total"

alias s2r='sync; acpiconf -s 3'
alias s2d='sync; acpiconf -s 4'	# Neb reka da bas radi, bit ce da mu treba pravi swap
# alias reboot='doas shutdown -r now'
alias su='su -l'

alias sw0="swapoff /dev/gpt/swap"
alias sw1="swapon  /dev/gpt/swap"
alias sw2='sw0; sw1'

alias zsnap_used="zfs get -o name,value used |grep @"
alias zsnap_destroy_all="zfs list -H -o name -t snapshot | xargs -n1 zfs destroy"
alias beadm=bectl	# 12.0 has beadm tool in base system as bectl
alias zdf="zpool list -o name,size,allocated,capacity"	# INFO 200731: better use zfs list to get free space
alias jkill="service jail stop"
alias jrun="service jail start"

# ------------------ 3rd party system utils --------------------------------
alias freec='freecolor -mt'
alias rsync="rsync -avshu --exclude .zfs"	# even '--exclude=/something' is relative to current path!
alias rssh="rsync -P -e ssh"
alias sshr="rsync -P -e ssh"
alias port="nmap -p N hostname | grep open"
alias ip="w3m www.whatismyip.com | grep 'Your IP Address Is:' | cut -d ':' -f 2 | sed 's/ //'"
alias pstree='pstree -g 2'
# -------------------------------------------------------------------------- }}}
# ------------------ alias - unix tools ------------------------------------ {{{
alias l='ls'
alias ll='ls -l'
alias llt='ls -lt'
alias la='ls -a'

alias cp='cp -ia'
alias mv='mv -i'
alias less='less -XMr'

alias df='df -h'
alias dff='/opt/df'
alias dfs='df -h | sort -h -k 4'	# sort by size
alias du='du -h'

# alias w='fetch'
alias w='wget'
alias which='which -a'

#override shell built-in commands
alias pwd='/bin/pwd'
alias kill='/bin/kill'

alias date='/bin/date +"%a %y.%m.%d. %H:%M:%S"'
alias d='/bin/date +'%y%m%d''
alias h='/bin/date +'%H:%M''

alias p='/bin/pwd'
alias pp='echo `/usr/bin/whoami`@$HOST"["$TTY"]":`/bin/pwd`'

# alias mount='mount | column -t'
alias mnt="mount | sed 's/on//g' | sed -e 's/([^()]*)//g' | column -t"

alias newfs.ntfs='mkntfs'

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
# INFO 200913: moved to zshrc_local
# -------------------------------------------------------------------------- }}}
# ------------------ alias - network --------------------------------------- {{{
alias pg='ping www.opendns.org'
alias pr="ping $(netstat -rn | grep default | awk '{print $2}')"
alias pd='ping 1.1.1.1'
alias nr='/etc/rc.d/netif restart'
alias rr='/etc/rc.d/routing restart'

alias wls='ifconfig wlan0 scan'
alias wif='ifconfig wlan0 | grep ssid | cut -d " " -f 2'
alias ssid='ifconfig wlan0 | grep ssid | cut -d " " -f 2'
alias wip='ifconfig wlan0 | grep inet | cut -d " " -f 2'      # nece pokazat nista ako nema IP adresu
alias wst='ifconfig wlan0 | grep status | cut -d " " -f 2'
alias ws='echo `wst; ssid; echo "  IP: "; wip`'

# find IPs: nmap -sP 192.168.2.1/24
# -------------------------------------------------------------------------- }}}
# ------------------ alias - user programs --------------------------------- {{{
alias vi=nvim
alias vimdiff="nvim -d"
alias vim="vi -c FZFMru"
alias vio="vi -c Files"
alias vis="vi -S"
#alias s='screen -U'
alias s='tmux'
alias history='history -Ef'	# pretty history with European dates"

alias cal='/usr/local/bin/cal -e -nod'
alias caly='/usr/local/bin/cal -e -nod $(/bin/date +%Y)'
alias calp='YEAR=$(/bin/date +%Y); MONTHP=$(expr $(/bin/date +"%m") - 1) ; printf "\t$YEAR.$MONTHP."; /usr/local/bin/cal -e -nod $MONTHP $YEAR'
alias caln='YEAR=$(/bin/date +%Y); MONTHN=$(expr $(/bin/date +"%m") + 1) ; printf "\t$YEAR.$MONTHN."; /usr/local/bin/cal -e -nod $MONTHN $YEAR'
alias feh="feh -d -B black"
alias kf='killall feh'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

# state 0x0, keycode 39 (keysym 0x73, s), same_screen YES,
alias xevm="\xev | grep -A2 '^ButtonRelease'"


# alias xev="xev | grep -A2 --line-buffered '^KeyRelease\|^ButtonRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

alias fkomanda='find . -type f -exec chmod 644 {} +'
alias dkomanda='find . -type d -exec chmod 755 {} +'
alias makni20="for i in *20*; do n=`echo $i|sed 's/%20/\ /g'`; mv $i $n; done"

alias mpa='mpv -vo=null'
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

# patched GDB from ports with python support
alias gdba="tmux rename-window gdb-arm; arm-none-eabi-gdb"

alias grip="grip --norefresh"	# GitHub readme preview, don't auto refresh because GitHubs limitation of 60 refresh in hour
alias md="grip --norefresh"	# GitHub readme preview, don't auto refresh because GitHubs limitation of 60 refresh in hour

#echo "ibase=16; FFF"|bc
#echo "obase=16; 10"|bc
alias gg='gmake clean && gmake'
alias ggu='gmake clean && gmake -j4 && gmake upload'
alias weather='curl wttr.in/Osijek\?F'

alias zathura-tabbed="tabbed -c zathura -e"		# XXX 200315 don't work as expected
alias mupdf=zathura
alias rgf="rg --no-ignore --files | grep "
alias gp='WINEPREFIX=/mnt/vm/wine/gp6 wine start /unix "/mnt/vm/wine/gp6/drive_c/Program Files/Guitar Pro 6/GuitarPro.exe"'
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
# man() {
# 	# man termcap:
# 	# mb - turn on blinking
# 	# md - turn on bold (extra bright) mode
# 	# me - turn off all atributes
# 	# se - exit standout mode
# 	# so - 
# 	# ue - 
# 	# us - 
# 	env \
# 		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
# 		LESS_TERMCAP_md=$(printf "\e[1;31m") \
# 		LESS_TERMCAP_me=$(printf "\e[0m") \
# 		LESS_TERMCAP_se=$(printf "\e[0m") \
# 		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
# 		LESS_TERMCAP_ue=$(printf "\e[0m") \
# 		LESS_TERMCAP_us=$(printf "\e[1;32m") \
# 		man "$@"
# }
# -------------------------------------------------------------------------- }}}
# For colourful man pages, navodno RedHat sytle, nije lose
# export LESS_TERMCAP_md=$'\E[01;31m'	# uppercase boldana slova postaju crvena, overidea .Xdefault: *VT100.colorBD
# export LESS_TERMCAP_se=$'\E[0m'		# smanji sirinu status bara gdje pise less ili more
# export LESS_TERMCAP_so=$'\E[01;44;33m'	# plavi status bar gdje pise less ili more

export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;44;33m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")

export LESS_TERMCAP_md=$'\E[01;31m'	# make bold letters red (and bold)
export LESS_TERMCAP_se=$'\E[0m'		# decrese width of blue status bar below

# cron: con't sell mails:
MAILTO=""

#To find and play audio straight from your terminal with mm "search terms" put the following function in your .bashrc:
function mm() {
    mpv --no-video --ytdl-format=bestaudio ytdl://ytsearch10:"$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh TODO check one day
# setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
# setopt correct # spelling correction for commands
# setopt correctall # spelling correction for arguments
# lookup functions from here # https://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

# 191207
QT_QPA_PLATFORMTHEME=qt5c

# 200625 QT5 dark theme
export QT_QPA_PLATFORMTHEME=qt5ct

# 200919 hello again slrn, after so many years/decade
NNTPSERVER='news.gmane.io'; export NNTPSERVER
