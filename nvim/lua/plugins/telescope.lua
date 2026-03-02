return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Optional but recommended for performance
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = true,
}
