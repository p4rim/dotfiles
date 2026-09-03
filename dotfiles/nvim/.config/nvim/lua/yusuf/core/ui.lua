-- vim.pack.add({
--   "https://github.com/rebelot/kanagawa.nvim",
-- })
--
-- require("kanagawa").setup({
--   background = {
--     dark = "dragon",
--     light = "lotus",
--   },
-- })
--
-- vim.cmd.colorscheme("kanagawa")

-- vim.pack.add({
-- 	"https://github.com/miikanissi/modus-themes.nvim",
-- })
--
-- vim.o.background = "dark" -- or "light"
-- vim.cmd.colorscheme("modus")

vim.pack.add({
	"https://github.com/drewxs/ash.nvim",
})

require("ash").setup({
	transparent = false,
	term_colors = false,
	no_italic = false,
	no_bold = false,
	no_underline = false,
})

vim.cmd.colorscheme("ash")
