-- Auto-install packer if not present
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

-- Plugin management with packer.nvim
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Airbus5717/c3.vim'       -- C3 syntax highlighting
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-lualine/lualine.nvim'
  use 'hrsh7th/cmp-buffer' -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path' -- Path source for nvim-cmp
  use 'hrsh7th/cmp-cmdline' -- Command line source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippet source for nvim-cmp
  use { "catppuccin/nvim", as = "catppuccin" }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- General Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.g.mapleader = ' '
vim.opt.scrolloff = 999

-- Catppuccin theme setup
require('catppuccin').setup({
  flavour = 'macchiato', -- Options: latte, frappe, macchiato, mocha
  transparent_background = false,
  term_colors = true,
})

vim.cmd('colorscheme catppuccin-macchiato')


-- LSP and Autocompletion setup
local lspconfig = require('lspconfig')
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }),
})

--[[
-- Example LSP setup for custom language
lspconfig.custom_lsp.setup{
  cmd = { "/path/to/custom-lsp" },
  filetypes = { "c3" },
  root_dir = lspconfig.util.root_pattern(".git", "main.c3"),
  settings = {
    customLspConfig = {
      option1 = true,
      option2 = false,
    }
  },
  on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
  end,
}
}]]
-- Treesitter setup for syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript", "html", "css" },
  highlight = {
    enable = true,
  },
}

-- Nvim-tree setup
require'nvim-tree'.setup {}

-- Lualine setup
require('lualine').setup {
  options = { theme = 'gruvbox' }
}

local lspconfig = require 'lspconfig'

-- Setup LSP server for C/C++
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end,
}

-- Keybinding for file explorer
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

