" created 160729, again
" vim as IDE at work: created 160512
" export MYVIMRC="~/vim_ide"		" change .vim position
" vim -U ~/vim_ide/vimrc

" Unicode characters can be inserted by typing ctrl-vu followed by the 4 digit hexadecimal code.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"				settings
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
"set autoread		" autoload files that have changed outside of vim
"set clipboard+=unnamed	" use system clipboard INFO maybe Mac specific, not tested, not needed

" better splits
set splitbelow
set splitright

set timeoutlen=1000 ttimeoutlen=0		" delay for the esc key, 10ms
"set exrc		" source .vimrc file if it present in working directory
set secure		" This option will restrict usage of some commands in non-default .vimrc files; commands that wrote to file or execute shell commands are not allowed and map commands are displayed.

set nomodeline
set modelines=0
" INFO secure-modelines plugin is used which only allows some (secure) modeline options

" Xorg paste with middle click
if !has('nvim')
	set ttymouse=xterm2
endif

set gdefault "applies substitutions globally on lines. For example, instead of :%s/foo/bar/g you just type :%s/foo/bar/

"set completeopt=menu,menuone,preview
"set completeopt=menuone,preview	" default
set completeopt=menuone				" f(); can be view in command line with plugin
set noshowmode						"Don't show the mode(airline is handling this)
set shortmess+=I	" don't show intro message at startup
set cursorline		" color the line when the cursor is
set matchpairs+=<:>	" Include angle brackets in matching.
set showmatch

"		<tab> and wrapping			{{{
"""""""""""""""""""""""""""""""""""""""
" soft wrap
set wrap			" soft break when line is wider than Vim window (not tw)
set linebreak		" break line without breaking the word
					" wont't work when "list" is enabled

" hard break
" set textwidth=78			" autowrap after N chars
set colorcolumn=+1	" show coloumn where autowrap will start"
set formatoptions=""
		" default: tcq
		" t: autowrap using tw
		" c: add comment in new line a: format line every time when it is
		" changed (no more longer or shorter lines) 		pretty annoying

set tabstop=4		" tab size
set shiftwidth=4 	" when indenting with '>'
"set expandtab		" convert tab to spaces
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
"set listchars+=trail:◊
set list	" show invisible chars (tabs and others defined in listchars)

" directory for swap files
set directory=$HOME/.vim/swap/,/tmp
" place for: filename.txt~
set backupdir=$HOME/.vim/swap/,/tmp
"		search						{{{
"""""""""""""""""""""""""""""""""""""""
set ignorecase		" case insensitive search, needed for the line below
set smartcase		" If searched word starts with an uppercase then be case sensitive
set incsearch		" search as you type INFO for caseinsensitive search: /something\c
"set hlsearch        " highlight search - disabled because it will activate themself after reloading vimrc
""""""""""""""""""""""""""""""""""""}}}
"		spell						{{{
"""""""""""""""""""""""""""""""""""""""
set spellfile=~/.vim/spelluser.utf-8.add	" don't use '_' in filename
"set spelllang=~/.vim/spell/hr.utf-8.spl,en	"
setlocal spelllang=en_us	" TODO hr
" set complete+=kspell
""""""""""""""""""""""""""""""""""""}}}

set conceallevel=2	" hide concealed chars until cursor is on that line
"set foldcolumn=2	" will show clickable '+' in column at the left (which is wide $foldcolumn chars)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		OS specific															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('unix')
	let s:uname = substitute(system("uname"), '\n', '', '')
endif

if s:uname == "FreeBSD"
	let g:tagbar_ctags_bin=substitute(system("which exctags"), '\n', '','')
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		build/programming			{{{
"""""""""""""""""""""""""""""""""""""""
" TODO incoporate this as prefix for part below
" makeprg can't have spaces
if s:uname == "FreeBSD"
	set makeprg="gmake -j4"
elseif s:uname == "Linux"
	set makeprg="make -j4"
endif

function! Compile()
	" TODO wait for user input after compiling and before running
		" if enter run program, if q/esc don't
	if file_readable('Makefile')
		make
	elseif file_readable('makefile')
		make
	elseif file_readable('compile.sh')
		setlocal makeprg=./compile.sh
		make
	elseif file_readable('compile')
		setlocal makeprg=./compile
	elseif expand('%:e') == "cpp"
		setlocal makeprg=c++\ -Wall\ %\ -o\ %:r.elf\ -std=c++11
		make
	elseif expand('%:e') == "c"
		setlocal makeprg=cc\ -Wall\ %\ -o\ %:r.elf\ -std=c99
		make
	else
		echoerr "Don't know how to build :["
	endif
endfunction
nnoremap <F5> :call Compile()<cr>
nnoremap <leader>rr :call Compile()<cr>

" za gF komandu koja otvori fajl pod kursorom
let &path.="src/include,/usr/include/AL,"

" XXX XXX XXX only work in first buffer
" Highlight TODO, FIXME, NOTE, etc. FIXME:
if has("autocmd")
	if v:version > 701
		autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|ZAJEB\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
		autocmd Syntax * call matchadd('Debug', '\W\zs\(INFO_START\|INFO_END\|ERROR\|DEBUG_START\|DEBUG_END\|DEBUG_INFO\)')
	endif
endif

" tags file in CWD
" search for $CWD/tags, $CWD/.tags and go level up until $HOME
set tags=tags,.tags;$HOME
""""""""""""""""""""""""""""""""""""}}}

"		autocmd																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup my_group_with_a_very_uniq_name
	" this is executed every time when vimrc is sourced, so clear it at the beggining:
	autocmd!

	autocmd Filetype man NumbersDisable
	" Filetype only works on first time opening the help window
	autocmd Filetype help NumbersDisable
	autocmd BufEnter help norelativenumber
	autocmd BufEnter help IndentLinesDisable
	" INFO FixWhiteSpace is controled from its option

	" map q as kill only in help window
	autocmd Filetype help nnoremap <buffer> q :wincmd c<cr>
	" unmap enter in help and man window
	"autocmd Filetype help nnoremap <buffer> <cr> <cr>
	" Enter is "goto tag" TODO: if not tag map to *
	autocmd Filetype help nnoremap <buffer> <cr> <C-]>
	autocmd Filetype man nnoremap <buffer> <cr> <cr>

	" unmap enter in QuickFix window (window at the bottom which isn't preview)
	autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>
	"autocmd BufReadPost quickfix nnoremap <buffer> q :q<cr>
	" autocmd FileType quickfix nnoremap <buffer> q :q<cr>
	" INFO qf and quickfix aren't the same
	autocmd FileType qf,netrw nnoremap <buffer> q :q<cr>
	autocmd Filetype qf set nolist

	" force Vim to threat .md files as markdown and not Modula
	" or use tpope/vim-markdown plugin
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	" don't match < in C++ (cout << "Something";)
	autocmd Filetype cpp,make,vim set matchpairs-=<:>
	autocmd Filetype shell set matchpairs-=`:`	" works, but only in reverse

	" in case I ever open a python file
	autocmd Filetype python set expandtab

	autocmd FileType qf nnoremap <buffer> p <plug>(quickr_preview)
	"autocmd FileType qf nnoremap <buffer> q <plug>(quickr_preview_qf_close)

	" Don't show numbers in preview window
	autocmd BufWinEnter * if &previewwindow | setlocal nonumber norelativenumber | endif


	autocmd BufWinEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	autocmd BufEnter * if bufname("%") == "[Command Line]" | nnoremap <buffer> q :q<cr> | endif
	autocmd BufEnter * if @% == "[Command Line]" | echo "QQQQQQ" | endif
	autocmd VimEnter * if @% == "[Command Line]" | echo "QQQQQQ" | else | "AAAAAA" | endif
augroup END

" setup when in diff mode:
if &diff
	cabbrev q qa!
	nnoremap q :qa!<cr>
endif

" setup for preview window
" if &previewwindow
	" nnoremap q :q!<cr>
" endif

" TODO:
" autocmd WinEnter *
" if &previewwindow
	" nnoremap q :q!<cr>
" endif

"autocmd WinEnter * if &previewwindow | ... | endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				keymaps
"		cmd aliases															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO all abbrev commands are non recursive

" alias only triggered if it's on the start of the line
cnoreabbrev <expr> csa ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')

" annoying misspell:
cabbrev W w
cabbrev Q q
cabbrev q1 q!
cabbrev X x
cabbrev x1 x!
cabbrev QA qa
cabbrev QA1 qa!
cabbrev Qa! qa!
cabbrev qA qa
cabbrev qa1 qa!
cabbrev Qa qa
cabbrev WQ wq
cabbrev Wq wq
cabbrev wQ wq
" generic aliases
" TODO :we

" TODO remap all to this
"cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

command! PU PlugUpdate | PlugUpgrade
command! PI PlugInstall

" open help in vertical split right
cabbrev h vert bo help
cabbrev man vert bo Man
" get file path:
cabbrev fpath echo @%
cabbrev fp echo @%
cabbrev FP echo expand('%:p')
" reload syntax
cabbrev rsyn syntax sync fromstart
"cabbrev fix_dos ed ++ff=dos
"cabbrev fixdos ed ++ff=dos
" TODO put this inf function (:e ++ff=dos) ili tako nekako
cabbrev cc set cursorcolumn!

" folds help: zo zc za, zO, zC, zA (open, close, toggle)
"	zf create fold (marker/manual)
"	zd, zD delete fold
" close all folds
cabbrev foldcloseall %foldclose!
cabbrev foldca %foldclose!
cabbrev fca %foldclose!
cabbrev foa %foldopen!
"because standard Vim fold shortcuts are starting with z
cabbrev zca %foldclose!
cabbrev zoa %foldopen!
" close all other folds

" Don't show ^M in DOS files
command! FixDos edit ++ff=dos

" :we to write and reload file TODO
"cabbrev we write | edit

" XXX CtrlSpace won't restore tabs with only one tab (only at PC on the work, on my everything works™)
cabbrev css CtrlSpaceSaveWorkspace
cabbrev csl CtrlSpaceLoadWorkspace

cabbrev ccc call ToggleColorColumn()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		generic mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" disable ed mode:
nnoremap Q <nop>
" no more ćevap-fingers
inoremap <F1> <esc>
nnoremap <F1> <esc>
vnoremap <F1> <esc>

" delete to the black hole register
nnoremap dd "_dd
nnoremap D "_D
nnoremap dw "_dw
" yank and delete
nnoremap dy yydd
nnoremap yd yydd

" Enter new line without going to insert mode
nnoremap <cr> o<esc>

" swap the behaviour between j/k and gj/gk
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

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
inoremap <S-Tab> <C-o><<
" INFO maybe more useful shortcut for window management
" XXX doesn't work
nnoremap <S-Tab> <<

" auto-complete 'fix'
" Enter for breaking autocomplete (when it's active)
" XXX this will not for if one char is typed and completion is active 		Ctrl-e is for breaking
inoremap <expr><cr>		pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"
" tmp fix: use Ctrl-e
"inoremap <expr><esc>	pumvisible() ? "\<C-e>" : "\<esc>"
inoremap <expr><tab> 	pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><S-tab>	pumvisible() ? "\<C-p>" : "\<S-tab>"
inoremap <expr><C-_>	deoplete#undo_completion()

" <CR>: close popup and save indent.
" enter to break autocomplete and put new line (previous this action needed 2x enter)
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function() abort
	" return deoplete#mappings#close_popup() . "\<CR>"
" endfunction
" INFO 161203 It's seems that default behaviour of enter and deoplete is good enough for me
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		buffers/windows/tabs keymaps										{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap tn :tabnew<cr>
nnoremap th :tabprev<cr>
nnoremap tl :tabnext<cr>
" XXX very short message duration time
" nnoremap - :tabprev<cr>:echom "going to the previous tab"<cr>
" nnoremap + :tabnext<cr>:echom "going to the next tab"<cr>
" nnoremap = :tabnext<cr>:echom "going to the next tab"<cr>

nnoremap <A-h> :tabprev<cr>
nnoremap <A-l> :tabnext<cr>
nnoremap <A-j> :CtrlSpaceGoDown<cr>
nnoremap <A-k> :CtrlSpaceGoUp<cr>

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
nnoremap tj :CtrlSpaceGoDown<cr>
nnoremap tk :CtrlSpaceGoUp<cr>

" doesn't seems particularly useful:
"nnoremap <leader>- <Plug>AirlineSelectPrevTab
"nnoremap <leader>+ <Plug>AirlineSelectNextTab

nnoremap tm :tabnew<cr>:CtrlPMRUFiles<CR>
nnoremap to :tabnew<cr>:CtrlP<CR>
" because it's close to O, and sometimes there is a need to just open a file
nnoremap ti :tabedit<space>
nnoremap te :tabedit<space>

nnoremap <leader>q :tabprev<cr>
nnoremap <leader>w :tabnext<cr>

" jumping, Ctrl-I (tab) is used for switching splits
nnoremap <C-p> :pop<cr>:echo "Tag jump -1"<cr>
nnoremap <C-n> :tag<cr>:echo "Tag jump +1"<cr>

" IDEA
" <leader>n 	for switching buffers
" Alt-shift-N 	for switching tabs
if has('nvim')
	" INFO shift in shortcuts doesn't work, but this is:
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

inoremap <C-w>j <esc><C-w>j
inoremap <C-w>k <esc><C-w>k
inoremap <C-w>h <esc><C-w>h
inoremap <C-w>l <esc><C-w>l
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
nnoremap <silent> <esc> :noh<cr><esc>:echo "hlsearch disabled"<cr>
"		leader mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" muliple leader (just in case, not really needed in my case):
"nmap , \
"nmap <space> \ " won't work because space is used for fold toggle

"temporarily disable search highlighting until the next search.
" INFO this is NOT the same as set nohlsearch
nnoremap <leader>h :noh<cr>
nnoremap <leader>s :setlocal spell!<cr>
" toggle showing invisible chars
nnoremap <leader>l :set list!<cr>:set list?<CR>
" nnoremap <leader>n :set relativenumber!<cr>
" nnoremap <leader>N :set number!<cr>
nnoremap <leader>n :set relativenumber!<cr>:set number!<CR>
nnoremap <leader>N :set relativenumber!<cr>
"reload config file
nnoremap <leader>r :so $MYVIMRC<cr>:echo "vimrc reloaded"<CR>
nnoremap <leader>e :e $MYVIMRC<cr>

" INFO capsed to not slowdown <leader>m which is more used (for CtrlP MRU)
nnoremap <silent> <leader>ML :call AppendModeline()<cr>
" buffers and windows
" INFO not really useful, better shortcuts can use that shortcuts
"nnoremap <leader>w :w<cr>
"nnoremap <leader>x :x<cr>
"nnoremap <leader>q :q<cr>


" INFO there are some leader mappings <leader>0..9 in tabs section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		plugin mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <leader>f :NERDTreeToggle<cr>
nnoremap <leader>ff :NERDTreeToggle<cr>
nnoremap <leader>c :SyntasticToggleMode<cr>
nnoremap <leader>o :CtrlP<cr>
nnoremap <leader>m :CtrlPMRUFiles<cr>
nnoremap <leader>M :CtrlPMixed<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
" Open a new tab and search for something
" map <leader>a :tab split<cr>:Ag ""<Left>
"Immediately search for the word under the cursor in a new tab
" map <leader>A :tab split<cr>:Ag <C-r><C-w><CR>
"
" TODO open new tab (duplicate), there open Ack!
nnoremap <leader>a :tab split<cr>:Ack! <C-r><C-w><CR>
command! FixWhiteSpace StripWhitespace

" not too useful
"nnoremap <leader>1 <Plug>AirlineSelectTab1
"nnoremap <leader>2 <Plug>AirlineSelectTab2
"nnoremap <leader>3 <Plug>AirlineSelectTab3
"nnoremap <leader>4 <Plug>AirlineSelectTab4
"nnoremap <leader>5 <Plug>AirlineSelectTab5
"nnoremap <leader>6 <Plug>AirlineSelectTab6
"nnoremap <leader>7 <Plug>AirlineSelectTab7
"nnoremap <leader>8 <Plug>AirlineSelectTab8
"nnoremap <leader>9 <Plug>AirlineSelectTab9
"nnoremap <leader>- <Plug>AirlineSelectPrevTab
"nnoremap <leader>+ <Plug>AirlineSelectNextTab
"nnoremap <leader>= <Plug>AirlineSelectNextTab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"		copy paste mappings													{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" paste and adjuste indent
" nnoremap p ]p
" nnoremap P ]P
nnoremap p p=`]
nnoremap P P=`]

if has('clipboard')	" not really needed for all options under this
	" ": unnamed register (dd/yy)
	" *: X11 primary	  (select/middle click)
	" +: X11 secondanry   (Ctrl-C/V)

	" INFO can't have spaces in alias, spaces is aliased to fold toggle TODO
	" "*	X11 primary buffer
	vnoremap <leader>ry "*y
	vnoremap <leader>rd "*d
	nnoremap <leader>rp "*p
	vnoremap <leader>rp "*p
	" TODO r{1,2}{y,d,p}


	" TODO TODO IDEA
	" y - vim yank
	" Y - X11 2nd (clipboard) yank (without leader key)
	" <leader>y - tmux yank
	" <leader>Y - X11 1nd yank
	" TODO TODO TODO reorganize all this
	vnoremap <leader>Y :w! /tmp/vim_buffer<cr>:echo "vselection copied to /tmp/vim_buffer"<cr>


	" X11 primary buffer		"*
	"vnoremap <leader>Y "*y:echo "copied to the X11 1nd clipboard"<cr>
	vnoremap <leader>D "*d:echo "cutted to the X11 1nd clipboard"<cr>
	vnoremap <leader>X "*d:echo "cutted to the X11 1nd clipboard"<cr>
	nnoremap <leader>P "*p:echo "pasted from the X11 1nd clipboard"<cr>
	vnoremap <leader>P "*p:echo "pasted from the X11 1nd clipboard"<cr>

	" X11 secondary buffer		"+
	"vnoremap <leader>y "+y :echo "copied to the X11 2nd clipboard"<cr>
	" TODO TODO set paste mode before pasting
	" vnoremap <leader>y "+y :echo "copied to the X11 2nd clipboard"<cr>
	" vnoremap <leader>yy "+y :echo "copied to the X11 2nd clipboard"<cr>
	vnoremap <leader>d "+d :echo "cutted to the X11 2nd clipboard"<cr>
	vnoremap <leader>x "+d :echo "cutted to the X11 2nd clipboard"<cr>
	nnoremap <leader>p "+p :echo "pasted from the X11 2nd clipboard"<cr>
	vnoremap <leader>p "+p :echo "pasted from the X11 2nd clipboard"<cr>

	" Easier copy/paste to the named registers
	" INFO this will slowdown copy to the X11 clipboard (<leader>y)
	" TODO better naming (it's not a register 1 but q)
	" TODO :set paste [y/d/p] :set nopaste
	" TODO registers: asdfghjkl

	vnoremap <leader>y1 "qy  :echo "copied to the register 1"<cr>
	vnoremap <leader>y2 "wy  :echo "copied to the register 2"<cr>
	vnoremap <leader>y3 "ey  :echo "copied to the register 3"<cr>
	vnoremap <leader>y4 "ry  :echo "copied to the register 4"<cr>
	vnoremap <leader>y5 "ty  :echo "copied to the register 5"<cr>
	vnoremap <leader>y6 "yy  :echo "copied to the register 6"<cr>
	vnoremap <leader>y7 "uy  :echo "copied to the register 7"<cr>
	vnoremap <leader>y8 "iy  :echo "copied to the register 8"<cr>
	vnoremap <leader>y9 "oy  :echo "copied to the register 9"<cr>
	vnoremap <leader>y0 "py  :echo "copied to the register 0"<cr>
	" append
	vnoremap <leader>y1 "Qy  :echo "copied to the register 1"<cr>
	vnoremap <leader>y2 "Wy  :echo "copied to the register 2"<cr>
	vnoremap <leader>y3 "Ey  :echo "copied to the register 3"<cr>
	vnoremap <leader>y4 "Ry  :echo "copied to the register 4"<cr>
	vnoremap <leader>y5 "Ty  :echo "copied to the register 5"<cr>
	vnoremap <leader>y6 "Yy  :echo "copied to the register 6"<cr>
	vnoremap <leader>y7 "Uy  :echo "copied to the register 7"<cr>
	vnoremap <leader>y8 "Iy  :echo "copied to the register 8"<cr>
	vnoremap <leader>y9 "Oy  :echo "copied to the register 9"<cr>
	vnoremap <leader>y0 "Py  :echo "copied to the register 0"<cr>

	nnoremap <leader>p1 "q]p  :echo "paste from the register 1"<cr>
	nnoremap <leader>p2 "w]p  :echo "paste from the register 2"<cr>
	nnoremap <leader>p3 "e]p  :echo "paste from the register 3"<cr>
	nnoremap <leader>p4 "r]p  :echo "paste from the register 4"<cr>
	nnoremap <leader>p5 "t]p  :echo "paste from the register 5"<cr>
	nnoremap <leader>p6 "y]p  :echo "paste from the register 6"<cr>
	nnoremap <leader>p7 "u]p  :echo "paste from the register 7"<cr>
	nnoremap <leader>p8 "i]p  :echo "paste from the register 8"<cr>
	nnoremap <leader>p9 "o]p  :echo "paste from the register 9"<cr>
	nnoremap <leader>p0 "p]p  :echo "paste from the register 0"<cr>

	" % 	relative path
	" %:p	full path
	" %:t	just filename

	" copy filepath to X11 clipboard
	nnoremap <leader>FP  :let @* = expand("%")<cr>:echo		"relative path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fp  :let @+ = expand("%")<cr>:echo		"relative path of the file copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FFP :let @* = expand("%:p")<cr>:echo		"full path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>ffp :let @+ = expand("%:p")<cr>:echo		"full path of the file copied to the X11 2nd clipboard"<CR>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		mouse mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" double click select all occurrences
" nnoremap <2-LeftMouse> *N
" inoremap <2-LeftMouse> <c-o>*N
" vnoremap <2-LeftMouse> *N
" TODO interface with indexed search plugin
" TODO Shift and/or Alt + 2 mouse click: goto tag

" triple click to toggle fold
nnoremap <3-LeftMouse> za
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Map to buttons
nnoremap <C-w>H :call TmuxResize('h', 1)<CR>
nnoremap <C-w>J :call TmuxResize('j', 1)<CR>
nnoremap <C-w>K :call TmuxResize('k', 1)<CR>
nnoremap <C-w>L :call TmuxResize('l', 1)<CR>
"				Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"				Plugins														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
if has("nvim")
	" Autocomplete for nvim (needs python3)
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'zchee/deoplete-clang'	" show functions arguments, slows down j/k
	" Plug 'Rip-Rip/clang_complete'
	"Plug 'wellle/tmux-complete.vim'	" autocomplete text from tmux buffer (eg git commit hash)
else
	Plug 'Shougo/neocomplete.vim' " Needs Lua
endif
"Plug 'Shougo/neoinclude.vim', {'for': 'c,cpp'}	" headers autocomplete
Plug 'Shougo/echodoc.vim'	" show functions in commad line window (:) insted of in preview
Plug 'Shougo/neopairs.vim'	" Auto insert pairs when complete done
"Plug 'ervandew/supertab'

"Plug 'Shougo/neosnippet-snippets'	" needed for neosnippet
"Plug 'Shougo/neosnippet.vim' 		" dodatak za neocomplete
"Plug 'garbas/vim-snipmate' 		" autocomplete for loops and etc

Plug 'vim-airline/vim-airline'		" fancy status and tabbar
"Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'			" fuzzy file/buffer/MRU finder
Plug 'bogado/file-line'				" open file.txt:123
Plug 'dietsche/vim-lastplace'		" Open file at last edit position
Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'ntpeters/vim-better-whitespace'	" show red block when there is a trailing whitespace

Plug 'kshenoy/vim-signature'		" show marks visually
"Plug 'romgrk/winteract.vim'
Plug 'ronakg/quickr-preview.vim'	" preview file without opening

"Plug 'tpope/vim-speeddating'		" Ctrl-A/X now works on dates	XXX TODO

"Plug 'vim-scripts/taglist.vim'		" list functions
Plug 'majutsushi/tagbar'			" show tags in the window at the right


Plug 'ciaranm/securemodelines'
"Plug 'rking/ag.vim'			" multifile grep - faster version of ack
Plug 'mileszs/ack.vim'			" ack plugin, but for 'ag'
"Plug 'gcmt/taboo.vim'			" rename tabs XXX don't work with CtrlSpace and AirLine
"Plug 'ronakg/quickr-cscope.vim'" cscope XXX
Plug 'brookhong/cscope.vim'		" cscope
Plug 'rhysd/vim-clang-format'

"Plug 'tpope/vim-characterize'	" show dec/hex/oct for char under the cursos, (ga), unicode style
" čć


"Plug 'tpope/vim-fugitive'		" plugin on GitHub repo
"Plug 'airblade/vim-gitgutter'	" Show +-~ left of number column
Plug 'mhinz/vim-signify'		" svn, git, ...


Plug 'xolox/vim-misc'				" Needed for easytags and vim-session
Plug 'xolox/vim-easytags'			" XXX XXX XXX XXX XXX fucking slow on work PC
"Plug 'Raimondi/delimitMate'		" automatic closing quotes, brackets, ...  remaps <BS>
Plug 'scrooloose/nerdcommenter'		" comments
Plug 'scrooloose/nerdtree',		{ 'on': 'NERDTreeToggle' }	" project tree (file explorer)
"Plug 'jistr/vin-nerdtree-tabs' 	" Nerdtree for all tabs
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'scrooloose/syntastic'		" synthax checker in the window at the bottom
Plug 'godlygeek/tabular'			" aligning/tabulating text
Plug 'regedarek/ZoomWin'			" toggle between one window and multi-window (Ctrl-W o)	newer version than vim-scripts
"Plug 'terryma/vim-multiple-cursors'		" rename var at multiple places at once	 INFO not really useful for me (Vim's ways are OK for me)
Plug 'tpope/vim-unimpaired'				" TODO
" Plug 'gioele/vim-autoswap'
" Plug 'chrisbra/NrrwRgn'				" plugin for focussing on a selected region
" Plug 'MarcWeber/vim-addon-mw-utils'	" Needed for snipmate
" Plug 'tomtom/tlib_vim'				" Needed for snipmate
"Plug 'dyng/ctrlsf.vim'				" search and replace in multiple files
Plug 'vim-scripts/a.vim'		" open headers
"Plug 'jez/vim-superman'		" man pages
"Plug 'xolox/vim-session'		" won't restore multiple buffers in a tab
" Plug 'Shougo/vimproc.vim'		" Needed for vim shell
" Plug 'Shougo/vimshell.vim'

Plug 'vim-ctrlspace/vim-ctrlspace'	" tabs/buffer/file management, sessions, bookmarks		:CtrlSpaceGo{Up,Down}
"Plug '~/.vim/plugged/vim-ctrlspace2'
Plug 'sheerun/vim-polyglot'			" A collection of language packs for Vim. won't affect your startup time
Plug 'easymotion/vim-easymotion'	" leader leader and magic begins
Plug 'myusuf3/numbers.vim'		" disable relative numbers in insert mode and other windows


"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-endwise'
"Plug 'hyiltiz/vim-plugins-profile'
"Plug 'vim-scripts/gitignore'
"Plug 'mattn/webapi-vim' 	" needed for comment
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-sleuth'

" programming plugins
Plug 'tpope/vim-commentary'

"Plug 'mmozuras/vim-github-comment'
"Plug 'spolu/dwm.vim'
"Plug 'chriskempson/base16'
"Plug 'jiangmiao/auto-pairs'
"Plug 'junegunn/vim-easy-align'
"Plug 'matze/vim-move'
"Plug 'tpope/vim-projectionist'

"Plug 'mtth/scratch.vim'
"Plug 'vim-scripts/c.vim'
"Plug 'mhinz/vim-startify'
"Plug 'zhaocai/GoldenView.Vim'
Plug 'vim-scripts/AutoTag'
"Plug 'ludovicchabant/vim-gutentags' " XXX uspori kad krene sortirat tagove
"Plug 'gilligan/vim-lldb'
"Plug 'LucHermitte/vim-refactor'
"Plug 'xmementoit/vim-ide'
"Plug 'tpope/vim-markdown'
"Plug 'plasticboy/vim-markdown'

Plug 'tpope/vim-obsession'	" restore session, needed for tmux ressurect

"			themes 															{{{
"Plug 'edkolev/tmuxline.vim'	" enable tmux to pickup Vim airline style
Plug 'tpope/vim-vividchalk'
Plug 'gosukiwi/vim-atom-dark'	" not-to-high contrast
Plug 'lisposter/vim-blackboard'	" pretty ugly
Plug 'dracula/vim'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'jpo/vim-railscasts-theme'
Plug 'morhetz/gruvbox'				" too little contrast
Plug 'chriskempson/tomorrow-theme'
Plug 'sheerun/vim-wombat-scheme'
Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'sjl/badwolf'
" Plug 'vim-scripts/asu1dark.vim'
" Plug 'vim-scripts/borland.vim'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

Plug 'vim-scripts/tinymode.vim'

Plug 'kien/rainbow_parentheses.vim'
Plug 'vim-scripts/TagHighlight'	" color typedefs as variables
Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'ryanoasis/vim-devicons'		" fonts
Plug 'vim-scripts/Workspace-Manager'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				Plugins setup												{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"		deoplete 															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has ('nvim')
	" NeoVim autocomplete
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#enable_ignore_case = 1	" ignore case
	let g:deoplete#enable_smart_case = 1	" but use smart case
	"let g:deoplete#enable_camel_case = 1 " INFO only with deoplete-matcher*fuzzy
	let g:neocomplete#enable_fuzzy_completion = 1
	" let g:deoplete#auto_complete_start_length = 1	" default: 2
	" let g:deoplete#auto_complete_start_length = 1	" deprecated
	let g:deoplete#source#attribute#min_pattern_length = 1
	"let g:deoplete#max_abbr_width = 0 " disable, default: 80
	"-> is added
	let g:deoplete#delimiters = ['/', '.', '::', ':', '#', '->']
	" let g:deoplete#max_list = 20					" max number of items in list
	" let g:deoplete#auto_complete_delay = 20		" ms, default 150, still slow
	let g:deoplete#auto_complete_delay = 1		" ms, default 150, still slow

	"let g:deoplete#sources = {} " init of the variable
	"let g:deoplete#sources._ = ['buffer'] " default files
	"let g:deoplete#sources.cpp = ['buffer', 'tag']
	"let g:deoplete#sources.cpp = ['buffer']			" + deoplete-clang
	"let g:deoplete#sources.c = ['buffer', 'tag']
	"let g:deoplete#sources.h = ['buffer', 'tag']

	if s:uname == "FreeBSD"
		let g:deoplete#sources#clang#libclang_path = "/usr/local/llvm38/lib/libclang.so"
		let g:deoplete#sources#clang#clang_header = "/usr/local/llvm38/include/clang"
	endif
	if s:uname == "Linux"
		let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-3.6/lib/libclang.so"
		let g:deoplete#sources#clang#clang_header = "/usr/include/clang/"
	endif
	" "let g:deoplete#sources#clang#flags = '-Wall'
	let g:deoplete#sources#clang#std#c = 'c11'
	let g:deoplete#sources#clang#std#cpp = 'c++11'
	" let g:deoplete#sources#clang#sort_algo = 'priority'

	" let g:deoplete#tag#cache_limit_size = 50000000 " 50 MB
	call deoplete#custom#set('_', 'matchers', ['matcher_length', 'matcher_full_fuzzy'])	" don't auto complete basing on the first char

	let g:deoplete#sources#clang#sort_algo = 'priority'	" or alphabetical
	let g:echodoc_enable_at_startup = 1			" show info in cmd line instead in preview window
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		airline																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO reenable this when CtrlSpace can be disabled

" INFO nisam uspio nac da radi kao bez CtrlSpace (buffers on the left, tabs on
" the rigt)
" enable/disable enhanced tabline
" otherwise standard vim tabline will be shown
let g:airline#extensions#tabline#enabled = 1

" enable/disable displaying open splits per tab (only when tabs are opened). >
let g:airline#extensions#tabline#show_splits = 1

" switch position of buffers and tabs on splited tabline (c)
let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
" INFO doesn't seems to have any effect

" show tabline even when there is only one tab
let g:airline#extensions#tabline#show_buffers = 1
"
" enable/disable displaying tabs, regardless of number. (c)
" INFO will only be displayed if there is more than one tab
let g:airline#extensions#tabline#show_tabs = 1

" enable/disable display preview window buffer in the tabline. >
let g:airline#extensions#tabline#exclude_preview = 1

"let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
"let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
" INFO this will show "3.1 [No Name] for 3rd tab with one window (zero splits)

" enable/disable displaying tab type (far right) >
let g:airline#extensions#tabline#show_tab_type = 1

let g:airline#extensions#tabline#buffer_idx_mode = 1
" configure whether buffer numbers should be shown. >
"let g:airline#extensions#tabline#buffer_nr_show = 1
" INFO i bez ovoga nekako pokazuje brojeve, ako se ovo omoguci bit ce samo jos
" dodatno zasran ispis, npr 3. tab: 			3.1 3: [No Name]
" configure how buffer numbers should be formatted with |printf()|. >
let g:airline#extensions#tabline#buffer_nr_format = '%s: '

" configure the minimum number of buffers needed to show the tabline. >
let g:airline#extensions#tabline#buffer_min_count = 1


" configure the minimum number of tabs needed to show the tabline. >
let g:airline#extensions#tabline#tab_min_count = 0
" Note: this setting only applies when `show_buffers` is false.

" configure whether close button should be shown: >
let g:airline#extensions#tabline#show_close_button = 1
" configure symbol used to represent close button >
"let g:airline#extensions#tabline#close_symbol = 'X'


" enable/disable vim-ctrlspace integration >
let g:airline#extensions#ctrlspace#enabled = 1






let g:airline_detect_paste=1					" Show PASTE if in paste mode

" enable/disable syntastic integration
"let g:airline#extensions#syntastic#enabled = 1

"" XXX djeluje da ne radi:
"let g:airline#extensions#tabline#show_close_button = 1
"let g:airline#extensions#tabline#close_symbol = 'X'

" enable/disable vim-obsession integration
let g:airline#extensions#obsession#enabled = 1

" set marked window indicator string
let g:airline#extensions#obsession#indicator_text = '$'

" INFO fonts need to be installed, and xterm configured to use them, otherwise this won't work
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		Ctrl-Space															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin for tabs/buffers/file/sessions/bookmarks
" only used for binding buffers to specific tabs and saving that layout

" Should Vim-CtrlSpace change your default tabline to its own?
let g:CtrlSpaceUseTabline = 1	" default 1
let g:CtrlSpaceSymbols = { "File": "F", "CTab": "ct", "Tabs": "T" }
if executable("ag")
	let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

let g:CtrlSpaceUseUnicode = 0 " unicode will show just 1 and 2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		CtrlP																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<leader>o'	" override default Ctrl-P
let g:ctrlp_arg_map = 0			" Stop CtrlP from using Ctrl-O as his shortcut
" Disable Ctrl-o as CtrlP shortcut, he has better things to do
let g:ctrlp_prompt_mappings = {
			\ 'OpenMulti()':          [''],
			\ }

let g:ctrlp_max_height=30
" TODO provjerit
"let g:ctrlp_by_filename = 1
"let g:ctrlp_regex_search = 1
"let g:ctrlp_use_caching = 1

" Search from current directory instead of project root
let g:ctrlp_working_path_mode = 0

" This is already set in Vim's wildignore
" let g:ctrlp_custom_ignore = {
			" \ 'dir':  '\v[\/]\.(git|hg|svn)$',
			" \ 'file': '\v\.(exe|so|dll|o)$',
			" \ 'link': 'some_bad_symbolic_links',
			" \ }

" CtrlP Emacs shortcuts and some other
let g:ctrlp_prompt_mappings = {
	\ 'PrtBS()':				['<c-h>',	'<bs>',	'<c-]>'],
	\ 'PrtDelete()':			['<c-d>',	'<del>'],
	\ 'PrtDeleteWord()':		['<c-w>'],
	\ 'PrtClear()':				['<c-u>'],
	\ 'PrtSelectMove("j")':		['<c-n>',	'<c-j>',		'<down>'],
	\ 'PrtSelectMove("k")':		['<c-p>',	'<c-k>',		'<up>'],
	\ 'PrtSelectMove("t")':		['<a-a>',	'<Home>',		'<kHome>'],
	\ 'PrtSelectMove("b")':		['<a-e>',	'<End>',		'<kEnd>'],
	\ 'PrtSelectMove("u")':		['<a-b>',	'<PageUp>',		'<kPageUp>'],
	\ 'PrtSelectMove("d")':		['<a-f>',	'<PageDown>',	'<kPageDown>'],
	\ 'PrtHistory(-1)':			['<a-p>'],
	\ 'PrtHistory(1)':			['<a-n>'],
	\ 'AcceptSelection("e")':	['<c-m>',				'<cr>', '<2-LeftMouse>'],
	\ 'AcceptSelection("h")':	['<c-s>',	'<a-s>',	'<c-cr>'],
	\ 'AcceptSelection("t")':	[			'<a-t>'],
	\ 'AcceptSelection("v")':	['<c-v>',	'<a-v>',			'<RightMouse>'],
	\ 'ToggleFocus()':			['<s-tab>'],
	\ 'ToggleRegex()':			['<c-r>'],
	\ 'ToggleByFname()':		[''],
	\ 'ToggleType(1)':			['<tab>',	'<c-up>'],
	\ 'ToggleType(-1)':			['',		'<c-down>'],
	\ 'PrtExpandDir()':			[''],
	\ 'PrtInsert("c")':			['<MiddleMouse>', '<insert>'],
	\ 'PrtInsert()':			['<c-\>'],
	\ 'PrtCurStart()':			['<c-a>'],
	\ 'PrtCurEnd()':			['<c-e>'],
	\ 'PrtCurLeft()':			['<c-b>', '<left>', '<c-^>'],
	\ 'PrtCurRight()':			['<c-l>', '<right>'],
	\ 'PrtClearCache()':		['<a-r>', '<F5>'],
	\ 'PrtDeleteEnt()':			['<F7>'],
	\ 'CreateNewFile()':		['<c-y>'],
	\ 'MarkToOpen()':			['<c-z>'],
	\ 'OpenMulti()':			['<c-o>'],
	\ 'PrtExit()':				['<esc>', '<c-c>', '<c-g>'],
	\ }

let g:ctrlp_clear_cache_on_exit = 0	" Use F5 in CtrlP for refresh, calls CtrlPClear{,All}Caches
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
"let g:ctrlp_show_hidden = 1		" will not search .git because of wildignore
let g:ctrlp_max_files = 30000
let g:ctrlp_max_depth = 40			" max dirs
let g:ctrlp_match_current_file = 1	" show current file when searching

" MRU options
let g:ctrlp_mruf_max = 250
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'

" extension, should be enabled
let g:ctrlp_buftag_ctags_bin = ''

" CtrlP by default use OS find program. Use ag to respect .gitignore, tags,...
if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

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
let g:better_whitespace_filetypes_blacklist = ['help', 'Help', 'quickfix', 'vim-plug', 'man', 'diff']
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		indexed search														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO shows search 1 of 123
let g:indexed_search_center = 1			" center the screen, default 0
let g:indexed_search_max_lines = 10000	" default 3000
let g:indexed_search_shortmess = 1		" shorter messages, default 0
let g:indexed_search_dont_move = 1		" don't move to the next match
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		NERD commenter														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO:
" [count]<leader>cX
" cc	comment
" cn	comment, forced nesting
" cu	uncomment
" c<space>	toggle
" ci	invert
" cy	yanking + commenting
" c$	comment from the cursor to the end of line
" cA	add comment to the end of line and go to insert mode
" c{l,b}	aligned left/right

" add one space after the comment char
let NERDSpaceDelims=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		signature															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO visually shows Vim marks (and more)
" mx	toggle mark x
" dmx	delete mark x
" m,	place the next available mark
" m.	remove mark if exist, if not, add the next available marker
" m-	delete all marks from the current line
" m<space>	delete all marks from the current buffer
" ]' ['	jump to the next/prev mark
" m/	show marks in window below

" verbose maps:
"nnoremap m, m, :echo "Next available marker was added"<CR>

" functions:
" SignatureToggleSigns
" SignatureRefresh
" SignatureListBufferMarks [n]
" SignatureListGlobalMarks [n]
" SignatureListMarkers [marker] [n]

" Ctrl-W m to show marks
nnoremap <C-w>m :SignatureListBufferMarks<cr>
nnoremap <C-w>M :SignatureListGlobalMarks<cr>

" TODO guard
autocmd QuickFixCmdPost * pclose
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		speed dating														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO Ctrl-A/X working on dates

" XXX doesn't work

" need custom format for EU standard dates as 28.1.2011.
" help: SpeedDatingFormat to list all formats

 ""%Y-%m-%d                         2016-11-16
 "autocmd VimEnter *     TODO
augroup autogroup_speeddating
	autocmd!
	"SpeedDatingFormat %Y.%m.%d.
augroup END
" 2016.11.16.
" 2016-11-16
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		bufkill																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't create various <leader>b* mapping (which will slowdown <leader>b for CtrlPBuffer)
let g:BufKillCreateMappings = 0
" To move backwards/forwards through recently accessed buffers, use: :BB/:BF
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		git plugins															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO show +-~ on the left of line if line is added/removed/changed
" GitGutter{Enable,Disable,Toggle}
" update: GitGutter{,All}	current/all buffers
" keys: [c ]c goto prev/next


let g:gitgutter_enabled = 0				" default
"let g:gitgutter_highlight_lines = 1
" Required after having changed the colorscheme
"hi clear SignColumn


" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = 'x'
let g:gitgutter_sign_modified = 'm'
let g:gitgutter_sign_modified_removed = 'xm'


"let g:gitgutter_override_sign_column_highlight = 0
highlight GitGutterAdd			ctermfg=green	ctermbg=236
highlight GitGutterChange		ctermfg=14		ctermbg=236
highlight GitGutterDelete		ctermfg=red		ctermbg=236
highlight GitGutterChangeDelete	ctermfg=11		ctermbg=236


" TODO disable this plugin in non active split
" used only git and SVN
let g:signify_vcs_list = [ 'git', 'svn', 'hg' ]
let g:signify_update_on_focusgained = 0
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = 'm'
"let g:signify_sign_changedelete      = g:signify_sign_change
let g:signify_sign_show_count = 1
" TODO interface with indexed search
" INFO not nnoremap
nmap ]c <plug>(signify-next-hunk)zz
nmap [c <plug>(signify-prev-hunk)zz
nmap ]C <plug>(signify-next-hunk)
nmap [C <plug>(signify-prev-hunk)
" TODO wrap around if indexed search is active (now it just stop at the end which is not a bad thing)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		ack																	{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO ack Vim plugin but systems 'ag' binary will be used
" :AckAdd:		add results to the current search list in quickfix
" :AckWindow:	search current tab
if executable('ag')
	if s:uname == "FreeBSD"
		"let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore'
		let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore -H --column'
		" FreeBSD ag version 1.0.1
	elseif s:uname == "Linux"
		" Linux ag --version: 0.19.2
		let g:ackprg = 'ag'
		" TODO ack-grep?
	endif
endif

let g:ack_apply_qmappings = 0	" disable QuickFix mappings
let g:ack_apply_lmappings = 0
" let g:ack_mappings
" Default: {
	" \ "t": "<C-W><CR><C-W>T",
	" \ "T": "<C-W><CR><C-W>TgT<C-W>j",
	" \ "o": "<CR>",
	" \ "O": "<CR><C-W><C-W>:ccl<CR>",
	" \ "go": "<CR><C-W>j",
	" \ "h": "<C-W><CR><C-W>K",
	" \ "H": "<C-W><CR><C-W>K<C-W>b",
	" \ "v": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
	" \ "gv": "<C-W><CR><C-W>H<C-W>b<C-W>J" }
let g:ack_mappings = {
	\ "p": ":pedit ' . expand('<cfile>')"} " TODO open in preview window
let g:ackhighlight = 1		" highlight the searched term.
"let g:ack_autoclose = 1		" specify whether to close the quickfix window after using any of the shortcuts.
"let g:ack_autofold_results = 1	" fold results in QF window, they are be auto unfolder when cursor is on them
"let g:ackpreview = 1		" autopreview file under cursor
	" INFO default mapping must be enabled, not really preview but open
"let g:ack_use_dispatch = 1		" XXX syntax error when enabled
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		quickr-preview														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO show preview without opening

"let g:quickr_preview_keymaps = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		taboo																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO rename tabs XXX don't work with CtrlSpace (which manages Airline tabline)

" remember tab names after restore
"set sessionoptions+=tabpages,globals

let g:taboo_tabline = 0		" AirLine is OK for this purpose
let g:airline#extensions#taboo#enabled = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		clang-format														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO reformat code
let g:clang_format#command="clang-format-3.5"
let g:clang_format#code_style="mozilla"
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"		Syntastic															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO disable YCM checkers for this to work
let g:syntastic_always_populate_loc_list = 1	" auto populating window at the bottom
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=4	" size of the bottom window
let g:syntastic_error_symbol = "✗"
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

" Don't use GCC
let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_compiler_options = ' -Wall -std=c99'

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -Wall -std=c++11 -stdlib=libc++'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_include_dirs = ["includes", "headers"]

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
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
	"nnoremap <leader>a= :Tabularize /=<cr>
	"vnoremap <leader>a= :Tabularize /=<cr>
	"nnoremap <leader>a: :Tabularize /:\zs<cr>
	"vnoremap <leader>a: :Tabularize /:\zs<cr>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		EasyTags															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
"let g:easytags_dynamic_files = 2
"let g:easytags_resolve_links = 1
"let g:easytags_suppress_ctags_warning = 1
"let g:easytags_file = "~/.vim/tags"

"set regexpengine=1 " old engine, faster (maybe), no changes
let g:easytags_auto_highlight=0		" fix slowiness
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		delimitMate															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let delimitMate_expand_cr = 1
augroup mydelimitMate
	au!
	au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
	au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		NERDTree															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeChDirMode=2
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI = 1
"noremap <space> :NERDTreeToggle<cr>
"noremap <leader>. :NERDTreeFind<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		tinymode															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO
" TODO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" <leader>s search all buffers

"				GUI settings												{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
	"set lines=150 columns=230
	set guioptions -=T		" toolbar
	set guioptions -=r		" right scrollbar
	set guioptions -=L		" left scrollbar

	" gvim ispravno generira u fajlu ▸ ali ne i kad se stisne tab

	"Invisible character colors
	highlight NonText guifg=#2a4a59
	highlight SpecialKey guifg=#2a4a59

	set winaltkeys=no		" Turn off <Alt>/<Meta> pulling down GUI menu

	set showbreak=…		" char to be displayed on the beggining of broken line
	"set listchars=tab:\|·,eol:¬,trail:·
	" trail is not needed, plugin take care of that
	" TODO same font as xterm
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" 					colors and TERM setup									{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colors as sublime
colorscheme molokai
"colorscheme badwolf
"colorscheme dracula

highlight Todo			ctermfg=196 ctermbg=232
highlight Debug			ctermfg=226 ctermbg=234

" color of tw bar at right (funny color for bad LCD panels)
"highlight ColorColumn ctermbg=93 guibg=DarkMagenta
let g:color_ColorColumn = 234 " must be global (otherwise function ToggleColorColumn won't see it)
execute "highlight ColorColumn ctermbg=".color_ColorColumn
highlight clear ColorColumn		" disable on default

" highlight all afer 80 chars
let &colorcolumn=join(range(81,999),",")
" double highlight, 80 and 120 chars:
"let &colorcolumn="80,".join(range(120,999),",")

highlight VertSplit		ctermfg=202 ctermbg=232

" change color of tab chars (:set list)
highlight SpecialKey	ctermfg=236

" change concel to match background
highlight Conceal		ctermfg=7 ctermbg=233

" longer vertical bar for vertical splits, space for folds (default was -)
set fillchars=vert:\│,fold:\ 

" change the colors in diff mode
highlight DiffAdded		ctermfg=81
highlight DiffRemoved	ctermfg=208

" auto completion menu
highlight pmenu			ctermfg=white ctermbg=52

" hide ANSCI escape chars
syntax match Ignore /\%o33\[[0-9]\{0,5}m/ conceal

" ugly but easier to read
highlight Comment		ctermfg=101

"highlight ExtraWhitespace ctermbg=202
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				custom functions											{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! AppendModeline() " {{{
	let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d foldmethod=%s %set :", &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
function! CursorEdge()	" {{{
	" check if cursor is EDGE_LINES from end of the screen
	let l:CURSOR_EDGE = 5
	let l:from_start = winline()
	let l:max_lines = winheight(0)
	let l:from_end = winheight(0) - winline()
	echo l:from_start l:from_end l:max_lines

	if l:from_start < l:CURSOR_EDGE || l:from_end < l:CURSOR_EDGE
		echo "Cursor is near the edge"
		nnoremap * *<Plug>(indexed-search-*)zz
		nnoremap # #<Plug>(indexed-search-#)zz
		nnoremap n n<Plug>(indexed-search-n)zz
		nnoremap N N<Plug>(indexed-search-N)zz
		nnoremap / /<Plug>(indexed-search-/)zz
		nnoremap ? ?<Plug>(indexed-search-?)zz
	else
		echom "Cursor"
		nnoremap * *<Plug>(indexed-search-*)
		nnoremap # #<Plug>(indexed-search-#)
		nnoremap n n<Plug>(indexed-search-n)
		nnoremap N N<Plug>(indexed-search-N)
		nnoremap / /<Plug>(indexed-search-/)
		nnoremap ? ?<Plug>(indexed-search-?)
	endif
	" XXX uzima u obzir trenutnu lokaciju kursora, a ne gdje se nalazi iduci hit
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

" TODO combo with indexed_search
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
" http://vim.1045645.n5.nabble.com/Check-if-highlight-exists-and-not-quot-cleared-quot-td1185235.html
func! HlExists(hl)
		if !hlexists(a:hl)
			return 0
		endif
		redir => hlstatus
		exe "silent hi" a:hl
		redir END
		return (hlstatus !~ "cleared")
endfunc

function! ToggleColorColumn()
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"" Add set path=.,<relative include dir> for searching for header in particular directories. For more information do ":help file-searching".

" open tag in a new tab TEST modified line
"map <C-\> :tab split<cr>:exec("tag ".expand("<cword>"))<CR>
" this is remapped to C-]
" open tag in a new split
" XXX will open split when tag is not found
"map <A-]> :vsp <cr>:exec("tag ".expand("<cword>"))<CR>

" cscope "																	{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('cscope')
	" include cscope when searching for tag (Ctrl-])
	" show verbose info when loading cscope DB
	set cscopetag cscopeverbose

	if has('quickfix')
		set cscopequickfix=s-,c-,d-,i-,t-,e-
	endif

	command! -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src

	nnoremap <leader>fs :cs find s <C-r><C-w><cr>:echo "cscope searching symbol"<cr>
	nnoremap <leader>fg :cs find g <C-r><C-w><cr>:echo "cscope searching definition"<cr>
	nnoremap <leader>fd :cs find g <C-r><C-w><cr>:echo "cscope searching definition"<cr>
	"nnoremap <leader>fd :cs find d <C-r><C-w><cr>:echo "cscope searching functions called by"<cr>
	nnoremap <leader>fC :cs find d <C-r><C-w><cr>:echo "cscope searching functions called by"<cr>
	nnoremap <leader>fc :cs find c <C-r><C-w><cr>:echo "cscope searching functions calling this"<cr>
	nnoremap <leader>ft :cs find t <C-r><C-w><cr>:echo "cscope searching text"<cr>
	nnoremap <leader>ff :cs find f <C-r><C-w><cr>:echo "cscope searching file"<cr>
	nnoremap <leader>fh :cs find i <C-r><C-w><cr>:echo "cscope searching header/include"<cr>
	nnoremap <leader>fa :cs find a <C-r><C-w><cr>:echo "cscope searching where assigned"<cr>
	nnoremap <C-g> :cs find find c <C-r><C-w><cr>:echo "cscope searching functions calling this"<cr>

	let g:cscope_silent = 1	" don't show message when autoupdating DB
endif

" Ctrl-\ to jump to the tag (like Ctrl-] but easier to type on ANSI keyboard)
" nnoremap <C-\> :tag <C-r><C-w><cr>
" from help:
map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" " work specific stuff														{{{
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:work_pc=system('is_work_pc')
" let g:work_dir=system('is_work_dir')

" if work_pc == 1
	" set list

	" if work_dir == 1
		" " expand only if we are working on work stuff
		" set expandtab
		" highlight clear ColorColumn	" don't color background after textwidth
	" endif
" endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" tab jumps to the previous active window
" TODO make this to call wincmd w when there is no previous active window
" 		maybe <expr> if window nubmer greater than X/there is next window
" 		then...
" TODO skip syntastic window
nnoremap <tab> :wincmd p<cr>
" TODO S-Tab jump to "special" windows - syntastic, quick fix, ...


" TODO
" when Ag quickfix window is active: <space> (or p) for preview file (now is "go")
" Ag ignore: .o tags
" when quickfix is active: Ctrl-W c should close main buffer and quickfix
" put cursor at the end of the pasted part

" tab_complete example " 													{{{
""I'm using tab for cycling over the items in a completion menu (instead of c-n). But I also use tab when there is no completion menu to expand a snippet, and jump to the next placeholder inside the snippet. So the tab key needed some love:
"function! s:tab_complete()
  "" is completion menu open? cycle to next item
  "if pumvisible()
	"return "\<c-n>"
  "endif

  "" is there a snippet that can be expanded?
  "" is there a placholder inside the snippet that can be jumped to?
  "if neosnippet#expandable_or_jumpable()
	"return "\<Plug>(neosnippet_expand_or_jump)"
  "endif

  "" if none of these match just use regular tab
  "return "\<tab>"
"endfunction
" from https://github.com/fatih/dotfiles/blob/master/vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"imap <silent><expr><TAB> <SID>tab_complete()
" U in visual mode will convert to UPPERCASE
" 10| will move to the 10-th column
" g* like * but will not search only whole words
" C-W T window to tab
" gx open an URL/image/something from Vim
" q/ open search history in command window
" // to quickly search again, works in substitution mode also (s//b/g)
" :lcd	cd only for current window

" TODO :help sort

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


" TODO replace <C-r><C-w> shortcuts with expand('<cword>')
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" move split to tab: Ctrl-W T
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
" font {{{
" another patched font
" mkdir -p ~/.local/share/fonts
" cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf

" }}}


" variables:
" % - buffer (or file) TODO
" ^ - alternate file
" TODO :h pattern-atoms

" Vim debug:
" vim -V9myVimLog
" TODO ag sredit da nema praznu liniju ispod svake korisne u quickfix
" TODO C-w c da zatvori cijeli tab (ukljucujus sve splitove i quickfix window) -> :tabclose
" TODO napravit da oboja jednako i TODO2
" TODO remember highlight state after reloading vimrc
" TODO n (next match) skip if the next match is line after cursor
" TODO if normal mode and highlight search is active: <esc> to turn off highlighting
" TODO <leader>n toggle relative numbers and numbers plugin
" TODO hide ^M in dos files (or at least dont paint them red)
" TODO map ]p only in .c and .h files
" TODO K to show tag in preview window, another K to close preview window (:pclose)
" INFO moglo bi bit korisno jednog dana: "&& bufname("%") != "[Command Line]"

" TODO make :BD plays nice with CtrlSpace and buffers per tab
" INFO CtrlSpaceSaveWorspace would work OK for ctrl-space tabs and buffers
" TODO even full and default CtrlSpace wont recognize multiple buffers when vim file1.txt file2.txt (and CtrlSpaceGoUp/Down won't work)

" kopirat listchars u novi vimrc
" show leading whitespaces
" setlocal conceallevel=2 concealcursor=nv
" syn match LeadingWS /\(^\s*\)\@<=\s/ conceal cchar=·
" XXX and this will also change how tabs are showed
" INFO highlight ALL whitespace (and tabs): /\s
" INFO highlight all whitespace at hte beggining: /^<space>
" sctrach buffer: enew (buffer withou file)
" TODO yank da bude zapravo set paste mode, set ono da poravna (]p) i onda nopaste
" TODO jump to header under cursor
" TODO q for close if it's last file/window in Vim
" TODO code snippets
" TODO dont' autocomplete second " in Vim (probably some plugin)
" INFO set paste! will realign folds text
" TODO Ag skip tags file
" TODO disable swap file in paste mode (otherwise very slow on copying multiple lines)
" TODO <Tab>/<C-i> switch window if there are multiple windows, othervise normal Ctrl-I
" TODO another '*' should disable highlight
" TODO <enter> - if it's link under cursor then "gx", if it's tag under cursor then :tag... othervise "o"

" INFO cscope cmd: cscope -R -b
" XXX something disables WhiteSpace after reloading vimrc
" See :help function-list for a high-level overview of vimscript functions.

" vim: set ts=4 sw=4 tw=0 foldmethod=marker noet :
