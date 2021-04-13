-- 210413 created
-- toggle quickfix or location list windows
-- inspired by 'Valloric/ListToggle'
-- vim.cmd() is an alias for vim.api.nvim_command()

local M = {}
function M.qf_toggle()
	local number_of_buffers1 = vim.fn.bufnr("$")
	vim.cmd('silent! cclose')
	local number_of_buffers2 = vim.fn.bufnr("$")

	if number_of_buffers1 == number_of_buffers2 then
		vim.cmd('silent! copen')
	end
end

function M.loc_toggle()
	local number_of_buffers1 = vim.fn.bufnr("$")
	vim.cmd('silent! lclose')
	local number_of_buffers2 = vim.fn.bufnr("$")

	if number_of_buffers1 == number_of_buffers2 then
		vim.cmd('lopen')
	end
end

vim.cmd("nnoremap <silent> <leader>q <cmd>lua require('quickfix_toggle').qf_toggle()<CR>")
vim.cmd("nnoremap <silent> <leader>l <cmd>lua require('quickfix_toggle').loc_toggle()<CR>")

return M
