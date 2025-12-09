local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
  },

  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      '"L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'akinsho/bufferline.nvim',
    opts = {},
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'junegunn/fzf.vim',
    dependencies = {
      'junegunn/fzf',
    },
    build = ':call fzf#install()',
  },

  {
    'tpope/vim-fugitive',
  },

  {
    'airblade/vim-gitgutter',
  },

  {
    'tpope/vim-commentary',
  },
  
  {
    'tpope/vim-surround',
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },

  {
    'ellisonleao/gruvbox.nvim'
  }
})
