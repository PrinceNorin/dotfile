local AUGroups = require('augroups')
local o = vim.opt
local fn = vim.fn
local map = vim.api.nvim_set_keymap

-- map leader key
map('n', ',', '', {})
vim.g.mapleader = ' '
vim.cmd 'set inccommand=split'
o.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'
o.updatetime = 1500
o.timeoutlen = 400
o.ttimeoutlen = 0
o.backup = false
o.swapfile = false
o.mouse = 'a'
o.mousefocus = true
o.dir = fn.stdpath 'data' .. '/swp'
o.undofile = true
o.undodir = fn.stdpath 'data' .. '/undodir'
o.history = 500
o.clipboard = 'unnamedplus'
o.conceallevel = 0
o.cursorline = false
o.number = true
o.relativenumber = true
o.cmdheight = 1
o.showmode = false
o.showtabline = 1
o.laststatus = 3
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.termguicolors = true
o.scrolloff = 3
o.sidescrolloff = 5
o.hlsearch = false
o.ignorecase = true
o.foldenable = false
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter:foldexpr()'
o.fillchars = {
  eob = ' ',
}
vim.g.rainbow_active = 1
o.listchars = {
  tab = '┆ ',
  trail = '~',
}
o.list = true
o.shortmess = o.shortmess + 'c'
o.wildmode = 'full'
o.lazyredraw = false
o.completeopt = {
  'menu',
  'menuone',
  'noselect',
  'noinsert',
}
o.wildignorecase = true
o.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
]]

-- Register the AUGroups and autocommands
local autoCommands = {
  open_folds = {
    { 'BufEnter', '*', 'normal zx zR' },
  },
  -- format on write
  format_on_write = {
    { 'BufWritePre', '*.lua', 'lua vim.lsp.buf.format()' },
    { 'BufWritePre', '*.go',  'lua vim.lsp.buf.format()' },
    { 'BufWritePre', '*.erl', 'lua vim.lsp.buf.format()' },
  },
  compile_commands_generate = {
    {
      'BufWritePost',
      '*.cpp,*.hpp,*.c,*.h,*.cc,*.hh,*.cxx,*.hxx,*.m,*.mm',
      "silent! exec 'make compile_commands.json'",
    },
  },
}

AUGroups.CreateFrom(autoCommands)
