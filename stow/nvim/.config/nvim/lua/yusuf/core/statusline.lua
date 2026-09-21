local M = {}

-- Plain ASCII, grayscale, and a single bar shared by all windows.
local function highlights()
	vim.api.nvim_set_hl(0, "RetroStatus", { fg = "#bcbcbc", bg = "#1c1c1c", ctermfg = 250, ctermbg = 234 })
	vim.api.nvim_set_hl(0, "RetroMode", { fg = "#1c1c1c", bg = "#d0d0d0", bold = true, ctermfg = 234, ctermbg = 252 })
	vim.api.nvim_set_hl(0, "RetroMuted", { fg = "#949494", bg = "#1c1c1c", ctermfg = 246, ctermbg = 234 })
end

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	R = "REPLACE",
	c = "COMMAND",
	r = "PROMPT",
	["!"] = "SHELL",
	t = "TERM",
}

function M.render()
	local mode = vim.api.nvim_get_mode().mode
	local label = modes[mode:sub(1, 1)] or "NORMAL"
	if mode:sub(1, 2) == "no" then
		label = "OPERATOR"
	end

	local width = vim.o.columns
	local parts = {
		"%#RetroMode# " .. label .. " ",
		"%#RetroStatus# %<%f %m%r",
		"%=",
		"%#RetroMuted#",
	}
	if width >= 80 then
		table.insert(parts, " %{&filetype == '' ? '-' : &filetype} |")
	end
	table.insert(parts, " %l:%c ")
	if width >= 60 then
		table.insert(parts, "| %p%% ")
	end
	if width >= 100 then
		table.insert(parts, "| %{strftime('%H:%M')} ")
	end
	return table.concat(parts)
end

vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.statusline = "%!v:lua.require'yusuf.core.statusline'.render()"

local group = vim.api.nvim_create_augroup("RetroStatusline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = highlights })
vim.api.nvim_create_autocmd("ModeChanged", {
	group = group,
	callback = function()
		vim.cmd.redrawstatus()
	end,
})
highlights()

local timer = vim.fn.timer_start(30000, function()
	vim.cmd.redrawstatus()
end, { ["repeat"] = -1 })

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		if timer ~= -1 then
			vim.fn.timer_stop(timer)
		end
	end,
})

return M
