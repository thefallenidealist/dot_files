-- 201029
-- 201120 updated to newer LSP

local g = vim.g		-- global variables from VimScript

require'lspconfig'.clangd.setup			{on_attach=require'completion'.on_attach}
require'lspconfig'.pyls.setup			{on_attach=require'completion'.on_attach}
require'lspconfig'.rust_analyzer.setup	{on_attach=require'completion'.on_attach}
require'lspconfig'.cmake.setup { config = { filetypes = { "cmake", "CMakeLists.txt" } }}
require'lspconfig'.bashls.setup{}
-- require'lspconfig'.diagnosticls.setup { config = { filetypes = { "sh" }}}
-- Rust LSP: only in cargo projects, otherwise rust-project.json needs to be " provided

--- disable diagnostics:
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

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
