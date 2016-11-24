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
set exrc		" source .vimrc file if it present in working directory
set secure		" This option will restrict usage of some commands in non-default .vimrc files; commands that wrote to file or execute shell commands are not allowed and map commands are displayed.

" TODO disable modeline for root
"":set modelines=0
"":set nomodeline

set matchpairs+=<:>	" Include angle brackets in matching.

" Xorg paste with middle click
if !has('nvim')
	set ttymouse=xterm2
endif

set gdefault "applies substitutions globally on lines. For example, instead of :%s/foo/bar/g you just type :%s/foo/bar/

"set completeopt=menu,menuone,preview
set completeopt=menuone,preview		" default
set noshowmode                  "Don't show the mode(airline is handling this)
""""""""""""""""""""""""""""""""""""""""
"		<tab> and wrapping
""""""""""""""""""""""""""""""""""""""""
" soft wrap
set wrap			" soft break when line is wider than Vim window (not tw)
set linebreak		" break line without breaking the word
					" wont't work when "list" is enabled

" hard break
"set tw=80			" autowrap after N chars
set colorcolumn=+1	" show coloumn where autowrap will start"
set formatoptions=""
		" default: tcq
		" t: autowrap using tw
		" c: add comment in new line a: format line every time when it is
		" changed (no more longer or shorter lines) 		pretty annoying

set tabstop=4		" tab size
set shiftwidth=4 	" when indenting with '>'
"set expandtab		" convert tab to spaces

""""""""""""
set shortmess-=I	" don't show intro	XXX seems that is doesn't work
set cursorline		" color the line when the cursor is

" shell like autocompletition of commands
"set wildmode=longest,list,full
" bash like
set wildmenu
"set wildmode=longest,list	" at first tab show all comands
" When you type the first tab hit will complete as much as possible, the second tab hit will provide a list, the third and subsequent tabs will cycle through completion options so you can complete the file without further keys
set wildmode=list:longest,list,full
" Don't complete this file types
set wildignore+=*.a,*.o,*.elf,*.bin,*.dd,*.img
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp

if !has('gui_running')
	set showbreak=…		" char to be displayed on the beggining of broken line
	"set listchars=tab:\|·,eol:¬,trail:·
	" trail is not needed, plugin take care of that
endif

" show invisible characters, tab is longer (unicode) pipe char
set listchars=tab:\│·,extends:>,precedes:<
" show ALL spaces:
" set listchars+=space:║
"set listchars+=trail:◊

"set nolist "default: not showing invisible chars
set list

" directory for swap files
set directory=$HOME/.vim/swap/,/tmp
" place for: filename.txt~
set backupdir=$HOME/.vim/swap/,/tmp
"		search						{{{
"""""""""""""""""""""""""""""""""""""""
set ignorecase		" case insensitive search, needed for the line below
set smartcase		" If searched word starts with an uppercase then ... TODO
set incsearch		" search as you type
" for caseinsensitive search /something\c
set showmatch
set hlsearch        " highlight search
""""""""""""""""""""""""""""""""""""}}}
"		spell						{{{
"""""""""""""""""""""""""""""""""""""""
" INFO ViM zajeb: Don't use _ in file name
set spellfile=~/.vim/spelluser.utf-8.add
"set spelllang=~/.vim/spell/hr.utf-8.spl,en	" hr i en spell check zajedno TODO
setlocal spell spelllang=en_us
"setlocal spell spelllang=en_us,hr	" TODO hr
set nospell
" set complete+=kspell
""""""""""""""""""""""""""""""""""""}}}
"		build/programming			{{{
"""""""""""""""""""""""""""""""""""""""
set makeprg=gmake\ -C\ ../build\ -j4
" TODO <leader> rr
nnoremap <F5> :w<cr>:!clear && cc % -o %.elf && ./%.elf<CR>
" F5 mejka i pokrene trenutni program
nnoremap <F5> :<C-U>silent make %:r<cr>:redraw!<CR>:!./%:r<CR>
" compat with PCmanFM	XXX: inserts 'e' after calling
nnoremap <F4> :!xterm&<cr>redraw<CR>
" TODO if Makefile exists, then just call make

" za gF komandu koja otvori fajl pod kursorom
let &path.="src/include,/usr/include/AL,"

" XXX XXX XXX only work in first buffer
" Highlight TODO, FIXME, NOTE, etc. FIXME:
" if has("autocmd")
	" if v:version > 701
		" autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|ZAJEB\)')
		" autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
		" autocmd Syntax * call matchadd('Debug', '\W\zs\(INFO_START\|INFO_END\|ERROR\|DEBUG_START\|DEBUG_END\|DEBUG_INFO\)')
	" endif
" endif

set tags=tags;

set binary	" TODO
set equalalways
""""""""""""""""""""""""""""""""""""}}}


" hide ANSCI escape chars
syntax match Ignore /\%o33\[[0-9]\{0,5}m/ conceal

set conceallevel=2	" hide until cursor is on that line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		autocmd																{{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup my_group_with_a_very_uniq_name
	" this is executed every time when vimrc is sourced, so clear it at the beggining:
	autocmd!

	autocmd Filetype man NumbersDisable
	" Filetype only works on first time opening the help window
	autocmd Filetype help NumbersDisable
	autocmd BufEnter help norelativenumber
	autocmd BufEnter help IndentLinesDisable
	" TODO FixWhiteSpace is controler from its option

	" map q as kill only in help window
	autocmd Filetype help nnoremap <buffer> q :wincmd c<cr>
	" unmap enter in help and man window
	autocmd Filetype help nnoremap <buffer> <cr> <cr>
	autocmd Filetype man nnoremap <buffer> <cr> <cr>

	" unmap enter in QuickFix window (window at the bottom which isn't preview)
	autocmd BufReadPost quickfix nnoremap <buffer> <cr> <cr>
	"autocmd BufReadPost quickfix nnoremap <buffer> q :q<cr>
	" autocmd FileType quickfix nnoremap <buffer> q :q<cr>
	" INFO qf and quickfix aren't the same
	autocmd FileType qf nnoremap <buffer> q :q<cr>

	" force Vim to threat .md files as markdown and not Modula
	" or use tpope/vim-markdown plugin
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	" don't match < in C++ (cout << "Something";)
	autocmd Filetype cpp,make,vim set matchpairs-=<:>
	autocmd Filetype shell set matchpairs-=`:`	" works, but only in reverse

	" in case I ever open a python file
	autocmd Filetype python set expandtab

	" hide all ^M in DOS file
	" INFO this need conceallevel higher than 1
	"autocmd Filetype * syntax match Ignore /\r$/ conceal containedin=ALL
	" autocmd Filetype * FixDos
augroup END

" setup when in diff mode:
if &diff
	cabbrev q qa!
	nnoremap q :qa!<cr>
endif
""""""""""""""""""""""""""""""""""""}}}
"				keymaps
"		cmd aliases						{{{
"""""""""""""""""""""""""""""""""""""""""""
" INFO all abbrev commands are non recursive
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

if exists(":PlugInstall")
	" vim-plug
	cabbrev	pi PlugInstall
	cabbrev pu PlugUpdate
endif
if exists(":PluginInstall")
	" Vundle
	cabbrev	pi PluginInstall
	cabbrev pu PluginUpdate
endif

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

" close all folds
cabbrev foldcloseall %foldclose!
cabbrev foldca %foldclose!
cabbrev fca %foldclose!
cabbrev foa %foldopen!
"because standard Vim fold shortcuts are starting with z
cabbrev zca %foldclose!
cabbrev zoa %foldopen!

iabbrev adn and
""""""""""""""""""""""""""""""""""""""""}}}
"		generic mappings				{{{
"""""""""""""""""""""""""""""""""""""""""""
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
nnoremap zi zi:echo "fold all toggle"<cr>
nnoremap za za:echo "fold current toggle"<cr>
nnoremap zc zc:echo "fold current close"<cr>
nnoremap zR zR:echo "fold all open"<cr>
nnoremap zM zM:echo "fold all close"<cr>
" INFO it's seems that this will cause problems for indexed-search (N)
"nnoremap zv zv :echo "fold reveal cursor"<cr>
nnoremap <space> za

" don't quit visual mode after first indent/deindent
vnoremap < <gv
vnoremap > >gv

" deindent from insert mode
inoremap <S-Tab> <C-o><<
" INFO maybe more useful shortcut for window management
nnoremap <S-Tab> <<

" auto-complete 'fix'
" Enter for breaking autocomplete (when it's active)
inoremap <expr><cr>		pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"
inoremap <expr><tab> 	pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><S-tab>	pumvisible() ? "\<C-p>" : "\<S-tab>"
""""""""""""""""""""""""""""""""""""""""}}}
"		buffers/windows/tabs keymaps	{{{
"""""""""""""""""""""""""""""""""""""""""""
nnoremap tn :tabnew<cr>
nnoremap th :tabprev<cr>
nnoremap tl :tabnext<cr>
" XXX very short message duration time
nnoremap - :tabprev<cr>:echom "going to the previous tab"<cr>
nnoremap + :tabnext<cr>:echom "going to the next tab"<cr>
"nnoremap = :tabnext<cr>


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

" move tab to the left/right
nnoremap tH :tabmove -1<cr>
nnoremap tL :tabmove +1<cr>

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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		Emacs shortcuts					{{{
"""""""""""""""""""""""""""""""""""""""""""
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
" awww, memories    XXX
"map <C-x> <C-s>    :write<cr>
"map <C-x> <C-c>    :quit<cr>
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
"		hardko mode						{{{
"""""""""""""""""""""""""""""""""""""""""""
nnoremap <Left>		:echoe "Use h"<cr>
nnoremap <Right>	:echoe "Use l"<cr>
nnoremap <Up>		:echoe "Use k"<cr>
nnoremap <Down>		:echoe "Use j"<cr>

" Fix for cursors keys when Esc is remapped
nnoremap <esc>[ <esc>[

" breaking the habit
imap <C-c> <C-o>:echoe "Use esc, bogajebo"<cr>
""""""""""""""""""""""""""""""""""""""""}}}
" TODO better, check if highlight is active (HOW?):
nnoremap <silent> <esc> :noh<cr><esc>:echo "hlsearch disabled"<cr>
"		leader mappings					{{{
"""""""""""""""""""""""""""""""""""""""""""
" muliple leader (just in case, not really needed in my case):
"nmap , \
"nmap <space> \ " won't work because space is used for fold toggle

"temporarily disable search highlighting until the next search.
" INFO this is NOT the same as set nohlsearch
nnoremap <leader>h :noh<cr>
nnoremap <leader>s :set spell!<cr>
" toggle showing invisible chars
nnoremap <leader>l :set list!<cr>:set list?<CR>
nnoremap <leader>n :set relativenumber!<cr>
"nnoremap <leader>n :set relativenumber!<cr>:set number!<CR>
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
""""""""""""""""""""""""""""""""""""""""}}}
"		leader plugin mappings			{{{
"""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <leader>f :NERDTreeToggle<cr>
nnoremap <leader>c :SyntasticToggleMode<cr>
nnoremap <leader>o :CtrlP<cr>
nnoremap <leader>m :CtrlPMRUFiles<cr>
nnoremap <leader>M :CtrlPMixed<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
" Open a new tab and search for something
map <leader>a :tab split<cr>:Ag ""<Left>
"Immediately search for the word under the cursor in a new tab
map <leader>A :tab split<cr>:Ag <C-r><C-w><CR>

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
""""""""""""""""""""""""""""""""""""""""}}}

"		copy paste mappings				{{{
"""""""""""""""""""""""""""""""""""""""""""
" paste and indent
" this will sometimes fail
nnoremap p ]p
nnoremap P ]P
" TODO try this
"nnoremap p p=`]
" TODO enter paste mode, ]p, exit paste mode

if has('clipboard')	" not really needed for all options under this
	" copy paste from system clipboard (second X11 buffer - Ctrl-C/V)
	" p paste after the cursor
	" P paste before the cursor INFO not used here

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
	vnoremap <leader>y "+y :echo "copied to the X11 2nd clipboard"<cr>
	" faster, do not wait
	vnoremap <leader>yy "+y :echo "copied to the X11 2nd clipboard"<cr>
	vnoremap <leader>d "+d :echo "cutted to the X11 2nd clipboard"<cr>
	vnoremap <leader>x "+d :echo "cutted to the X11 2nd clipboard"<cr>
	nnoremap <leader>p "+p :echo "pasted from the X11 2nd clipboard"<cr>
	vnoremap <leader>p "+p :echo "pasted from the X11 2nd clipboard"<cr>

	" Easier copy/paste to the named registers
	" INFO this will slowdown copy to the X11 clipboard (<leader>y)
	" TODO better naming (it's not a register 1 but q)
	" TODO :set paste [y/d/p] :set nopaste
	nnoremap <leader>y1 "qyy :echo "current line copied to the register 1"<cr>
	nnoremap <leader>y2 "wyy :echo "current line copied to the register 2"<cr>
	nnoremap <leader>y3 "eyy :echo "current line copied to the register 3"<cr>
	nnoremap <leader>y4 "ryy :echo "current line copied to the register 4"<cr>
	nnoremap <leader>y5 "tyy :echo "current line copied to the register 5"<cr>
	nnoremap <leader>y6 "yyy :echo "current line copied to the register 6"<cr>
	nnoremap <leader>y7 "uyy :echo "current line copied to the register 7"<cr>
	nnoremap <leader>y8 "iyy :echo "current line copied to the register 8"<cr>
	nnoremap <leader>y9 "oyy :echo "current line copied to the register 9"<cr>
	nnoremap <leader>y0 "pyy :echo "current line copied to the register 0"<cr>

	vnoremap <leader>y1 "qy  :echo "selected text copied to the register 1"<cr>
	vnoremap <leader>y2 "wy  :echo "selected text copied to the register 2"<cr>
	vnoremap <leader>y3 "ey  :echo "selected text copied to the register 3"<cr>
	vnoremap <leader>y4 "ry  :echo "selected text copied to the register 4"<cr>
	vnoremap <leader>y5 "ty  :echo "selected text copied to the register 5"<cr>
	vnoremap <leader>y6 "yy  :echo "selected text copied to the register 6"<cr>
	vnoremap <leader>y7 "uy  :echo "selected text copied to the register 7"<cr>
	vnoremap <leader>y8 "iy  :echo "selected text copied to the register 8"<cr>
	vnoremap <leader>y9 "oy  :echo "selected text copied to the register 9"<cr>
	vnoremap <leader>y0 "py  :echo "selected text copied to the register 0"<cr>

	nnoremap <leader>p1 "q]p  :echo "something pasted from the register 1"<cr>
	nnoremap <leader>p2 "w]p  :echo "something pasted from the register 2"<cr>
	nnoremap <leader>p3 "e]p  :echo "something pasted from the register 3"<cr>
	nnoremap <leader>p4 "r]p  :echo "something pasted from the register 4"<cr>
	nnoremap <leader>p5 "t]p  :echo "something pasted from the register 5"<cr>
	nnoremap <leader>p6 "y]p  :echo "something pasted from the register 6"<cr>
	nnoremap <leader>p7 "u]p  :echo "something pasted from the register 7"<cr>
	nnoremap <leader>p8 "i]p  :echo "something pasted from the register 8"<cr>
	nnoremap <leader>p9 "o]p  :echo "something pasted from the register 9"<cr>
	nnoremap <leader>p0 "p]p  :echo "something pasted from the register 0"<cr>


	" ": unnamed register (dd/yy)
	" *: X11 primary	  (select/middle click)
	" +: X11 secondanry   (Ctrl-C/V)

	" % 	relative path
	" %:p	full path
	" %:t	just filename

	" copy filepath to X11 clipboard
	nnoremap <leader>FP  :let @* = expand("%")<cr>:echo		"relative path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>fp  :let @+ = expand("%")<cr>:echo		"relative path of the file copied to the X11 2nd clipboard"<CR>
	nnoremap <leader>FFP :let @* = expand("%:p")<cr>:echo		"full path of the file copied to the X11 1st clipboard"<CR>
	nnoremap <leader>ffp :let @+ = expand("%:p")<cr>:echo		"full path of the file copied to the X11 2nd clipboard"<CR>
endif
""""""""""""""""""""""""""""""""""""""""}}}
"		mouse mappings														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" double click select all occurrences
nnoremap <2-LeftMouse> *N
inoremap <2-LeftMouse> <c-o>*N
vnoremap <2-LeftMouse> *N
" TODO interface with indexed search plugin

" TODO Shift and/or Alt + 2 mouse click: goto tag
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				Plugins
"				Plugins														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
"Plug 'Valloric/YouCompleteMe'
if has("nvim")
	" Autocomplete for nvim (needs python3)
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	"Plug 'zchee/deoplete-clang'	" show functions arguments
	" INFO run this after installing :UpdateRemotePlugs
else
	"Plug 'Shougo/neocomplete.vim' " Needs Lua
endif
" INFO ne svidja mi se bas, nekad zna bit previse pametan i iritantan,
" svejedno ne pokazuje argumente funkcijama
"Plug 'justmao945/vim-clang'   " complete after . -> ::

"Plug 'Shougo/neosnippet.vim' 	" dodatak za neocomplete
"Plug 'Shougo/neosnippet-snippets' " needed for neosnippet
"Plug 'Shougo/echodoc.vim'  " show preview in echo area

Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'			" fuzzy file/buffer/MRU finder
Plug 'bogado/file-line'			" open file.txt:123
Plug 'dietsche/vim-lastplace'		" Open file at last edit position
Plug 'qpkorr/vim-bufkill'			" kill buffer without killing split :BD :BW
Plug 'henrik/vim-indexed-search'	" show search as: result 123 of 456
Plug 'kshenoy/vim-signature'		" show marks visually
"Plug 'romgrk/winteract.vim'
" buggy as fuck
"Plug 'Yggdroot/indentLine'		" show chars instead of leading spaces (not tabs)
"Plug 'tpope/vim-speeddating'		" Ctrl-A/X now works on dates	XXX TODO

"Plug 'vim-scripts/taglist.vim'		" list functions
Plug 'majutsushi/tagbar'			" show tags in the window at the right



Plug 'ciaranm/securemodelines'
Plug 'rking/ag.vim'			" multifile grep - faster version of ack

"Plug 'tpope/vim-characterize'	" show dec/hex/oct for char under the cursos, (ga), unicode style


"Plug 'vim-scripts/ZoomWin'		" toggle between one window and multi-window (Ctrl-W o)
Plug 'tpope/vim-fugitive'			" plugin on GitHub repo
Plug 'airblade/vim-gitgutter'	" Show +-~ left of number column

Plug 'xolox/vim-misc'				" Needed for easytags and vim-session
"Plug 'xolox/vim-easytags'			" TODO
Plug 'Raimondi/delimitMate'		" automatic closing quotes, brackets, ...
Plug 'scrooloose/nerdcommenter'	" comments
"Plug 'drmikehenry/vim-fixkey'	" INFO experimental fix Alt-key
" Project tree (file explorer) in the window at the left
Plug 'scrooloose/nerdtree',		{ 'on': 'NERDTreeToggle' }
"Plug 'jistr/vin-nerdtree-tabs' 	" Nerdtree for all tabs
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'scrooloose/syntastic'		" synthax checker in the window at the bottom
Plug 'godlygeek/tabular'			" aligning/tabulating text
Plug 'regedarek/ZoomWin'			" toggle between one window and multi-window (Ctrl-W o)	newer version than vim-scripts
"Plug 'terryma/vim-multiple-cursors'		" rename var at multiple places at once
Plug 'bronson/vim-trailing-whitespace'	" show red block when there is a trailing whitespace  :FixWhiteSpace
Plug 'tpope/vim-unimpaired'				" TODO
Plug 'gioele/vim-autoswap'
Plug 'chrisbra/NrrwRgn'				" plugin for focussing on a selected region
Plug 'MarcWeber/vim-addon-mw-utils'	" Needed for snipmate
Plug 'tomtom/tlib_vim'				" Needed for snipmate
"Plug 'garbas/vim-snipmate' 	" autocomplete for loops and etc
"Plug 'bling/vim-bufferline' 	" show the list of buffers in the command bar
" INFO not needed, airline already covered that
Plug 'dyng/ctrlsf.vim'		" Like sublimes Ctrl-Shift-f
"Plug 'edkolev/tmuxline.vim'	" enable tmux to pickup Vim airline style
Plug 'vim-scripts/a.vim'		" open headers
Plug 'jez/vim-superman'		" man pages
Plug 'altercation/vim-colors-solarized'
"Plug 'xolox/vim-session'		" won't restore multiple buffers in a tab
Plug 'Shougo/vimshell.vim'

" INFO autocomplete playground
"Plug 'ervandew/supertab' 			" use <Tab> for autocomplete

Plug 'vim-ctrlspace/vim-ctrlspace'	" tabs/buffer/file management, sessions, bookmarks		:CtrlSpaceGo{Up,Down}
"Plug '~/.vim/plugged/vim-ctrlspace2'
Plug 'sheerun/vim-polyglot'			" A collection of language packs for Vim. won't affect your startup time
Plug 'easymotion/vim-easymotion'		" leader leader and magic begins

Plug 'sheerun/vim-wombat-scheme'		" colorscheme
Plug 'ChrisKempson/Tomorrow-Theme'

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

"			themes
Plug 'tpope/vim-vividchalk'
Plug 'gosukiwi/vim-atom-dark'
Plug 'lisposter/vim-blackboard'	" colortheme, pretty ugly
Plug 'dracula/dracula-theme'
Plug 'tomasr/molokai'
"Plug 'justinmk/molokai' " previse svijetla bg
Plug 'chriskempson/base16-vim'
Plug 'jpo/vim-railscasts-theme'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/tomorrow-theme'




Plug 'kien/rainbow_parentheses.vim'
Plug 'myusuf3/numbers.vim'		" disable relative numbers in insert mode and other windows
Plug 'vim-scripts/TagHighlight'	" color typedefs as variables

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				Plugins setup												{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"		YCM conf					{{{
"""""""""""""""""""""""""""""""""""""""
"let g:ycm_min_num_of_chars_for_completion = 2	" default 2
"let g:ycm_error_symbol = 'x>'
"let g:ycm_warniing_symbol = 'w>'
"let g:ycm_enable_diagnostic_signs = 1	" fall back to the value of the 'g:syntastic_enable_signs' option
"let g:ycm_enable_diagnostic_highlighting = 1	" fall back to the value of the 'g:syntastic_enable_highlighting'
"let g:ycm_collect_identifiers_from_comments_and_strings = 0	" default: 0
"let g:ycm_collect_identifiers_from_tags_files = 1	" default: 0
"" INFO exctags -R --fields=+l
"let g:ycm_add_preview_to_completeopt = 1	" show function preview INFO doesn't seem that changes anything
"" completeopt already have a preview
"let g:ycm_autoclose_preview_window_after_completion = 1	" default: 0
"let g:ycm_autoclose_preview_window_after_insertion = 1	" default: 0
"" INFO iritantno bude kad se doda Enter, Enter nece napravit novi red nego togglat selekciju
""let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']	" Added Enter
"" Shift-TAB. That mapping will probably only work in GUI Vim (Gvim or MacVim) and not in plain console Vim because the terminal usually does not forward modifier key combinations to Vim.
"let g:ycm_complete_in_comments=1
"let g:ycm_key_invoke_completion = '' " manual invoke, default <C-Space>
"let g:ycm_key_detailed_diagnostics = '' " :YcmShowDetailedDiagnostic default: '<leader>d'
"" config file to use when there is no local .ycm_extra_conf.py:
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
""let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py' " doesn't exist
""let g:ycm_confirm_extra_conf = 0	" don't ask for permission to loader local conf default 1
"let g:ycm_extra_conf_globlist = ['~/c/*','!/tmp/*']
	"" load conf from ~/c folder, but don't load from /tmp/
	"" ycm_confirm_extra_conf should be 1 for this to work
"let g:ycm_use_ultisnips_completer = 1	" default: 1
""let g:ycm_goto_buffer_command = 'horizontal-split' "default: 'same-buffer'
							"" INFO goto declaration is better in the same buffer

""let g:ycm_open_loclist_on_ycm_diags = 1	" This should open XXX todo FixIt
"" TODO YCM instead Syntastic - error checking on the fly instead on save
"" TODO YCM + UltiSnips
""let g:clang_c_completeopt = 'preview,longest,menuone'

""""""""""""""""""""""""""""""""""""}}}
"		deoplete "					{{{
"""""""""""""""""""""""""""""""""""""""
" NeoVim autocomplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1	" ignore case
let g:deoplete#enable_smart_case = 1	" but use smart case
"let g:deoplete#enable_camel_case = 1 " INFO only with deoplete-matcher*fuzzy
let g:neocomplete#enable_fuzzy_completion = 1
" let g:deoplete#auto_complete_start_length = 1	" default: 2
let g:deoplete#auto_complete_start_length = 2
"let g:deoplete#max_abbr_width = 0 " disable, default: 80
"-> is added
let g:deoplete#delimiters = ['/', '.', '::', ':', '#', '->']

"let g:deoplete#sources = {} " init of the variable
"let g:deoplete#sources._ = ['buffer'] " default files
"let g:deoplete#sources.cpp = ['buffer', 'tag']
"let g:deoplete#sources.c = ['buffer', 'tag']
"let g:deoplete#sources.h = ['buffer', 'tag']

" deoplete-clang
"let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-3.6/lib/libclang.so"
"let g:deoplete#sources#clang#clang_header = "/usr/include/clang/"
""""""""""""""""""""""""""""""""""""}}}
"		airline						{{{
"""""""""""""""""""""""""""""""""""""""
" TODO reenable this when CtrlSpace can be disabled

" INFO nisam uspio nac da radi kao bez CtrlSpace (buffers on the left, tabs on
" the rigt)
" enable/disable enhanced tabline
" otherwise standard vim tabline will be shown
let g:airline#extensions#tabline#enabled = 1

" enable/disable displaying open splits per tab (only when tabs are opened). >
let g:airline#extensions#tabline#show_splits = 1

" switch position of buffers and tabs on splited tabline (c)
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
" INFO doesn't seems to have any effect

" enable/disable displaying buffers with a single tab. (c)
" show tabline even when there is only one tab
let g:airline#extensions#tabline#show_buffers = 1
"
" enable/disable displaying tabs, regardless of number. (c)
" INFO will only be displayer if there is more than one tab
let g:airline#extensions#tabline#show_tabs = 1

" enable/disable display preview window buffer in the tabline. >
let g:airline#extensions#tabline#exclude_preview = 1

" enable/disable displaying tab number in tabs mode
let g:airline#extensions#tabline#show_tab_nr = 1
" configure how numbers are displayed in tab mode
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

""""""""""""""""""""""""""""""""""""}}}
"		Ctrl-Space					{{{
"""""""""""""""""""""""""""""""""""""""
" Should Vim-CtrlSpace change your default tabline to its own?
let g:CtrlSpaceUseTabline = 1	" default 1

" Plugin for tabs/buffers/file/sessions/bookmarks
" only used for binding buffers to specific tabs
" TODO UTF8
let g:CtrlSpaceSymbols = { "File": "F", "CTab": "ct", "Tabs": "T" }
if executable("ag")
	let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif
" custom tabline
let g:CtrlSpaceUseTabline = 1
"" *ctrlspace-single-mode*
" Displays only buffers related to the current tab. By related I mean
""""""""""""""""""""""""""""""""""""}}}

"		lastplace															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO reopen files where you left off
let g:lastplace_open_folds = 1 " auto open folder, default: 1
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		FixWhiteSpace															{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO highlight trailing spaces in red
" disable plugin on this filetypes
let g:extra_whitespace_ignored_filetypes = ['help', 'Help', 'quickfix', 'vim-plug', 'man', 'diff']
" XXX still will work on help filetype
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		indexed search														{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO shows search 1 of 123
let g:indexed_search_center = 1 " center the screen, default 0
let g:indexed_search_max_lines = 10000 " default 3000
let g:indexed_search_shortmess = 1 " shorter messages, default 0
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"		tagbar																{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO shows tags (variables, enums, typedes, functions on the windows on the right)
" :TagbarToggle
" :TagbarOpenAutoClose - useful for jumping to the function (with preview window)
let g:tagbar_width = 50	" default: 40
"let g:tagbar_zoomwidth = 0	" default: 0 (Use the width of the longest currently visible tag)
"let g:tagbar_autoclose = 1	" default: 0
let g:tagbar_autofocus = 1	" auto jump to the Tagbar	default: 0
let g:tagbar_sort = 0		" default: 1
let g:tagbar_show_linenumbers = 2	" show relative
"let g:tagbar_singleclick = 1
let g:tagbar_iconchars = ['►', '▼']	" changed first symbol because powerline font
let g:tagbar_previewwin_pos = "aboveleft"
" Don't show numbers in preview window
autocmd BufWinEnter * if &previewwindow | setlocal nonumber norelativenumber | endif
let g:tagbar_autopreview = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


"		clang						{{{
"""""""""""""""""""""""""""""""""""""""
let g:clang_auto = 1	" auto complete after -> . ::
let g:clang_exec = 'clang-3.6'
""""""""""""""""""""""""""""""""""""}}}
"		CtrlP						{{{
"""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<leader>o'	" disable default Ctrl-P
"let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_arg_map = 0		" Stop CtrlP from using Ctrl-O as his shortcut
" Disable Ctrl-o as CtrlP shortcut, he has better things to do
let g:ctrlp_prompt_mappings = {
			\ 'OpenMulti()':          [''],
			\ }

" don't let ctrlp take over the screen!
let g:ctrlp_max_height=30
" TODO provjerit
"let g:ctrlp_by_filename = 1
"let g:ctrlp_regex_search = 1
"let g:ctrlp_use_caching = 1

" Search from current directory instead of project root
let g:ctrlp_working_path_mode = 0

"let g:ctrlp_user_command = 'find %s -type f'	" Use a custom file listing command
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']	" Ignore files in .gitignore

" This is already set in Vim's wildignore
let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(exe|so|dll|o)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }


" CtrlP Emacs shortcuts
" INFO older shortcuts with used keys need to be removed
" TODO mozda jos nesta, zasad samo "j" i "k" dodani Emacs
let g:ctrlp_prompt_mappings = {
			\ 'PrtBS()':              ['<bs>', '<c-]>'],
			\ 'PrtDelete()':          ['<del>'],
			\ 'PrtDeleteWord()':      ['<c-w>'],
			\ 'PrtClear()':           ['<c-u>'],
			\ 'PrtSelectMove("j")':   ['<c-n>', '<c-j>', '<down>'],
			\ 'PrtSelectMove("k")':   ['<c-p>', '<c-k>', '<up>'],
			\ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
			\ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
			\ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
			\ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
			\ 'PrtHistory(-1)':       [''],
			\ 'PrtHistory(1)':        [''],
			\ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
			\ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
			\ 'AcceptSelection("t")': ['<c-t>'],
			\ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
			\ 'ToggleFocus()':        ['<s-tab>'],
			\ 'ToggleRegex()':        ['<c-r>'],
			\ 'ToggleByFname()':      ['<c-d>'],
			\ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
			\ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
			\ 'PrtExpandDir()':       ['<tab>'],
			\ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
			\ 'PrtInsert()':          ['<c-\>'],
			\ 'PrtCurStart()':        ['<c-a>'],
			\ 'PrtCurEnd()':          ['<c-e>'],
			\ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
			\ 'PrtCurRight()':        ['<c-l>', '<right>'],
			\ 'PrtClearCache()':      ['<F5>'],
			\ 'PrtDeleteEnt()':       ['<F7>'],
			\ 'CreateNewFile()':      ['<c-y>'],
			\ 'MarkToOpen()':         ['<c-z>'],
			\ 'OpenMulti()':          ['<c-o>'],
			\ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
			\ }

let g:ctrlp_clear_cache_on_exit = 0	" Use F5 in CtrlP for refresh, calls CtrlPClear{,All}Caches
									" TODO remap this to something that is not F5 or use manual function
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_show_hidden = 1	" will not search .git because of wildignore
let g:ctrlp_max_files = 30000
let g:ctrlp_max_depth = 40	" max dirs
let g:ctrlp_match_current_file = 1	" show current file when searching

" MRU options
let g:ctrlp_mruf_max = 250
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*' " MacOSX/Linux


" extension, should be enabled
let g:ctrlp_buftag_ctags_bin = ''

" TODO Ctrl-S open in split (instead Ctrl-X)
" TODO ignore .o
""""""""""""""""""""""""""""""""""""}}}
"		Syntastic					{{{
"""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""}}}
"		ag	The Silver Searcher		{{{
"""""""""""""""""""""""""""""""""""""""
if executable('ag')
	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	"let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'
	" INFO well, mine is not lightining fast

	" ag is fast enough that CtrlP doesn't need to cache
	"LET g:ctrlp_use_caching = 0

	if !exists(":Ag")
		command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
		"nnoremap \ :Ag<SPACE>
	endif
endif
""""""""""""""""""""""""""""""""""""}}}
"		Golden View					{{{
"""""""""""""""""""""""""""""""""""""""
" 1. split to tiled windows
"nnoremap <C-;>  <Plug>GoldenViewSplit
"nnoremap <C-;>  <Plug>GoldenViewSplit

" 2. quickly switch current window with the main pane
" and toggle back
"nnoremap <F8>   <Plug>GoldenViewSwitchMain
"nnoremap <S-F8> <Plug>GoldenViewSwitchToggle

" 3. jump to next and previous window
"nnoremap <C-w>n  <Plug>GoldenViewNext
"nnoremap <C-w>p  <Plug>GoldenViewPrevious
""""""""""""""""""""""""""""""""""""}}}
"		multicursor					{{{
let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='D'
let g:multi_cursor_prev_key='<c-p>'
let g:multi_cursor_skip_key='<c-x>'
let g:multi_cursor_quit_key='<c-c>'
""""""""""""""""""""""""""""""""""""}}}
"		indentLine					{{{
"""""""""""""""""""""""""""""""""""""""
" INFO plugin that will show indenting spaces (for tabs use builtin Vim's listchars)
" TODO this is one plugin with some magic behaviour
"let g:indentLine_loaded = 1 " XXX holy Jeebus on a stick, this will actually disable the plugin
            "sdfsdffss TEST

let g:indentLine_enabled = 1
let g:indentLine_leadingSpaceEnabled = 1 " first space on the line
let g:indentLine_leadingSpaceChar = '¦'
let g:indentLine_char = '¦'
"let g:indentLine_first_char = '¦'
"let g:indentLine_leadingSpaceChar = '·'
"let g:indentLine_color_term = 239	" default
"let g:indentLine_color_term = 197
"let g:indentLine_concealcursor = 'inc' " default
"let g:indentLine_conceallevel = 2 " default

"let g:indentLine_char = '┊'	" like subl2
"let g:indentLine_indentLevel=1
""""""""""""""""""""""""""""""""""""}}}
"		git plugins					{{{
"""""""""""""""""""""""""""""""""""""""
" INFO show +-~ on the left of line if line is added/removed/changed
" GitGutter{Enable,Disable,Toggle}
" update: GitGutter{,All}	current/all buffers
" keys: [c ]c goto prev/next


let g:gitgutter_enabled = 1				" default
"let g:gitgutter_highlight_lines = 1
let g:gitgutter_sign_modified_removed = 'xx'
" Required after having changed the colorscheme
hi clear SignColumn

" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" TODO disable in non active split
""""""""""""""""""""""""""""""""""""}}}
"		Tabularize					{{{
"""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""}}}
"		EasyTags					{{{
"""""""""""""""""""""""""""""""""""""""
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
"let g:easytags_dynamic_files = 2
"let g:easytags_resolve_links = 1
"let g:easytags_suppress_ctags_warning = 1
let g:easytags_file = "~/.vim/tags"

if system("uname") == "FreeBSD"
	let g:tagbar_ctags_bin=system("which exctags")
endif
""""""""""""""""""""""""""""""""""""}}}
"		delimitMate					{{{
"""""""""""""""""""""""""""""""""""""""
"let delimitMate_expand_cr = 1
augroup mydelimitMate
	au!
	au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
	au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END
""""""""""""""""""""""""""""""""""""}}}
"		NERDTree					{{{
"""""""""""""""""""""""""""""""""""""""
let g:NERDTreeChDirMode=2
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI = 1
"noremap <space> :NERDTreeToggle<cr>
"noremap <leader>. :NERDTreeFind<cr>
""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" 					colors and TERM setup									{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colors as sublime
" INFO need to be after plugin load
colorscheme molokai
" original molokai bg
"let g:molokai_original = 1
" make cterm close as possible to GUI version
"let g:rehash256 = 1 " too bright

set t_Co=256	" already set, probably in a theme file

" for base16 theme (and green linenubmers)
let base16colorspace=256

" INFO need to be after loading the theme
" Search         xxx term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792
highlight Todo	term=standout	cterm=bold ctermfg=196 ctermbg=232 gui=bold guifg=#FFFFFF guibg=bg
highlight Debug 				cterm=bold ctermfg=226 ctermbg=234 gui=bold guibg=Purple
"highlight Search term=reverse			   ctermfg=0   ctermbg=222 guifg=#000000 guibg=#FFE792

" color of tw bar at right
highlight ColorColumn ctermbg=93 guibg=DarkMagenta

"highlight CursorLine     term=underline ctermbg=235 guibg=#293739	" default
" change background
" INFO this will fuckup colors, need to be set in a theme file, default is 233. 234 is a little darker
"highlight Normal ctermbg=234

"		  VertSplit xxx term=reverse cterm=bold ctermfg=244 ctermbg=232 gui=bold guifg=#808080 guibg=#080808
highlight VertSplit		term=reverse cterm=bold ctermfg=202 ctermbg=232 gui=bold guifg=#808080 guibg=#080808

" change color of tab chars (:set list)
highlight SpecialKey	ctermfg=236 gui=italic guifg=#465457
"highlight SpecialKey	ctermfg=95 gui=italic guifg=#465457

" change concel to match background
"Conceal        xxx ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
highlight Conceal	ctermfg=7 ctermbg=233 guifg=LightGrey guibg=DarkGrey


"set fillchars=vert:|,fold:- " default
"set fillchars=vert:\│,fold:·
" longer vertical bar for vertical splits, space for folds
set fillchars=vert:\│,fold:\ 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
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
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"				custom functions											{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! AppendModeline()
	let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d foldmethod=%s %set :", &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"function! s:CursorEdge()	" 's:' for script (vimrc in this case) function only
function! CursorEdge()	" 's:' for script (vimrc in this case) function only
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" visual mode */#
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" TODO combo with indexed_search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't show ^M in DOS files
command! FixDos edit ++ff=dos
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INFO toggle between ^ and 0
function! ZeroMove()
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

if executable('ag')
	" Note we extract the column as well as the file and line number
	set grepprg=ag\ --nogroup\ --nocolor\ --column
	" f file name
	" l line number
	" c column number
	" m error message
	" TODO dosredit ovo da ne pokazuje novu liniju izmedju fajlova u quickfix windowu
	set grepformat=%f:%l:%c%m

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

"Improve your efficiency further by remapping the keys for jumping through search matches (stored in the "quickfix" list):		:cnext:w
"" Add set path=.,<relative include dir> for searching for header in particular directories. For more information do ":help file-searching".

" open tag in a new tab
map <C-\> :tab split<cr>:exec("tag ".expand("<cword>"))<CR>
" TODO korisno, al dosredit
map <A-]> :vsp <cr>:exec("tag ".expand("<cword>"))<CR>

"		work specific stuff												{{{
let g:work_pc=system('is_work_pc')
let g:work_dir=system('is_work_dir')

if work_pc == 1
	set list

	if work_dir == 1
		" expand only if we are working on work stuff
		set expandtab
	endif
endif
"=======================================================================}}}

" tab jumps to the previous active window
" TODO make this to call wincmd w when there is no previous active window
" 		maybe <expr> if window nubmer greater than X/there is next window
" 		then...
" TODO skip syntastic window
nnoremap <tab> :wincmd p<cr>
" TODO S-Tab jump to "special" windows - syntastic, quick fix, ...


" TODO
" when Ag quickfix window is active: <space> for preview file (now is "go")
" Ag ignore: .o tags
" when quickfix is active: Ctrl-W c should close main buffer and quickfix
" put cursor at the end of the pasted part


"" TODO <leader>cn to uncomment {{{
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

"imap <silent><expr><TAB> <SID>tab_complete()
"		useful stuff													}}}
"		useful stuff													{{{
" U in visual mode will convert to UPPERCASE
" 10| will move to the 10-th column
" g* like * but will not search only whole words
" C-W T window to tab
" gx open an URL/image/something from Vim
" q/ open search history in command window
" ccl[ose]  close QuickFix window
" // to quickly search again, works in substitution mode also (s//b/g)
" :lcd	cd only for current window

"=======================================================================}}}
" TODO :help sort

" programmers vim 															{{{
"#############################################################################
" @: repeat last : command
" @@ for next repeat
" Just type & to repeat the last substitution on the current line. You can repeat it on all lines by typing g&.
" "*]p	paste from * register, and the indent with the current line
" Ctrl-R '1p	paste from the first register in insert mode

" Ctrl-W } show variable/function in a preview window
" Ctrl-W ] open a tag in a split windows	TODO open in a vsp instead split
" :pc	close preview window
" C delete to the end of the line and go to insert mode

" quick fix list prev/next: 	[q	]q
" prev/next file:				[f	]f
" prev/next misspell			[s	]s
" prev/next file in args list	[a	]a (A for first/last)

" ga: show char under the cursor in decimal, hex, and oct, for unicode: tpope/vim-characterize XXX works without plugin
" gCtrl-] If there is only one match, it will take you there. If there are multiple matches, it will list them all, letting you choose the one you want, just like :tselect

" multiple files load: args files*.c
" multiple replace: TODO

" yank until mark a: y'a
" '. goto place of last edit

" reselect last visually selected block: gv
"##########################################################################}}}
" tips and tricks 															{{{
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

" zz put current line on the middle of the screen
" zt put current line on the top of the screen
" zb put current line on the bottom of the screen

" file/IO redirection
" redirect to file:
	" :redir > /tmp/file
	" :highlight (or something else, eg: :set all)
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

" Vim debug:
" vim -V9myVimLog
"
" TODO ag sredit da nema praznu liniju ispod svake korisne u quickfix
" TODO C-w c da zatvori cijeli tab (ukljucujus sve splitove i quickfix window) -> :tabclose
" TODO napravit da oboja jednako i TODO2
" TODO remember highlight state after reloading vimrc
" TODO n (next match) skip if the next match is line after cursor
" TODO if normal mode and highlight search is active: <esc> to turn off highlighting
" TODO <leader>n toggle relative numbers and numbers plugin
" TODO hide ^M in dos files (or at least dont paint them red)
" TODO map ]p only in .c and .h files
" TODO 0 vrati na prvi char, ako je vec na prvom charu neka 0 vrati na pravi
" pocetak
" TODO (line 145) fix highlight IDEA and similiar in new buffer also
" TODO K to show tag in preview window, another K to close preview window (:pclose)
" INFO moglo bi bit korisno jednog dana: "&& bufname("%") != "[Command Line]"
" TODO <enter> to clear highlighter search if active


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
" TODO Ag skip tags file

" vim: set ts=4 sw=4 tw=0 foldmethod=marker noet :
