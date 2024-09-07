local plugins = {
  -- Editor support
  -- The next few plugins are really the IDE feel
  {
    'williamboman/mason.nvim',
    run = ':MasonUpdate',
  },
  'williamboman/mason-lspconfig.nvim',
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('plugin-configs.lsp')
    end,
  },
  'ray-x/lsp_signature.nvim',
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('plugin-configs.noice')
    end,
  },
  {
    'dcampos/nvim-snippy',
    dependencies = { 'honza/vim-snippets' },
    config = function()
      require('snippy').setup({})
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        auto_install = true,
        indent = { enable = true },
      })
    end,
  },
  'editorconfig/editorconfig-vim',
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require('plugin-configs.cmp')
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'onsails/lspkind-nvim',
      'SergioRibera/cmp-dotenv',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
    },
  },
  {
    'b0o/mapx.nvim',
    config = function()
      require('keyboard-mappings')
    end,
  },
  'f-person/git-blame.nvim',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({})
    end,
  },
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({})
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({
        lightbulb = {
          enable = false,
          virtual_text = false,
        },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  -- Window management
  {
    'aserowy/tmux.nvim',
    config = function()
      require('plugin-configs.tmux')
    end,
  },


  -- File management
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require('plugin-configs.nvim-tree')
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup({})
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('plugin-configs.autopairs')
    end,
  },
  {
    'hedyhli/outline.nvim',
    config = function()
      require('outline').setup({})
    end,
  },
  'tpope/vim-endwise',
  'tpope/vim-fugitive',
  'tpope/vim-surround',

  -- Visual
  {
    'yamatsum/nvim-nonicons',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-dap.nvim',
    },
    config = function()
      require('plugin-configs.telescope')
    end,
  },
  {
    'ldelossa/nvim-dap-projects',
    config = function()
      require('nvim-dap-projects').search_project_config()
    end,
  },
  {
    'goolord/alpha-nvim',
    config = function()
      require('plugin-configs.dashboard').setup({})
    end,
  },
  -- {
  --   'rcarriga/nvim-notify',
  --   config = function()
  --     local notify = require('notify')
  --     notify.setup({
  --       background_colour = '#000000',
  --     })
  --     vim.notify = notify
  --   end,
  -- },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({})
      vim.cmd [[colorscheme catppuccin-mocha]]
    end,
  },

  -- Debugging
  {
    'mfussenegger/nvim-dap',
    config = function()
      require('plugin-configs.nvim-dap')
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require('plugin-configs.nvim-dap-gui')
    end,
  },
  'theHamsta/nvim-dap-virtual-text'
}

if vim.fn.has('macunix') == 1 then
  table.insert(plugins, 'sebdah/vim-delve')
  table.insert(plugins, 'leoluz/nvim-dap-go')
  table.insert(plugins, {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
  })
end

return plugins
