return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'windwp/nvim-autopairs',
  },
  config = function()
    local cmp = require('cmp')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
        -- Scroll documentation window
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Close completion window
        ['<C-e>'] = cmp.mapping.abort(),

        -- Accept the selected item.
        -- If `select` is `true`, it will select the first item if none is selected.
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Tab/Shift+Tab to navigate the completion menu
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),

      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      }),

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
    })

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
