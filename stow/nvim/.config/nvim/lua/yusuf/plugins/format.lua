local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		-- leptosfmt runs last: it only rewrites `view!` bodies, which rustfmt
		-- leaves alone, so this keeps rustfmt's output for everything else.
		rust = { "rustfmt", "leptosfmt" },
		lua = { "stylua" },
	},
	format_on_save = {
		timeout_ms = 3000,
		lsp_format = "never",
	},
	notify_on_error = true,
	notify_no_formatters = false,
})

vim.api.nvim_create_user_command("Format", function(args)
	conform.format({
		async = args.bang,
		timeout_ms = 3000,
		lsp_format = "never",
	})
end, {
	bang = true,
	desc = "Format the current buffer",
})
