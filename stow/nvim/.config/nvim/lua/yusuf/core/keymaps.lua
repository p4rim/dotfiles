local map = vim.keymap.set

-- clear explorer highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- oil explorer
map("n", "<leader>e", "<cmd>Oil<cr>")

-- telescope search
map("n", "<leader><leader>", function()
	require("telescope.builtin").find_files()
end)

-- grep project
map("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end)

-- buffers
map("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end)

-- mason
map("n", "<leader>pm", "<cmd>Mason<cr>")

-- keymaps
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- need fixing
-- map("x", "p", '"_dP')
-- map({ "n", "x" }, "d", '"_d')
-- map({ "n", "x" }, "D", '"_D')
-- map({ "n", "x" }, "c", '"_c')
-- map({ "n", "x" }, "C", '"_C')
-- map({ "n", "x" }, "x", '"_x')
-- map({ "n", "x" }, "X", '"_X')
-- map({ "n", "x" }, "s", '"_s')
-- map({ "n", "x" }, "S", '"_S')

-- stops comment continuation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
