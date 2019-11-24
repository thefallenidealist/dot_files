" 170812
" 1.0 - created 160729, again
" 0.1 - 160512 - vim as IDE at work
" 0.0 - 2006. probably
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker noet :

" TODO 2017-09-02 Windows libclang
let s:work_pc = 0

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
set background=dark
set laststatus=2	" always show status bar
set lazyredraw		" don't redraw screen in the middle of a macro
set hidden			" allow changing window without saving buffer first, also needed for Ctrl-Space plugin
set showcmd			" show size of visual block in cmdline at right

set notitle

set autowrite		" Automatically :write before running commands
set noautoread		" don't autoload files that have changed outside of vim

" better splits
set splitbelow
set splitright

set timeoutlen=300		" [ms] long enough for <leader><shift>F, was 1000
" set ttimeoutlen=0		" delay for the esc key, 10ms XXX
set ttimeoutlen=20		" delay for the esc key, 10ms XXX
"set exrc		" source .vimrc file if it present in working directory
set secure		" This option will restrict usage of some commands in non-default .vimrc files;
" commands that wrote to file or execute shell commands are not allowed and map commands are displayed.

set nomodeline
set modelines=0
" INFO secure-modelines plugin is used which only allows some (secure) modeline options

" fix mouse usage after 220-th column
if has("mouse_sgr") " 171208 Unix, vim has it, nvim does not
	set ttymouse=sgr
else
	" Xorg paste with middle click
	if !has('nvim') " Nvim doesn't have this
		set ttymouse=xterm2
	endif
end

set gdefault "applies substitutions globally on lines. For example, instead of :%s/foo/bar/g you just type :%s/foo/bar/

"set completeopt=menuone,preview	" default
set completeopt=menuone				" f(); can be view in command line with plugin
set completeopt+=noselect			" fix deoplete auto insert
set noshowmode						"Don't show the mode(airline is handling this)
set shortmess+=I	" don't show intro message at startup
set shortmess+=c	" don't give ins-completion-menu messages
set cursorline		" color the line when the cursor is
set matchpairs+=<:>	" Include angle brackets in matching.
set showmatch

set encoding=utf-8	" otherwise gVim will complain about listchars and showbreak
set diffopt+=vertical
"		<tab> and wrapping			{{{
"""""""""""""""""""""""""""""""""""""""
set tabstop=4		" tab size
set shiftwidth=4 	" when indenting with '>'
" set expandtab		" convert tab to spaces
set softtabstop=4	" smart <BS> - delete 4 chars"

" soft wrap
set wrap			" soft break when line is wider than Vim window (not tw)
set linebreak		" don't break in the middle of the word
					" wont't work when "list" is enabled - will in nvim
" set showbreak=…		" char to be displayed on the beggining of broken line
set showbreak=…………		" char to be displayed on the beggining of broken line

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
" set wildignore+=*.a,*.o,*.elf,*.bin,*.dd,*.img
" set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
" set wildignore+=.git,.hg,.svn
" set wildignore+=*~,*.swp,*.tmp
""""""""""""""""""""""""""""""""""""}}}

" show invisible characters, tab is longer (unicode) pipe char
set listchars=tab:\│·,extends:>,precedes:<
" show ALL spaces:
" set listchars+=space:║
" set listchars+=trail:◊
set list	" show invisible chars (tabs and others defined in listchars)

" undo, swap and backup														{{{
" -----------------------------------------------------------------------------
" backupdir (file.txt~), directory (file.txt.swp)
set swapfile
set directory=~/.vim/swap//
set writebackup " protect against crash-during-write
set nobackup " but do not persist backup after successful write
set backupdir=~/.vim/backup//
set undofile
set undodir=~/.vim/undo//

" Create undo directory
if !isdirectory($HOME . "/.vim/undo")
call mkdir($HOME . "/.vim/swap", "p")
call mkdir($HOME . "/.vim/backup", "p")
call mkdir($HOME . "/.vim/undo", "p")
call setfperm($HOME . "/.vim/swap",   "rwx------")
call setfperm($HOME . "/.vim/backup", "rwx------")
call setfperm($HOME . "/.vim/undo",   "rwx------")
endif
" ------------------------------------------------------------------------- }}}
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

if has('nvim')
	set inccommand=nosplit " live :substitute, only for nvim
endif

set formatoptions+=j	" pretty formating when joining lines (key J)
" set nrformats+=alpha  " Ctrl-A/X will also work on single chars
set sessionoptions=buffers,curdir,folds,help,winpos
" XXX 181128: won't restore full help window: status will be 'Normal', not
" 'Help' s so <C-]> won't work as expected
set foldmethod=marker
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		OS specific															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('unix')
	let s:uname = substitute(system("uname"), '\n', '', '')

	if s:uname == "FreeBSD"
		let g:python3_host_prog='/usr/local/bin/python3'
		let g:clang_library_path='/usr/local/llvm50/lib'

		" Universal Ctags - Exuberant Ctags fork
		let g:ctags_exe='/usr/local/bin/uctags'

		" let g:tagbar_ctags_bin=substitute(system("which exctags"), '\n', '','')
		let g:tagbar_ctags_bin=g:ctags_exe

	elseif s:uname == "Linux"
		let g:ctags_exe='/usr/bin/ctags-exuberant'
	endif " uname
elseif has('win32')
	" INFO 190516: /c/python3_x64/python.exe -m pip install --upgrade pip pywin
	let $PATH.=';C:\bin'			" place where win32yank is
	let $PATH.=';C:\python35_x64'	" work PC
	let g:ctags_exe='c:\bin\ctags.exe'
	if substitute(system('is_sverige'), '\n','','g') == "1"
		let g:python3_host_prog='C:\python3_x64\python.exe'
		" download from llvm.org "Pre-built Binaries" for Winsows (64-bit)
		" let g:ncm2_pyclang#library_path = 'C:\msys64\mingw64\bin\libclang.dll'
		" let g:ncm2_pyclang#library_path = 'C:\Program Files\LLVM\lib\clang\8.0.0\lib\windows'
	endif
	cabbrev rm del
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		build/programming			{{{
"""""""""""""""""""""""""""""""""""""""
" for 'gf' command: open stdio.h and similar
let &path.="src/include,/usr/include/AL,"

" search for $CWD/tags, $CWD/.tags and go level up until $HOME
set tags=tags,.tags;$HOME
""""""""""""""""""""""""""""""""""""}}}
"		autocmd																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup my_group_with_a_very_uniq_name
	" this is executed every time when vimrc is sourced, so clear it at the beggining:
	autocmd!
	" INFO 190514: FileType: will be executed when opening file
	" Buf/WinEnter: Will be executed when entering buffer/window

	" easier quit from this windows
	autocmd FileType help nnoremap <buffer> q :wincmd c<cr>
	autocmd FileType qf,quickfix,netrw nnoremap <buffer> q :q<cr>
	autocmd FileType qf 10wincmd_	" QF will always have height of 10 lines

	autocmd FileType help,man nnoremap <buffer> <cr> <C-]>

	autocmd FileType help,man,qf :NumbersDisable	" Disable Numbers plugin in help or man

	autocmd FileType qf set nolist norelativenumber number

	" force Vim to threat .md files as markdown and not Modula
	" or use tpope/vim-markdown plugin
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	" don't match '<' in C++ (cout << "Something";)
	autocmd FileType cpp,make,vim set matchpairs-=<:>
	autocmd FileType shell set matchpairs-=`:`	" works, but only in reverse

	" in case I ever open a python file
	autocmd FileType python set expandtab

	autocmd FileType xdefaults set commentstring=!%s
	autocmd FileType pf,dnsmasq,fstab,cfg,gitconfig,crontab,sshdconfig,resolv setlocal commentstring=#\ %s
	autocmd FileType c setlocal commentstring=\/\/\ %s

	" Warn if file in current buffer is changed outside of Vim
	" - default: just warning when trying to write to the file
	autocmd BufEnter,FocusGained * checktime %

	autocmd BufRead,BufNewFile SConstruct,SConscript set filetype=python

	autocmd FileType verilog call SetupVerilogEnvironment()

	" close preview window if it is last
	autocmd WinEnter * if &previewwindow | nnoremap <buffer> q :q!<cr> | endif
	" close quickfix if last
	autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
	" TODO 190527: close also if QF + NERDTree
	autocmd WinEnter * if (winnr('$') == 2 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" && exists("b:NERDTree") && b:NERDTree.isTabTree()) |q|endif


	" close NERDTree/Tagbar if it is last window
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	autocmd BufEnter * if (winnr("$") == 1 && (bufwinnr('__Tagbar__')) != -1) | q | endif

	" maps in command-line-window:
	autocmd CmdwinEnter * map <buffer> <cr> <cr>
	autocmd CmdwinEnter * map <buffer> q :q<cr>
	autocmd CmdwinEnter * map <buffer> <esc> :q<cr>

	" maps in git messenger floating window
	autocmd FileType gitmessengerpopup map <buffer> <esc> q

	au InsertEnter * set norelativenumber
	au InsertLeave * set relativenumber
augroup END

" setup when in diff mode:
if &diff
	" when fixing merge conflict:
	map <leader>1 :diffget LOCAL<CR>
	map <leader>2 :diffget BASE<CR>
	map <leader>3 :diffget REMOTE<CR>
	nnoremap du :diffupdate<cr>
	nnoremap dg :diffget<cr>
	call SetupCommandAlias("du", "diffupdate")
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
call SetupCommandAlias("Bd", "bd")
" cabbrev QA1 qa!
" cabbrev Qa! qa!
" cabbrev qA qa
" cabbrev qa1 qa!

command! WE write | edit
call SetupCommandAlias("we", "WE")
call SetupCommandAlias("We", "WE")

command! PU PlugUpdate | PlugUpgrade
command! PI write | so $MYVIMRC | PlugInstall
command! PD write | so $MYVIMRC | PlugClean

" open help in vertical split right
cabbrev h vert leftabove help
call SetupCommandAlias("h", "vert leftabove help")
" TODO 171214: resize help window split: vertical resize 84
cabbrev man vert leftabove Man
" get file path:
cabbrev fp echo @%
" copy the current filename to the X11 2nd buffer
cabbrev fpy echo @%
cabbrev FP echo expand('%:p')
" reload syntax
cabbrev rsyn syntax sync fromstart
call SetupCommandAlias("CC", "set cursorcolumn!")

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
" call SetupCommandAlias("zca", "zi")
" call SetupCommandAlias("zoa", "zi")
" close all other folds

" Don't show ^M in DOS files
command! FixDos edit ++ff=dos

" cabbrev css CtrlSpaceSaveWorkspace
" cabbrev csl CtrlSpaceLoadWorkspace
cabbrev css :mksession!
cabbrev csl :source Session.vim

cabbrev ccc call ToggleColorColumn()
call SetupCommandAlias("qc", "ccl") " quickfix close (alignmend with :pc[lose])
call SetupCommandAlias("dt", "diffthis")
call SetupCommandAlias("do", "diffoff")
call SetupCommandAlias("sig", "call AppendModeline()")
call SetupCommandAlias("mode", "call AppendModeline()")
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		generic mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" patch moving one char left when leavig Insert mode
inoremap <silent> <Esc> <Esc>`^
" disable ed mode:
nnoremap Q <nop>
" remap recording
nnoremap Q q
nnoremap Q? q/
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
" insert only one char:
nnoremap s i_<esc>r

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

" INFO 180114: xbindkeys will transform <C-i> to <F14>,
" only in insert mode, muscle memory. Doesn't work in 100% of cases
inoremap <F14> <Tab>

nnoremap <F4> :set paste!<cr>
" don't 'insert char above cursor, it's confusing'
" inoremap <C-y> <nop> " XXX 180115: will break snippets and NCM

" jump to next misspell (<leader>z and z= are already used for spelling)
nnoremap ]z ]s
nnoremap [z [s
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		buffers/windows/tabs keymaps										{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap tn :tabnew<cr>
nnoremap tN :-tabnew<cr>
nnoremap td :tab split<cr>:echom "tab duplicated"<cr>

nnoremap th :tabprev<cr>
nnoremap tl :tabnext<cr>
" closer than Ctrl-PgUp/PgDn. Ctrl-[/] is already used
nnoremap <A-[> :tabprev<cr>
nnoremap <A-]> :tabnext<cr>
nnoremap [t :tabprev<cr>
nnoremap ]t :tabnext<cr>
" AltGr + [/] - depends on (xmodmap) keyboard layout
nnoremap š :tabprev<cr>
nnoremap đ :tabnext<cr>
" gt is default for next tab, this is pret close to gt
nnoremap gr :tabprev<cr>

nnoremap tj :bnext<cr>
nnoremap tk :bprev<cr>
nnoremap [b :bnext<cr>
nnoremap ]b :bprev<cr>

" delete buffer without closing tab or split
" INFO '<bar>' is used instead of '|' pipe char
nnoremap <leader>d :setl bufhidden=delete <bar> bnext<cr>
nnoremap <A-w> :BD<cr>
call SetupCommandAlias("Bd", "bd")
inoremap <A-w> <C-o>:BD<cr>

nnoremap <silent><Tab> :call SwitchWindow()<cr>
" XXX 190422 (works on Windows): " TODO 190516
nnoremap <C-w><C-c> :wincmd c<cr>
nnoremap <C-w><C-x> :wincmd l<cr>:wincmd c<cr>:echo "closed window on the right side"<cr>
nnoremap <C-w>x :wincmd l<cr>:wincmd c<cr>:echo "closed window on the right side"<cr>
" other options: P: reverse previous, W: reverse next

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
	" inoremap <A-u> <C-o>:tabprev<cr>
	" inoremap <A-i> <C-o>:tabnext<cr>
	" inoremap <A-n> <C-o>:tabprev<cr>
	" inoremap <A-m> <C-o>:tabnext<cr>
	" nnoremap <A-u> <C-o>:tabprev<cr>
	" nnoremap <A-i> <C-o>:tabnext<cr>
	" nnoremap <A-n> <C-o>:tabprev<cr>
	" nnoremap <A-m> <C-o>:tabnext<cr>
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

nnoremap T1 :tabmove 0<cr>:echo "current tab moved to position 1"<cr>
nnoremap T2 :tabmove 1<cr>:echo "current tab moved to position 2"<cr>
nnoremap T3 :tabmove 2<cr>:echo "current tab moved to position 3"<cr>
nnoremap T4 :tabmove 3<cr>:echo "current tab moved to position 4"<cr>
nnoremap T5 :tabmove 4<cr>:echo "current tab moved to position 5"<cr>
nnoremap T6 :tabmove 5<cr>:echo "current tab moved to position 6"<cr>
nnoremap T7 :tabmove 6<cr>:echo "current tab moved to position 7"<cr>
nnoremap T8 :tabmove 7<cr>:echo "current tab moved to position 8"<cr>
nnoremap T9 :tabmove 8<cr>:echo "current tab moved to position 9"<cr>

nnoremap te :tabedit<space>

" jumping, Ctrl-I (tab) is used for switching splits
nnoremap <C-p> :pop<cr>:echo "Tag jump -1"<cr>
nnoremap <C-n> :tag<cr>:echo "Tag jump +1"<cr>

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
nnoremap <C-w>d :tab split<cr>:echom "current tab duplicated"<cr>
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
nnoremap <silent><Esc><Esc> <Esc>:nohlsearch<CR><Esc>:echo "hlsearch disabled"<cr>
"		leader mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" another leader keys:
nmap ; <leader>
nmap , <leader>

"temporarily disable search highlighting until the next search.
" INFO this is NOT the same as set nohlsearch
nnoremap <leader>H :noh<cr>
" TODO make this to toggle highlight, probably will not be possible

nnoremap <leader>z :setlocal spell!<cr>
" toggle showing invisible chars
nnoremap <leader>; :set list!<cr>:set list?<CR>
nnoremap <leader>n :set relativenumber!<cr>
nnoremap <leader>N :set number!<cr>
nnoremap <leader>r :so $MYVIMRC<cr>:echo "vimrc reloaded"<CR>
nnoremap <leader>e :e $MYVIMRC<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		copy paste mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" paste and adjuste indent
nnoremap p ]p
nnoremap P ]P
nnoremap p p=`]
nnoremap P P=`]

" delete to the black hole (_) register
nnoremap dd "_dd
nnoremap x "_x
nnoremap D "_D
nnoremap C "_C
nnoremap yD D
nnoremap yC C
nnoremap dw "_dw
nnoremap cw "_cw
nnoremap diw "_diw
nnoremap ciw "_ciw
nnoremap Y y$
nnoremap X "_X
nnoremap x "_x
" yank and delete
nnoremap dy yydd
nnoremap yd yydd

" selected copied text:
nnoremap gp `[v`]

" easier copying when cursor is not at the beggining of the word:
nnoremap yw yiw
" in case that old behaviour is needed:
nnoremap yW yw

"	clipboard																{{{
if has('clipboard')	" not really needed for all options under this
	" copy filepath to X11 clipboard
	nnoremap <leader>FP  :let @* = expand("%")<cr>:echo   "relative path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fp  :let @+ = expand("%")<cr>:echo   "relative path of the file copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FD  :let @* = expand("%:h")<cr>:echo "relative path of the dir copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fd  :let @+ = expand("%:h")<cr>:echo "relative path of the dir copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FFP :let @* = expand("%:p")<cr>:echo "full path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>ffp :let @+ = expand("%:p")<cr>:echo "full path of the file copied to the X11 2nd clipboard"<CR>

	" shift + {1,2,3} = X11 1st, X11 2nd, tmux
	inoremap <C-r>! <C-o>"*]p<C-o>:echo "paste from the X11 1st clipboard"<cr>
	inoremap <C-r>@ <C-o>"+]p<C-o>:echo "paste from the X11 2st clipboard"<cr>
	inoremap <C-r># <C-o>:Tput<cr><C-o>:echo "paste from the clipboard"<cr>

	" tmux keybindings:
	" p - tmux buffer paste
	" P - X11 2nd
	" [ - X11 1st
	" { - Vim paste

	nnoremap yiW "+yiw:echo "yank inner word to the X11 2nd clipboard"<cr>
	vnoremap Y "+y:echo "yank selection to the X11 2nd clipboard"<cr>

	" X11 primary buffer		"*
	vnoremap <leader>Y "*y:echo "copied to the X11 1st clipboard"<cr>
	nnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>
	vnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>

	" X11 secondary buffer		"+
	" TODO TODO set paste mode before pasting
	vnoremap <leader>y "+y:echo  "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>y "+yiw:echo "word copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>yy "+yy:echo "line copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>p "+p:echo  "pasted from the X11 2nd clipboard"<cr>
	vnoremap <leader>p "+p:echo  "pasted from the X11 2nd clipboard"<cr>

	" compat with C-r Shift-1/2
	vnoremap <leader>y! "*y:echo "copied to the X11 1st clipboard"<cr>
	vnoremap <leader>y@ "+y:echo "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>p! "*p:echo "pasted from the X11 1st clipboard"<cr>
	nnoremap <leader>p@ "+p:echo "pasted from the X11 2nd clipboard"<cr>

	cnoremap <C-r>! <C-r>*
	cnoremap <C-r>@ <C-r>+

	" Windows compat:
	inoremap <S-Insert> <C-r>*
	" ThinkPad keyboard compat:
	inoremap <S-Delete> <C-r>*
	" needed for nvim-qt.exe
	cnoremap <S-Insert> <C-r>+
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
nnoremap <leader>ff  :let @" = expand("%")<cr>:echo   "relative path of the file copied to the unnamed register"<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		mouse mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" double click select all occurrences
nnoremap <2-LeftMouse> *N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
inoremap <2-LeftMouse> <c-o>*N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
vnoremap <2-LeftMouse> *N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
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
	elseif (l:state == 0)
		" execute "highlight ColorColumn ctermbg=".g:color_ColorColumn
		" execute "highlight ColorColumn ctermbg=234 guibg=#1c1c1c"
		" execute "highlight ColorColumn ctermbg=234 guibg=".g:color_ColorColumnGUI
		execute "highlight ColorColumn ctermbg=".g:color_ColorColumn." guibg=".g:color_ColorColumnGUI
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
function! RemoveBrackets()                                                " {{{
	" removes '\<' and '\>' in '/' register
	" INFO created 171022, used for <C-R>/ after */#
	let @/ = substitute(@/, "\\\\\<", "", "")
	let @/ = substitute(@/, "\\\\\>", "", "")
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! HeaderToggle()                                                   " {{{
	" bang for overwrite when saving vimrc
	" from https://stackoverflow.com/questions/17170902/in-vim-how-to-switch-quickly-between-h-and-cpp-files-with-the-same-name
	let file_path = expand("%")
	let file_name = expand("%<")
	let extension = split(file_path, '\.')[-1] " '\.' is how you really split on dot
	let err_msg = "There is no file "

	if extension == "c"
		let next_file = join([file_name, ".h"], "")

		if filereadable(next_file)
			:e %<.h
		else
			echo join([err_msg, next_file], "")
		endif
	elseif extension == "h"
		let next_file = join([file_name, ".c"], "")

		if filereadable(next_file)
			:e %<.c
		else
			echo join([err_msg, next_file], "")
		endif
	elseif extension == "cpp"
		let next_file = join([file_name, ".hpp"], "")

		if filereadable(next_file)
			:e %<.hpp
		else
			echo join([err_msg, next_file], "")
		endif
	elseif extension == "hpp"
		let next_file = join([file_name, ".cpp"], "")

		if filereadable(next_file)
			:e %<.cpp
		else
			echo join([err_msg, next_file], "")
		endif
	endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! SetupVerilogEnvironment()                                        " {{{
	" https://github.com/albertxie/iverilog-tutorial
	" TODO 180617: Incorporate this into <F5> mapping for C/C++/Rust
	" (depending on filetype)
	map <F5> :! iverilog -o %:r.vvp %:r.v %:r_tb.v && vvp %:r.vvp && gtkwave %:r.vcd <ENTER>
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" register clear															{{{
" -----------------------------------------------------------------------------
function! RegisterClear()
	let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
	for r in regs
		call setreg(r, ' ')
	endfor
endfunction
call SetupCommandAlias("regc",  "call RegisterClear()")
" ------------------------------------------------------------------------- }}}
" switch window																{{{
" ------------------------------------------------------------------------- }}}
function! SwitchWindow()												"  {{{
" -----------------------------------------------------------------------------
" created by me on 190524
" - switch to previous window if available
" - if not, then cycle
" - usefull after closing quickfix/location list
	let l:prev_window = winnr('#')
	let l:curr_window = winnr()
	" echo "Previous: " . l:prev_window . " current: " . l:curr_window

	if l:prev_window == 0	" there is no previous window, just cycle
		" echo "No previous window"
		wincmd w
	elseif l:curr_window == l:prev_window
		" echo "same windows"
		" for git windows, when split is closed
		wincmd w
	else	" there is previous window
		" echo "switch to previous"
		wincmd p
	endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! Line(...)														" {{{
" ---------------------------------------------------------------------------
	" created by me on 190520
	let l:arg_num=a:0
	let s:line1 = "											{{{"
	" fold mark just to make it in synch with printf() bellow	{{{

	if &commentstring == "// %s"
		let s:line2 = printf("----------------------------------------------------------------------------")
		let s:line3 = printf("------------------------------------------------------------------------- }}}")
	else
		let s:line2 = printf("-----------------------------------------------------------------------------")
		let s:line3 = printf("------------------------------------------------------------------------- }}}")
	endif
	let s:line2 = substitute(&commentstring, "%s", s:line2, "")
	let s:line3 = substitute(&commentstring, "%s", s:line3, "")
	let s:line1 = substitute(&commentstring, "%s", s:line1, "")

	if l:arg_num == "0"
		" Just append lines bellow cursor
		call append(line("."), s:line3)
		call append(line("."), s:line2)
		call append(line("."), s:line1)
		call feedkeys('j0la', 'n')
	elseif l:arg_num == "1"
		let l:arg1=a:1
		if l:arg1 == "1"
			call append(line("."), s:line1)
		elseif l:arg1 == "2"
			call append(line("."), s:line2)
		elseif l:arg1 == "3"
			call append(line("."), s:line3)
		else
			echo "arg is wrong: ".l:arg1
		endif
	else
		echo "Wrong number of arguments: " arg_num
	endif
endfunction

call SetupCommandAlias("lines", "call Line()")
call SetupCommandAlias("line", "call Line()")
call SetupCommandAlias("line1", "call Line(1)")
call SetupCommandAlias("line2", "call Line(2)")
call SetupCommandAlias("line3", "call Line(3)")
" ------------------------------------------------------------------------- }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Plugins																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto install plug.vim doesn't exists                                      {{{
" -----------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" -----------------------------------------------------------------------------
" ------------------------------------------------------------------------- }}}
call plug#begin('~/.vim/plugged')

" AutoComplete

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'	" auto complete, inspired ncm2 but written in VimL
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
if executable('ctags')
	" Plug 'prabirshrestha/asyncomplete-tags.vim'
	Plug 'ludovicchabant/vim-gutentags', { 'for': 'c,cpp,rust' }
endif
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'

" python3 -m pip install pynvim
Plug 'liuchengxu/vim-clap'

" Plug 'huawenyu/neogdb.vim'
Plug 'neomake/neomake'
Plug 'jceb/vim-orgmode'
Plug 'mattn/calendar-vim'

Plug 'tpope/vim-unimpaired'	" easier movements around, like [q, ]q (quickfick)
" Plug 'triglav/vim-visual-increment' " Ctrl-A/X for columns
" Plug 'vim-scripts/VisIncr'
" Vim 8: visual select and Ctrl-A
Plug 'Valloric/ListToggle'	" toggle quickfix and location list
Plug 'stefandtw/quickfix-reflector.vim'		" editable quickfix

Plug 'SirVer/ultisnips'		" snippet engine
" Plug 'honza/vim-snippets'	" snippet collection
" Auto generate incremetal tags
Plug 'jsfaint/gen_tags.vim'
Plug 'majutsushi/tagbar'	" show tags (func, vars) in window right
" Plug 'vim-scripts/TagHighlight'	" color typedefs as variables, needs
" :UpdateTypesFile
Plug 'octol/vim-cpp-enhanced-highlight'	" simpler works out-of-the box, but not as good as TagHighlight
										" INFO 180525: This line must be here, otherwise C functions won't be highlighted
" Plug 'jeaye/color_coded'	" semantic highlighter INFO 170818: doesn't work in nvim

" Plug 'chrisbra/NrrwRgn' " narrow region
" Plug 'kana/vim-altr'	" switch files easy

" ******************** files
" CtrlP look-a-like
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
" minimalistic file browser, insirated by netrw
" only list and open files, no rm/cp
Plug 'dietsche/vim-lastplace'		" Open file at last edit position
Plug 'bogado/file-line'				" open file.txt:123
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'vim-airline/vim-airline'
" Plug 'rbong/vim-crystalline'
" Plug 'mkitt/tabline.vim'
Plug 'gcmt/taboo.vim'				" Rename tabs
Plug 'skywind3000/vim-preview'		" preview ctags in vsplit

" ******************** basics
Plug 'ciaranm/securemodelines'
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'osyo-manga/vim-anzu'			" show search matches in statusline
									" (second from the right)
" Plug 'tmsvg/pear-tree'				" auto close quotes, brackets, ...
Plug 'tpope/vim-surround'			" replace quotes, brackets,...
Plug 'tpope/vim-repeat'             " repeat with . previous plugin
Plug 'vim-scripts/visualrepeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'            " better search and replace and abbrev :Subvert
Plug 'troydm/zoomwintab.vim'		" <C-w>o wil zoom/unzoom windows/split
Plug 'AndrewRadev/undoquit.vim'
Plug 'ntpeters/vim-better-whitespace'	" show red block when there is a trailing whitespace
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-tbone.git'
Plug 'elzr/vim-json'
Plug 'westeri/asl-vim'				" ACPI source language syntax


" Plug 'ervandew/supertab'


" Plug 'mileszs/ack.vim'		" wrapper around vimgrep or external grep
Plug 'jremmen/vim-ripgrep'	" fast external grep
Plug 'mhinz/vim-grepper'	" search buffers and populate quickfix
" search buffers and populate quickfix, lazy loading the plugin:
" Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'ronakg/quickr-preview.vim'	" preview files in quickfix without spoiling buffer list

Plug 'tomasr/molokai'		" color scheme
Plug 'altercation/vim-colors-solarized'
Plug 'tomasiser/vim-code-dark'		" VisualStudio inspired theme
Plug 'powerman/vim-plugin-AnsiEsc'	" Show shell ANSI colors as colors

" Plug 'idanarye/vim-vebugger'
" needed for vebugger
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}


Plug 'kshenoy/vim-signature'	" marks in sign column and with easier shortcuts
								" use fzf :Marks for search
Plug 'airblade/vim-gitgutter'	" git: show +-m in sign column, shortcuts [c ]c
Plug 'tpope/vim-fugitive'		" Git commands for Vim
Plug 'jreybert/vimagit'			" Git
Plug 'rhysd/git-messenger.vim'	" fancy git blame
Plug 'tpope/vim-tbone'			" Tmux under Vim (copy/paste)

" Vim session plugins
Plug 'tpope/vim-obsession'	" restore session, needed for tmux ressurect
Plug 'mhinz/vim-startify'	" Fancy Vim startup screen (shows MRU, session, ...)
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'		" Required for vim-session

" Plug 'godlygeek/tabular'	" Tabularize/align
Plug 'junegunn/vim-easy-align'
Plug 'rhysd/vim-clang-format'

" TODO 170813: check one day
" Plug 'timonv/vim-cargo'		" simple plugin, cmds: Cargo{Build, Run, Test, Bench}
Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'easymotion/vim-easymotion'	" leader leader and magic begins
" Plug 'justinmk/vim-sneak'       " lightweight easymotion
Plug 'myusuf3/numbers.vim'		" disable relative numbers in insert mode and non-active windows
" Plug 'hyiltiz/vim-plugins-profile'
" Plug 'matze/vim-move'
" Plug 'gilligan/vim-lldb'
" Plug 'LucHermitte/vim-refactor'
" Plug 'tpope/vim-markdown'
" Plug 'plasticboy/vim-markdown'
" Plug 'vim-scripts/tinymode.vim'
" Plug 'kien/rainbow_parentheses.vim'

Plug 'Carpetsmoker/auto_autoread.vim'
Plug 'wesQ3/vim-windowswap'		" Easier window swap: <leader>ww

Plug 'machakann/vim-highlightedyank'	" temporary highlight yanked text/selection
" Plug 'luochen1990/rainbow'             " colored brackets

" Plug 'arakashic/chromatica.nvim'
Plug 'Asheq/close-buffers.vim'
Plug 'chrisbra/vim-diff-enhanced'


" Initialize plugin system
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Plugin configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" put this after the theme plugin is installed, but before custom "highlight"
" overrides
colorscheme molokai
" autocomplete & LSP														{{{
" -----------------------------------------------------------------------------
" -----------------------------------------------------------------------------
" " 191116
" let g:LanguageClient_serverCommands = {
"     \ 'c': ['/usr/local/bin/clangd80'],
"     \ }

" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" Register ccls C++ lanuage server - vim-lsp wiki:
if executable('ccls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'ccls',
				\ 'cmd': {server_info->['ccls']},
				\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
				\ 'initialization_options': {},
				\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
				\ })

	" 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
endif

" Key bindings for vim-lsp.
nn <silent> <M-d> :LspDefinition<cr>
nn <silent> <M-r> :LspReferences<cr>
nn <f2> :LspRename<cr>
nn <silent> <M-a> :LspWorkspaceSymbol<cr>
nn <silent> <M-l> :LspDocumentSymbol<cr>

nnoremap <silent> <M-]> :LspDefinition<cr>
nnoremap <silent> <C-\\> :LspDeclaration<cr>

" " vim-lsp wiki:
" if executable('clangd')
" 	au User lsp_setup call lsp#register_server({
" 				\ 'name': 'clangd',
" 				\ 'cmd': {server_info->['clangd', '-background-index']},
" 				\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
" 				\ })
" endif

" " Key bindings for vim-lsp.
" nn <silent> <M-d> :LspDefinition<cr>
" nn <silent> <M-r> :LspReferences<cr>
" nn <f2> :LspRename<cr>
" nn <silent> <M-a> :LspWorkspaceSymbol<cr>
" nn <silent> <M-l> :LspDocumentSymbol<cr>


" if executable('clangd80')
" 	augroup lsp_clangd
" 		autocmd!
" 		autocmd User lsp_setup call lsp#register_server({
" 					\ 'name': 'clangd80',
" 					\ 'cmd': {server_info->['clangd80']},
" 					\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
" 					\ })
" 		autocmd FileType c      setlocal omnifunc=lsp#complete
" 		autocmd FileType cpp    setlocal omnifunc=lsp#complete
" 		autocmd FileType objc   setlocal omnifunc=lsp#complete
" 		autocmd FileType objcpp setlocal omnifunc=lsp#complete
" 	augroup end
" endif

" snippets
if has('python3')
	" let g:UltiSnipsExpandTrigger="<c-e>"
	let g:UltiSnipsExpandTrigger="<c-y>"
	call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
				\ 'name': 'ultisnips',
				\ 'whitelist': ['*'],
				\ 'completor': function('asyncomplete#sources#ultisnips#completor'),
				\ }))
endif

" ctags
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
" 			\ 'name': 'tags',
" 			\ 'whitelist': ['c'],
" 			\ 'completor': function('asyncomplete#sources#tags#completor'),
" 			\ 'config': {
" 			\    'max_file_size': 50000000,
" 			\  },
" 			\ }))

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')

" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

let g:lsp_preview_float = 1

" asyncomplete, recomendded by vim-lsp
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" restart autocomplete on backspace
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:lsp_diagnostics_enabled = 0	" disable diagnostics support
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode


highlight PopupWindow ctermbg=lightblue guibg=lightblue

au FileType fzf set nonumber norelativenumber

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
			\ 'name': 'file',
			\ 'whitelist': ['*'],
			\ 'priority': 10,
			\ 'completor': function('asyncomplete#sources#file#completor')
			\ }))

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
			\ 'name': 'buffer',
			\ 'whitelist': ['*'],
			\ 'blacklist': ['go'],
			\ 'completor': function('asyncomplete#sources#buffer#completor'),
			\ 'config': {
			\    'max_buffer_size': 5000000,
			\  },
			\ }))

" augroup lsp_float_colours
" 	autocmd!
" 	if !has('nvim')
" 		autocmd User lsp_float_opened
" 					\ call win_execute(lsp#ui#vim#output#getpreviewwinid(),
" 					\		'setlocal wincolor=PopupWindow')
" 	else
" 		autocmd User lsp_float_opened
" 					\ call nvim_win_set_option(lsp#ui#vim#output#getpreviewwinid(),
" 					\		'winhighlight', 'Normal:PopupWindow')
" 	endif
" augroup end
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Linter																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO 190422: It is not possible to configure how quickfix locations are
" displayed. It is only possible to specify how to interpret them with the
" errorformat option

if exists(':Neomake')
	" call neomake#configure#automake('nrwi', 500)
	" call neomake#configure#automake('w')
endif
" uses location list (:lnext/:prev/[l/]l)
" unimpared is unconfigurable and already uses [e ]e shortcuts

" open the list automatically:
" let g:neomake_open_list = 2

nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>
nnoremap [E :lfirst<cr>
nnoremap ]E :llast<cr>
nnoremap [w :lprev<cr>
nnoremap ]w :lnext<cr>

highlight LinterErrorSign   ctermfg=red    ctermbg=black
highlight LinterWarningSign ctermfg=yellow ctermbg=black
highlight LinterMessageSign ctermfg=white  ctermbg=black
let g:neomake_error_sign =   {'text': '->', 'texthl': 'LinterErrorSign'}
let g:neomake_warning_sign = {'text': '->', 'texthl': 'LinterWarningSign', }
let g:neomake_message_sign = {'text': '->', 'texthl': 'LinterMessageSign', }

" let g:neomake_c_enabled_makers=['gcc']
" let g:neomake_gcc_args=[
"     \ '-fsyntax-only',
"     \ '-std=gnu11',
"     \ '-Wall',
"     \ '-Wextra',
"     \ '-fopenmp',
"     \ '-I.'
"     \ ]
let g:neomake_c_clangcheck_exe='clang-check60'
nnoremap <F5> :Neomake! make<cr>
nnoremap <F6> :Neomake<cr>
nnoremap <A-r> :Neomake<cr>
nnoremap <leader>rr :Neomake<cr>

" let g:neomake_c_lint_maker = {
" 	\ 'exe': 'lint',
" 	\ 'args': ['--option', 'x'],
" 	\ 'errorformat': '%f:%l:%c: %m',
" 	\ }

" let g:neomake_c_enabled_makers=['gcc']
let g:neomake_c_enabled_makers=['gcc']
let g:neomake_make_maker = {
	\ 'exe': 'gmake',
	\ 'args': ['elf'],
	\ 'errorformat': '%f:%l:%c: %m',
	\ }
	 " 'errorformat': '%f:%l:%c: %m',
" " Use the maker like this:
" " :Neomake! make

let g:neomake_c_armgcc_maker={
			\  'exe': 'arm-none-eabi-gcc',
			\ 'args': ['-mcpu=cortex-m3', '-O0', '-g3', '-nostdlib', '-mfloat-abi=soft', '-Wall', '-Wextra', '-DSTM32F10X_MD', '-DSTM32F1', '-I.', '-Isrc/lib', '-Isrc/lib/inc', '-Isrc', '-ffreestanding', '-mthumb', '-c', ],
			\ 'errorformat': '%f:%l:%c: %m', }
set makeprg='gmake'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Rust																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't expand tab (and other things)
let g:rust_recommended_style = 0
let g:ftplugin_rust_source_path = $HOME.'~/src/rust-src/rust'

" 180805 RustFmt:
" TODO 180805
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Airline																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1
" show buffers in their own part of airline
let g:airline#extensions#tabline#show_buffers = 1

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

" show buffers number (for me it is confusing)
" let g:airline#extensions#tabline#buffer_nr_show = 1

" Obsession symbol (when Session.vim is tracked)
let g:airline#extensions#obsession#indicator_text = 'Ses' " default: '$'

" let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l:%3v%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# '

" don't show git branch nor hunks
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0


" function! StatusLine(current, width)
"   return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
"         \ . ' %f%h%w%m%r '
"         \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
"         \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
"         \ . (a:width > 80 ? ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P ' : ' ')
" endfunction

" function! TabLine()
"   let l:vimlabel = has("nvim") ?  " NVIM " : " VIM "
"   return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
" endfunction

" let g:crystalline_statusline_fn = 'StatusLine'
" let g:crystalline_tabline_fn = 'TabLine'
" let g:crystalline_theme = 'default'

" set showtabline=2
" set laststatus=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" snippets																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
" let g:UltiSnipsExpandTrigger        = '<C-u>'   " expand snippet
" 180218 NCM:
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger="<tab>"		" jumps to ${1}, ${2}, ...
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"	" jumps to ${2}, ${1}, ...

let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsEnableSnipMate       = 0 " no need to look for SnipMate snippets

" author variable used in licence snippets, remove NULL (^@) char:
let g:snips_author=substitute(strtrans(system('git config user.name')), '\^@','','g')
let g:snips_mail=substitute(strtrans(system('git config user.email')), '\^@','','g')

let g:UltiSnipsEditSplit="vertical"
call SetupCommandAlias("snipe", "UltiSnipsEdit")

" don't search for directory, use only tihs:
" let g:UltiSnipsSnippetDirectories=$HOME.'/.vim/UltiSnips'
" set runtimepath+=~/.vim/my-snippets/	" radi, ali unutar tog foldera mora bit subfolder "snippets" ili "UltiSnips""
" let g:UltiSnipsSnippetsDir = "~/.vim/my-snippets/UltiSnips"	" CP s neta, njima radi, meni ne
"
" Where user snippets can be found (cannot be named "snippets")
set runtimepath+=~/.vim/snippets
" for :UltiSnipsEdit command
let g:UltiSnipsSnippetsDir = "~/.vim/snippets/UltiSnips"
" Where snippets can be found, subfolder in "runtimepath" above
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Commenter                                                                  {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for tpope commenter, muscle memory from NERDcommenter
" INFO 170812: Yes, nmap, not nnoremap
nmap <leader>c<space>   <Plug>CommentaryLine
vmap <leader>c<space>   <Plug>Commentary
nmap <leader>cc         <Plug>CommentaryLine
vmap <leader>cc         <Plug>Commentary
nmap <leader>cy       yy<Plug>CommentaryLine
vmap <leader>cy      ygv<Plug>Commentary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" fuzzy open                                                                 {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :Files, :Commits, :Windows, :Tags, :BTags
nnoremap <leader>o :Files<CR>
nnoremap <leader>m :FZFMru<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :Windows<CR>
nnoremap to :tabnew<cr>:Files<CR>
nnoremap tO :-tabnew<cr>:Files<CR>
nnoremap tm :tabnew<cr>:FZFMru<CR>
nnoremap tM :-tabnew<cr>:FZFMru<CR>
nnoremap tb :tabnew<cr>:Buffers<cr>
nnoremap tB :-tabnew<cr>:Buffers<cr>
nnoremap tt :tabnew<cr>:Tags<cr>
nnoremap tT :-tabnew<cr>:Tags<cr>
nnoremap ; :Buffers<CR>

imap <c-x><c-l> <plug>(fzf-complete-line)

function! s:build_quickfix_list(lines)
	" - <tab> to select multiple files
	" - call this function to fill QF with that files
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

let g:fzf_action = {
			\ 'ctrl-q': function('s:build_quickfix_list'),
			\ 'ctrl-y': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~40%' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" [[B]Commits] Customize the options used by 'git log':
" let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" 171205 close FZF windows with <esc> (insted of <C-W>c)
" TODO 181105: Check this under Windows
if has('nvim')
	aug fzf_setup
		autocmd!
		autocmd TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
		autocmd FileType fzf set nonumber norelativenumber
	aug END
end

" 191124 use floating window for FZF
let $FZF_DEFAULT_OPTS='--layout=reverse'	" show hints at top of the screen not bottom
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
	let buf = nvim_create_buf(v:false, v:true)
	call setbufvar(buf, '&signcolumn', 'no')

	let height = &lines - 8
	let width = float2nr(&columns - (&columns * 2 / 10))
	let col = float2nr((&columns - width) / 2)

	let opts = {
				\ 'relative': 'editor',
				\ 'row': 4,
				\ 'col': col,
				\ 'width': width,
				\ 'height': height
				\ }

	call nvim_open_win(buf, v:true, opts)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" vim orgmode																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" calendar																	{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change Month & Day names
let g:calendar_mruler = '1 Jan,2 Feb,3 Mar,4 Apr,5 May,6 Jun,7 Jul,8 Aug,9 Sep,10 Oct,11 Nov,12 Dec'
" let g:calendar_wruler = '7Su 1Mo 2Tu 3We 4Th 5Fr 6Sa'
let g:calendar_monday = 2	" Monday (2nd entry in calendar_wruler) is the first day
let g:calendar_weeknm = 1 " show week number in format: WK01
augroup calendar
	autocmd!
	autocmd FileType calendar set nonumber norelativenumber
	" autocmd FileType calendar :vertical resize 50
	autocmd BufWinEnter calendar set winwidth=50 " TODO 190514
augroup END
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" File managers                                                              {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>f :NERDTreeToggle<cr>
nnoremap <leader>F :NERDTreeFind<cr>
" TODO 180218: <leader>F 

nnoremap <C-w>f :NERDTreeFocus<cr>
nnoremap <C-w>F :NERDTreeClose<cr>
" TODO <space> to expand folder
let g:NERDTreeMapActivateNode = "<space>"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" git plugins																{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GitGutter
" - shows +-m in sign column
" - shortcuts: [c ]c

let g:gitgutter_sign_added            = '+'
let g:gitgutter_sign_modified         = '~'
let g:gitgutter_sign_removed          = '-'
let g:gitgutter_sign_modified_removed = '-~'
highlight GitGutterAdd				ctermbg=234 ctermfg=10 guifg=green
highlight GitGutterDelete			ctermbg=234 ctermfg=9  guifg=red
highlight GitGutterChange			ctermbg=234 ctermfg=3  guifg=yellow
highlight link GitGutterChangeDelete GitGutterChange

let g:gitgutter_max_signs=5000	" default was 500

" TODO 170813: goto first line of the preview window
nmap <Leader>gv <Plug>(GitGutterPreviewHunk) :wincmd P<CR> :1<CR>
nmap <Leader>ga <Plug>(GitGutterStageHunk)
nmap <Leader>gr <Plug>(GitGutterUndoHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

call SetupCommandAlias("gitt","GitGutterToggle")
call SetupCommandAlias("Gcc","Gcommit")
call SetupCommandAlias("Gcm","Gcommit -m")
call SetupCommandAlias("Gca","Gcommit --amend")
call SetupCommandAlias("Gce","Gcommit --amend --no-edit")

" let g:gitgutter_realtime = 0
" let g:gitgutter_eager = 0

" Fugitive - use 'q' to exit Gdiff:
if (bufname('%') == '^fugitive:')
	nnoremap <buffer> q :wincmd c<cr>
endif

" 190112 newer Gstatus:
" call SetupCommandAlias("G","botright Gstatus")
call SetupCommandAlias("Gstatus","botright Gstatus")
" call SetupCommandAlias("Gstatus","botright Gstatus<cr> | :resize -10")

nnoremap <leader>gg :GitMessenger<cr>
let g:git_messenger_always_into_popup = 1	" jump into popup

let g:magit_discard_hunk_mapping="X"   " discard hunk
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" searching																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 180217 Grepper
let g:grepper = {}            " initialize g:grepper with empty dictionary
runtime plugin/grepper.vim    " initialize g:grepper with default values
let g:grepper.highlight = 1
" let g:grepper.rg.grepprg .= ' --smart-case'

" - -query must be the last flag

if has('win32')
	" 180218: This doesn't work under my Win10 VM for some reason
	nnoremap <leader>a :Rg <C-r><C-w><CR>
else
	nnoremap <leader>a :Grepper -tool rg -query <C-r><C-w><CR>
endif
nnoremap <leader>A :Grepper<cr>
nnoremap <leader>s :Grepper -tool rg -buffers -query <C-r><c-w><cr>
nnoremap <leader>S :Grepper -tool rg -buffers <cr>

call SetupCommandAlias("Gbuf",  "Grepper -tool rg -buffer -query")
call SetupCommandAlias("Gbufs", "Grepper -tool rg -buffers -query")
call SetupCommandAlias("G",     "Grepper -tool rg -query")
" call SetupCommandAlias("Gadd",  "Grepper -tool rg -append -query") " XXX 180218
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" toggle quickfix and location list											{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" easymotion																{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" easymotion original {{{
" press <leader><leader>X where X is char for modes (it can be f,w,...)
" <Leader>f{char} to move to {char}
map  <leader><leader>f <Plug>(easymotion-bd-f)
nmap <leader><leader>f <Plug>(easymotion-overwin-f)
" search for one char:
map  <leader><leader>c <Plug>(easymotion-bd-f)
nmap <leader><leader>c <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
" nmap C <Plug>(easymotion-overwin-f2)

" Move to line
map  <leader><leader>l <Plug>(easymotion-bd-jk)
nmap <leader><leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
" }}}

" 180218 vim-sneak
" label-mode for a minimalist alternative to EasyMotion:
" let g:sneak#label = 1
" nmap \\ <Plug>SneakLabel_s
" INFO 180218: complicated to me, not working as expected, remaps <tab> and s
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" narrow region                                                              {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" select and :NR or <leader>nr
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}


" ctags																		{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO will auto create tags, auto update on save (incremental update)
" it will generate a new tag file if there is none (but it needs time, it will report "no tags file found")
let g:gutentags_ctags_executable = g:ctags_exe
nnoremap <C-]> g<C-]>
" buffer
call SetupCommandAlias("tagsu","GutentagsUpdate")
call SetupCommandAlias("tagu","GutentagsUpdate")
" project
call SetupCommandAlias("tagsu!","GutentagsUpdate!")
call SetupCommandAlias("tagu!","GutentagsUpdate!")

" 190512
" Press tag into vsplit windows, press again to jump to another tag in another file
" C-w z to close it
nnoremap <silent> <C-\> :PreviewTag<cr>
" nnoremap <silent> <M-e> :PreviewScroll +1<cr>
" nnoremap <silent> <M-y> :PreviewScroll -1<cr>
" :PreviewSignature
" noremap <C-\|>:PreviewSignature!<cr>

" uctags -R --sort=foldcase --c++-kinds=+p --fields=+ianS --extras=+q -f ~/.vim/tags/libc.tags /usr/include
set tags+=~/.vim/tags/libc.tags

" TODO 190512:
" When you are using Language Servers with LanguageClient-neovim, You can use PreviewFile to preview definition instead of jump to it:
" call LanguageClient#textDocument_definition({'gotoCmd':'PreviewFile'})

" INFO 190512 gen_tags + gtags/global
" FreeBSD: pkg install global
" :GenGTAGS  :ClearGTAGS!
let g:gen_tags#gtags_opts = '-c --verbose'

let g:gen_tags#use_cache_dir = 0	" don't use ~/.cache/tags_dir/<project>
" git  `<project folder>/.git/tags_dir`
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
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
let g:tagbar_show_linenumbers = 0   " 2 - show relative
"let g:tagbar_singleclick = 1
let g:tagbar_iconchars = ['►', '▼']		" changed first symbol because powerline font
let g:tagbar_previewwin_pos = "aboveleft"
let g:tagbar_autopreview = 0

nnoremap <leader>t :TagbarToggle<CR>
" let g:tagbar_type_rust = {
"             \ 'ctagstype' : 'rust',
"             \ 'kinds' : [
"             \'T:types,type definitions',
"             \'f:functions,function definitions',
"             \'g:enum,enumeration names',
"             \'s:structure names',
"             \'m:modules,module names',
"             \'c:consts,static constants',
"             \'t:traits',
"             \'i:impls,trait implementations',
"             \]
"             \}
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

" " Highlight local variables
" let g:TagHighlightSettings={'IncludeLocals':'True'}
" function CustomTagHighlight()
" 	hi LocalVariable guifg=#ff00ff
" 	hi GlobalVariable guifg=#ff00ff
" endfunction
" autocmd Syntax c,cpp call CustomTagHighlight()

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
nnoremap <C-w>c :call undoquit#SaveWindowQuitHistory()<cr><C-w>c
" go to left tab after closing
" TODO 171210: skip going to left tab if we are closing the last tab
" nnoremap <C-w>c :call undoquit#SaveWindowQuitHistory()<cr><C-w>c:tabprev<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"		taboo																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rename current tab
set sessionoptions+=tabpages,globals	" nedded for taboo plugin (used to rename tabs)
let g:airline#extensions#taboo#enabled = 1	" enable
let g:taboo_tabline = 0						" leave drawing tabline to Airline
" modified tab will show "%#TabModifiedSelected#*%#TabLineSel#"
" FIX: manually merge:
" https://github.com/gcmt/taboo.vim/pull/25
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

" INFO usage:
" :Obsession <custom filename>		save session
" :Obsession . (or custom dir)		save session to Session.vim
" :Obsession!						delete file and stop saving/tracking
" :load <session file>				load
" vim -S <session file>				load

call SetupCommandAlias("sess", ":Obsession .")
call SetupCommandAlias("css", ":Obsession .")	" muscle memory


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

let g:session_autosave = 'no'	" Don't ask when exiting Vim
let g:session_autosave_periodic = '1'	" Auto save every N minutes

let g:session_command_aliases = 1	" :SomethingSession is :SessionSomething
call SetupCommandAlias("ss", ":SaveSession")
call SetupCommandAlias("sl", ":OpenSession")	" 'ls' is used
call SetupCommandAlias("os", ":OpenSession")
" TODO 170926: Autosave sessions but only if session is loaded/named (don't save session which are not saved by :SaveSession)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" vim-startify						{{{
" ----------------------------------------------------------------------------
" Fancy Vim startup screen (shows MRU, session, ...)
" n/k/l - goto next file/list item

" disable mappings:
augroup plugin-startify
	autocmd User Startified for key in ['b','s','t','v','n'] |
				\ execute 'nunmap <buffer>' key | endfor
augroup END

let g:startify_session_dir = '~/.vim/session'
let g:startify_commands = [
	\ {'m': ['FZF MRU', 'FZFMru']},
	\ {'f': ['FZF Files', 'Files']},
	\ {'o': ['FZF Files', 'Files']},
	\ {'v': ['vimrc', 'e $MYVIMRC']},
	\ {'z': ['zshrc', 'e ~/.zshrc']},
	\ ]

" :SSave[!] [session]
" :SDelete[!] [session]
" :SLoad[!] [session]
" :SClose
" ------------------------------------------------------------------------ }}}
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" quickfix preview                                                           {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" preview the result in detail without spoiling the buffer list.
" Everything is automatically clened up once quickfix window is closed.

let g:quickr_preview_keymaps = 0

augroup plugin_qf_preview
	autocmd!
	" XXX 190515: 'p' and Ctrl-Enter won't work
	autocmd FileType qf nmap <buffer> <leader>p <plug>(quickr_preview)
	autocmd FileType qf nmap <buffer> <C-p> <plug>(quickr_preview)
	autocmd FileType qf nmap <buffer> <C-]> <plug>(quickr_preview)
	autocmd FileType qf let g:quickr_preview_on_cursor = 0		" 1 = auto enable, only for QF, not location list
augroup END

let g:quickr_preview_exit_on_enter = 1	" 1 = auto-close on enter XXX 190515
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" autopairs {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin to autoclose branckets ()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" unimpared                                                                  {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin with usefull shortcuts

" options:
" [oX to disable something
" ]oX to enable something
" \oX to toggle something:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" tmux - tbone.vim															{{{
" -----------------------------------------------------------------------------
"  cmds: :Tmux Tyank Tput Twrite Tattach
" TODO 181222: remove newline before yanking
" mnemonic: yank for tmux
vnoremap <leader>yt :Tyank<cr>:echo "copied to tmux paste buffer"<cr>
nnoremap <leader>yt :Tyank<cr>:echo "copied to tmux paste buffer"<cr>
" ------------------------------------------------------------------------- }}}

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

command! FixWhiteSpace StripWhitespace	" function from 'better white space' plugin
call SetupCommandAlias("fws", "StripWhitespace")	" function from 'better white space' plugin
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
" match exact (not backwards) - don't remove <>:
nnoremap # *N:ShowSearchIndex<cr>

" centered search:
nnoremap n nzz
nnoremap N Nzz
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		bufkill																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO used for :BD
" don't create various <leader>b* mapping (which will slowdown <leader>b for CtrlPBuffer)
let g:BufKillCreateMappings = 0
" let g:BufKillOverrideCtrlCaret = 1
" To move backwards/forwards through recently accessed buffers, use: :BB/:BF
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
"		EasyAlign															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		window swap															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigate to the window you'd like to move
" Press <leader>ww
" Navigate to the window you'd like to swap with
" Press <leader>ww again
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" highlighted yank {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" temporary highlight the text which is yanked
let g:highlightedyank_highlight_duration = 1000 " [ms]
highlight HighlightedyankRegion gui=reverse ctermbg=130 ctermfg=15
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" semantic highlighter														{{{
let g:chromatica#libclang_path='/usr/local/llvm60/lib'
let g:chromatica#enable_at_startup=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" diff enhanced																{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Patience diff algorithm
" :PatienceDiff - Use the Patience Diff algorithm for the next diff mode
" :EnhancedDiff <algorithm> - Use <algorithm> to generate the diff.

" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
	let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Easier way to jump to alternate file
" nnoremap <BS> <C-^>

" editing binary files (XXX 190824 only for vim which includes xxd binary)
" https://vi.stackexchange.com/questions/343/how-to-edit-binary-files-with-vim
nmap <leader>hr :set binary<CR> :%!xxd<CR> :set filetype=xxd<CR>
nmap <leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR> :set fileencoding=<CR> :w<CR> :set nobinary<CR>

" 					colors and TERM setup									{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight Normal		ctermbg=233	" XXX change in theme file
" ~/.vim/plugged/molokai/colors/molokai.vim
highlight Normal guibg=#121212

highlight Todo			ctermfg=196 ctermbg=232 guifg=#ff0000 guibg=#080808
highlight Debug			ctermfg=226 ctermbg=234 guifg=#ffff00 guibg=#1c1c1c

highlight Search		ctermfg=0   ctermbg=222 guifg=#000000 guibg=#ffd787
highlight Folded		ctermbg=234 ctermfg=69  guibg=#1c1c1c guifg=#5f87ff
highlight CursorLine	ctermbg=235             guibg=#262626

highlight TermCursor	ctermfg=red             guifg=red

" invisible chars (:set line)
highlight NonText		ctermfg=239             guifg=#4e4e4e

" XXX XXX XXX only work in first buffer
" Highlight TODO, FIXME, NOTE, etc. FIXME:
if has("autocmd")
	if v:version > 701
		autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|ZAJEB\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(INFO_START\|INFO_END\|ERROR\|DEBUG_START\|DEBUG_END\|DEBUG_INFO\)')
	endif
endif

" colors for ColorColumn (bar/area on the right after 80 or so chars)
" must be global (otherwise function ToggleColorColumn won't see it)
let g:color_ColorColumn = 234 "
let g:color_ColorColumnGUI = "#1c1c1c"
highlight clear ColorColumn		" disable on default

" let &colorcolumn=join(range(81,999),",")        " highlight all afer 80 chars
" let &colorcolumn="80,".join(range(120,999),",") " double highlight, 80 and 120 chars:
" match ErrorMsg '\%>80v.\+'	" highlight only chars after 'tw' as error message

highlight VertSplit		ctermfg=202 ctermbg=232 guifg=#ff5f00

" change color of tab chars (:set list)
highlight SpecialKey	ctermfg=236

" change concel to match background
highlight Conceal		ctermfg=7 ctermbg=233

" longer vertical bar for vertical splits, space for folds (default was -)
set fillchars=fold:\ ,vert:\│

" change the colors in diff mode, similiar to git diff
" highlight DiffAdded		ctermfg=87	guifg=cyan
" highlight DiffRemoved	ctermfg=196	guifg=red
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" auto completion menu
highlight pmenu				ctermbg=237 ctermfg=254

" hide ANSCI escape chars
syntax match Ignore /\%o33\[[0-9]\{0,5}m/ conceal

" ugly but easier to read
highlight Comment		ctermfg=101
" highlight Comment		ctermfg=114 guifg=#80a0ff

" highlight ExtraWhitespace	ctermbg=162
highlight ExtraWhitespace ctermbg=202 guibg=Red

" highlight Error			ctermfg=15 ctermbg=9 guifg=White guibg=Red
" highlight WarningMsg	ctermfg=210 guifg=Red

" sign column (git +-m, marks, linter signs)
highlight SignColumn			ctermfg=118 ctermbg=0 guifg=#A6E22E guibg=#232526

" brighter, easier to read line numbers (column left)
" INFO line column is the same for numbers, git marks, vim marks, linter,...
highlight LineNr				ctermfg=253	guifg=white
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				GUI settings												{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
	" Windows and Unix gVim:
	" set encoding=utf-8
	set winaltkeys=no		" Turn off <Alt>/<Meta> pulling down GUI menu
	" set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powe:h10

	set listchars=tab:│·,extends:>,precedes:<
	set showbreak=…		" char to be displayed on the beggining of broken line

	set guioptions -=T		" toolbar
	set guioptions -=r		" right scrollbar
	set guioptions -=L		" left scrollbar
	set guioptions -=m		" menubar
	set guioptions +=a		" auto-copy selected text"

	set hlsearch
	set backspace=2		"indent,eol,start, needed for Windows gVim
	let g:airline_powerline_fonts = 1

	set mousefocus

	" disable bell
	autocmd GUIEnter * set vb t_vb=

	" gVim by default has italic char for tab, make it non italic:
	" highlight SpecialKey		term=bold ctermfg=236 gui=italic guifg=#465457
	highlight SpecialKey		term=bold ctermfg=236 gui=none guifg=#465457

	"Invisible character colors
	highlight NonText guifg=#2a4a59
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" " work specific stuff														{{{
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable("$HOME\posao.vim")
	echo "subvimrc2 has been found"
elseif filereadable("$HOME\AppData\Local\nvim\posao.vim")
	echo "subvimrc has been found"
endif

if substitute(system('is_work_pc'), '\n','','g') == "1"
	let s:work_pc = 1
else
	let s:work_pc = 0
endif

if (s:work_pc == 1)
	" you can't use variables on the rhs in the .vimrc.
	set tabstop=3		" tab size
	set shiftwidth=3 	" when indenting with '>'
	set expandtab		" convert tab to spaces
	set softtabstop=3	" smart <BS> - delete 4 chars"
	set textwidth=120
	set diffopt+=iwhite	" ignore whitespace changes and also newlines (^M)
	autocmd FileType c setlocal commentstring=/*%s*/
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" :pc	close preview window
" C delete to the end of the line and go to insert mode


" ga: show char under the cursor in decimal, hex, and oct, for unicode: tpope/vim-characterize XXX works without plugin
" gCtrl-] If there is only one match, it will take you there. If there are multiple matches, it will list them all, letting you choose the one you want, just like :tselect

" goto preview window Ctrl-W Ctrl-P

" delete lines that do NOT match pattern: :v/pattern/d
" change direction of select in visual mode: 'o'
" :mkview :loadview to save folds

set viewoptions-=options	" for mkview, don't store current file
set viewdir=~/.vim/view

" IDEA smarter jumping (tag/file/...)
set isfname+=:	" to recognize :123 as filename (for jumping to specific line)
set isfname+=32	" <space> is part of filename
" ~/.vimrc:123
" /tmp/new file.txt
" file under cursor (like gf uses): echo expand("<cfile>")
" for tag search (like * uses): echo expand('<cword'>)
" if not tag, check if declaration: gd, then gD
" check if www link
" execute("e ".mycurf) opens the file saved in mycurf
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
"##########################################################################}}}
" vimL misc							{{{
" number of tabs: tabpagenr('$')
" let l:buffers = range(1, bufnr('$'))
" let l:currentTab = tabpagenr()
" current buffer number: bufnr('$')
" current buffer number: bufnr('%')
" get line under the cursors: getline('.')
"									}}}

" TODO :h pattern-atoms
" Vim debug:
" vim -V9myVimLog

" INFO maybe will be useful some day: "&& bufname("%") != "[Command Line]"
" INFO highlight ALL whitespace (and tabs): /\s
" INFO highlight all whitespace at the beggining: /^<space>

" export MYVIMRC="~/vim_ide"		" change .vim position
" vim -U ~/vim_ide/vimrc

" Unicode characters can be inserted by typing ctrl-vu followed by the 4 digit hexadecimal code.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" TODO 16xxxx <enter> - if it's link under cursor then "gx", if it's tag under cursor then :tag... othervise "o"
" TODO 170717: tmux <C-j>p -> enter/exit paste mode before/after that command
" INFO: remmaping Esc will fuckup scroll (scrolling will start to insert chars)
"
" INFO 170901: Ako se razjebe ista sta koristi python (npr ncm na Windowsima): pip install --upgrade neovim
" TODO 170921: <leader>r -> references to function
" INFO 170926: vim slowiness
" syntax off, relative number off, cursorline off -> speedup
" autocommand spam: :autocmd CursorMoved
" :syntime on, move around in your ruby file and then, :syntime report

nnoremap <Leader>h :call HeaderToggle()<CR>

let g:startify_fortune_use_unicode = 1
" Sort sessions by modification time rather than alphabetically.
let g:startify_session_sort = 0

cmap w!! w !sudo tee %

" 180106 - useful when reading man pages
nnoremap <Home> gg
nnoremap <End> G

" TODO 181026:check this (on Windows specially)
" g:session_directory = '~/.vim/sessions' "" or ~\vimfiles\sessions (on Windows).
" TODO 181128: chane all lines with multiple " to ------
" TODO 190514: quit QF windows before calling :Files or :FZFMru (otherwise
" that file will be open in (miniature) QF window split)
" TODO 190515: disable <C-w>v/s/d commands in location list

" 190119 nvim-yarp debugging
" Log files will be generated with prefix /tmp/nvim_log
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
" fold {{{
" -----------------------------------------------------------------------------
" ------------------------------------------------------------------------- }}}

" autocmd User VimagitEnterCommit setlocal textwidth=72
" autocmd User VimagitLeaveCommit setlocal textwidth=0
