-- 201029
-- 201120 updated to newer LSP
-- require'lspconfig'.clangd.setup{on_attach=on_attach}
require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}

-- vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

-- require'lspconfig'.rust_analyzer.setup{on_attach=on_attach}
-- require'lspconfig'.cmake.setup { config = { filetypes = { "cmake", "CMakeLists.txt" } }}
-- require'lspconfig'.bashls.setup{}
-- require'lspconfig'.diagnosticls.setup { config = { filetypes = { "sh" }}}

--- disable diagnostics:
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- treesitter																{{{
-------------------------------------------------------------------------------
-- local treesitter = require'nvim-treesitter.configs'

--------------------------------------------------------------------------- }}}
