local opt = vim.opt

opt.clipboard = "unnamedplus"

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true 

opt.wrap = false

opt.number = true
opt.relativenumber= true
opt.cursorline = false 
opt.cursorcolumn = false 
opt.guicursor = "a:block-blinkon0" 
opt.termguicolors = true
opt.background = "dark" 
opt.signcolumn = "yes"
opt.laststatus = 2
opt.showtabline = 1
opt.showmode = true
opt.ruler = false 
opt.shortmess:append("I")
opt.fillchars:append({ eob = " " })

opt.statusline = " %f %m%r%=%{strftime('%H:%M')} "

local timer = vim.fn.timer_start(30000, function()
	vim.cmd.redrawstatus()
end, { ["repeat"] = -1 })

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if timer ~= -1 then
			vim.fn.timer_stop(timer)
		end
	end,
})





