-- 201029
-- 201120 updated to newer LSP

local g = vim.g		-- global variables from VimScript

-- LSP																		{{{
-------------------------------------------------------------------------------
if g.lsp_enabled == 1 then
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end		--- disable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,	-- disable inline diagnostics
		signs = true,			-- enable signs in signcolumn
	}
)

-- signcolumn/gutter symbols
vim.fn.sign_define("LspDiagnosticsSignError",		{text = "x" , texthl = "LspDiagnosticsVirtualTextError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",		{text = "w" , texthl = "LspDiagnosticsVirtualTextWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",	{text = "i" , texthl = "LspDiagnosticsVirtualTextHint"})
vim.fn.sign_define("LspDiagnosticsSignHint",		{text = "h" , texthl = "LspDiagnosticsVirtualTextHint"})

-- neovim/nvim-lspconfig
-- language servers setup													{{{
-------------------------------------------------------------------------------
-- pkg install llvm-devel-13
require'lspconfig'.clangd.setup {
	name = 'clangd',
	cmd = {'clangd-devel'},
}
-- pip install cmake-language-server
require'lspconfig'.cmake.setup{}

-- pkg install rust-analyzer
require'lspconfig'.rust_analyzer.setup{}
--------------------------------------------------------------------------- }}}
-- floating windows borders													{{{
-------------------------------------------------------------------------------
-- neovim 0.5 as of 210413
vim.lsp.handlers["textDocument/hover"] =
	vim.lsp.with(
	vim.lsp.handlers.hover,
	{
		border = "single"
	}
)

vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{
		border = "single"
	}
)

vim.api.nvim_exec(
[[
	highlight FloatBorder	ctermfg=202 ctermbg=234
]], false)

-- vim.cmd [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>]]
--------------------------------------------------------------------------- }}}
-- LSP autocomplete - nvim-compe											{{{
-------------------------------------------------------------------------------
-- 210415
vim.o.completeopt = "menuone,noselect"
vim.g.UltiSnipsExpandTrigger = '<f23>'	-- leave triggering to LSP autocomplete

require'compe'.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'enable';
	throttle_time = 80;
	source_timeout = 200;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = true;

	source = {
		path = true;
		buffer = true;
		calc = false;
		nvim_lsp = true;
		nvim_lua = true;
		ultisnips = true;
	};
}

-- complete with tab/shift-tab												{{{
-------------------------------------------------------------------------------
-- CP from https://github.com/hrsh7th/nvim-compe#how-to-use-tab-to-navigate-completion-menu
local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return true
	else
		return false
	end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-n>"
	-- elseif vim.fn.call("vsnip#available", {1}) == 1 then
	-- 	return t "<Plug>(vsnip-expand-or-jump)"
	elseif check_back_space() then
		return t "<Tab>"
	else
		return vim.fn['compe#complete']()
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-p>"
	-- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
	-- 	return t "<Plug>(vsnip-jump-prev)"
	else
		return t "<S-Tab>"
	end
end

vim.api.nvim_set_keymap("i", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--------------------------------------------------------------------------- }}}
--------------------------------------------------------------------------- }}}

end
--------------------------------------------------------------------------- }}}

-- treesitter																{{{
-------------------------------------------------------------------------------
-- 200722, 201121
if g.treesitter_enabled == 1 then
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true,					-- false will disable the whole extension
		-- disable = { "c", "rust" },	-- list of language that will be disabled
		ignore_install = { "javascript", "haskell" }, -- List of parsers to ignore installing
	},
}
end
--------------------------------------------------------------------------- }}}
-- telescope																{{{
-------------------------------------------------------------------------------
-- 210409

local actions = require('telescope.actions')	-- needed for mappings
require('telescope').setup{
	defaults = {
		prompt_position = "top",
		sorting_strategy = "ascending",
		prompt_prefix = "--> ",
		-- initial_mode = "insert",
		layout_strategy = 'flex',	-- swap to vertical if not enoguh space
		layout_defaults = {
			horizontal = {
				width_padding = 0.1,
				height_padding = 0.05,
				preview_width = 0.5,
			},
		},
		file_ignore_patterns = { 'tags' },
		mappings = {
			i = {
				["<M-t>"] = actions.select_tab,	-- custom, <C-t> is used for tmux
				-- ["<C-y>"] = actions.select_tab,	-- custom, <C-t> is used for tmux
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				-- ["<esc>"] = actions.close,	-- disable normal mode, exit on first esc
			},
			n = {
				-- ["<esc>"] = actions.close,
				-- ["q"]     = actions.close,	-- will override <esc> above
			},
		},
	}
}
--------------------------------------------------------------------------- }}}
--------------------------------------------------------------------------- }}}
