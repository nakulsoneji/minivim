local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
	add("windwp/nvim-autopairs")
	require("mini.pairs").setup()
end)

later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		-- Use 'master' while monitoring updates in 'main'
		checkout = "master",
		monitor = "main",
		-- Perform action after every checkout
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "vimdoc" },
		highlight = { enable = true },
		additional_vim_regex_highlighting = false,
	})

end)

