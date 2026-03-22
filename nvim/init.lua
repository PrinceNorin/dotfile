require("config.lazy")

-- Basic settings
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.mouse = "a"             -- Enable mouse support
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.opt.showmode = false        -- Don't show mode (statusline already shows it)
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- nvim-cmp disable auto select

-- Editing settings
vim.opt.endofline = true
vim.opt.fixendofline = true
vim.opt.guicursor = 'a:block-blinkon500-blinkoff500'

-- Indentation
vim.opt.tabstop = 2            -- Number of spaces tabs count for
vim.opt.softtabstop = 2        -- Number of spaces tab inserts
vim.opt.shiftwidth = 2         -- Number of spaces for autoindent
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.autoindent = true      -- Copy indent from current line

-- Search
vim.opt.hlsearch = true        -- Highlight search results
vim.opt.incsearch = true       -- Show search matches as you type
vim.opt.ignorecase = true      -- Ignore case in search
vim.opt.smartcase = true       -- Override ignorecase if search contains uppercase

-- Splits
vim.opt.splitright = true      -- Vertical splits to the right
vim.opt.splitbelow = true      -- Horizontal splits below

-- Appearance
vim.opt.cursorline = true      -- Highlight current line
vim.opt.wrap = false           -- Don't wrap lines
vim.opt.list = true            -- Show invisible characters
vim.opt.listchars = {
    tab = "→ ",
    trail = "·",
    extends = "›",
    precedes = "‹",
    nbsp = "␣"
}

-- Backup and swap files
vim.opt.backup = false         -- Don't create backup files
vim.opt.swapfile = false       -- Don't create swap files
vim.opt.undofile = false       -- Disable persistent undo

-- NetRW (built-in file explorer)
vim.g.netrw_banner = 0         -- Hide banner
vim.g.netrw_liststyle = 3      -- Tree style listing
vim.g.netrw_browse_split = 4   -- Open files in previous window


-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Quickly go into normal mode
map('i', 'jk', '<esc>', opts)

-- Better navigation
map('n', '<C-h>', '<C-w>h', opts)  -- Move to left window
map('n', '<C-j>', '<C-w>j', opts)  -- Move to window below
map('n', '<C-k>', '<C-w>k', opts)  -- Move to window above
map('n', '<C-l>', '<C-w>l', opts)  -- Move to right window

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<CR>', opts)
map('n', '<C-Down>', '<cmd>resize -2<CR>', opts)
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', opts)
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', opts)

-- Better indenting
map('v', '<', '<gv', opts)     -- Keep selection after indenting left
map('v', '>', '>gv', opts)     -- Keep selection after indenting right

-- Better searching
map('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)  -- Clear search highlights

-- File explorer
map('n', '<leader>e', '<cmd>Explore<CR>', opts)  -- Open file explorer

-- Quick save
map('n', '<leader>w', '<cmd>w<CR>', opts)        -- Save file
map('n', '<leader>q', '<cmd>q<CR>', opts)        -- Quit
map('n', '<leader>x', '<cmd>x<CR>', opts)        -- Save and quit

-- Move lines (visual mode)
map('v', 'J', ":m '>+1<CR>gv=gv", opts)  -- Move selected lines down
map('v', 'K', ":m '<-2<CR>gv=gv", opts)  -- Move selected lines up

-- Telescope mapping
local telescope = require('telescope.builtin')
map('n', '<c-p>', telescope.find_files, opts)
map('n', '<leader>ff', telescope.find_files, opts)
map('n', '<leader>fg', telescope.live_grep, opts)
map('n', '<leader>fh', telescope.help_tags, opts)

-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General autocommands
local general = augroup('General', { clear = true })

-- Return to last edit position when opening files
autocmd('BufReadPost', {
  group = general,
  pattern = '*',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end
})

-- Trim trailing whitespace on save
autocmd('BufWritePre', {
  group = general,
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end
})

-- Colorscheme
vim.o.background = 'dark'
vim.cmd.colorscheme('nightfox')

-- Custom functions
local function toggle_theme()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
    vim.cmd.colorscheme('dayfox')
  else
    vim.o.background = 'dark'
    vim.cmd.colorscheme('nightfox')
  end
end

-- Switch between dark or light theme
map('n', '<leader>tt', toggle_theme)
