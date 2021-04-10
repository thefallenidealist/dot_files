" 170812
" 1.0 - created 160729, again
" 0.1 - 160512 - vim as IDE at work
"		150612	started experimenting with plugin managers and autocomplete
" 0.0 - 2006. probably
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker noet :

if has('nvim-0.5')
	let g:lsp_enabled = 1
	let g:treesitter_enabled = 1
else
	let g:lsp_enabled = 0
	let g:treesitter_enabled = 0
endif

" Generic Vim settings														{{{
" -----------------------------------------------------------------------------
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
set wildmenu		" cmd completion with wildchar (<tab>)
" set wildmode=full	" more shell-like completion
set wildmode=list:longest
set wildignore+=*~,*.swp,*.tmp	" don't complete these file types
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
" ------------------------------------------------------------------------- }}}
" OS specific																{{{
" -----------------------------------------------------------------------------
if has('unix')
	let s:uname = substitute(system("uname"), '\n', '', '')

	if s:uname == "FreeBSD"
		let g:python3_host_prog='/usr/local/bin/python3'
	endif " uname
endif
" ------------------------------------------------------------------------- }}}
" build/programming															{{{
" -----------------------------------------------------------------------------
" for 'gf' command: search in standard includes and in all subdirs in PWD
let &path.="src/include,/usr/include/AL,.,**"

" search for $CWD/tags, $CWD/.tags and go level up until $HOME
" set tags=tags,.tags;$HOME
" ------------------------------------------------------------------------- }}}
" cmd aliases																{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
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

command! PU so $MYVIMRC | PlugUpgrade | PlugUpdate
command! PI so $MYVIMRC | PlugInstall
command! PD so $MYVIMRC | PlugClean

" open help in vertical split right
cabbrev h vert leftabove help
call SetupCommandAlias("h", "vert leftabove help")
call SetupCommandAlias("man", "vert leftabove Man")
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
" ------------------------------------------------------------------------- }}}
" generic mappings															{{{
" -----------------------------------------------------------------------------
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
" INFO 200509 auto-paste if needed:
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
" don't 'insert char above cursor, it's confusing'
" inoremap <C-y> <nop> " XXX 180115: will break snippets and NCM

" jump to next misspell (<leader>z and z= are already used for spelling)
nnoremap ]z ]s
nnoremap [z [s
" ------------------------------------------------------------------------- }}}
" autocmd																	{{{
" -----------------------------------------------------------------------------
augroup autocmd_qf
	autocmd!
	autocmd FileType qf set nolist norelativenumber number
	autocmd FileType qf 10wincmd_	" QF will always have height of 10 lines
	autocmd FileType qf nnoremap <buffer> <cr> <cr>
augroup END

augroup my_group_with_a_very_uniq_name
	" this is executed every time when vimrc is sourced, so clear it at the beggining:
	autocmd!
	" INFO 190514: FileType: will be executed when opening file
	" Buf/WinEnter: Will be executed when entering buffer/window

	" kill QF/NERDTree/Tagbar if they are last windows
	autocmd BufEnter * call LastWindow()

	" easier quit from this windows
	autocmd FileType help nnoremap <buffer> q :wincmd c<cr>
	autocmd FileType qf,quickfix,netrw,fugitive,fugitiveblame nnoremap <buffer> q :q<cr>
	autocmd FileType help,man nnoremap <buffer> <cr> <C-]>
	if exists(":NumbersDisable")
		autocmd FileType help,man,qf :NumbersDisable	" Disable Numbers plugin in help or man
	endif

	" force Vim to threat .md files as markdown and not Modula
	" or use tpope/vim-markdown plugin
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	" don't match '<' in C++ (cout << "Something";)
	autocmd FileType cpp,make,vim set matchpairs-=<:>
	autocmd FileType shell set matchpairs-=`:`	" works, but only in reverse

	" in case I ever open a python file
	autocmd FileType python set expandtab

	autocmd FileType xdefaults set commentstring=!%s
	autocmd FileType pf,dnsmasq,fstab,cfg,gitconfig,crontab,sshdconfig,resolv,expect setlocal commentstring=#\ %s
	autocmd FileType c setlocal commentstring=\/\/\ %s
	autocmd FileType cpp setlocal commentstring=\/\/\ %s

	" Warn if file in current buffer is changed outside of Vim
	" - default: just warning when trying to write to the file
	autocmd BufEnter,FocusGained * checktime %

	autocmd BufRead,BufNewFile SConstruct,SConscript set filetype=python

	" maps in command-line-window:
	autocmd CmdwinEnter * map <buffer> <cr> <cr>
	autocmd CmdwinEnter * map <buffer> q :q<cr>
	autocmd CmdwinEnter * map <buffer> <esc> :q<cr>

	" maps in git messenger floating window
	autocmd FileType gitmessengerpopup map <buffer> <esc> q

	" au InsertEnter * set norelativenumber
	" au InsertLeave * set relativenumber

	" autocmd BufType fzf set nonumber norelativenumber
	autocmd WinEnter * if &buftype == 'nofile' | set nonumber norelativenumber | endif
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
" ------------------------------------------------------------------------- }}}
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
" Emacs shortcuts															{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" hardko mode																{{{
" -----------------------------------------------------------------------------
" nnoremap <Left>		:echoe "Use h"<cr>
" nnoremap <Right>	:echoe "Use l"<cr>
" nnoremap <Up>		:echoe "Use k"<cr>
" nnoremap <Down>		:echoe "Use j"<cr>

" Fix for cursors keys when Esc is remapped
nnoremap <esc>[ <esc>[

" breaking the habit
imap <C-c> <C-o>:echoe "Use esc, bogajebo"<cr>
" ------------------------------------------------------------------------- }}}
" TODO better, check if highlight is active (HOW?):
nnoremap <silent><Esc><Esc> <Esc>:nohlsearch<CR><Esc>:echo "hlsearch disabled"<cr>
" leader mappings															{{{
" -----------------------------------------------------------------------------
" another leader keys:
" nmap ; <leader>
" nmap , <leader>

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
" ------------------------------------------------------------------------- }}}
" copy paste mappings														{{{
" -----------------------------------------------------------------------------
" paste and adjuste indent
nnoremap p ]p
nnoremap P ]P
" nnoremap p p=`]
" nnoremap P P=`]

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

" clipboard																	{{{
" -----------------------------------------------------------------------------
if has('clipboard')	" not really needed for all options under this
	" copy filepath to X11 clipboard
	nnoremap <leader>FP  :let @* = expand("%")<cr>:echo   "relative path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fp  :let @+ = expand("%")<cr>:let @" = expand("%")<cr>:echo   "relative path of the file copied to the X11 2nd clipboard and vim register"<CR>
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
	" noremap <leader>Y "*y:echo "copied to the X11 1st clipboard"<cr>
	" nnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>
	" vnoremap <leader>P "*p:echo "pasted from the X11 1st clipboard"<cr>
	vnoremap <leader>Y "*y:echo  "copied to the X11 1st clipboard"<cr>
	nnoremap <leader>Y "*yiw:echo "word copied to the X11 1st clipboard"<cr>
	nnoremap <leader>YY "*yy:echo "line copied to the X11 1st clipboard"<cr>
	nnoremap <leader>P "*p:echo  "pasted from the X11 1st clipboard"<cr>
	vnoremap <leader>P "*p:echo  "pasted from the X11 1st clipboard"<cr>

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
" ------------------------------------------------------------------------- }}}
nnoremap <leader>ff  :let @" = expand("%")<cr>:echo   "relative path of the file copied to the unnamed register"<CR>
" ------------------------------------------------------------------------- }}}
" mouse mappings															{{{
" -----------------------------------------------------------------------------
" double click select all occurrences
nnoremap <2-LeftMouse> *N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
inoremap <2-LeftMouse> <c-o>*N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
vnoremap <2-LeftMouse> *N:call RemoveBrackets()<cr>:ShowSearchIndex<cr>
" ------------------------------------------------------------------------- }}}
" custom functions															{{{
" -----------------------------------------------------------------------------
function! AppendModeline()	"												{{{
	let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d fdm=%s %set :", &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
" ------------------------------------------------------------------------- }}}
function! s:VSetSearch() "													{{{
	" visual mode */#
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
" ------------------------------------------------------------------------- }}}
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
" ------------------------------------------------------------------------- }}}
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
" ------------------------------------------------------------------------- }}}
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
" ------------------------------------------------------------------------- }}}
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
" ------------------------------------------------------------------------- }}}
function! PreviewWindowOpened()	"											{{{
	" from: https://stackoverflow.com/a/14300184/8078624
	for nr in range(1, winnr('$'))
		if getwinvar(nr, "&pvw") == 1
			" found a preview
			return 1
		endif
	endfor
	return 0
endfun
" ------------------------------------------------------------------------- }}}
function! s:HelpTag(reverse)	"											{{{
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
" ------------------------------------------------------------------------- }}}
function! RemoveBrackets()                                                " {{{
	" removes '\<' and '\>' in '/' register
	" INFO created 171022, used for <C-R>/ after */#
	let @/ = substitute(@/, "\\\\\<", "", "")
	let @/ = substitute(@/, "\\\\\>", "", "")
endfunction
" ------------------------------------------------------------------------- }}}
function! HeaderToggle()	"												{{{
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
" ------------------------------------------------------------------------- }}}
function! SetupVerilogEnvironment()		"									{{{
	" https://github.com/albertxie/iverilog-tutorial
	" TODO 180617: Incorporate this into <F5> mapping for C/C++/Rust
	" (depending on filetype)
	map <F5> :! iverilog -o %:r.vvp %:r.v %:r_tb.v && vvp %:r.vvp && gtkwave %:r.vcd <ENTER>
endfunction
" ------------------------------------------------------------------------- }}}
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
function! HeaderToggle()	"												{{{
	" bang for overwrite when saving vimrc
	" from https://stackoverflow.com/questions/17170902/in-vim-how-to-switch-quickly-between-h-and-cpp-files-with-the-same-name
	let file_path = expand("%")
	let file_name = expand("%:r")
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
		" from .h try to open .c
		let next_file = join([file_name, ".c"], "")

		if filereadable(next_file)
			:e %<.c
		else
			echo join([err_msg, next_file], "")
		endif

		" from .h try to open .cpp
		let next_file = join([file_name, ".cpp"], "")

		if filereadable(next_file)
			:e %<.cpp
		else
			echo join([err_msg, next_file], "")
		endif
	elseif extension == "cpp"
		" from .cpp try to open .hpp
		let next_file = join([file_name, ".hpp"], "")

		if filereadable(next_file)
			:e %<.hpp
		else
			echo join([err_msg, next_file], "")
		endif

		" from .cpp try to open .h
		let next_file = join([file_name, ".h"], "")

		if filereadable(next_file)
			:e %<.h
		else
			echo join([err_msg, next_file], "")
		endif
	endif
endfunction
" ------------------------------------------------------------------------- }}}
function! SwitchWindow()	"												{{{
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
" ------------------------------------------------------------------------- }}}
function! Line(...)	"														{{{
" -----------------------------------------------------------------------------
" created by me on 190520
	let l:arg_num=a:0
	let s:line1 = "											{{{"
	" fold mark just to make it in synch with printf() bellow	{{{

	if &commentstring == "// %s"
		let s:line2 = printf("-----------------------------------------------------------------------------")
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
function! LastWindow()	"													{{{
" -----------------------------------------------------------------------------
" 200509 moved from augroup to separate function
" close current tab if only remaining buffers are quickfix/nerdtree/tagbar

	let l:no_of_windows = winnr('$')
	let l:exists_file   = exists("b:NERDTree")
	let l:exists_tagbar = bufwinnr('__Tagbar__') != -1
	let l:exists_qf     = bufwinnr('quickfix') != -1
	let l:is_last_tab	= tabpagenr('$') == 1

	" close if qf/NERDTree/tagbar are last windows:
	if l:no_of_windows == 1 && (l:exists_qf || l:exists_file || l:exists_tagbar)
		NERDTreeClose
	endif

	if l:no_of_windows == 2 && (l:exists_file && l:exists_qf)
		NERDTreeClose
		cclose
		if l:is_last_tab
			q
		endif
	endif

	if l:no_of_windows == 3 && (l:exists_file && l:exists_qf && l:exists_tagbar)
		NERDTreeClose
		TagbarClose
		cclose
		if l:is_last_tab
			q
		endif
	endif
endfunction
" ------------------------------------------------------------------------- }}}
" ------------------------------------------------------------------------- }}}

" Plugins																	{{{
" -----------------------------------------------------------------------------
" Auto install plug.vim doesn't exists										{{{
" -----------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" ------------------------------------------------------------------------- }}}
call plug#begin('~/.vim/plugged')

" completions & programming
" -----------------------------------------------------------------------------
if has('nvim-0.5')
if (g:lsp_enabled == 1)
Plug 'neovim/nvim-lsp'			" LSP core, nvim 0.5+
Plug 'nvim-lua/completion-nvim'	" LSP autocomplete, nvim 0.5+
Plug 'steelsojka/completion-buffers'
" Plug 'tjdevries/lsp_extensions.nvim'	" inlay hints for Rust
endif	" if lsp_enabled
if (g:treesitter_enabled == 1)
Plug 'nvim-treesitter/nvim-treesitter'			" nvim 0.5+
Plug 'nvim-treesitter/completion-treesitter'	" nvim 0.5+
endif	" if treesitter_enabled
endif	" if nvim-0.5
Plug 'SirVer/ultisnips'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'liuchengxu/vista.vim'				" LSP tagbar
Plug 'octol/vim-cpp-enhanced-highlight'	" simpler works out-of-the box, but not as good as TagHighlight
										" INFO 180525: This line must be here, otherwise C functions won't be highlighted

" basics
" -----------------------------------------------------------------------------
Plug 'ciaranm/securemodelines'
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'osyo-manga/vim-anzu'			" show search matches in statusline (second from the right)
" Plug 'tmsvg/pear-tree'			" auto close quotes, brackets, ...
" Plug 'jiangmiao/auto-pairs'		" auto close quotes, brackets, ...
Plug 'tpope/vim-surround'			" replace quotes, brackets,...
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'			" better search and replace and abbrev :Subvert
Plug 'tpope/vim-unimpaired'			" easier movements around, like [q, ]q (quickfick)
Plug 'Valloric/ListToggle'			" toggle quickfix and location list
Plug 'troydm/zoomwintab.vim'		" <C-w>o wil zoom/unzoom windows/split
Plug 'AndrewRadev/undoquit.vim'
Plug 'ntpeters/vim-better-whitespace'	" show red block when there is a trailing whitespace
Plug 'tpope/vim-tbone'					" Tmux copy/paste and others (:Tyank, :Tput, ...)
Plug 'elzr/vim-json'
Plug 'westeri/asl-vim', {'for': 'asl'}	" ACPI source language syntax
Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'chrisbra/vim-diff-enhanced'
Plug 'Houl/repmo-vim'				" repeat motions (repeat f/F/t/T with .)
Plug 'gcmt/taboo.vim'				" Rename tabs

" files
" -----------------------------------------------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'dietsche/vim-lastplace'		" Open file at last edit position
Plug 'bogado/file-line'				" open file.txt:123
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}	" lazy loading saves 300 ms on startup
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeToggle']}
if has('nvim-0.5')
Plug 'kyazdani42/nvim-tree.lua'		" NERDTree + netrw replacement
Plug 'kyazdani42/nvim-web-devicons'	" for file icons
Plug 'nvim-lua/popup.nvim'				" needed for telescope
Plug 'nvim-lua/plenary.nvim'			" needed for telescope
Plug 'nvim-telescope/telescope.nvim'	" fuzzy everything
endif

" git plugins
" -----------------------------------------------------------------------------
Plug 'kshenoy/vim-signature'		" marks in sign column and with easier shortcuts
									" use fzf :Marks for search
Plug 'airblade/vim-gitgutter'		" git: show +-m in sign column, shortcuts [c ]c
Plug 'tpope/vim-fugitive'			" Git commands for Vim
Plug 'moll/vim-bbye'				" follow symlinks - optional dependency
Plug 'aymericbeaumet/vim-symlink'	" follow symlinks
Plug 'junegunn/gv.vim'				" browse git commits, needs fugitive
Plug 'jreybert/vimagit'				" Git
if has('nvim-0.5')
Plug 'TimUntersberger/neogit'		" Lua magit
endif
Plug 'rhysd/git-messenger.vim'		" fancy git blame
Plug 'rhysd/conflict-marker.vim'	" git conflicts

" Vim session plugins
" -----------------------------------------------------------------------------
Plug 'tpope/vim-obsession'	" restore session, needed for tmux ressurect
Plug 'mhinz/vim-startify'	" Fancy Vim startup screen (shows MRU, session, ...)
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'		" Required for vim-session

" colors
" -----------------------------------------------------------------------------
Plug 'tomasr/molokai'					" color scheme
Plug 'altercation/vim-colors-solarized'
Plug 'tomasiser/vim-code-dark'			" VisualStudio inspired theme
Plug 'powerman/vim-plugin-AnsiEsc', {'for': 'sh,conf'}	" Show shell ANSI colors as colors
Plug 'christianchiarulli/nvcode-color-schemes.vim'		" treesitter enabled colors

" misc
" -----------------------------------------------------------------------------
Plug 'vim-airline/vim-airline'
" Plug 'rbong/vim-crystalline'		" light airline
" Plug 'mkitt/tabline.vim'			" light airline
Plug 'jremmen/vim-ripgrep'	" fast external grep
Plug 'mhinz/vim-grepper'	" search buffers and populate quickfix
" Plug 'ronakg/quickr-preview.vim'	" preview files in quickfix without spoiling buffer list
" Plug 'huawenyu/neogdb.vim'
Plug 'jceb/vim-orgmode'
Plug 'mattn/calendar-vim'
" Plug 'liuchengxu/vim-clap'
" Plug 'stefandtw/quickfix-reflector.vim'		" editable quickfix
Plug 'tpope/vim-markdown'
" Plug 'plasticboy/vim-markdown'
" Plug 'mzlogin/vim-markdown-toc'		" autogenerate markdown ToC (:GenTocGFM)
Plug 'godlygeek/tabular'	" Tabularize/align
" Plug 'junegunn/vim-easy-align'
" Plug 'tommcdo/vim-lion'		" simple tabularize/align

" Initialize plugin system
call plug#end()
" ------------------------------------------------------------------------- }}}
" Plugin configuration
" -----------------------------------------------------------------------------
" put this after the theme plugin is installed, but before custom "highlight"
" overrides
colorscheme molokai

" complete something like foo::bar
set iskeyword+=:
set completeopt=menu,menuone,noinsert,noselect

if has('nvim-0.5')
lua require('init')
if (g:lsp_enabled == 1)
" LSP nvim																	{{{
" -----------------------------------------------------------------------------
" 200723 builtin nvim (v0.5) LSP
nnoremap <silent> gd			<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]>			<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K				<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD			<cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k>			<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD			<cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>d		<cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>rn	<cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gr			<cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0			<cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW			<cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent><leader>la		<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent><leader>ld		<cmd>lua vim.lsp.buf.clear_refeerences()<CR>
" autocmd CursorHold * lua  vim.lsp.diagnostic.show_line_diagnostics()

command! LspDefinition		lua vim.lsp.buf.definition()
command! LspDeclaration		lua vim.lsp.buf.declaration()
command! LspHover			lua vim.lsp.buf.hover()
command! LspImplementation	lua vim.lsp.buf.implementation()
command! LspSignatureHelp	lua vim.lsp.buf.signature_help()
command! LspTypeDefinition	lua vim.lsp.buf.type_definition()
command! LspRename			lua vim.lsp.buf.rename()
command! LspReferences		lua vim.lsp.buf.references()
command! LspDocumentSymbol	lua vim.lsp.buf.document_symbol()
command! LspWorkspaceSymbol	lua vim.lsp.buf.workspace_symbol()
command! LspAction			lua vim.lsp.buf.code_action()
command! LspCodeAction		lua vim.lsp.buf.code_action()
command! LspLineDiagnostics	lua vim.lsp.util.show_line_diagnostics()

" open folds on jump
set foldopen+=tag
" CursorHold event after 300 ms
set updatetime=300

highlight LspDiagnosticsVirtualTextError	ctermfg=red		ctermbg=black
highlight LspDiagnosticsVirtualTextWarning	ctermfg=208		ctermbg=black
highlight LspDiagnosticsVirtualTextHint		ctermfg=105		ctermbg=black
" ------------------------------------------------------------------------- }}}
" LSP complete nvim 														{{{
" -----------------------------------------------------------------------------
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

let g:completion_enable_auto_popup = 1
let g:completion_enable_snippet = 'UltiSnips'
" disable <tab> key in snippets (so it can be used with completion-nvim)
let g:UltiSnipsExpandTrigger =			"<C-y>"		" default was <tab>
let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
		\ "\<Plug>(completion_confirm_completion)"  :
		\ "\<c-e>\<CR>" : "\<CR>"
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_paren = 1
augroup CompletionTriggerCharacter
	autocmd!
	autocmd BufEnter * let g:completion_trigger_character = ['.']
	autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '->', '::']
augroup end
let g:completion_trigger_keyword_length = 2
let g:completion_chain_complete_list = {
\ 'default' : {
\   'default': [
\       {'complete_items': ['lsp', 'snippet', 'buffers']},
\       {'complete_items': ['path'], 'triggered_only': ['/']},
\       {'mode': '<c-p>'},
\       {'mode': '<c-n>'}]
\   }
\}
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_strategy_list = ['exact', 'fuzzy']
let g:completion_matching_ignore_case = 1
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1
" sort according to complete_items[]:
let g:completion_sorting = 'none'

" triggering autocompletition
" manual: <C-x><C-o>
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
" ------------------------------------------------------------------------- }}}
" LSP diagnostic nvim 														{{{
" -----------------------------------------------------------------------------
nnoremap <silent> ]e :lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> [e :lua vim.lsp.diagnostic.goto_prev()<cr>
" no jump to warning for now
nnoremap <silent> ]w :lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> [w :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> <leader><space> :lua vim.lsp.diagnostic.set_loclist()<cr>
command! LspAll		lua vim.lsp.diagnostic.set_loclist()<cr>

let g:diagnostic_enable_virtual_text = 1	" inline diagnostic
let g:diagnostic_insert_delay = 1			" don't show it in insert mode
let g:diagnostic_virtual_text_prefix = '[LSP] '
let g:space_before_virtual_text = 5
let g:diagnostic_auto_popup_while_jump = 1	" auto open diagnostic popup
" ------------------------------------------------------------------------- }}}
endif
" fuzzy everything (Telescope)												{{{
" -----------------------------------------------------------------------------
" 171205 fzf.vim
" 210409 nvim-telescope
" - documenation - part in :h Telescope, mostly on GitHub

" nnoremap <leader>o <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>o <cmd>Telescope find_files<cr>
nnoremap <leader>m <cmd>Telescope oldfiles<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap ; <cmd>Telescope buffers<cr>
nnoremap to  :tab split<cr>:Telescope find_files<cr>
nnoremap tO :-tab split<cr>:Telescope find_files<cr>
nnoremap tm  :tab split<cr>:Telescope oldfiles<cr>
nnoremap tM :-tab split<cr>:Telescope oldfiles<cr>
nnoremap tb  :tab split<cr>:Telescope buffers<cr>
nnoremap tB :-tab split<cr>:Telescope buffers<cr>

" FZF missing things TODO 210409
" nnoremap <leader>w :Windows<CR>
" imap <c-x><c-l> <plug>(fzf-complete-buffer-line)
" " 201012
" " Fuzzy search all files in CWD:
" command! -bang -nargs=* RgFiles call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --glob !.git ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
" zsh (doesn't work):
" alias vim='vi -c "Telescope oldfiles"'

nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ll <cmd>Telescope lsp_document_diagnostics<cr>

" keys:
" <C-x>/<C-v>	open in split/vsplit
" <C-t>			open in tab
" <C-u>/<C-d>	scroll in preview

highlight TelescopeNormal			ctermbg=233
highlight TelescopePreviewNormal	ctermbg=233
highlight TelescopeBorder			ctermbg=233 ctermfg=196
highlight TelescopeSelection		ctermbg=232 ctermfg=120
highlight TelescopeMatching			ctermfg=10
" ------------------------------------------------------------------------- }}}
endif

" open header																{{{
" -----------------------------------------------------------------------------
nnoremap <Leader>h :call HeaderToggle()<CR>
nnoremap <Leader>h :ClangdSwitchSourceHeader<CR>
" ------------------------------------------------------------------------- }}}
" Rust																		{{{
" -----------------------------------------------------------------------------
" don't expand tab (and other things)
let g:rust_recommended_style = 0
let g:ftplugin_rust_source_path = $HOME.'~/src/rust-src/rust'

" 180805 RustFmt:
" TODO 180805
" ------------------------------------------------------------------------- }}}
" Airline																	{{{
" -----------------------------------------------------------------------------
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

" 200509 don't show "INSERT COMPL" in section_a
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'
let g:airline#extensions#lsp#enabled = 0	" 210223 fix startup error
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"" Airline - crystalline													{{{
" -----------------------------------------------------------------------------
"" 191210
"function! StatusLine(current, width)
"	let l:s = ''

"	if a:current
"		let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
"	else
"		let l:s .= '%#CrystallineInactive#'
"	endif
"	let l:s .= ' %f%h%w%m%r '
"	if a:current
"		let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
"	endif

"	let l:s .= '%='
"	if a:current
"		let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
"		let l:s .= crystalline#left_mode_sep('')
"	endif
"	if a:width > 80
"		let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
"	else
"		let l:s .= ' '
"	endif

"	return l:s
"endfunction

"function! TabLine()
"	let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
"	return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
"endfunction

"let g:crystalline_enable_sep = 1
"let g:crystalline_statusline_fn = 'StatusLine'
"let g:crystalline_tabline_fn = 'TabLine'
"let g:crystalline_theme = 'default'

"set showtabline=2
"set guioptions-=e
"set laststatus=2
" ------------------------------------------------------------------------- }}}

" Commenter																	{{{
" -----------------------------------------------------------------------------
" for tpope commenter, muscle memory from NERDcommenter
" INFO 170812: Yes, nmap, not nnoremap
nmap <leader>c<space>   <Plug>CommentaryLine
vmap <leader>c<space>   <Plug>Commentary
nmap <leader>cc         <Plug>CommentaryLine
vmap <leader>cc         <Plug>Commentary
nmap <leader>cy       yy<Plug>CommentaryLine
vmap <leader>cy      ygv<Plug>Commentary
" ------------------------------------------------------------------------- }}}
" vim orgmode																{{{
" -----------------------------------------------------------------------------

" ------------------------------------------------------------------------- }}}
" calendar																	{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" File managers																{{{
" -----------------------------------------------------------------------------
nnoremap <leader>f :NERDTreeToggle<cr>
nnoremap <leader>F :NERDTreeFind<cr>

nnoremap <C-w>f :NERDTreeFocus<cr>
nnoremap <C-w>F :NERDTreeClose<cr>
let g:NERDTreeMapActivateNode = "<space>"

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeIgnore=['\~$', '.o$']
" ------------------------------------------------------------------------- }}}
" File managers - lua														{{{
" -----------------------------------------------------------------------------
" 210325 nvim-tree.lua
" nnoremap <leader>f :NvimTreeToggle<CR>
" nnoremap <leader>F :NvimTreeFindFile<CR>

" set termguicolors " this variable must be enabled for colors to be applied properly
let g:nvim_tree_ignore = [ '.git', '*.bin' ]
let g:nvim_tree_auto_close = 1		" close if is last window
let g:nvim_tree_disable_keybindings = 0		" can't be disabled if keybindings will be customized below
" XXX default keybindings can't be overridden (eg <tab>)
" - if keybindings are disabled then config bellow won't be applied
" - if keybindings are not disabled then config bellow (local tree_cb = require'nvim-tree.config'.nvim_tree_callback) is just overlay over default
" - kludge: comment <tab> in ~/.vim/plugged/nvim-tree.lua/lua/nvim-tree/config.lua
" ------------------------------------------------------------------------- }}}
" git plugins																{{{
" -----------------------------------------------------------------------------
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
" nmap <Leader>gv <Plug>(GitGutterPreviewHunk) :wincmd P<CR> :1<CR>
nmap <Leader>gv <Plug>(GitGutterPreviewHunk)
nmap <Leader>ga <Plug>(GitGutterStageHunk)
nmap <Leader>gr <Plug>(GitGutterUndoHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

call SetupCommandAlias("gitt","GitGutterToggle")
call SetupCommandAlias("Gc","Git commit")
call SetupCommandAlias("Gcc","Git commit")
call SetupCommandAlias("Gcm","Git commit -m")
call SetupCommandAlias("Gca","Git commit --amend")
call SetupCommandAlias("Gce","Git commit --amend --no-edit")

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
" let g:git_messenger_always_into_popup = 1	" jump into popup

let g:magit_discard_hunk_mapping="X"   " discard hunk
let g:git_messenger_include_diff="current"	" auto show dif (whiout pressing 'd' key)

" Conflict-Marker	201005
" ]x/[x - jump to next/prev conflict marker
" %		- jump to beginning/middle/end conflict markers
" :ConflictMarker* functions
" ------------------------------------------------------------------------- }}}
" searching																	{{{
" -----------------------------------------------------------------------------
" 210405 vim's :grep command
if executable("rg")
	set grepprg=rg\ --vimgrep
endif

" 180217 Grepper
let g:grepper = {}			" initialize g:grepper with empty dictionary
runtime plugin/grepper.vim	" initialize g:grepper with default values
let g:grepper.highlight = 1
" let g:grepper.rg.grepprg .= ' --smart-case'

" - -query must be the last flag
nnoremap <leader>a :Grepper -tool rg -query <C-r><C-w><CR>
nnoremap <leader>a :Grepper -tool rg -cword -query<CR>
nnoremap <leader>A :Grepper -tool rg<cr>
nnoremap <leader>s :Grepper -tool rg -buffers -cword -query<cr>
nnoremap <leader>S :Grepper -tool rg -buffers <cr>

call SetupCommandAlias("Gbuf",  "Grepper -tool rg -buffer -query")
call SetupCommandAlias("Gbufs", "Grepper -tool rg -buffers -query")
call SetupCommandAlias("G",     "Grepper -tool rg -query")
" call SetupCommandAlias("Gadd",  "Grepper -tool rg -append -query") " XXX 180218
" ------------------------------------------------------------------------- }}}
" toggle quickfix and location list											{{{
" -----------------------------------------------------------------------------
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
" ------------------------------------------------------------------------- }}}
" easymotion																{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}

"	Tagbar - LSP															{{{
" -----------------------------------------------------------------------------
" 201120
let g:vista_default_executive = 'nvim_lsp'
" toggle tagbar
nnoremap <leader>t :Vista!!<CR>

" show tags from current buffer in floating window
command! Tags		Vista finder

let g:airline#extensions#vista#enabled = 1
" ------------------------------------------------------------------------- }}}
" C/C++ highlighter															{{{
" -----------------------------------------------------------------------------
" INFO 170818: works for C also
" let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1		" object.*var1*
" let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1
" XXX 170818: won't highlight object name, nor typedefed variable/type
" ------------------------------------------------------------------------- }}}

" undoquit 																	{{{
" -----------------------------------------------------------------------------
" undo quit window/split/tab/buffer

let g:undoquit_mapping = '<C-w>u'

" <C-w>c doesn't call QuitPre autocmd, patch it to works with this plugin
nnoremap <C-w>c :call undoquit#SaveWindowQuitHistory()<cr><C-w>c
" go to left tab after closing
" TODO 171210: skip going to left tab if we are closing the last tab
" nnoremap <C-w>c :call undoquit#SaveWindowQuitHistory()<cr><C-w>c:tabprev<cr>
" ------------------------------------------------------------------------- }}}
" taboo																		{{{
" -----------------------------------------------------------------------------
" rename current tab
set sessionoptions+=tabpages,globals	" nedded for taboo plugin (used to rename tabs)
let g:airline#extensions#taboo#enabled = 1	" enable
let g:taboo_tabline = 0						" leave drawing tabline to Airline
" modified tab will show "%#TabModifiedSelected#*%#TabLineSel#"
" FIX: manually merge:
" https://github.com/gcmt/taboo.vim/pull/25
nnoremap tr :TabooRename<space>
" ------------------------------------------------------------------------- }}}
" zoom-win																	{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}

" sessions																	{{{
" -----------------------------------------------------------------------------
" Obsession - autosave session (":mksession")
" -----------------------------------------------------------------------------
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
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" vim-startify																{{{
" -----------------------------------------------------------------------------
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
let g:startify_fortune_use_unicode = 1
" Sort sessions by modification time rather than alphabetically.
let g:startify_session_sort = 0


" :SSave[!] [session]
" :SDelete[!] [session]
" :SLoad[!] [session]
" :SClose
" ------------------------------------------------------------------------- }}}
" marks																		{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" quickfix preview															{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" tmux - tbone.vim															{{{
" -----------------------------------------------------------------------------
"  cmds: :Tmux Tyank Tput Twrite Tattach
" TODO 181222: remove newline before yanking
" mnemonic: yank for tmux
vnoremap <leader>yt :Tyank<cr>:echo "copied to tmux paste buffer"<cr>
nnoremap <leader>yt :Tyank<cr>:echo "copied to tmux paste buffer"<cr>
" ------------------------------------------------------------------------- }}}
" lastplace																	{{{
" -----------------------------------------------------------------------------
" INFO reopen files where you left off
let g:lastplace_open_folds = 1 " auto open folder, default: 1 XXX don't work for nested folds
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
" ------------------------------------------------------------------------- }}}
" WhiteSpace																{{{
" -----------------------------------------------------------------------------
" INFO highlight trailing spaces in red
" :ToggleWhitespace
let g:better_whitespace_filetypes_blacklist = ['help', 'Help', 'quickfix', 'vim-plug', 'man', 'diff', 'location', 'markdown']

command! FixWhiteSpace StripWhitespace	" function from 'better white space' plugin
call SetupCommandAlias("fws", "StripWhitespace")	" function from 'better white space' plugin
" ------------------------------------------------------------------------- }}}
" indexed search															{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" bufkill																	{{{
" -----------------------------------------------------------------------------
" INFO used for :BD
" don't create various <leader>b* mapping (which will slowdown <leader>b for CtrlPBuffer)
let g:BufKillCreateMappings = 0
" let g:BufKillOverrideCtrlCaret = 1
" To move backwards/forwards through recently accessed buffers, use: :BB/:BF
" ------------------------------------------------------------------------- }}}
" Tabularize																{{{
" -----------------------------------------------------------------------------
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

" 200223: simpler plugin vim-lion:
" gl - right-align operator
" gL - lef-align operator
" gl= - align around =
" gLi(	- align inside ()
" ------------------------------------------------------------------------- }}}
" window swap																{{{
" -----------------------------------------------------------------------------
" Navigate to the window you'd like to move
" Press <leader>ww
" Navigate to the window you'd like to swap with
" Press <leader>ww again
" ------------------------------------------------------------------------- }}}
" highlighted yank															{{{
" -----------------------------------------------------------------------------
" 210104 highlight yanked text - replacement for plugin
" temporary highlight the text which is yanked
highlight HighlightedyankRegion gui=reverse ctermbg=130 ctermfg=15

augroup LuaHighlight
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout=1000,higroup="HighlightedyankRegion"})
augroup END
" ------------------------------------------------------------------------- }}}
" diff enhanced																{{{
" -----------------------------------------------------------------------------
" Patience diff algorithm
" :PatienceDiff - Use the Patience Diff algorithm for the next diff mode
" :EnhancedDiff <algorithm> - Use <algorithm> to generate the diff.

" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
	let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif
if has ("nvim")
	set diffopt+=algorithm:patience
endif
if has("patch-8.1.0360")	" Vim 8.1+
    set diffopt+=internal,algorithm:patience
endif
" ------------------------------------------------------------------------- }}}
" NeoVim terminal															{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}

" Easier way to jump to alternate file
" nnoremap <BS> <C-^>

" editing binary files (XXX 190824 only for vim which includes xxd binary)
" https://vi.stackexchange.com/questions/343/how-to-edit-binary-files-with-vim
nmap <leader>hr :set binary<CR> :%!xxd<CR> :set filetype=xxd<CR>
nmap <leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR> :set fileencoding=<CR> :w<CR> :set nobinary<CR>

" colors and TERM setup														{{{
" -----------------------------------------------------------------------------
" highlight Normal		ctermbg=233	" XXX change in theme file
highlight Normal		ctermbg=232
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

highlight DiffAdd    cterm=bold ctermfg=0 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=0 ctermbg=52
highlight DiffChange cterm=bold ctermfg=0 ctermbg=17
highlight DiffText   cterm=bold ctermfg=0 ctermbg=19

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
highlight LineNr	ctermfg=253 ctermbg=234
highlight WildMenu	ctermfg=188 ctermbg=24
" ------------------------------------------------------------------------- }}}
" GUI settings																{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}

" INFO																		{{{
" -----------------------------------------------------------------------------
" programmers vim 															{{{
" -----------------------------------------------------------------------------
" @: repeat last : command
" @@ for next repeat
" Just type & to repeat the last substitution on the current line. You can repeat it on all lines by typing g&.

" Ctrl-W } show variable/function in a preview window

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
" ------------------------------------------------------------------------- }}}
" searching																	{{{
" -----------------------------------------------------------------------------
":%!/usr/local/bin/zsh!/opt/bin/zsh		-> ! as delimiter (# also works)
"/some_text.*							-> '.' and wild wildcard starts working
" ------------------------------------------------------------------------- }}}
" moving		 															{{{
" -----------------------------------------------------------------------------
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

" ------------------------------------------------------------------------- }}}
" tips and tricks 															{{{
" -----------------------------------------------------------------------------
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
" ------------------------------------------------------------------------- }}}
" vimL misc																	{{{
" -----------------------------------------------------------------------------
" number of tabs: tabpagenr('$')
" let l:buffers = range(1, bufnr('$'))
" let l:currentTab = tabpagenr()
" current buffer number: bufnr('$')
" current buffer number: bufnr('%')
" get line under the cursors: getline('.')
" ------------------------------------------------------------------------- }}}

" TODO :h pattern-atoms
" Vim debug:
" vim -V9myVimLog

" INFO maybe will be useful some day: "&& bufname("%") != "[Command Line]"
" INFO highlight ALL whitespace (and tabs): /\s
" INFO highlight all whitespace at the beggining: /^<space>

" export MYVIMRC="~/vim_ide"		" change .vim position
" vim -U ~/vim_ide/vimrc

" Unicode characters can be inserted by typing ctrl-vu followed by the 4 digit hexadecimal code.
" ------------------------------------------------------------------------- }}}
" TODO 16xxxx <enter> - if it's link under cursor then "gx", if it's tag under cursor then :tag... othervise "o"
" TODO 170717: tmux <C-j>p -> enter/exit paste mode before/after that command
" INFO: remmaping Esc will fuckup scroll (scrolling will start to insert chars)
"
cmap w!! w !sudo tee %

" 180106 - useful when reading man pages
nnoremap <Home> gg
nnoremap <End> G

" TODO 190514: quit QF windows before calling :Files or :FZFMru (otherwise
" that file will be open in (miniature) QF window split)
" TODO 190515: disable <C-w>v/s/d commands in location list

" 191203 git commit markers:
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
