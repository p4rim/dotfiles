local function alias(name, target)
	vim.api.nvim_create_user_command(name, function(opts)
		local range = ""
		if opts.range == 1 then 
			range =  tostring(opts.line1)
		elseif opts.range == 2 then
			range = opts.line1 .. "," .. opts.line2
		end
		vim.cmd(range .. target .. (opts.bang and "!" or "") .. " " .. opts.args)
	end, { bang = true, nargs = "?" , complete = "file", range = true})
end

alias("W", "w")
alias("Q", "q")
alias("Wq", "wq")
alias("WQ", "wq")
alias("Qa", "Qa")
