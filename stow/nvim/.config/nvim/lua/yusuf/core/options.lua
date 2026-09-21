local opt = vim.opt

opt.clipboard = "unnamedplus"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.cursorcolumn = false
opt.guicursor = "a:block-blinkon0"
opt.termguicolors = true
opt.background = "dark"
opt.showtabline = 1
opt.ruler = false
opt.shortmess:append("I")
opt.fillchars:append({ eob = " " })

opt.scrolloff = 8
opt.signcolumn = "yes"
