require('packages')
require('lsp')
require('term')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.g.mapleader = ' '
vim.opt.scrolloff = 999
vim.loader.enable()

require('catppuccin').setup({
  flavour = 'macchiato',
  transparent_background = false,
  term_colors = true,
})
vim.cmd('colorscheme catppuccin-macchiato')

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
