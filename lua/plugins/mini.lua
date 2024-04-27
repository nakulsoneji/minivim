local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function ()
  add("nvim-tree/nvim-web-devicons")
end)

now(function()
	require("mini.statusline").setup({
		set_vim_settings = false
	})
end)

now(function()
	require("mini.tabline").setup()
end)

now(function()
	require("mini.basics").setup()
end)

later(function()
	require("mini.notify").setup()
end)

later(function()
	require("mini.pick").setup()
end)

later(function()
	require("mini.files").setup({
		options = {
			use_as_default_explorer = false,
		}
	})
end)

later(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.comment").setup()
end)


later(function()
	require("mini.surround").setup()
end)
