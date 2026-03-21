return {
  'AlexandrosAlexiou/kotlin.nvim',
  filetypes = { 'kotlin' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'stevearc/oil.nvim',
    'folke/trouble.nvim',
  },
  config = function()
    require('kotlin').setup({
      root_markers = {
        'mvnw',
        'pom.xml',
        'gradlew',
        'settings.gralde',
        '.git'
      },

      jre_path = nil,
      jdk_for_symbol_resolution = nil,

      inlay_hints = {
        enabled = true,
      },
    })
  end,
}
