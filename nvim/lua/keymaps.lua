local keymap = vim.keymap.set

-- keymap('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

keymap('n', '<C-Up>', ':resize +2<CR>')
keymap('n', '<C-Down>', ':resize -2<CR>')
keymap('n', '<C-Left>', ':vertical resize -2<CR>')
keymap('n', '<C-Right>', ':vertical resize +2<CR>')

keymap('n', '<leader>e', ':NvimTreeToggle<CR>')
keymap('n', '<C-p>', ':Files<CR>')

keymap('n', '<S-Tab>', ':bprevious<CR>')
keymap('n', '<Tab>', ':bnext<CR>')

keymap('i', 'jk', '<esc>', { silent = true })
keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

vim.api.nvim_create_user_command('BufOnly', function()
  vim.cmd('silent! %bd|e#|bd#')
end, {})
keymap('n', '<leader>bo', ':BufOnly<cr>')
