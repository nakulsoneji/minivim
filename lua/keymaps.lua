local opts = {}
vim.keymap.set("n", "<S-h>", "<cmd>bprev<cr>", opts)
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", opts)
vim.keymap.set("n", "<space>bd", "<cmd>lua require('mini.bufremove').delete()<cr>")

vim.keymap.set("n", "<space><space>", "<cmd>Pick files<cr>", opts)
vim.keymap.set("n", "<space>ff", "<cmd>Pick files<cr>", opts)
vim.keymap.set("n", "<space>fg", "<cmd>Pick grep_live<cr>", opts)

vim.keymap.set("n", "<space>e", "<cmd>Lex<cr>", opts)
vim.keymap.set("n", "<space>fe", "<cmd>:lua MiniFiles.open()<cr>", opts)

vim.keymap.set("n", "<space>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

