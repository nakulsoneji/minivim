local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

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

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- is used in place of on_attach, actual on_attach is in autocommand
	local function disable_lsp_highlights(client, _)
		client.server_capabilities.semanticTokensProvider = nil
	end

	require("mason-lspconfig").setup({
		handlers = {
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
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
					on_attach = disable_lsp_highlights,
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
					capabilities = capabilities,
				})
			end,
		},
	})


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

