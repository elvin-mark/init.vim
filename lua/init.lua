require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pylsp", "clangd", "gopls", "ts_ls"},
  automatic_installation = true,
})

require("mason-null-ls").setup({
  ensure_installed = { "black", "clang-format", "goimports" },
  automatic_installation = true,
})

-- LSP Server Configurations
local on_attach = function(client, bufnr)
  -- Keybindings for LSP
  local bufmap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }
  bufmap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  bufmap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  bufmap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
end

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- Python LSP
require("lspconfig").pylsp.setup {
  on_attach = on_attach,
}

-- C LSP
require("lspconfig").clangd.setup {
  on_attach = on_attach,
}

-- Golang LSP
require("lspconfig").gopls.setup({
  on_attach = on_attach,
})

-- Typescript LSP
require("lspconfig").ts_ls.setup({
  on_attach = on_attach, 
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    require("null-ls").builtins.formatting.black, -- Black formatter
    require("null-ls").builtins.formatting.clang_format, -- Add C formatter
    require("null-ls").builtins.formatting.gofmt,       -- Standard Go formatter
    require("null-ls").builtins.formatting.goimports,   -- Auto-fix imports
    require("null-ls").builtins.formatting.prettier, -- Typescript/Javascript formatter
  },
})
vim.cmd([[autocmd BufWritePre *.py lua vim.lsp.buf.format()]])
vim.cmd([[autocmd BufWritePre *.c,*.h lua vim.lsp.buf.format()]])
vim.cmd([[autocmd BufWritePre *.go lua vim.lsp.buf.format()]])
vim.cmd([[autocmd BufWritePre *.ts lua vim.lsp.buf.format()]])
vim.cmd([[autocmd BufWritePre *.js lua vim.lsp.buf.format()]])
vim.cmd([[autocmd BufWritePre *.css lua vim.lsp.buf.format()]])

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

