-- Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.cmd('syntax on')

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

vim.opt.termguicolors = true
vim.opt.guicursor = ''
vim.opt.completeopt = 'menuone,noselect'

require('plugins')
require('lsp-config')
require('keymaps')
