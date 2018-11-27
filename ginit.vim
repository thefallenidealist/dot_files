" created 171214
" config file for nvim-qt (used on Windows)

GuiFont! DejaVu Sans Mono for Powerline:h10

" 181114 don't use GUI tabbar which is default in nvim v0.3.2
GuiTabline 0
" 181114 don't use GUI menu for autocomplete
GuiPopupmenu 0

" start neovim-gt.exe maximized (only on Windows):
call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
