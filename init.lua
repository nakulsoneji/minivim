local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		-- '--branch', 'stable',
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end

-- Set up 'mini.deps'
require("mini.deps").setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
	add("AstroNvim/astrotheme")
	require("astrotheme").setup()
end)

now(function()
	vim.o.termguicolors = true
	-- use spaces for tabs and whatnot
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.shiftround = true
	vim.opt.expandtab = true
	vim.opt.backspace = "indent,start,eol"
  vim.opt.pumheight = 10
  vim.opt.clipboard:append("unnamedplus")
	vim.cmd("colorscheme astrodark")
end)

now(function()
	require("mini.notify").setup()
end)

now(function()
	require("mini.basics").setup()
end)

now(function()
	require("mini.tabline").setup()
end)

now(function()
	require("mini.statusline").setup()
end)

now(function()
	add("nvim-tree/nvim-web-devicons")
	require("nvim-web-devicons").setup()
end)

now(function()
	add("williamboman/mason.nvim")
	require("mason").setup()
end)

-- LSP Setup
now(function()
	-- Supply dependencies near target plugin
	add({
		source = "neovim/nvim-lspconfig",
		depends = {
			{
				source = "williamboman/mason-lspconfig.nvim",
				hooks = {
					post_checkout = function()
						vim.cmd("MasonUpdate")
					end,
				},
			},
      "hrsh7th/cmp-nvim-lsp",
		},
	})

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- is used in place of on_attach, actual on_attach is in autocommand
  local function disable_lsp_highlights(client, _)
    client.server_capabilities.semanticTokensProvider = nil
  end

	require("mason-lspconfig").setup({
		handlers = {
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({
          capabilities = capabilities
        })
			end,
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
          capabilities = capabilities,
          on_attach = disable_lsp_highlights
				})
			end,
      ["clangd"] = function()
				require("lspconfig").clangd.setup({
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=/usr/bin/arm-none-eabi-*",
          },
          capabilities = capabilities
				})
      end
		},
	})

	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

		end,
	})
end)

later(function()
  add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets"
    }
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
        require('luasnip').lsp_expand(args.body)
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
      end
    },
    experimental = {
      ghost_text = true
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

later(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.comment").setup()
end)

later(function()
	require("mini.pick").setup()
end)

later(function()
	require("mini.surround").setup()
end)

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
