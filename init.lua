-- 201029
-- 201120 updated to newer LSP
require'lspconfig'.clangd.setup			{on_attach=require'completion'.on_attach}
require'lspconfig'.pyls.setup			{on_attach=require'completion'.on_attach}
require'lspconfig'.rust_analyzer.setup	{on_attach=require'completion'.on_attach}
require'lspconfig'.cmake.setup { config = { filetypes = { "cmake", "CMakeLists.txt" } }}
require'lspconfig'.bashls.setup{}
require'lspconfig'.diagnosticls.setup { config = { filetypes = { "sh" }}}

--- disable diagnostics:
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- treesitter																{{{
-------------------------------------------------------------------------------
-- 201121
-- require'nvim-treesitter.configs'.setup {
-- 	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
-- 	highlight = {
-- 		enable = true,              -- false will disable the whole extension
-- 		disable = { "c", "rust" },  -- list of language that will be disabled
-- 	},
-- }
--------------------------------------------------------------------------- }}}
