" 170812
" 1.0 - created 160729, again
" 0.1 - 160512 - vim as IDE at work
" 0.0 - 2006. probably
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker et :

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
set cursorline		" color the line when the cursor is
set matchpairs+=<:>	" Include angle brackets in matching.
set showmatch
set shortmess+=c    " don't give ins-completion-menu messages

set encoding=utf-8	" otherwise gVim will complain about listchars and showbreak
"		<tab> and wrapping			{{{
"""""""""""""""""""""""""""""""""""""""
if (s:work_pc == 1)
    " let s:tab_size = 3
    " you can't use variables on the rhs in the .vimrc.
    " execute "set tabstop=".tab_size
    set tabstop=3		" tab size
    set shiftwidth=3 	" when indenting with '>'
    set expandtab		" convert tab to spaces
    set softtabstop=3	" smart <BS> - delete 4 chars"
    set textwidth=120
    set diffopt+=iwhite " ignore whitespace changes and also newlines (^M)
else
    set tabstop=4		" tab size
    set shiftwidth=4 	" when indenting with '>'
    " 180114: I surrender, spaces as tab:
    set expandtab		" convert tab to spaces
    set softtabstop=4	" smart <BS> - delete 4 chars"
endif

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

" backupdir (file.txt~), directory (file.txt.swp)
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set nobackup noswapfile
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

set diffopt+=vertical   " vertical split
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		OS specific															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('unix')
	let s:uname = substitute(system("uname"), '\n', '', '')

	if s:uname == "FreeBSD"
		let g:clang_library_path='/usr/local/llvm50/lib'

		" Universal Ctags - Exuberant Ctags fork
		let g:ctags_exe='/usr/local/bin/uctags'

		" let g:tagbar_ctags_bin=substitute(system("which exctags"), '\n', '','')
		let g:tagbar_ctags_bin=g:ctags_exe

	elseif s:uname == "Linux"
	endif " uname
elseif has('windows')
    " INFO 17xxxx: nvim clipboard: Install win32yank.exe and put in $PATH. That's it
    " place where Python (x64, as vim.exe) is installed
    let $PATH.=';C:\bin'
    let $PATH.=';C:\python35_x64'   " posao
    let $PATH.=';C:\python36'       " Win10 VM
    let g:ctags_exe='c:\bin\ctags.exe'
    let g:python3_host_prog='python.exe'
    if substitute(system('is_sverige'), '\n','','g') == "1"
        let g:python3_host_prog='C:\python35_x64\python.exe'
    endif

    let g:session_autosave = 'no'
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
        setlocal makeprg=cargo\ build\ $*
        make
        " TODO 180805: check if Makefile exists then just call make instead of cargo
        " places to check: . src/ src/rust
	else
		echoerr "Don't know how to build :["
	endif
endfunction

nnoremap <F5> :call Compile()<cr>
nnoremap <leader>rr :call Compile()<cr>
inoremap <F5> :call Compile()<cr>
inoremap <leader>rr :call Compile()<cr>
if has('nvim')
    inoremap <A-r> <C-o>:call Compile()<cr>
    nnoremap <A-r> :call Compile()<cr>
endif

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
	autocmd FileType qf nnoremap <buffer> q :q<cr> :pclose<cr>

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

	" autocmd BufWinEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	" autocmd BufEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	" autocmd BufEnter * if @% == "[Command Line]" | echo "QQQQQQ" | endif
	" autocmd VimEnter * if @% == "[Command Line]" | echo "QQQQQQ" | else | "AAAAAA" | endif

	autocmd Filetype xdefaults set commentstring=!%s
	autocmd FileType pf,dnsmasq,fstab,cfg setlocal commentstring=#\ %s

	" Warn if file in current buffer is changed outside of Vim
	" - default: just warning when trying to write to the file
	autocmd BufEnter,FocusGained * checktime %

    autocmd BufRead,BufNewFile SConstruct,SConscript set filetype=python

    autocmd Filetype verilog call SetupVerilogEnvironment()

    " close preview windows if it is last
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

" setup when in diff mode:
if &diff
	" TODO 170831: check if is working in nvim-qt on Windows
	" INFO 170901: This is not working on Windows, check on Unix
	" cabbrev <buffer> q qa!
	" nnoremap <buffer> q :qa!<cr>
	" when fixing merge conflict:
	map <leader>1 :diffget LOCAL<CR>
	map <leader>2 :diffget BASE<CR>
	map <leader>3 :diffget REMOTE<CR>

    call SetupCommandAlias("dg",  "diffget")
    call SetupCommandAlias("dp",  "diffput")
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
call SetupCommandAlias("Bd", "bd")
" cabbrev QA1 qa!
" cabbrev Qa! qa!
" cabbrev qA qa
" cabbrev qa1 qa!

command! WE write | edit
cabbrev we WE
cabbrev We WE

command! PU PlugUpdate | PlugUpgrade
command! PI so $MYVIMRC | PlugInstall

" open help in vertical split right
cabbrev h vert leftabove help
call SetupCommandAlias("h", "vert leftabove help")
" TODO 171214: resize help window split: vertical resize 84
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
" call SetupCommandAlias("zca", "zi")
" call SetupCommandAlias("zoa", "zi")
" close all other folds

" Don't show ^M in DOS files
command! FixDos edit ++ff=dos

" XXX CtrlSpace won't restore tabs with only one tab (only at PC on the work, on my everything works™)
" cabbrev css CtrlSpaceSaveWorkspace
" cabbrev csl CtrlSpaceLoadWorkspace
cabbrev css :mksession!
cabbrev csl :source Session.vim

cabbrev ccc call ToggleColorColumn()
call SetupCommandAlias("qc", "ccl") " quickfix close (alignmend with :pc[lose])
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

" INFO 180114: xbindkeys will transform <C-i> to <F14>,
" only in insert mode, muscle memory. Doesn't work in 100% of cases
inoremap <F14> <Tab>

nnoremap <F4> :set paste!<cr>
" don't 'insert char above cursor, it's confusing'
" inoremap <C-y> <nop> " XXX 180115: will break snippets and NCM
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
" AltGr + [/] - depends on (xmodmap) keyboard layout
nnoremap š :tabprev<cr>
nnoremap đ :tabnext<cr>

nnoremap tj :bnext<cr>
nnoremap tk :bprev<cr>
nnoremap [b :bnext<cr>
nnoremap ]b :bprev<cr>

" delete buffer without closing tab or split
" nnoremap :BD :bd<cr>
" nnoremap :BD :setl bufhidden=delete <bar> bnext
" nnoremap :bd :setl bufhidden=delete <bar> bnext
" INFO '<bar>' is used instead of '|' pipe char
nnoremap <leader>d :setl bufhidden=delete <bar> bnext<cr>
nnoremap <leader>D :bd<cr>
nnoremap <A-w> :BD<cr>
call SetupCommandAlias("Bd", "bd")
inoremap <A-w> <C-o>:BD<cr>

nnoremap <Tab> :wincmd p<cr>
nnoremap <S-Tab> :wincmd w<cr>
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
" INFO 180114 <C-[> is rempapped to <F16> with xbindkeys
nnoremap <F16> :pop<cr>:echo "Taglist jump -1"<cr>

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
nnoremap yD D
nnoremap dw "_dw
nnoremap diw "_diw
" yank and delete
nnoremap dy yydd
nnoremap yd yydd

" selected copied text:
nnoremap gp `[v`]

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
nnoremap <leader>p1 "qp :echo "paste from the register 1(q)"<cr>
nnoremap <leader>p2 "wp :echo "paste from the register 2(w)"<cr>
nnoremap <leader>p3 "ep :echo "paste from the register 3(e)"<cr>
nnoremap <leader>p4 "rp :echo "paste from the register 4(r)"<cr>
nnoremap <leader>p5 "tp :echo "paste from the register 5(t)"<cr>
nnoremap <leader>p6 "yp :echo "paste from the register 6()"<cr>
nnoremap <leader>p7 "up :echo "paste from the register 7()"<cr>
nnoremap <leader>p8 "ip :echo "paste from the register 8()"<cr>
nnoremap <leader>p9 "op :echo "paste from the register 9()"<cr>
nnoremap <leader>p0 "pp :echo "paste from the register 0()"<cr>
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
   nnoremap <leader>FD  :let @* = expand("%:h")<cr>:echo		"relative path of the dir copied to the X11 1st clipboard"<CR>
   nnoremap <leader>fd  :let @+ = expand("%:h")<cr>:echo		"relative path of the dir copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FFP :let @* = expand("%:p")<cr>:echo		"full path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>ffp :let @+ = expand("%:p")<cr>:echo		"full path of the file copied to the X11 2nd clipboard"<CR>

	" insert mode paste from X11 clipboard
	inoremap <C-r>! <C-o>"*]p<C-o>:echo "paste from the X11 1st clipboard"<cr>
	inoremap <C-r>@ <C-o>"+]p<C-o>:echo "paste from the X11 2st clipboard"<cr>

	" "*	X11 primary buffer
	" vnoremap <leader>ry "*y
	" vnoremap <leader>rd "*d
	" nnoremap <leader>rp "*p
	" vnoremap <leader>rp "*p
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
	" <leader>Y - X11 1st yank
	" TODO TODO TODO reorganize all this
	" mnomoic: yank for tmux
	vnoremap <leader>yt :w! /tmp/vim_buffer<cr>:echo "vselection copied to /tmp/vim_buffer"<cr>

	nnoremap yiW "+yiw:echo "yank inner word to the X11 2nd clipboard"<cr>
    vnoremap Y "+y:echo "yank selection to the X11 2nd clipboard"<cr>

	" X11 primary buffer		"*
	vnoremap <leader>Y "*y:echo "copied to the X11 1st clipboard"<cr>
	nnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>
	vnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>

	" X11 secondary buffer		"+
	" TODO TODO set paste mode before pasting
	vnoremap <leader>y "+y:echo  "copied to the X11 2nd clipboard"<cr>
	nnoremap <leader>yy "+yy:echo "copied to the X11 2nd clipboard"<cr>
    nnoremap <leader>y "+yiw:echo "copied to the X11 2nd clipboard"<cr>
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
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Easier copy/paste to the named registers
" INFO this will slowdown copy to the X11 clipboard (<leader>y)
" TODO :set paste [y/d/p] :set nopaste

if has('nvim')
	" needed for nvim-qt.exe
	cnoremap <S-Insert> <C-r>+
endif
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Plugins																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" AutoComplete
Plug 'roxma/nvim-completion-manager'
" NCM fork without Python dependency
" Plug ''prabirshrestha/asyncomplete'
if !has('nvim')
	Plug 'roxma/vim-hug-neovim-rpc'
endif
" Plug 'roxma/clang_complete' " can be used for gotoDeclaration
Plug 'roxma/ncm-clang'

" rust
Plug 'rust-lang/rust.vim'   " Rust lang support
Plug 'racer-rust/vim-racer' " Rust autocompleter
Plug 'roxma/nvim-cm-racer'  " Rust enginge for NCM

Plug 'roxma/ncm-github'
Plug 'huawenyu/neogdb.vim'
Plug 'tpope/vim-dispatch'	" async make, needed for cscope code snippet below

Plug 'tpope/vim-unimpaired'	" easier movements around, like [q, ]q (quickfick)
" Plug 'triglav/vim-visual-increment' " Ctrl-A/X for columns
" Plug 'vim-scripts/VisIncr'
" Vim 8: visual select and Ctrl-A

" Plug 'w0rp/ale'				" Linter
Plug 'SirVer/ultisnips'		" snippet engine
Plug 'honza/vim-snippets'	" snippet collection
" Auto generate incremetal tags
Plug 'ludovicchabant/vim-gutentags', { 'for': 'c,cpp,rust' }
" Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'	" show tags (func, vars) in window right
" Plug 'vim-scripts/TagHighlight'	" color typedefs as variables, needs
" :UpdateTypesFile
Plug 'octol/vim-cpp-enhanced-highlight'	" simpler works out-of-the books, but not as good as TagHighlight
                                        " INFO 180525: This line must be here, otherwise C functions won't be highlighted
" Plug 'jeaye/color_coded'	" semantic highlighter INFO 170818: doesn't work in nvim

Plug 'chrisbra/NrrwRgn' " narrow region

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
Plug 'gcmt/taboo.vim'				" Rename tabs

" ******************** basics
Plug 'ciaranm/securemodelines'
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'osyo-manga/vim-anzu'			" show search matches in statusline
									" (second from the right)
Plug 'jiangmiao/auto-pairs'			" auto close quotes, brackets, ...
Plug 'tpope/vim-surround'			" replace quotes, brackets,...
Plug 'tpope/vim-repeat'             " repeat with . previous plugin
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'            " better search and replace and abbrev :Subvert
Plug 'troydm/zoomwintab.vim'		" <C-w>o wil zoom/unzoom windows/split
Plug 'AndrewRadev/undoquit.vim'
Plug 'ntpeters/vim-better-whitespace'	" show red block when there is a trailing whitespace


" Plug 'ervandew/supertab'


" Plug 'mileszs/ack.vim'		" wrapper around vimgrep or external grep
Plug 'jremmen/vim-ripgrep'	" fast external grep
Plug 'mhinz/vim-grepper'	" search buffers and populate quickfix
" search buffers and populate quickfix, lazy loading the plugin:
" Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'ronakg/quickr-preview.vim'	" preview files in quickfix without spoiling buffer list

Plug 'tomasr/molokai'		" color scheme
Plug 'tomasiser/vim-code-dark'  " VisualStudio inspired theme
Plug 'powerman/vim-plugin-AnsiEsc'	" Show shell ANSI colors as colors

" Plug 'brookhong/cscope.vim'		" XXX 180217: on clean Win10
Plug 'idanarye/vim-vebugger'
" needed for vebugger
Plug 'Shougo/vimproc.vim', {'do' : 'make'}


Plug 'kshenoy/vim-signature'	" marks in sign column and with easier shortcuts
								" use fzf :Marks for search
Plug 'airblade/vim-gitgutter'	" git: show +-m in sign column, shortcuts [c ]c
Plug 'tpope/vim-fugitive'		" Git commands for Vim

" Vim session plugins
Plug 'tpope/vim-obsession'	" restore session, needed for tmux ressurect
Plug 'mhinz/vim-startify'	" Fancy Vim startup screen (shows MRU, session, ...)
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'		" Required for vim-session

Plug 'godlygeek/tabular'	" Tabularize/align

" TODO 170813: check one day
" Plug 'timonv/vim-cargo'		" simple plugin, cmds: Cargo{Build, Run, Test, Bench}
Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'easymotion/vim-easymotion'	" leader leader and magic begins
" Plug 'justinmk/vim-sneak'       " lightweight easymotion
Plug 'myusuf3/numbers.vim'		" disable relative numbers in insert mode and non-active windows
" Plug 'hyiltiz/vim-plugins-profile'
" Plug 'junegunn/vim-easy-align'
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

" igranje:

" Initialize plugin system
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" Plugin configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" put this after the theme plugin is installed, but before custom "highlight"
" overrides
colorscheme molokai
" NCM																		{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <expr><tab> 	pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><S-tab>	pumvisible() ? "\<C-p>" : "\<S-tab>"

" <enter> for expanding snippet
" <C-u> is UltiSnipsExpandTrigger, <C-y> cancels completition menu
imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
imap <expr> <Plug>(expand_or_nl) (cm#completed_is_snippet() ? "\<C-u>":"\<CR>")

" <esc> to close autocomplete menu
" imap <expr> <esc>  (pumvisible() ?  "<c-y>" : "\<esc>") " 2018-01-16: iritating
" imap <expr> <cr>  (pumvisible() ?  "<c-y>" : "\<cr>") " XXX

inoremap <C-space> <C-o><Plug>(cm_force_refresh)

let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
" let g:cm_matcher = {'module': 'cm_matchers.abbrev_matcher', 'case': 'smartcase'}
"cm_matchers.abbrev_matcher"`	" not really fuzzy
" let g:cm_refresh_length=2
" let g:cm_refresh_length=[[1,4],[7,3]]   " default
let g:cm_refresh_length=[[1,4],[7,1]]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" clang_complete															{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" path to directory where library can be found
" let g:clang_library_path='/usr/local/llvm40/lib'
" -> Already set in OS specific part
" or path directly to the library file
" let g:clang_library_path='/usr/local/llvm40/lib/libclang.so.4.0'

" <Plug>(clang_complete_goto_declaration_preview)
au FileType c,cpp  nmap gd <Plug>(clang_complete_goto_declaration)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" snippets																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:UltiSnipsExpandTrigger        = '<C-u>'   " expand snippet
" 180218 NCM:
let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
" INFO 180115: <C-o> works but it will break Vim's <C-o> (exit insert mode for
" one command)
let g:UltiSnipsJumpForwardTrigger   = "<tab>"   " jump between $1, $2, ...
let g:UltiSnipsJumpBackwardTrigger  = "<s-tab>"
let g:UltiSnipsListSnippets         = '<C-l>'
" 180218 NCM optional:
inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

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
nmap <Leader>gv <Plug>GitGutterPreviewHunk :wincmd P<CR> :1<CR>
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gr <Plug>GitGutterUndoHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk

call SetupCommandAlias("gitt","GitGutterToggle")
call SetupCommandAlias("Gca","Gcommit --amend")
call SetupCommandAlias("GcA","Gcommit --amend --reuse-message=HEAD")

" let g:gitgutter_realtime = 0
" let g:gitgutter_eager = 0

" Fugitive - use 'q' to exit Gdiff:
if (bufname('%') == '^fugitive:')
    nnoremap <buffer> q :wincmd c<cr>
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" searching																	{{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 180217 Grepper
let g:grepper = {}            " initialize g:grepper with empty dictionary
runtime plugin/grepper.vim    " initialize g:grepper with default values
let g:grepper.highlight = 1
" let g:grepper.rg.grepprg .= ' --smart-case'

" - -query must be the last flag

if has('windows')
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
" au Syntax c,cpp call CustomTagHighlight()

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
" INFO rename tabs XXX don't work with CtrlSpace (which manages Airline tabline)

" remember tab names after restore
set sessionoptions+=tabpages,globals,buffers,curdir,folds,resize

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

" INFO usage:
" :Obsession <custom filename>		save session
" :Obsession . (or custom dir)		save session to Session.vim
" :Obsession!						delete file and stop saving/tracking
" :load <session file>				load
" vim -S <session file>				load

call SetupCommandAlias("sess", ":Obsession .")
call SetupCommandAlias("css", ":Obsession .")	" muscle memory

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

" let g:session_autosave = 'no'	" Don't ask when exiting Vim
let g:session_autosave_periodic = '1'	" Auto save every N minutes

" Disable all session locking - I know what I'm doing :-).
" Enables multiple loading of the same session
" let g:session_lock_enabled = 0
" let g:session_default_name='default_'.getcwd().'_'.system('date +%y%d%m_%H%M') " This will be evaluated only on Vim start
" XXX 171102: This will not work on Windows gVim:
if has('unix')
	" let g:session_default_name='default_'.system('pwd').system('date +%y%d%m') " This will be evaluated only on Vim start
	" let g:session_test=substitute(strtrans(system('pwd')), '\^@','','g').substitute(session_default_name, '\/','_','g')
	" let g:session_default_name='default_'.substitute(strtrans(system('pwd')), '\^@','','g').substitute(session_default_name, '\/','_','g')
endif

let g:session_command_aliases = 1	" :SomethingSession is :SessionSomething
call SetupCommandAlias("ss", ":SaveSession")
call SetupCommandAlias("sl", ":OpenSession")	" 'ls' is used
call SetupCommandAlias("os", ":OpenSession")
" TODO 170926: Autosave sessions but only if session is loaded/named (don't save session which are not saved by :SaveSession)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
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
" quickr-preview.vim lets you preview the result in detail without spoiling the buffer list. Everything is automatically clened up once quickfix window is closed.

let g:quickr_preview_keymaps = 0
" nmap <space> <plug>(quickr_preview) " XXX 171215: This will interfere <space> for folds
" nmap q <plug>(quickr_preview_qf_close)
" XXX won't close preview window after closing quickfix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" autopairs {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin to autoclose branckets ()
let g:AutoPairsMapCR = 0    " otherwise NCM expansion with <CR> won't work

" disable <A-b> it's used as Emacs type A-b
let g:AutoPairsShortcutBackInsert = '<nop>'
let g:AutoPairsShortcutJump = '<nop>'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" unimpared                                                                  {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin with usefull shortcuts

" options:
" [oX to disable something
" ]oX to enable something
" \oX to toggle something:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

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
highlight HighlightedyankRegion cterm=reverse gui=reverse
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" cscope																	{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('cscope')
    " unimpared mapping: ]q [q

    " regenerate DB from vim: :!cscope -Rbq :cs reset
"	set cscopetag cscopeverbose

"	if has('quickfix')
"		set cscopequickfix=s-,c-,d-,i-,t-,e-
"	endif

    " a: Find assignments to this symbol
    nmap <C-\>a :cs find s <C-R>=expand("<cword>")<CR><CR>
    " s: Find this C symbol
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    " g: Find this definition
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    " c: Find functions calling this function
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    " t: Find this text string
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    " e: Find this egrep pattern
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    " f: Find this file
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    " i: Find files #including this file
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    " d: Find functions called by this function
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"	" command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
endif


" if has('cscope')
"     set cscopetagorder=0
"     set cscopetag
"     set cscopeverbose
"     set cscopequickfix=s-,c-,d-,i-,t-,e-
"     set cscopepathcomp=3

"     function! LoadCscope()
"         let db = findfile("cscope.out", ".;")
"         if (!empty(db))
"             let path = strpart(db, 0, match(db, "/cscope.out$"))
"             set nocscopeverbose " suppress 'duplicate connection' error
"             exe "cs add " . db . " " . path
"             set cscopeverbose
"         endif
"     endfunction
"     au BufEnter /* call LoadCscope()

"     nnoremap T :cs find c <C-R>=expand("<cword>")<CR><CR>
"     " nnoremap t <C-]>
"     nnoremap gt <C-W><C-]>
"     nnoremap gT <C-W><C-]><C-W>T
"     nnoremap <silent> <leader>z :Dispatch echo "Generating tags and cscope database..." &&
"                         \ /usr/local/bin/ctags -R --fields=+aimSl --c-kinds=+lpx --c++-kinds=+lpx --exclude=.svn 
"                         \ --exclude=.git && find . -iname '*.c' -o 
"                         \ -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' 
"                         \ > cscope.files && cscope -b -i cscope.files -f cscope.out &&
"                         \ echo "Done." <cr><cr>

"     cnoreabbrev csa cs add
"     cnoreabbrev csf cs find
"     cnoreabbrev csk cs kill
"     cnoreabbrev csr cs reset
"     " cnoreabbrev css cs show
"     cnoreabbrev csh cs help
"     cnoreabbrev csc Cscope
"     command! Cscope :call LoadCscope()
" endif

" generate db:
" 1 cscope -bcqR .
" 2) find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" > cscope.files
"    cscope -q -R -b -i cscope.files
"    - c: don't compress the data

nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
" Some optional key mappings to search directly.
" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
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

" Easier way to jump to alternate file
" nnoremap <BS> <C-^>

" editing binary files:
" 		https://vi.stackexchange.com/questions/343/how-to-edit-binary-files-with-vim
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
match ErrorMsg '\%>80v.\+'	" highlight only chars after 'tw' as error message

highlight VertSplit		ctermfg=202 ctermbg=232 guifg=#ff5f00

" change color of tab chars (:set list)
highlight SpecialKey	ctermfg=236

" change concel to match background
highlight Conceal		ctermfg=7 ctermbg=233

" longer vertical bar for vertical splits, space for folds (default was -)
set fillchars=fold:\ ,vert:\│

" change the colors in diff mode, similiar to git diff
highlight DiffAdded		ctermfg=87	guifg=cyan
highlight DiffRemoved	ctermfg=196	guifg=red
" diff coors:
hi DiffAdd                     ctermbg=22  guibg=#005f00
" hi DiffChange      ctermfg=181 ctermbg=239
" hi DiffDelete      ctermfg=162 ctermbg=53
" hi DiffText                    ctermbg=102 cterm=bold

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
highlight ExtraWhitespace ctermbg=202 guibg=Red

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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
" TODO 16xxxx another '*' should disable highlight
" TODO 16xxxx <enter> - if it's link under cursor then "gx", if it's tag under cursor then :tag... othervise "o"
" TODO 170717: tmux <C-j>p -> enter/exit paste mode before/after that command
" INFO: remmaping Esc will fuckup scroll (scrolling will start to insert chars)
"
" INFO 170901: Ako se razjebe ista sta koristi python (npr ncm na Windowsima): pip install --upgrade neovim
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

" TODO 171210: :bd when quickfix is open: delete current buffer, but do not close window (it will fuck up quickfix window height)



" open header:
" nnoremap <leader>h :e %:r.h<cr>
" TODO 180206: Open .c file if header is currently opened
nnoremap <Leader>h :call HeaderToggle()<CR>

" XXX 180116: Doesn't work anymore. Doesn't work on vimrc from 2017.9.
" "bubble" move the lines (will have weird things on edge of the buffer)
" nnoremap <A-k> ddkP
" nnoremap <A-j> ddp
" vnoremap <A-k> xkP`[V`]
" vnoremap <A-j> xp`[V`]
inoremap <A-S-k> <C-o>dd<C-o>k<C-o>P
inoremap <A-S-j> <C-o>dd<C-o>p
" bubble move the lines with unimpared plugin
" nmap <A-S-k> [e
" nmap <A-S-j> ]e
" vmap <A-S-k> [egv
" vmap <A-S-j> ]egv
" " manually create that dirs:
" inoremap <A-k> <C-o>[e
" inoremap <A-j> <C-o>]e

" TODO 171224: explain this
" nnoremap [c zk

let g:vebugger_leader='<Leader>x'
let g:vebugger_path_gdb='arm-none-eabi-gdb --data-directory=~/.local/share/gdb-arm/data-directory'


let g:startify_fortune_use_unicode = 1
" Sort sessions by modification time rather than alphabetically.
let g:startify_session_sort = 0

cmap w!! w !sudo tee %

" TODO 180114: play with this for faster <leader>f (without other key after 'f')
" set timeoutlen

" 180106 - useful when reading man pages
nnoremap <Home> gg
nnoremap <End> G

" INFO 180218: multiple file search and replace:
" - search and populate quick list: Greeper or <leader>a
" - :cdo s/old/new/ge | update
