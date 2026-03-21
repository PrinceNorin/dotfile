local lspconfig = require('lspconfig')

return {
  cmd = { 'jdtls' },
  filetypes = { 'java' },
  root_dir = lspconfig.util.root_pattern({
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'settings.gradle',
    'settings.gradle.kts',
    '.git'
  }),
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'Graalvm-21',
            path = '~/asdf/installs/java/graalvm-community-21.0.2',
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'none', -- literla, all or none
        },
      },
    },
  },
  init_options = {
    bundles = {},
  },
}
