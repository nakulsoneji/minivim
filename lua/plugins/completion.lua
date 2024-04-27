local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()

	add({
		source = "hrsh7th/nvim-cmp",
		depends = {
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	})

	local cmp = require("cmp")
	local defaults = require("cmp.config.default")()

	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.setup({
		auto_brackets = {}, -- configure any filetype to auto add brackets
		completion = {
			completeopt = "menu,menuone,noinsert",
		},

		mapping = cmp.mapping.preset.insert({
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<S-CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
		formatting = {
			format = function(_, item)
				local max_width = 25
				local fixed_width = true
				local ellipsis_char = "..."

				item.menu = ""

				local label = item.abbr:gsub("%s+", "")
				if string.len(label) > max_width then
					item.abbr = string.sub(label, 0, max_width - string.len(ellipsis_char)) .. ellipsis_char
				elseif string.len(label) < max_width and fixed_width then
					item.abbr = label .. string.rep(" ", max_width - string.len(label))
				else
					item.abbr = label
				end

				return item
			end,
		},
		experimental = {
			ghost_text = true,
		},
		sorting = defaults.sorting,
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
end)


