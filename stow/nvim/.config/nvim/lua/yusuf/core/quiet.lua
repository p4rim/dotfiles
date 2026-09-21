local M = {
	enabled = true,
	servers = {},
}

local function hide_suggestions()
	local ok, cmp = pcall(require, "blink.cmp")
	if not ok then
		return
	end

	cmp.hide()
	cmp.hide_documentation()
	cmp.hide_signature()
end

function M.is_enabled()
	return M.enabled
end

function M.setup(servers)
	M.servers = servers

	vim.api.nvim_create_user_command("Quiet", function()
		if not M.enabled then
			vim.notify("Quiet mode is already on")
			return
		end

		M.enabled = false
		hide_suggestions()
		vim.lsp.enable(M.servers, false)
		vim.notify("Quiet mode on: LSPs and suggestions disabled")
	end, { desc = "Disable all LSPs and completion suggestions" })

	vim.api.nvim_create_user_command("QuietOff", function()
		if M.enabled then
			vim.notify("Quiet mode is already off")
			return
		end

		M.enabled = true
		vim.lsp.enable(M.servers)
		vim.notify("Quiet mode off: LSPs and suggestions enabled")
	end, { desc = "Re-enable all LSPs and completion suggestions" })
end

return M
