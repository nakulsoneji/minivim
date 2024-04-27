local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	add("AstroNvim/astrotheme")
	require("astrotheme").setup({
    style = {
      inactive = false,
      border = false,
    }
  })
  add("navarasu/onedark.nvim")
  require("onedark").setup({
    style = "darker"
  })
  require("onedark").load()
end)

