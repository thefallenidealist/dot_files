" 170812
" 1.0 - created 160729, again
" 0.1 - 160512 - vim as IDE at work
" 0.0 - 2006. probably
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker noet :

" Guifont DejaVu Sans Mono:h13
set sessionoptions+=tabpages,globals
" TODO 2017-09-02 Windows libclang
" 					GUI colors

"				Generic Vim settings 										{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
	" these are already default in nvim
	set nocompatible
	set ttyfast
endif
set number
set relativenumber
set mouse=a
syntax enable
filetype plugin indent on
set showmatch		" show matching search as you type
" TODO remember highlight setting when reloading vimrc
"		noh nohlsearch doesn't work
set background=dark
set laststatus=2	" always show status bar
set lazyredraw		" possible fix for slow j/k		INFO disabling cursorline also results in speedup
set hidden			" allow changing window without saving buffer first, also needed for Ctrl-Space plugin
set showcmd			" show size of visual block in cmdline at right

set notitle

set autowrite		" Automatically :write before running commands
" set autoread		" autoload files that have changed outside of vim
set noautoread

" better splits
set splitbelow
set splitright

set timeoutlen=1000 ttimeoutlen=0		" delay for the esc key, 10ms XXX
"set exrc		" source .vimrc file if it present in working directory
set secure		" This option will restrict usage of some commands in non-default .vimrc files;
" commands that wrote to file or execute shell commands are not allowed and map commands are displayed.

set nomodeline
set modelines=0
" INFO secure-modelines plugin is used which only allows some (secure) modeline options

" Xorg paste with middle click
if !has('nvim')
	set ttymouse=xterm2
endif

set gdefault "applies substitutions globally on lines. For example, instead of :%s/foo/bar/g you just type :%s/foo/bar/

"set completeopt=menuone,preview	" default
set completeopt=menuone				" f(); can be view in command line with plugin
set completeopt+=noselect			" fix deoplete auto insert
set noshowmode						"Don't show the mode(airline is handling this)
set shortmess+=I	" don't show intro message at startup
set cursorline		" color the line when the cursor is
set matchpairs+=<:>	" Include angle brackets in matching.
set showmatch

set encoding=utf-8	" otherwise gVim will complain about listchars and showbreak
"		<tab> and wrapping			{{{
"""""""""""""""""""""""""""""""""""""""
set tabstop=4		" tab size
set shiftwidth=4 	" when indenting with '>'
" set expandtab		" convert tab to spaces

" soft wrap
set wrap			" soft break when line is wider than Vim window (not tw)
set linebreak		" don't break in the middle of the word
" wont't work when "list" is enabled - will in nvim
set showbreak=…		" char to be displayed on the beggining of broken line

" hard break
" set textwidth=78	" autowrap after N chars
set colorcolumn=+1	" show coloumn where autowrap will start"
set formatoptions=""
" default: tcq
" t: autowrap using tw
" c: add comment in new line a: format line every time when it is
" changed (no more longer or shorter lines) 		pretty annoying
" TODO (if possible): soft wrap lines on tw
""""""""""""""""""""""""""""""""""""}}}
"	commandline completion			{{{
"""""""""""""""""""""""""""""""""""""""
" shell like autocompletition of commands
"set wildmode=longest,list,full
" bash like
set wildmenu		" cmd completion with wildchar (<tab>)
"set wildmode=longest,list	" at first tab show all comands
" When you type the first tab hit will complete as much as possible, the second tab hit will provide a list, the third and subsequent tabs will cycle through completion options so you can complete the file without further keys
set wildmode=list:longest,list,full
"list: full "menu" of possible matches, <tab> will not complete anything
"full: only one bar at botom with all matches
"longest: nothing will be completed
"
" Don't complete this file types
set wildignore+=*.a,*.o,*.elf,*.bin,*.dd,*.img
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp
""""""""""""""""""""""""""""""""""""}}}

" show invisible characters, tab is longer (unicode) pipe char
set listchars=tab:\│·,extends:>,precedes:<
" show ALL spaces:
" set listchars+=space:║
" set listchars+=trail:◊
set list	" show invisible chars (tabs and others defined in listchars)

" directory for swap files
" set directory=$HOME/.vim/swap/,/tmp
" place for: filename.txt~
" set backupdir=$HOME/.vim/swap/,/tmp
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
"		search						{{{
"""""""""""""""""""""""""""""""""""""""
set ignorecase		" case insensitive search, needed for the line below
set smartcase		" If searched word starts with an uppercase then be case sensitive
set incsearch		" search as you type INFO for caseinsensitive search: /something\c
" set hlsearch        " highlight search - disabled because it will activate themself after reloading vimrc
""""""""""""""""""""""""""""""""""""}}}
"		spell						{{{
"""""""""""""""""""""""""""""""""""""""
set spellfile=~/.vim/spelluser.utf-8.add	" don't use '_' in filename
" set spellfile+=~/.vim/hr.utf-8.spl
setlocal spelllang=en_us
" setlocal spelllang=en_us,hr_hr

" complete from dictionary - Ctrl-x Ctrl-k
set dictionary+=/usr/share/dict/words
set complete+=kspell
""""""""""""""""""""""""""""""""""""}}}

set conceallevel=2	" hide concealed chars until cursor is on that line
"set foldcolumn=2	" show clickable '+' in column at the left (which is $foldcolumn chars wide)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		OS specific															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('unix')
	let s:uname = substitute(system("uname"), '\n', '', '')

	if s:uname == "FreeBSD"
		let g:clang_library_path='/usr/local/llvm40/lib'

		" Exuberant Ctags
		" let g:ctags_exe='/usr/local/bin/exctags'
		" Universal Ctags - Exuberant Ctags fork
		let g:ctags_exe='/usr/local/bin/uctags'

		" let g:tagbar_ctags_bin=substitute(system("which exctags"), '\n', '','')
		let g:tagbar_ctags_bin=g:ctags_exe

	elseif s:uname == "Linux"
	endif " uname
elseif has('windows')
	let g:ctags_exe='c:\bin\ctags.exe'
	" let g:python3_host_prog='c:\Python3\python.exe'
	let g:python_host_prog='c:\python27\python.exe'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		build/programming			{{{
"""""""""""""""""""""""""""""""""""""""
" TODO incoporate this as prefix for part below
" makeprg can't have spaces
if has('unix')
	if s:uname == "FreeBSD"
		set makeprg="gmake -j4"
	elseif s:uname == "Linux"
		set makeprg="make -j4"
	endif
endif

function! Compile()
	" TODO wait for user input after compiling and before running
	" if enter run program, if q/esc don't
	if file_readable('Makefile')
		echo "building Makefile"
		" make
		" TODO 170909
		!gmake
	elseif file_readable('makefile')
		echo "building makefile"
		make
	elseif expand('%:e') == "cpp"
		setlocal makeprg=c++\ -Wall\ %\ -o\ %:r.elf\ -std=c++11
		make
	elseif expand('%:e') == "c"
		setlocal makeprg=cc\ -Wall\ %\ -o\ %:r.elf\ -std=c99
		make
	elseif expand('%:e') == "rs"
		echo "building Rust"
		" setlocal makeprg=rustc\ %
		make
		" !./%:r
	else
		echoerr "Don't know how to build :["
	endif
endfunction

nnoremap <F5> :call Compile()<cr>
nnoremap <leader>rr :call Compile()<cr>

" za gF komandu koja otvori fajl pod kursorom
let &path.="src/include,/usr/include/AL,"

" tags file in CWD
" search for $CWD/tags, $CWD/.tags and go level up until $HOME
set tags=tags,.tags;$HOME
""""""""""""""""""""""""""""""""""""}}}
"		autocmd																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup my_group_with_a_very_uniq_name
	" this is executed every time when vimrc is sourced, so clear it at the beggining:
	autocmd!

	" easier quit from this windows
	autocmd Filetype help nnoremap <buffer> q :wincmd c<cr>
	autocmd FileType qf,quickfix,netrw nnoremap <buffer> q :q<cr>
	autocmd WinEnter * if PreviewWindowOpened() == '1' | nnoremap <buffer> q :q<cr> | endif
	" INFO 170813: will remap q for 
	" autocmd WinEnter * unmap <buffer> q

	" remap enter in help and man window
	autocmd Filetype help nnoremap <buffer> <cr> <C-]>
	autocmd Filetype man nnoremap <buffer> <cr> <C-]>

	" unmap enter in QuickFix window (window at the bottom which isn't preview)
	autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>
	autocmd Filetype qf set nolist

	" force Vim to threat .md files as markdown and not Modula
	" or use tpope/vim-markdown plugin
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	" don't match '<' in C++ (cout << "Something";)
	autocmd Filetype cpp,make,vim set matchpairs-=<:>
	autocmd Filetype shell set matchpairs-=`:`	" works, but only in reverse

	" in case I ever open a python file
	autocmd Filetype python set expandtab

	autocmd FileType qf nnoremap <buffer> p <plug>(quickr_preview)
	"autocmd FileType qf nnoremap <buffer> q <plug>(quickr_preview_qf_close)

	autocmd BufWinEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	autocmd BufEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	autocmd BufEnter * if @% == "[Command Line]" | echo "QQQQQQ" | endif
	autocmd VimEnter * if @% == "[Command Line]" | echo "QQQQQQ" | else | "AAAAAA" | endif
augroup END

" setup when in diff mode:
if &diff
	" TODO 170831: check if is working in nvim-qt on Windows
	" INFO 170901: This is not working on Windows, check on Unix
	cabbrev q qa!
	nnoremap q :qa!<cr>
	" when fixing merge conflict:
	map <leader>1 :diffget LOCAL<CR>
	map <leader>2 :diffget BASE<CR>
	map <leader>3 :diffget REMOTE<CR>
endif

" setup for preview window
if &previewwindow
	" INFO 170813: echo will work here, but not nnoremap
	" echoe "Preview Window here!"
	" nnoremap q :q!<cr>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		cmd aliases															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO all abbrev commands are non recursive

" alias only triggered if it's on the start of the line
cnoreabbrev <expr> csa ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')

function! SetupCommandAlias(from, to)									" {{{
	" cmd alias will be valid only at the beggining of the line
	" from: https://stackoverflow.com/a/3879737/8078624
	exec 'cnoreabbrev <expr> '.a:from
				\ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
				\ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" annoying misspell:
call SetupCommandAlias("W", "w")
call SetupCommandAlias("Q", "q")
call SetupCommandAlias("E", "e")
call SetupCommandAlias("X", "x")

call SetupCommandAlias("Qa", "qa")
call SetupCommandAlias("qA", "qa")
call SetupCommandAlias("QA", "qa")
call SetupCommandAlias("Qa!", "qa!")
call SetupCommandAlias("qA!", "qa!")
call SetupCommandAlias("QA!", "qa!")

call SetupCommandAlias("w1", "w!")
call SetupCommandAlias("r1", "r!")
call SetupCommandAlias("e1", "e!")
call SetupCommandAlias("x1", "x!")

call SetupCommandAlias("W1", "w!")
call SetupCommandAlias("R1", "r!")
call SetupCommandAlias("E1", "e!")
call SetupCommandAlias("X1", "x!")
" cabbrev QA1 qa!
" cabbrev Qa! qa!
" cabbrev qA qa
" cabbrev qa1 qa!

command! WE write | edit
cabbrev we WE

command! PU PlugUpdate | PlugUpgrade
command! PI PlugInstall

" open help in vertical split right
cabbrev h vert leftabove help
cabbrev man vert leftabove Man
" get file path:
cabbrev fpath echo @%
cabbrev fp echo @%
" copy the current filename to the Vim buffer
cabbrev fpy echo @%
" copy the current filename to the X11 2nd buffer
cabbrev fpy echo @%
cabbrev FP echo expand('%:p')
" reload syntax
cabbrev rsyn syntax sync fromstart
cabbrev CC set cursorcolumn!

" folds help: zo zc za, zO, zC, zA (open, close, toggle)
"	zf create fold (marker/manual)
"	zd, zD delete fold
" close all folds
cabbrev foldcloseall %foldclose!
cabbrev foldca %foldclose!
cabbrev fca %foldclose!
cabbrev foa %foldopen!
" because standard Vim fold shortcuts are starting with z
cabbrev zca %foldclose!
cabbrev zoa %foldopen!
" close all other folds

" Don't show ^M in DOS files
command! FixDos edit ++ff=dos

" XXX CtrlSpace won't restore tabs with only one tab (only at PC on the work, on my everything works™)
" cabbrev css CtrlSpaceSaveWorkspace
" cabbrev csl CtrlSpaceLoadWorkspace
cabbrev css :mksession!
cabbrev csl :source Session.vim

cabbrev ccc call ToggleColorColumn()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		generic mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" disable ed mode:
nnoremap Q <nop>
" remap recording
nnoremap Q q
" disable old recording shortcut
nnoremap q <nop>
" no more ćevap-fingers
inoremap <F1> <esc>
nnoremap <F1> <esc>
vnoremap <F1> <esc>

" Enter new line without going to insert mode
nnoremap <cr> o<esc>

" swap the behaviour between j/k and gj/gk
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap $ g$
nnoremap 0 g0

nnoremap e el

" toggle between ^ (goto first non-blank char) and 0 (goto start of the line)
nnoremap <silent>0 :call ZeroMove()<cr>

" verbose folding
nnoremap za za:echo "fold current toggle"<cr>
nnoremap zc zc:echo "fold current close"<cr>
nnoremap zi zi:echo "fold all toggle"<cr>
nnoremap zR zR:echo "fold all open"<cr>
nnoremap zM zM:echo "fold all close"<cr>
"nnoremap zv zv:echo "fold reveal cursor"<cr>
"nnoremap <space> za
nnoremap <silent> <Space> @=(foldlevel('.')?'zazz':"\<Space>")<CR>
vnoremap <Space> zf

" don't quit visual mode after first indent/deindent
vnoremap < <gv
vnoremap > >gv

" deindent from insert mode
" XXX 170902: Won't work autocomplete mapping
" inoremap <S-Tab> <C-o><<
" nnoremap <S-Tab> <<

" show ASCII code of the char under the cursor
nnoremap <M-x> ga
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		buffers/windows/tabs keymaps										{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap tn :tabnew<cr>
nnoremap td :tab split<cr>:echom "tab duplicated"<cr>

nnoremap th :tabprev<cr>
nnoremap tl :tabnext<cr>
nnoremap tj :bnext<cr>
nnoremap tk :bprev<cr>

nnoremap [b :bnext<cr>
nnoremap ]b :bprev<cr>

" delete buffer without closing tab or split
nnoremap :BD :setl bufhidden=delete <bar> bnext
nnoremap <leader>d :setl bufhidden=delete <bar> bnext<cr>
nnoremap <leader>D :bd<cr>
" INFO <bar> instead of '|' pipe char

" nnoremap <tab> :wincmd w<cr>
nnoremap <tab> :wincmd w<cr>

if has('nvim')
	" nnoremap <A-h> :tabprev<cr>
	" nnoremap <A-l> :tabnext<cr>
	" nnoremap <A-j> :CtrlSpaceGoDown<cr>
	" nnoremap <A-k> :CtrlSpaceGoUp<cr>
	" navigate windows
	tnoremap <A-h> <C-\><C-N><C-w>h
	tnoremap <A-j> <C-\><C-N><C-w>j
	tnoremap <A-k> <C-\><C-N><C-w>k
	tnoremap <A-l> <C-\><C-N><C-w>l
	inoremap <A-h> <C-\><C-N><C-w>h
	inoremap <A-j> <C-\><C-N><C-w>j
	inoremap <A-k> <C-\><C-N><C-w>k
	inoremap <A-l> <C-\><C-N><C-w>l
	nnoremap <A-h> <C-w>h
	nnoremap <A-j> <C-w>j
	nnoremap <A-k> <C-w>k
	nnoremap <A-l> <C-w>l

	" because they are close to hjkl
	nnoremap <A-u> :tabprev<cr>
	nnoremap <A-i> :tabnext<cr>
	nnoremap <A-n> :tabprev<cr>
	nnoremap <A-m> :tabnext<cr>
	inoremap <A-u> :tabprev<cr>
	inoremap <A-i> :tabnext<cr>
	inoremap <A-n> :tabprev<cr>
	inoremap <A-m> :tabnext<cr>
	tnoremap <A-u> <C-\><C-N>:tabprev<cr>
	tnoremap <A-i> <C-\><C-N>:tabnext<cr>
	tnoremap <A-n> <C-\><C-N>:tabprev<cr>
	tnoremap <A-m> <C-\><C-N>:tabnext<cr>
endif

nnoremap t1 :tabfirst<cr>
nnoremap t2 :tabn 2<cr>
nnoremap t3 :tabn 3<cr>
nnoremap t4 :tabn 4<cr>
nnoremap t5 :tabn 5<cr>
nnoremap t6 :tabn 6<cr>
nnoremap t7 :tabn 7<cr>
nnoremap t8 :tabn 8<cr>
nnoremap t9 :tabn 9<cr>
nnoremap t0 :tablast<cr>

nnoremap <leader>1 :tabfirst<cr>
nnoremap <leader>2 :tabn 2<cr>
nnoremap <leader>3 :tabn 3<cr>
nnoremap <leader>4 :tabn 4<cr>
nnoremap <leader>5 :tabn 5<cr>
nnoremap <leader>6 :tabn 6<cr>
nnoremap <leader>7 :tabn 7<cr>
nnoremap <leader>8 :tabn 8<cr>
nnoremap <leader>9 :tabn 9<cr>
nnoremap <leader>0 :tablast<cr>

" move tab to the left/right
nnoremap tH :tabmove -1<cr>
nnoremap tL :tabmove +1<cr>

" holy fucking gods of Vim, browse only buffers for current tab
" nnoremap tj :CtrlSpaceGoDown<cr>
" nnoremap tk :CtrlSpaceGoUp<cr>

" doesn't seems particularly useful:
"nnoremap <leader>- <Plug>AirlineSelectPrevTab
"nnoremap <leader>+ <Plug>AirlineSelectNextTab

" XXX 170609 will fuckup CtrlP completition
nnoremap te :tabedit<space>

" 170312 disabled, never used
" nnoremap <leader>q :tabprev<cr>
" nnoremap <leader>w :tabnext<cr>

" jumping, Ctrl-I (tab) is used for switching splits
nnoremap <C-p> :pop<cr>:echo "Tag jump -1"<cr>
nnoremap <C-n> :tag<cr>:echo "Tag jump +1"<cr>

" IDEA
" <leader>n 	for switching buffers
" Alt-shift-N 	for switching tabs
if has('nvim')
	" INFO Alt-N is used for tmux
	" INFO shift in shortcuts won't work, but this will:
	nnoremap <A-!> :tabfirst<cr>
	nnoremap <A-@> :tabn 2<cr>
	nnoremap <A-#> :tabn 3<cr>
	nnoremap <A-$> :tabn 4<cr>
	nnoremap <A-%> :tabn 5<cr>
	nnoremap <A-^> :tabn 6<cr>
	nnoremap <A-&> :tabn 7<cr>
	nnoremap <A-*> :tabn 8<cr>
	nnoremap <A-(> :tabn 9<cr>
	nnoremap <A-)> :tablast<cr>
endif
" duplicate current tab
nnoremap <C-w>d :tab split<cr>:echom "tab duplicated"<cr>
" close all windows in current tab
nnoremap <C-w>C :tabclose<cr>

" resize Vim windows (almost) as tmux splits
nnoremap <C-w>H :call TmuxResize('h', 1)<CR>
nnoremap <C-w>J :call TmuxResize('j', 1)<CR>
nnoremap <C-w>K :call TmuxResize('k', 1)<CR>
nnoremap <C-w>L :call TmuxResize('l', 1)<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		Emacs shortcuts														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" blasphemy, Emacs shortcuts in Vim
" INFO C-BS won't work in xterm
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-d> <Delete>
inoremap <C-k> <C-o>D
inoremap <C-_> <C-o>u
" awww, memories
" nnoremap <C-x><C-s> :write<cr>
" nnoremap <C-x><C-c> :quit<cr>
if has('nvim')
	inoremap <A-BS> <C-W>
	inoremap <A-b> <C-o>b
	inoremap <A-f> <C-o>w
	inoremap <A-n> <Down>
	inoremap <A-p> <Up>
	inoremap <A-m> <cr>
	inoremap <A-h> <C-w>
	inoremap <A-BS> <C-w>
	inoremap <A-d> <C-o>dw
	"inoremap <A-d> <C-o>diw

	cnoremap <A-d> <Delete>
	cnoremap <A-h> <C-w>
	" INFO this need some tweaking to work under tmux:
	" cnoremap <A-b> <S-Left>
	" cnoremap <A-f> <S-Right>
endif

" command line (:) shortcuts
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <C-h> <Backspace>
" TODO 170901 C-k
if has('nvim')
	cnoremap <A-d> <Delete>
	cnoremap <A-h> <C-w>
	" INFO this need some tweaking to work under tmux:
	cnoremap <A-b> <S-Left>
	cnoremap <A-f> <S-Right>
endif
""""""""""""""""""""""""""""""""""""""""}}}
"		hardko mode															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Left>		:echoe "Use h"<cr>
nnoremap <Right>	:echoe "Use l"<cr>
nnoremap <Up>		:echoe "Use k"<cr>
nnoremap <Down>		:echoe "Use j"<cr>

" Fix for cursors keys when Esc is remapped
nnoremap <esc>[ <esc>[

" breaking the habit
imap <C-c> <C-o>:echoe "Use esc, bogajebo"<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" TODO better, check if highlight is active (HOW?):
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>:echo "hlsearch disabled"<cr>
"		leader mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" another leader keys:
nmap ; <leader>
nmap , <leader>

"temporarily disable search highlighting until the next search.
" INFO this is NOT the same as set nohlsearch
nnoremap <leader>H :noh<cr>
" TODO make this to toggle highlight, probably will not be possible

nnoremap <leader>s :setlocal spell!<cr>
" toggle showing invisible chars
nnoremap <leader>l :set list!<cr>:set list?<CR>
nnoremap <leader>n :set relativenumber!<cr>
nnoremap <leader>N :set number!<cr>
nnoremap <leader>r :so $MYVIMRC<cr>:echo "vimrc reloaded"<CR>
nnoremap <leader>e :e $MYVIMRC<cr>

nnoremap <silent> <leader>ML :call AppendModeline()<cr>
" INFO there are some leader mappings <leader>0..9 in tabs section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		plugin mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>a :tab split<cr>:Rg <C-r><C-w><CR>
nnoremap <leader>A :tab split<cr>:Rg ""<left>

command! FixWhiteSpace StripWhitespace	" function from 'better white space' plugin
" call SetupCommandAlias("fws", "FixWhiteSpace")
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"		copy paste mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C/P registers:
" ": unnamed register (dd/yy)
" *: X11 primary	  (select/middle click)
" +: X11 secondanry   (Ctrl-C/V)

" paste and adjuste indent
nnoremap p ]p
nnoremap P ]P
" nnoremap p p=`]
" nnoremap P P=`]

" delete to the black hole register
nnoremap dd "_dd
nnoremap D "_D
nnoremap dw "_dw
nnoremap diw "_diw
" yank and delete
nnoremap dy yydd
nnoremap yd yydd

" easier copying when cursor is not at the beggining of the word:
nnoremap yw yiw
" in case that old behaviour is needed:
nnoremap yW yw

" INFO shortcuts for insert/command mode: <C-r>X
" c command
" / highlighted (*) or searched (/) text - already default
" p vim paste buffer
" f filename with extension
" F filename with full path
" INFO stuff that won't work:
" aligning text after <C-o>
" echoing text after paste (cursor will be moved one place to the left)
inoremap <C-r>c <C-o>":]p<C-o>:echo "pasted last used command"<cr>
inoremap <C-r>: <C-o>":]p<C-o>:echo "pasted last used command"<cr>
inoremap <C-r>/ <C-o>:call RemoveBrackets()<cr><C-r>/<C-o>:echo "pasted highlighted/searched text"<cr>
" cnoremap <C-r>/ <C-o>:call RemoveBrackets()<cr><C-r>/

function! RemoveBrackets()
	" removes '\<' and '\>' in '/' register
	" INFO created 171022, used for <C-R>/ after */#
	let @/ = substitute(@/, "\\\\\<", "", "")
	let @/ = substitute(@/, "\\\\\>", "", "")
endfunction

" author variable used in licence snippets, remove NULL (^@) char:
" let g:snips_author=substitute(strtrans(system('git config user.name')), '\^@','','g')

inoremap <C-r>p <C-o>]p<C-o>:echo "pasted from Vim paste buffer"<cr>
cnoremap <C-r>p <C-r>"
" TODO 170819: remove '\n'
inoremap <C-r>f <C-r>=expand("%:t")<CR>
cnoremap <C-r>f <C-r>=expand("%:t")<CR>
inoremap <C-r>F <C-r>%
cnoremap <C-r>F <C-r>%
" INFO expression register: in insert mode <C-r>=2+2 // in text "4" will be inserted

"	named registers															{{{
vnoremap <leader>y1 "qy :echo "copied to the register 1(q)"<cr>
vnoremap <leader>y2 "wy :echo "copied to the register 2(w)"<cr>
vnoremap <leader>y3 "ey :echo "copied to the register 3(e)"<cr>
vnoremap <leader>y4 "ry :echo "copied to the register 4(r)"<cr>
vnoremap <leader>y5 "ty :echo "copied to the register 5(t)"<cr>
vnoremap <leader>y6 "yy :echo "copied to the register 6(y)"<cr>
vnoremap <leader>y7 "uy :echo "copied to the register 7(u)"<cr>
vnoremap <leader>y8 "iy :echo "copied to the register 8(i)"<cr>
vnoremap <leader>y9 "oy :echo "copied to the register 9(u)"<cr>
vnoremap <leader>y0 "py :echo "copied to the register 0(p)"<cr>
" in normal mode - still work on whole line
nnoremap <leader>y1 "qyy :echo "copied to the register 1(q)"<cr>
nnoremap <leader>y2 "wyy :echo "copied to the register 2(w)"<cr>
nnoremap <leader>y3 "eyy :echo "copied to the register 3(e)"<cr>
nnoremap <leader>y4 "ryy :echo "copied to the register 4(r)"<cr>
nnoremap <leader>y5 "tyy :echo "copied to the register 5(t)"<cr>
nnoremap <leader>y6 "yyy :echo "copied to the register 6(y)"<cr>
nnoremap <leader>y7 "uyy :echo "copied to the register 7(u)"<cr>
nnoremap <leader>y8 "iyy :echo "copied to the register 8(i)"<cr>
nnoremap <leader>y9 "oyy :echo "copied to the register 9(o)"<cr>
nnoremap <leader>y0 "pyy :echo "copied to the register 0(p)"<cr>
" append - normal mode
nnoremap <leader>Y1 "Qy :echo "added to the register 1(q)"<cr>
nnoremap <leader>Y2 "Wy :echo "added to the register 2(w)"<cr>
nnoremap <leader>Y3 "Ey :echo "added to the register 3(e)"<cr>
nnoremap <leader>Y4 "Ry :echo "added to the register 4(r)"<cr>
nnoremap <leader>Y5 "Ty :echo "added to the register 5(t)"<cr>
nnoremap <leader>Y6 "Yy :echo "added to the register 6(y)"<cr>
nnoremap <leader>Y7 "Uy :echo "added to the register 7(u)"<cr>
nnoremap <leader>Y8 "Iy :echo "added to the register 8(i)"<cr>
nnoremap <leader>Y9 "Oy :echo "added to the register 9(o)"<cr>
nnoremap <leader>Y0 "Py :echo "added to the register 0(p)"<cr>
" append - visual mode
vnoremap <leader>Y1 "Qy :echo "added to the register 1(q)"<cr>
vnoremap <leader>Y2 "Wy :echo "added to the register 2(w)"<cr>
vnoremap <leader>Y3 "Ey :echo "added to the register 3(e)"<cr>
vnoremap <leader>Y4 "Ry :echo "added to the register 4(r)"<cr>
vnoremap <leader>Y5 "Ty :echo "added to the register 5(t)"<cr>
vnoremap <leader>Y6 "Yy :echo "added to the register 6(y)"<cr>
vnoremap <leader>Y7 "Uy :echo "added to the register 7(u)"<cr>
vnoremap <leader>Y8 "Iy :echo "added to the register 8(i)"<cr>
vnoremap <leader>Y9 "Oy :echo "added to the register 9(o)"<cr>
vnoremap <leader>Y0 "Py :echo "added to the register 0(p)"<cr>
" paste
nnoremap <leader>p1 "q]p :echo "paste from the register 1(q)"<cr>
nnoremap <leader>p2 "w]p :echo "paste from the register 2(w)"<cr>
nnoremap <leader>p3 "e]p :echo "paste from the register 3(e)"<cr>
nnoremap <leader>p4 "r]p :echo "paste from the register 4(r)"<cr>
nnoremap <leader>p5 "t]p :echo "paste from the register 5(t)"<cr>
nnoremap <leader>p6 "y]p :echo "paste from the register 6()"<cr>
nnoremap <leader>p7 "u]p :echo "paste from the register 7()"<cr>
nnoremap <leader>p8 "i]p :echo "paste from the register 8()"<cr>
nnoremap <leader>p9 "o]p :echo "paste from the register 9()"<cr>
nnoremap <leader>p0 "p]p :echo "paste from the register 0()"<cr>
" paste in insert mode
inoremap <C-r>1 <C-o>"q]p<C-o>:echo "paste from the register 1(q)"<cr>
inoremap <C-r>2 <C-o>"w]p<C-o>:echo "paste from the register 2(w)"<cr>
inoremap <C-r>3 <C-o>"e]p<C-o>:echo "paste from the register 3(e)"<cr>
inoremap <C-r>4 <C-o>"r]p<C-o>:echo "paste from the register 4(r)"<cr>
inoremap <C-r>5 <C-o>"t]p<C-o>:echo "paste from the register 5(t)"<cr>
inoremap <C-r>6 <C-o>"y]p<C-o>:echo "paste from the register 6(y)"<cr>
inoremap <C-r>7 <C-o>"u]p<C-o>:echo "paste from the register 7(u)"<cr>
inoremap <C-r>8 <C-o>"i]p<C-o>:echo "paste from the register 8(i)"<cr>
inoremap <C-r>9 <C-o>"o]p<C-o>:echo "paste from the register 9(o)"<cr>
inoremap <C-r>0 <C-o>"p]p<C-o>:echo "paste from the register 0(p)"<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"	clipboard																{{{
if has('clipboard')	" not really needed for all options under this
	" copy filepath to X11 clipboard
	nnoremap <leader>FP  :let @* = expand("%")<cr>:echo		"relative path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fp  :let @+ = expand("%")<cr>:echo		"relative path of the file copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FFP :let @* = expand("%:p")<cr>:echo		"full path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>ffp :let @+ = expand("%:p")<cr>:echo		"full path of the file copied to the X11 2nd clipboard"<CR>

	" insert mode paste from X11 clipboard
	inoremap <C-r>! <C-o>"*]p<C-o>:echo "paste from the X11 1st clipboard"<cr>
	inoremap <C-r>@ <C-o>"+]p<C-o>:echo "paste from the X11 2st clipboard"<cr>

	" "*	X11 primary buffer
	vnoremap <leader>ry "*y
	vnoremap <leader>rd "*d
	nnoremap <leader>rp "*p
	vnoremap <leader>rp "*p
	" TODO r{1,2}{y,d,p}

	" tmux:
	" p - tmux buffer paste
	" P - X11 2nd
	" [ - X11 1st
	" { - Vim paste
	" INFO vim: only used X11 1st and 2nd

	" TODO IDEA
	" y - vim yank
	" Y - X11 2nd (clipboard) yank (without leader key)
	" <leader>y - tmux yank
	" <leader>Y - X11 1nd yank
	" TODO TODO TODO reorganize all this
	" mnomoic: yank for tmux
	vnoremap <leader>yt :w! /tmp/vim_buffer<cr>:echo "vselection copied to /tmp/vim_buffer"<cr>


	" X11 primary buffer		"*
	vnoremap <leader>Y "*y:echo "copied to the X11 1nd clipboard"<cr>
	" vnoremap <leader>D "*d:echo "cutted to the X11 1nd clipboard"<cr>
	" vnoremap <leader>X "*d:echo "cutted to the X11 1nd clipboard"<cr>
	nnoremap <leader>P "*p:echo "pasted from the X11 1nd clipboard"<cr>
	vnoremap <leader>P "*p:echo "pasted from the X11 1nd clipboard"<cr>

	" X11 secondary buffer		"+
	"vnoremap <leader>y "+y :echo "copied to the X11 2nd clipboard"<cr>
	" TODO TODO set paste mode before pasting
	vnoremap <leader>y "+y :echo  "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>y "+yy :echo "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>y "+yy :echo "copied to the X11 2nd clipboard"<cr>
	" vnoremap <leader>d "+d :echo  "cutted to the X11 2nd clipboard"<cr>
	" nnoremap <leader>d "+dd :echo "cutted to the X11 2nd clipboard"<cr>
	" vnoremap <leader>x "+d :echo  "cutted to the X11 2nd clipboard"<cr>
	nnoremap <leader>p "+p :echo  "pasted from the X11 2nd clipboard"<cr>
	vnoremap <leader>p "+p :echo  "pasted from the X11 2nd clipboard"<cr>

	" compat with C-r Shift-1/2
	vnoremap <leader>y! "*y :echo "copied to the X11 1nd clipboard"<cr>
	vnoremap <leader>y@ "+y :echo "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>p! "*p  :echo "pasted from the X11 1nd clipboard"<cr>
	nnoremap <leader>p@ "+p  :echo "pasted from the X11 2nd clipboard"<cr>

	cnoremap <C-r>! <C-r>*
	cnoremap <C-r>@ <C-r>+

	" Windows compat:
	inoremap <S-Insert> <C-r>*
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Easier copy/paste to the named registers
" INFO this will slowdown copy to the X11 clipboard (<leader>y)
" TODO :set paste [y/d/p] :set nopaste

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		mouse mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" double click select all occurrences
nnoremap <2-LeftMouse> *N
inoremap <2-LeftMouse> <c-o>*N
vnoremap <2-LeftMouse> *N
" TODO interface with indexed search plugin
" TODO Shift and/or Alt + 2 mouse click: goto tag

" triple click to toggle fold
" nnoremap <3-LeftMouse> za
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"				custom functions											{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! AppendModeline() " {{{
	let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d fdm=%s %set :", &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! s:VSetSearch() "													{{{
	" visual mode */#
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! ZeroMove() "														{{{
	" INFO toggle between ^ and 0
	let l:column_old = col('.')

	" goto first non blank char
	execute "normal ^"
	let l:column_new = col('.')

	" check if we are moved, if not, we're at first non blank char
	if l:column_new == column_old
		" now goto the real first char, or jump back
		execute "normal! 0"
	endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! NeatFoldText() "													{{{
	" http://dhruvasagar.com/2013/03/28/vim-better-foldtext
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)"{{{"}}}
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	" return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
	" my dirty hack, don't show how many lines are fold at the right end of the screen, but close to end of &textwidth
	"return foldtextstart . repeat(foldchar, winwidth(0)/2-foldtextlength) . foldtextend
	return foldtextstart . repeat(foldchar, &textwidth+10-foldtextlength) . foldtextend " XXX ugly
endfunction
set foldtext=NeatFoldText()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" toggle ColorColumn														{{{

" check if highlight group exists and is it highlighed
" http://vim.1045645.n5.nabble.com/Check-if-highlight-exists-and-not-quot-cleared-quot-td1185235.html
function! HlExists(hl)
	if !hlexists(a:hl)
		return 0
	endif
	redir => hlstatus
	exe "silent hi" a:hl
	redir END
	return (hlstatus !~ "cleared")
endfunc

function! ToggleColorColumn()
	" INFO 170813: Heh, ovo sam ja napisao negdje na ljeto/jesen 2016.
	let l:state = HlExists('ColorColumn')

	if (l:state == 1)
		highlight clear ColorColumn
		"let l:state = 1
	elseif (l:state == 0)
		"highlight ColorColumn ctermbg=234
		execute "highlight ColorColumn ctermbg=".g:color_ColorColumn
	endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Tmux-like window resizing													{{{
" INFO still need to press multiple time <C-w>hjkl, not really like tmux, but better than Vims default
" TODO link for sauce of this
function! IsEdgeWindowSelected(direction)
	let l:curwindow = winnr()
	exec "wincmd ".a:direction
	let l:result = l:curwindow == winnr()

	if (!l:result)
		" Go back to the previous window
		exec l:curwindow."wincmd w"
	endif

	return l:result
endfunction

function! GetAction(direction)
	let l:keys = ['h', 'j', 'k', 'l']
	let l:actions = ['vertical resize -', 'resize +', 'resize -', 'vertical resize +']
	return get(l:actions, index(l:keys, a:direction))
endfunction

function! GetOpposite(direction)
	let l:keys = ['h', 'j', 'k', 'l']
	let l:opposites = ['l', 'k', 'j', 'h']
	return get(l:opposites, index(l:keys, a:direction))
endfunction

function! TmuxResize(direction, amount)
	" v >
	if (a:direction == 'j' || a:direction == 'l')
		if IsEdgeWindowSelected(a:direction)
			let l:opposite = GetOpposite(a:direction)
			let l:curwindow = winnr()
			exec 'wincmd '.l:opposite
			let l:action = GetAction(a:direction)
			exec l:action.a:amount
			exec l:curwindow.'wincmd w'
			return
		endif
		" < ^
	elseif (a:direction == 'h' || a:direction == 'k')
		let l:opposite = GetOpposite(a:direction)
		if IsEdgeWindowSelected(l:opposite)
			let l:curwindow = winnr()
			exec 'wincmd '.a:direction
			let l:action = GetAction(a:direction)
			exec l:action.a:amount
			exec l:curwindow.'wincmd w'
			return
		endif
	endif

	let l:action = GetAction(a:direction)
	exec l:action.a:amount
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! PreviewWindowOpened()											"{{{
	" from: https://stackoverflow.com/a/14300184/8078624
	for nr in range(1, winnr('$'))
		if getwinvar(nr, "&pvw") == 1
			" found a preview
			return 1
		endif
	endfor
	return 0
endfun
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! s:HelpTag(reverse)											" {{{
	" INFO 170817: jumps to next/previous help tag
	"http://sillybytes.net/2015/02/vim-jump-to-nextprevious-help-file-tags.html
	call search('|\S\+|', a:reverse ? 'bW' : 'W')
endfunction
" nmap [g <Plug>HelpTagPrevious
" nmap ]g <Plug>HelpTagNext
nmap [t <Plug>HelpTagPrevious
nmap ]t <Plug>HelpTagNext
nmap [h <Plug>HelpTagPrevious
nmap ]h <Plug>HelpTagNext

nnoremap <silent> <Plug>HelpTagPrevious :call <SID>HelpTag(1)<CR>
nnoremap <silent> <Plug>HelpTagNext     :call <SID>HelpTag(0)<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"	auto swap and file reloading if it is changed on the disk {{{


" https://github.com/neovim/neovim/issues/2127
" from tim pope's, iirc:
"	file changed in buffer, but not on disk: allocate a swapfile for it
"	file not changed in buffer: remove swap file, so that if vim is killed it
"		doesn't leave one lying around (and allows multiple editing, which
"		with the above rules, I'm fine with)

" from some stackoverflow or other:
"	file changed on disk, but not in buffer: load it
"	file changed on disk and in buffer: warn user, ask what to do

" edited from autoswap plugin:
"	opening file that has changed swapfile, and file is not newer: ask the
"		user, as normal.
"	opening file that has changed swapfile, and file is newer: swapfile has
"		already been abandoned, delete it

" augroup AutoSwap
" 	autocmd!
" 	autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
" augroup END

" function! AS_HandleSwapfile (filename, swapname)
" 	" if swapfile is older than file itself, just get rid of it
" 	if getftime(v:swapname) < getftime(a:filename)
" 		call delete(v:swapname)
" 		let v:swapchoice = 'e'
" 	endif
" endfunction

" autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
" 			\ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

" augroup checktime
" 	au!
" 	if !has("gui_running")
" 		"silent! necessary otherwise throws errors when using command
" 		"line window.
" 		" autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
" 	endif
" augroup END


	" This will mirror the functionality of Gvim, at least for right now.
	" au FocusGained * :checktime

" XXX 170909:
" - doesn't work on nvim: it will never ask to reload file, it will reload it automatically
" - with autogroups above it will reload without question
" - default: just warning when trying to write to the file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Plugins																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" call plug#begin('~/vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" AutoComplete
Plug 'roxma/nvim-completion-manager'
" NCM fork without Python dependency
" Plug ''prabirshrestha/asyncomplete'
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'roxma/clang_complete'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'roxma/nvim-cm-racer'
Plug 'roxma/ncm-github'
Plug 'huawenyu/neogdb.vim'
Plug 'tpope/vim-dispatch'	" async make, needed for cscope code snippet below
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-unimpaired'

Plug 'w0rp/ale'					" Linter
" snippets engine and collection
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Auto generate incremetal tags
" Plug 'ludovicchabant/vim-gutentags', { 'for': 'c,cpp,rust' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
" Plug 'vim-scripts/TagHighlight'	" color typedefs as variables, needs
" :UpdateTypesFile
" Plug 'octol/vim-cpp-enhanced-highlight'	" simpler works out-of-the books, but not as good as TagHighlight
" Plug 'jeaye/color_coded'	" semantic highlighter INFO 170818: doesn't work in nvim


" ******************** files
" CtrlP look-a-like
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
" minimalistic file browser, insirated by netrw
" only list and open files, no rm/cp
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'dietsche/vim-lastplace'		" Open file at last edit position
Plug 'bogado/file-line'				" open file.txt:123
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'vim-nerdtree-tabs'		" Not maintained, one NERDtree for all buffers



Plug 'vim-airline/vim-airline'
Plug 'gcmt/taboo.vim'				" Rename tabs

" ******************** basics
Plug 'ciaranm/securemodelines'
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'osyo-manga/vim-anzu'			" show search matches in statusline
									" (second from the right)
Plug 'jiangmiao/auto-pairs'			" auto close quotes, brackets, ...
Plug 'tpope/vim-surround'			" replace quotes, brackets,...
Plug 'tpope/vim-commentary'
Plug 'troydm/zoomwintab.vim'		" <C-w>o wil zoom/unzoom windows/split
Plug 'AndrewRadev/undoquit.vim'
Plug 'ntpeters/vim-better-whitespace'	" show red block when there is a trailing whitespace


" Plug 'ervandew/supertab'


Plug 'jremmen/vim-ripgrep'

Plug 'tomasr/molokai'
" Plug 'brookhong/cscope.vim'		" cscope

" Show shell ANSI colors as colors
Plug 'powerman/vim-plugin-AnsiEsc'

" marks in sign column and with easier shortcuts
" use fzf :Marks for search
Plug 'kshenoy/vim-signature'
" git: show +-m in sign column, shortcuts [c ]c
Plug 'airblade/vim-gitgutter'

" Vim session plugins
Plug 'tpope/vim-obsession'	" restore session, needed for tmux ressurect
Plug 'mhinz/vim-startify'	" Fancy Vim startup screen (shows MRU, session, ...)
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'		" Required for vim-session


" TODO 170813: check one day
" Plug 'timonv/vim-cargo'		" simple plugin, cmds: Cargo{Build, Run, Test, Bench}
" Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'tpope/vim-fugitive'		" Git commands for Vim
" Plug 'easymotion/vim-easymotion'	" leader leader and magic begins
" Plug 'myusuf3/numbers.vim'		" disable relative numbers in insert mode and other windows
" Plug 'tpope/vim-repeat'
" Plug 'hyiltiz/vim-plugins-profile'
" Plug 'junegunn/vim-easy-align'
" Plug 'matze/vim-move'
" Plug 'gilligan/vim-lldb'
" Plug 'LucHermitte/vim-refactor'
" Plug 'tpope/vim-markdown'
" Plug 'plasticboy/vim-markdown'
" Plug 'vim-scripts/tinymode.vim'
" Plug 'kien/rainbow_parentheses.vim'
Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'Carpetsmoker/auto_autoread.vim'


" Initialize plugin system
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Plugin configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" put this after the theme plugin is installed, but before custom "highlight"
" overrides
colorscheme molokai
" NCM																		{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Supress the annoying completion messages:
set shortmess+=c
" use <Tab> to cycle through completion
inoremap <expr><tab> 	pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><S-tab>	pumvisible() ? "\<C-p>" : "\<S-tab>"
" inoremap <expr><C-_>	deoplete#undo_completion()
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")


" Here is an example for expanding snippet in the popup menu with <Enter> key.
" Suppose you use the <C-U> key for expanding snippet.
" imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
" imap <expr> <Plug>(expand_or_nl) (cm#completed_is_snippet() ? "\<C-U>":"\<CR>")

" info 170926: moj pokusaj za UltiSnips
" imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
" imap <expr> <Plug>(expand_or_nl) (UltiSnips#ExpandSnippet() ? "\<C-U>":"\<CR>")
" imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(ultisnips_expand)" : "\<CR>")
" inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>
" "<Plug>(ultisnips_expand)"

" UltiSnips example:
" let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
" inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
"cm_matchers.abbrev_matcher"`	" not really fuzzy

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" clang_complete															{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" path to directory where library can be found
" let g:clang_library_path='/usr/local/llvm40/lib'
" -> Already set in OS specific part
" or path directly to the library file
" let g:clang_library_path='/usr/local/llvm40/lib/libclang.so.4.0'

" <Plug>(clang_complete_goto_declaration_preview)
au FileType c,cpp  nmap gd <Plug>(clang_complete_goto_declaration)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Linter																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO 170812: Will only show the first error, can't show multiple errors
"              Maybe linter's fault
" keep the sign gutter open at all times
let g:ale_sign_column_always = 1
" INFO 170813: It will be always 2 chars wide, and space is not allowed
let g:ale_sign_error = '─>'
let g:ale_sign_warning = '─>'

" for moving between warnings and errors quickly.
" INFO 170812: There is no support to recognize warnings and errors
nmap <silent> ]e <Plug>(ale_next_wrap)
nmap <silent> [e <Plug>(ale_prev_wrap)

" run linter only on save
let g:ale_lint_on_text_changed = 'never'
" You can disable this option too
" if you don't want linters to run on opening a file
" let g:ale_lint_on_enter = 0

" use the quickfix list instead of the loclist
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1

" Disable linting for some filetypes
let g:ale_pattern_options = {'\.txt$': {'ale_enabled': 0}}

" XXX razjebat ce ako se napise to nasred linije

cabbrev lintoff ALEDisable
cabbrev linton ALEenable
cabbrev lint ALEToggle

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" install rls:
" rustup component add rls --toolchain nightly
" rustup component add rust-analysis --toolchain nightly
" rustup component add rust-src --toolchain nightly
let g:ale_linters = {'rust': ['rustc']}
" let g:ale_linters = {'rust': ['rls']}
"  g:ale_rust_rls_executable
" let g:ale_rust_ignore_error_codes = ['E0432', 'E0433']
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Rust																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't expand tab (and other things)
let g:rust_recommended_style = 0

if has('nvim')
	inoremap <A-r> <C-o>:RustRun<cr>
	nnoremap <A-r> :RustRun<cr>
endif
" nnoremap <F5> :RustRun<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Airline																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

" Show just the filename in the tab
let g:airline#extensions#tabline#fnamemod = ':t'

" show tab numbers in the tab
let g:airline#extensions#tabline#show_tab_nr = 1 " enable
" let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number (<tab no>.<no of splits>)
" enable/disable displaying tab type (far right) >
let g:airline#extensions#tabline#show_tab_type = 1

" Disable showing "mixed ident", override with :AirlineToggleWhitespace
let g:airline#extensions#whitespace#enabled = 0

" let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l:%3v%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# '
" let g:airline_section_warning =  %{airline#util#wrap(airline#extensions#ale#get_warning(),0)}%{airline#util#wrap(airline#extensions#whitespace#check(),0)}
" let g:airline_section_warning = '%t %{ObsessionStatus()}'

" let g:airline_exclude_preview=1	" fix semi-randomly hiding of Airline tabbar
" tabbline would disappear after :bd	INFO 170909: ZoomWin fault, fixed
" https://github.com/vim-airline/vim-airline/issues/399
" autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" snippets																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NCM + UltiSnips
" XXX 170819: shortcut mapped as ExpandTrigger won't work as normal shortcut
" anymore (tested with CR and C-e)
" let g:UltiSnipsExpandTrigger			= '<cr>' " works, but won't work as
" 				It will work, but then normal <Enter> won't
" let g:UltiSnipsExpandTrigger			= '<C-e>'	" 	XXX 170926: won't work as normal <C-e> (<End>)
" let g:UltiSnipsExpandTrigger			= '<C-u>'	" 	XXX 170926: won't work, works as <tab>/<C-n>
" let g:UltiSnipsExpandTrigger			= '<C-u>'	" 	XXX 170926: won't work, works as <tab>/<C-n>
" let g:UltiSnipsExpandTrigger			= '<C-y>'	" works
let g:UltiSnipsExpandTrigger			= '<C-o>'	" works
" let g:UltiSnipsExpandTrigger			= '<Cr>'	" doesn't work
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsExpandTrigger="<C-u>"
let g:UltiSnipsJumpForwardTrigger="<tab>"	" jump between $1, $2, ...
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" When the expand key is pressed and nothing has been typed, a popup list for snippets will be triggered.
" let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
" inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

let g:UltiSnipsRemoveSelectModeMappings = 0

" author variable used in licence snippets, remove NULL (^@) char:
let g:snips_author=substitute(strtrans(system('git config user.name')), '\^@','','g')

let g:UltiSnipsEditSplit="vertical"
call SetupCommandAlias("snipe", "UltiSnipsEdit")

	" don't search for directory, use only tihs:
	" let g:UltiSnipsSnippetDirectories=$HOME.'/.vim/UltiSnips'
set runtimepath+=~/.vim/my-snippets/	" radi, ali unutar tog foldera mora bit subfolder "snippets" ili "UltiSnips""
" let g:UltiSnipsSnippetsDir = "~/.vim/my-snippets/UltiSnips"	" CP s neta, njima radi, meni ne
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Commenter {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for tpope commenter, muscle memory from NERDcommenter
" INFO 170812: Yes, nmap, not nnoremap
nmap <leader>c<space> <Plug>CommentaryLine
vmap <leader>c<space> <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
vmap <leader>cc <Plug>Commentary
nmap <leader>cy yy<Plug>CommentaryLine
vmap <leader>cy yy<Plug>Commentary

" patch for pf.conf (don't use /* */, use # instead)
autocmd FileType pf setlocal commentstring=#\ %s
autocmd FileType dnsmasq setlocal commentstring=#\ %s
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" fuzzy open {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :Files, :Commits, :Windows, :Tags, :BTags
nnoremap <leader>o :Files<CR>
nnoremap <leader>m :FZFMru<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :Windows<CR>
nnoremap to :tabnew<cr>:Files<CR>
nnoremap tm :tabnew<cr>:FZFMru<CR>
nnoremap tb :tabnew<cr>:Buffers<cr>
nnoremap tt :tabnew<cr>:Tags<cr>

imap <c-x><c-l> <plug>(fzf-complete-line)

let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }
" In Neovim, you can set up fzf window using a Vim command:
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" [[B]Commits] Customize the options used by 'git log':
" let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" 171205 close FZF windows with <esc> (insted of <C-W>c)
if has('nvim')
aug fzf_setup
  au!
  au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
aug END
end
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" File managers {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>f :NERDTreeToggle<cr>
nnoremap <leader>F :NERDTreeFind<cr>
" TODO <space> to expand folder
let g:NERDTreeMapActivateNode = "<space>"

" FileBeagle - simple file manager
let g:filebeagle_suppress_keymaps = 1
" map <silent> <Leader>f  <Plug>FileBeagleOpenCurrentWorkingDir
map <silent> -          <Plug>FileBeagleOpenCurrentBufferDir
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
nnoremap ; :Buffers<cr>
" git plugins																{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GitGutter
" - shows +-m in sign column
" - shortcuts: [c ]c

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '-~'
highlight GitGutterAdd				ctermbg=234 ctermfg=10 guifg=green
highlight GitGutterDelete			ctermbg=234 ctermfg=9  guifg=red
highlight GitGutterChange			ctermbg=234 ctermfg=3  guifg=yellow
highlight link GitGutterChangeDelete GitGutterChange

" unmap all keys (<leader>hX are not useful to me)
" let g:gitgutter_map_keys = 0
" default keybindings:
" nmap ]c <Plug>GitGutterNextHunk
" nmap [c <Plug>GitGutterPrevHunk
" omap ic <Plug>GitGutterTextObjectInnerPending
" omap ac <Plug>GitGutterTextObjectOuterPending
" xmap ic <Plug>GitGutterTextObjectInnerVisual
" xmap ac <Plug>GitGutterTextObjectOuterVisual

" TODO 170813: goto first line of the preview window
nmap <Leader>gv <Plug>GitGutterPreviewHunk :wincmd P<CR> :1<CR>
" nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gr <Plug>GitGutterUndoHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk

call SetupCommandAlias("gitt","GitGutterToggle")

" let g:gitgutter_realtime = 0
" let g:gitgutter_eager = 0

" Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" ripgrep																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fast grep
" :Rg :RgRoot

" let g:rg_command="rg --vimgrep"	" default
" let g:rg_command="rg --vimgrep -g '!.*.tags' -g '!.*tags' -g '!tags' -g '!.*.src'"
if has('windows')
	" Windows 171030:
	let g:rg_command="rg --vimgrep"
else
	" let g:rg_command="rg --vimgrep -g '!tags' -g '!.*.src'"
	let g:rg_command="rg --vimgrep -g '!tags' -g '!*.src'"
endif
let g:rg_command="rg --vimgrep -g '!*tags'"
" don't show column (%c):
let g:rg_format="%f:%l:%m"
let g:rg_highlight=1						" 1 if you want matches highlighted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" easymotion																{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" press <leader><leader>X where X is char for modes (it can be f,w,...)
" <Leader>f{char} to move to {char}
map  <leader><leader>f <Plug>(easymotion-bd-f)
nmap <leader><leader>f <Plug>(easymotion-overwin-f)
map  <leader><leader>c <Plug>(easymotion-bd-f)
nmap <leader><leader>c <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
nmap C <Plug>(easymotion-overwin-f2)

" Move to line
map  <leader><leader>l <Plug>(easymotion-bd-jk)
nmap <leader><leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" ctags																		{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO will auto create tags, auto update on save (incremental update)
" it will generate a new tag file if there is none (but it needs time, it will report "no tags file found")
let g:gutentags_ctags_executable = g:ctags_exe
nnoremap <C-]> g<C-]>
nnoremap <C-\> g<C-]>
" buffer
call SetupCommandAlias("tagsu","GutentagsUpdate")
call SetupCommandAlias("tagu","GutentagsUpdate")
" project
call SetupCommandAlias("tagsu!","GutentagsUpdate!")
call SetupCommandAlias("tagu!","GutentagsUpdate!")
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		tagbar																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO shows tags (variables, enums, typedes, functions on the windows on the right)
" :TagbarToggle
" :TagbarOpenAutoClose - useful for jumping to the function (with preview window)
let g:tagbar_width = 50		" default: 40
"let g:tagbar_zoomwidth = 0	" default: 0 (Use the width of the longest currently visible tag)
"let g:tagbar_autoclose = 1	" default: 0
let g:tagbar_autofocus = 1	" auto jump to the Tagbar	default: 0
let g:tagbar_sort = 0		" default: 1
let g:tagbar_show_linenumbers = 2	" show relative
"let g:tagbar_singleclick = 1
let g:tagbar_iconchars = ['►', '▼']		" changed first symbol because powerline font
let g:tagbar_previewwin_pos = "aboveleft"
let g:tagbar_autopreview = 0

nnoremap <leader>t :TagbarToggle<CR>
let g:tagbar_type_rust = {
			\ 'ctagstype' : 'rust',
			\ 'kinds' : [
			\'T:types,type definitions',
			\'f:functions,function definitions',
			\'g:enum,enumeration names',
			\'s:structure names',
			\'m:modules,module names',
			\'c:consts,static constants',
			\'t:traits,traits',
			\'i:impls,trait implementations',
			\]
			\}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" C/C++ highlighter															{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO 170818: works for C also
" let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1		" object.*var1*
" let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1
" XXX 170818: won't highlight object name, nor typedefed variable/type
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"	tag highlight															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO tag custom types and functions - useful for C
" needs tags file

" in C: file do:
" :UpdateTypesFile
" after exit:
" :ReadTypes

" STD libs:
" download http://www.cgtk.co.uk/data/vim-scripts/taghighlight/taghighlight_standard_libraries_r2.1.4.zip
" and extract to ~/.vim/plugged/TagHighlight
" INFO 170815: probably not needed (QT, Android and similiar libs)
" XXX 170815: this will not color malloc() and printf()


" $HOME/.vim/syntax/c.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" undoquit 																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undo quit window/split/tab/buffer

let g:undoquit_mapping = '<C-w>u'

" <C-w>c doesn't call QuitPre autocmd, patch it to works with this plugin
nnoremap <c-w>c :call undoquit#SaveWindowQuitHistory()<cr><c-w>c
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		taboo																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO rename tabs XXX don't work with CtrlSpace (which manages Airline tabline)

" remember tab names after restore
"set sessionoptions+=tabpages,globals

let g:taboo_tabline = 0		" AirLine is OK for this purpose
let g:airline#extensions#taboo#enabled = 1
" INFO 171104: remove "%m" - modified flag, Airline will take care of that
" otherwise modified tab will show "%#TabModifiedSelected#*%#TabLineSel#"
let g:taboo_tab_format = "%f"
nnoremap tr :TabooRename<space>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		zoom-win															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" temporary put current split (window) as maximized window
" default shortcut would report error about unsupported vim options which will be preserved after switching
" copied s:localoptlist from help and removed parameters that would cause error (key, oft, sn, tx)
let g:zoomwin_localoptlist   = [
			\ "ai"  , "ar"  , "bh"  , "bin", "bl"  ,
			\ "bomb", "bt"  , "cfu" , "ci" , "cin" ,
			\ "cink", "cino", "cinw", "cms", "com" ,
			\ "cpt" , "efm" , "eol" , "ep" , "et"  ,
			\ "fenc", "fex" , "ff"  , "flp", "fo"  ,
			\ "ft"  , "gp"  , "imi" , "ims", "inde",
			\ "inex", "indk", "inf" , "isk",
			\ "kmp" , "lisp", "mps" , "ml" , "ma"  ,
			\ "mod" , "nf"  , "ofu" ,         "pi" ,
			\ "qe"  , "ro"  , "sw"  ,         "si" ,
			\ "sts" , "spc" , "spf" , "spl", "sua" ,
			\ "swf" , "smc" , "syn" , "ts" ,
			\ "tw"  , "udf" , "wm"]
" after calling this, tabbar (Airline included) would be hidden
let g:zoomwintab_hidetabbar = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" sessions																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Obsession - autosave session (":mksession")
""""""""""""""""""""""""""""""""""""""""
" INFO: will track and autosave session, but only in current folder
" statusline - add %{ObsessionStatus()}

" INFO usage:
" :Obsession <custom filename>		save session
" :Obsession . (or custom dir)		save session to Session.vim
" :Obsession!						delete file and stop saving/tracking
" :load <session file>				load
" vim -S <session file>				load

call SetupCommandAlias("sess", ":Obsession .")
call SetupCommandAlias("css", ":Obsession .")

" vim-startify
""""""""""""""""""""""""""""""""""""""""
" Fancy Vim startup screen (shows MRU, session, ...)
" works out of the box

" vim-session
""""""""""""""""""""""""""""""""""""""""
" - doesn't have support for vim-startify
" - neat - save session in one folder, tab completition, later remembers the session name

" commands:
" :SaveSession
" :OpenSession
" :RestartVim
" :CloseSession
" :DeleteSession
" :ViewSession

" g:session_directory = '~/.vim/sessions' "" or ~\vimfiles\sessions (on Windows).
" Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=buffers

" let g:session_autosave = 'no'	" Don't ask when exiting Vim
" let g:session_autosave_periodic = '5'	" Auto save every 5 minutes
let g:session_autosave_periodic = '1'	" Auto save every 5 minutes
" let g:session_autosave = 'no'	" Don't ask when exiting Vim


" Disable all session locking - I know what I'm doing :-).
" Enables multiple loading of the same session
" let g:session_lock_enabled = 0
" let g:session_default_name='default_'.getcwd().'_'.system('date +%y%d%m_%H%M') " This will be evaluated only on Vim start
" XXX 171102: This will not work on Windows gVim:
if has('unix')
	let g:session_default_name='default_'.system('date +%y%d%m_%H%M') " This will be evaluated only on Vim start
endif

let g:session_command_aliases = 1	" :SomethingSession is :SessionSomething
call SetupCommandAlias("ss", ":SaveSession")
call SetupCommandAlias("sl", ":OpenSession")	" 'ls' is used
call SetupCommandAlias("os", ":OpenSession")
" TODO 170926: Autosave sessions but only if session is loaded/named (don't save session which are not saved by :SaveSession)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" marks																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :SignatureList{Buffer,Global, }Markers
let g:SignatureMap = {
			\ 'Leader'             :  "m",
			\ 'PlaceNextMark'      :  "m,",
			\ 'ToggleMarkAtLine'   :  "m.",
			\ 'PurgeMarksAtLine'   :  "m-",
			\ 'DeleteMark'         :  "dm",
			\ 'PurgeMarks'         :  "m<Space>",
			\ 'PurgeMarkers'       :  "m<BS>",
			\ 'GotoNextLineAlpha'  :  "']",
			\ 'GotoPrevLineAlpha'  :  "'[",
			\ 'GotoNextSpotAlpha'  :  "`]",
			\ 'GotoPrevSpotAlpha'  :  "`[",
			\ 'GotoNextLineByPos'  :  "]m",
			\ 'GotoPrevLineByPos'  :  "[m",
			\ 'GotoNextSpotByPos'  :  "]`",
			\ 'GotoPrevSpotByPos'  :  "[`",
			\ 'GotoNextMarker'     :  "]-",
			\ 'GotoPrevMarker'     :  "[-",
			\ 'GotoNextMarkerAny'  :  "]=",
			\ 'GotoPrevMarkerAny'  :  "[=",
			\ 'ListBufferMarks'    :  "m/",
			\ 'ListBufferMarkers'  :  "m?"
			\ }
" old defaults:
" \ 'GotoNextLineByPos'  :  "]'",
" \ 'GotoPrevLineByPos'  :  "['",
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"		lastplace															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO reopen files where you left off
let g:lastplace_open_folds = 1 " auto open folder, default: 1 XXX don't work for nested folds
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		WhiteSpace															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO highlight trailing spaces in red
" :ToggleWhitespace
let g:better_whitespace_filetypes_blacklist = ['help', 'Help', 'quickfix', 'vim-plug', 'man', 'diff', 'location']
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		indexed search														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO shows search 1 of 123
let g:indexed_search_center = 1			" center the screen, default 0
let g:indexed_search_max_lines = 10000	" default 3000
let g:indexed_search_shortmess = 1		" shorter messages, default 0
let g:indexed_search_dont_move = 1		" don't move to the next match (*N)

" anzu - other plugin - shows search match in Airline
let g:airline#extensions#anzu#enabled = 1

let g:indexed_search_mappings = 0		" patched shortcuts will be used
nnoremap * *N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
nnoremap # #N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>

" centered search:
nnoremap n nzz
nnoremap N Nzz
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		bufkill																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO used for :BD
" don't create various <leader>b* mapping (which will slowdown <leader>b for CtrlPBuffer)
let g:BufKillCreateMappings = 0
" To move backwards/forwards through recently accessed buffers, use: :BB/:BF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		multicursor															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='D'
let g:multi_cursor_prev_key='<c-p>'
let g:multi_cursor_skip_key='<c-x>'
let g:multi_cursor_quit_key='<c-c>'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		Tabularize															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO
" :Tabularize /,		tabularize at the commas
" :Tabularize /,/l0r2	tabularize at the commas, left of comma 0 space, right 1
if exists(":Tabularize")
	" visual -> Tabularize /{PATTERN}
	" Tabularize /:\zs      // ispadne varA:    10  	// : ostane uz var, tabulira s charom iza delimitera

	" not really useful shortcuts
	nnoremap <leader>a= :Tabularize /=<cr>
	vnoremap <leader>a= :Tabularize /=<cr>
	nnoremap <leader>a: :Tabularize /:\zs<cr>
	vnoremap <leader>a: :Tabularize /:\zs<cr>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" cscope																	{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has('cscope')
"	set cscopetag cscopeverbose

"	if has('quickfix')
"		set cscopequickfix=s-,c-,d-,i-,t-,e-
"	endif

"	" a: Find assignments to this symbol

"	" s: Find this C symbol
"	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"	" g: Find this definition
"	nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"	" c: Find functions calling this function
"	nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"	" t: Find this text string
"	nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"	" e: Find this egrep pattern
"	nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"	" f: Find this file
"	nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"	" i: Find files #including this file
"	nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"	" d: Find functions called by this function
"	nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"	" command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
"endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" TODO 170812: <leader>sX for searching with ripgrep

" NeoVim terminal															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" example: :vsplit term://htop
" 			:terminal htop		:te htop

if has('nvim')
	" <Esc> will exit terminal insert mode, close it as normal buffer
	tnoremap <Esc> <C-\><C-n>
	" To simulate |i_CTRL-R| in terminal-mode:
	" tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

" auto-insert when in terminal window
" INFO match buffer name (term://)
autocmd BufWinEnter,WinEnter term://* startinsert

" set guicursor=
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"

" change cursor color
" set termguicolors
" highlight Cursor guifg=white guibg=black
" highlight iCursor guifg=white guibg=steelblue
" set guicursor=n-v-c:block-Cursor
" set guicursor+=i:ver100-iCursor
" set guicursor+=n-v-c:blinkon0
" set guicursor+=i:blinkwait10
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Fast grep
" set grepprg=rg\ --vimgrep
if executable("rg")
	" ne radi na Windowsima:
	" set grepprg='rg --vimgrep --no-heading'
	set grepformat=%f:%l:%c:%m,%f:%l:%m
else
	echoe "ag executable not found"
endif
" Easier way to jump to alternate file
" nnoremap <BS> <C-^>

" editing binary files:
" 		https://vi.stackexchange.com/questions/343/how-to-edit-binary-files-with-vim
nmap <leader>hr :set binary<CR> :%!xxd<CR> :set filetype=xxd<CR>
nmap <leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR> :set fileencoding=<CR> :w<CR> :set nobinary<CR>

" 					colors and TERM setup									{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight Normal		ctermbg=233	" XXX change in theme file

highlight Todo			ctermfg=196 ctermbg=232
highlight Debug			ctermfg=226 ctermbg=234

highlight Search		ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792
highlight Folded		ctermbg=234	ctermfg=69
highlight CursorLine	ctermbg=235

highlight TermCursor ctermfg=red guifg=red

" invisible chars (:set line)
highlight NonText ctermfg=239

" XXX XXX XXX only work in first buffer
" Highlight TODO, FIXME, NOTE, etc. FIXME:
if has("autocmd")
	if v:version > 701
		autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|ZAJEB\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(INFO_START\|INFO_END\|ERROR\|DEBUG_START\|DEBUG_END\|DEBUG_INFO\)')
	endif
endif

" color of tw bar at right (funny color for bad LCD panels)
"highlight ColorColumn ctermbg=93 guibg=DarkMagenta
let g:color_ColorColumn = 234 " must be global (otherwise function ToggleColorColumn won't see it)
execute "highlight ColorColumn ctermbg=".color_ColorColumn
highlight clear ColorColumn		" disable on default

" highlight all afer 80 chars
let &colorcolumn=join(range(81,999),",")
" double highlight, 80 and 120 chars:
"let &colorcolumn="80,".join(range(120,999),",")

highlight VertSplit		ctermfg=202 ctermbg=232 guifg=orange

" change color of tab chars (:set list)
highlight SpecialKey	ctermfg=236

" change concel to match background
highlight Conceal		ctermfg=7 ctermbg=233

" longer vertical bar for vertical splits, space for folds (default was -)
set fillchars=fold:\ ,vert:\│

" change the colors in diff mode, similiar to git diff
highlight DiffAdded		ctermfg=87	guifg=cyan
highlight DiffRemoved	ctermfg=196	guifg=red

" auto completion menu
" highlight pmenu			ctermfg=white ctermbg=52
" highlight pmenu			ctermfg=120 ctermbg=8
" highlight pmenu 			ctermbg=232 ctermfg=120
highlight pmenu				ctermbg=237 ctermfg=254

" hide ANSCI escape chars
syntax match Ignore /\%o33\[[0-9]\{0,5}m/ conceal

" ugly but easier to read
highlight Comment		ctermfg=101
" highlight Comment		ctermfg=114 guifg=#80a0ff

" highlight ExtraWhitespace	ctermbg=162
highlight ExtraWhitespace ctermbg=202

" highlight Error			ctermfg=15 ctermbg=9 guifg=White guibg=Red
" highlight WarningMsg	ctermfg=210 guifg=Red

" linter colors
" highlight link ALEError			SpellBad
" highlight link ALEErrorSign		Error
" highlight link ALEWarning			SpellCap
" highlight ALEWarning			ctermbg=18 gui=undercurl guisp=Blue
highlight ALEWarning			ctermbg=235 gui=undercurl guisp=Blue
" highlight ALEWarningSign		ctermfg=130 ctermbg=220 guifg=Blue guibg=Yellow
highlight ALEWarningSign		ctermfg=15 ctermbg=240 guifg=Blue guibg=Yellow
" highlight ALEError		 		ctermbg=236 gui=undercurl guisp=Red
highlight ALEError		 		ctermbg=234 gui=undercurl guisp=Red
highlight ALEErrorSign			ctermfg=15 ctermbg=9 guifg=White guibg=Red

" sign column (git +-m, marks, linter signs)
highlight SignColumn			ctermfg=118 ctermbg=0 guifg=#A6E22E guibg=#232526

" brighter, easier to read line numbers (column left)
" INFO line column is the same for numbers, git marks, vim marks, linter,...
highlight LineNr				ctermfg=253	guifg=white
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				GUI settings												{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
	"Invisible character colors
	highlight NonText guifg=#2a4a59
	highlight SpecialKey guifg=#2a4a59
	highlight Normal	guibg=#0F0F0F

	" Windows and Unix gVim:
	" set encoding=utf-8
	set winaltkeys=no		" Turn off <Alt>/<Meta> pulling down GUI menu
	" set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powe:h10

	set listchars=tab:│·,extends:>,precedes:<
	set showbreak=…		" char to be displayed on the beggining of broken line
	"set listchars=tab:\|·,eol:¬,trail:·

	"	"set lines=150 columns=230
	set guioptions -=T		" toolbar
	set guioptions -=r		" right scrollbar
	set guioptions -=L		" left scrollbar
	set guioptions -=m		" menubar
	set guioptions +=a		" auto-copy selected text"
	" set guioptions -=m		" menu bar (possible Windows only)

	set hlsearch
	set backspace=2		"indent,eol,start, needed for Windows gVim
	let g:airline_powerline_fonts = 1
	" set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powe:h10

	" initial size:
	" set lines=70 columns=200

	set mousefocus

	" disable bell
	autocmd GUIEnter * set vb t_vb=

	" gVim by default has italic char for tab, make it non italic:
	" highlight SpecialKey		term=bold ctermfg=236 gui=italic guifg=#465457
	highlight SpecialKey		term=bold ctermfg=236 gui=none guifg=#465457



	"Invisible character colors
	highlight NonText guifg=#2a4a59
	" highlight SpecialKey guifg=#2a4a59

	" TODO same font as xterm
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" todo 1708 Windows Airline font:
" XXX
" set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1

" " work specific stuff														{{{
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" on Linux PC for team H
" if !has('windows')
" team H: Linux PC
" team A: Windows PC
	let g:work_pc=system('is_work_pc')
	let g:work_dir=system('is_work_dir')
	let g:team_a=system('is_sverige') " TODO 170831
	" sverige: if Windows and work_dir exists

	if work_pc == 1
		set list

		if work_dir == 1
			" expand only if we are working on work stuff
			if team_a == 1
				" weird North men use 3 spaces as a tab
				set tabstop=3		" tab size
				set shiftwidth=3 	" when indenting with '>'
			endif
			set expandtab
			highlight clear ColorColumn	" don't color background after textwidth
		endif
	endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-\> :Tags <C-R><C-W><CR>
nmap <C-Enter> <C-w>g<C-]><C-w>T
" Not saying it is required but I enjoy this one more than <C-]> but I guess it is already sort of covered by g<C-]>.


if has('cscope')
    set cscopetagorder=0
    set cscopetag
    set cscopeverbose
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set cscopepathcomp=3

    function! LoadCscope()
        let db = findfile("cscope.out", ".;")
        if (!empty(db))
            let path = strpart(db, 0, match(db, "/cscope.out$"))
            set nocscopeverbose " suppress 'duplicate connection' error
            exe "cs add " . db . " " . path
            set cscopeverbose
        endif
    endfunction
    au BufEnter /* call LoadCscope()

    nnoremap T :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap t <C-]>
    nnoremap gt <C-W><C-]>
    nnoremap gT <C-W><C-]><C-W>T
    nnoremap <silent> <leader>z :Dispatch echo "Generating tags and cscope database..." &&
                        \ /usr/local/bin/ctags -R --fields=+aimSl --c-kinds=+lpx --c++-kinds=+lpx --exclude=.svn 
                        \ --exclude=.git && find . -iname '*.c' -o 
                        \ -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' 
                        \ > cscope.files && cscope -b -i cscope.files -f cscope.out &&
                        \ echo "Done." <cr><cr>

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    " cnoreabbrev css cs show
    cnoreabbrev csh cs help
    cnoreabbrev csc Cscope
    command! Cscope :call LoadCscope()
endif

" TODO 171029: put this in the right place
nnoremap <A-w> :BD<cr>
inoremap <A-w> <C-o>:BD<cr>


" INFO {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fold moving:
" zj/zk - move to start/end of prev/next fold
" [z/]z - move to start/end of current open fold


" programmers vim 															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @: repeat last : command
" @@ for next repeat
" Just type & to repeat the last substitution on the current line. You can repeat it on all lines by typing g&.
" "*]p	paste from * register, and the indent with the current line
" Ctrl-R '1p	paste from the first register in insert mode

" Ctrl-W } show variable/function in a preview window
" Ctrl-W (ctrl)] open a tag in a split windows	TODO open in a vsp instead split
" :pc	close preview window
" C delete to the end of the line and go to insert mode


" ga: show char under the cursor in decimal, hex, and oct, for unicode: tpope/vim-characterize XXX works without plugin
" gCtrl-] If there is only one match, it will take you there. If there are multiple matches, it will list them all, letting you choose the one you want, just like :tselect

" multiple files load: args files*.c
" multiple replace: TODO

" yank until mark a: y'a
" '. goto place of last edit

" reselect last visually selected block: gv
" goto preview window Ctrl-W Ctrl-P

" delete lines that do NOT match pattern: :v/pattern/d
" change direction of select in visual mode: 'o'
" :mkview :loadview to save folds

set viewoptions-=options	" for mkview, don't store current file
set viewdir=~/.vim/view
" :mkview :loadview

" diff
" open original file in one split, open new split and put newer version (no need to save that buffer) and then:
" :windo diffon
" :windo diffoff

" args `ag -l SomethingToSearch`
" argdo s/something/else/g | w

" IDEA smarter jumping (tag/file/...)
set isfname+=:	" to recognize :123 as filename (for jumping to specific line)
set isfname+=32	" <space> is part of filename
" ~/.vimrc:123
" /tmp/new file.txt
" file under cursor (like gf uses): echo expand("<cfile>")
" for tag search (like * uses): echo expand('<cword'>)
" if not tag, check if declaration: gd, then gD
" check if www link
		" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
		" map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
		" execute("e ".mycurf) opens the file saved in mycurf


"  vib		select inner block (eg inside {})
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" searching																{{{
":%!/usr/local/bin/zsh!/opt/bin/zsh		-> ! as delimiter (# also works)
"/some_text.*							-> '.' and wild wildcard starts working
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" moving		 															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" '[ '] jump to the beggining or end of last change
" ]s [s jump to next/prev spell mistake
" {} goto prev/next empty line

" zz put current line on the middle of the screen
" zt put current line on the top of the screen
" zb put current line on the bottom of the screen

" quick fix list prev/next: 	[q	]q (alse :cn and :cp)
" prev/next file:				[f	]f
" prev/next misspell			[s	]s
" prev/next file in args list	[a	]a (A for first/last)
" goto changes (git)			[c	]c
" folds							[z	]z

" gd	will take you to the local declaration.
" gD	will take you to the global declaration.
" g*	search for the word under the cursor (like *, but g* on 'rain' will find words like 'rainbow').
" g#	same as g* but in backward direction.
" gg	goes to the first line in the buffer (or provide a count before the command for a specific line).
" G		goes to the last line (or provide a count before the command for a specific line).
" gf	goto file under cursor
" g]	jump to a tag definition

" :ccl	close QuickFix window

"##########################################################################}}}
" tips and tricks 															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" db	delete word backwars
" profiling: http://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow
	" :profile start profile.log
	" :profile func *
	" :profile file *
	" " At this point do slow actions
	" :profile pause
	" :noautocmd qall!

" TODO jednom sredit:
" plugin tslime		:vnoremap <buffer> \t <Plug>SendSelectionToTmux			" puts selected text to neighbors pane

" Select a range of code, enter command mode, and type Gbrowse:
"":'<,'>Gbrowse
" sarch and replace:
" 	search word: %s/word/		search whole word: %s/\<word\>/
" 	s/a/b/{g,c,i,I}	global, confirm, ignore case, dont ingore case
" 	. - the current line
" 	% - the whole file
" 	't - position of mark t
" 	:s/a/b/ is the same as :s:a:b
" window to tab: Ctrl-W T (caps locked T)
" read command output to buffer: :r[ead] !uname
" read command output to buffer (replace whole buffer): :%!uname
" read command output to buffer (replace current line): :.!uname
" last macro: @@
" load all matching files to buffers: :args `git grep -l <string>`
" do something on all loaded buffers: :argdo %s/<string>/<replacement>/gce | update 		gce: global, confirm, error ignore

" :r read file
" :r! read output of command
" :so source/execute commands from file<Paste>
" redirect to file (in this example kbd map):
	":redir! > vim_maps.txt
	" :map
	" :map!
	" :redir END

" R in normal mode: write throught (Replace)-(without need to delete)
" U/u/~ in visual mode to upper/lower/toggle case

" startup profiling:  vim --startuptime startup.log, visuasilation: https://github.com/hyiltiz/vim-plugins-profile

" load file without loading it :bad file.txt

" argdo {{{
    " :arg => list files in arglist
    " :argdelete * => clean arglist
    " :argadd **/*.rb => add files to arglist
    " :argdo %s/foo/bar/gc => replace foo by bar in arglist
    " :argdo update => save changes to arglist
    " :argdo undo => undo changes to arglist
" Navigation in arglist
    " [a => go to the previous file in arglist
    " ]a => go to the next file in arglist
    " [A => go to the first file in arglist
    " ]A => go to the last file in arglist
" }}}
"##########################################################################}}}
" vimL misc							{{{
" number of tabs: tabpagenr('$')
" let l:buffers = range(1, bufnr('$'))
" let l:currentTab = tabpagenr()
" current buffer number: bufnr('$')
" current buffer number: bufnr('%')
" get line under the cursors: getline('.')
"									}}}

" variables:
" % - buffer (or file) TODO
" ^ - alternate file
" TODO :h pattern-atoms
" Vim debug:
" vim -V9myVimLog

" INFO maybe will be useful some day: "&& bufname("%") != "[Command Line]"
" INFO highlight ALL whitespace (and tabs): /\s
" INFO highlight all whitespace at the beggining: /^<space>

" export MYVIMRC="~/vim_ide"		" change .vim position
" vim -U ~/vim_ide/vimrc

" Unicode characters can be inserted by typing ctrl-vu followed by the 4 digit hexadecimal code.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" TODO 16xxxx <Tab>/<C-i> switch window if there are multiple windows, othervise normal Ctrl-I
" TODO 16xxxx another '*' should disable highlight
" TODO 16xxxx <enter> - if it's link under cursor then "gx", if it's tag under cursor then :tag... othervise "o"
" TODO 170717: tmux <C-j>p -> enter/exit paste mode before/after that command
" INFO: remmaping Esc will fuckup scroll (scrolling will start to insert chars)
"
" INFO 170901: Ako se razjebe ista sta koristi python (npr ncm na Windowsima): pip install --upgrade neovim
" TODO 170909: nvim Windows: CP to clipboard. gVim works
" TODO 170921: Rg/ack skip tags file
" TODO 170921: snippets
" TODO 170921: <leader>r -> references to function
" INFO 170926: vim slowiness
" syntax off, relative number off, cursorline off -> speedup
" autocommand spam: :au CursorMoved
" :syntime on, move around in your ruby file and then, :syntime report
" old regex engine: :set re=1
" group autocommands
" => moze se ubrzat malo, ali i dalje bude spor, i dalje se vidi cursosr
" TODO 171001: search for keyword in all buffers

" DBG layout:
" registers: 
" vsplit
" vertical resize 24
" set nocursorline

" posao 170725
" set expandtab
" set shiftwidth=3
" set tabstop=3
" ignore whitespace changes and also newlines (^M)
" set diffopt+=iwhite




" open header:
nnoremap <leader>h :e %:r.h<cr>
" "bubble" move the lines (will have weird things on edge of the buffer)
" nnoremap <A-k> ddkP
" nnoremap <A-j> ddp
" vnoremap <A-k> xkP`[V`]
" vnoremap <A-j> xp`[V`]
inoremap <A-k> <C-o>dd<C-o>k<C-o>P
inoremap <A-j> <C-o>dd<C-o>p
" bubble move the lines with unimpared plugin
nmap <A-k> [e
nmap <A-j> ]e
vmap <A-k> [egv
vmap <A-j> ]egv
" " manually create that dirs:
" inoremap <A-k> <C-o>[e
" inoremap <A-j> <C-o>]e

" closer than Ctrl-PgUp/PgDn. Ctrl-[/] is already used
nnoremap <A-[> :tabprev<cr>
nnoremap <A-]> :tabnext<cr>
nnoremap T1 :tabmove 0<cr>:echo "current tab moved to position 1"<cr>

" 171127
