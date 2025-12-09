vim.env.JAVA_HOME = vim.fn.expand('~/.sdkman/candidates/java/21.0.9-amzn/')

local home = os.getenv('HOME')
local jdtls = require('jdtls')

local root_markers = {
    'gradlew',
    'mvnw',
    '.git',
}
local root_dir = require('jdtls.setup').find_root(root_markers)

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<c-o>', jdtls.organize_imports, bufopts)
  vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, bufopts)
  vim.keymap.set('n', '<leader>ec', jdtls.extract_constant, bufopts)
  vim.keymap.set('v', '<leader>em', [[<esc><cmd>lua require('jdtls').extract_method(true)<cr>]], {
    noremap = true, silent = true, buffer = bufnr
  })

  vim.keymap.set('n', '<leader>jc', function()
    require('jdtls').compile({ full = true })
  end, bufopts)
  vim.keymap.set('n', '<leader>jr', function()
    require('jdtls').run_main()
  end, bufopts)
  vim.keymap.set('n', '<leader>jt', function()
    require('jdtls').test_class()
  end, bufopts)
  vim.keymap.set('n', '<leader>jT', function()
    require('jdtls').test_nearest_method()
  end, bufopts)
end

local jdtls_bin = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
local jdtls_pkg = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local workspace = vim.fn.stdpath('cache') .. '/nvim/jdtls/workspace'

local uv = vim.uv or vim.loop
local os_name = uv.os_uname().sysname
local config_folder = 'config_linux'

if os_name == 'Darwin' then
  config_folder = 'config_mac'
elseif os_name == 'Windows_NT' then
  config_folder = 'config_win'
end

local cmd = {
  jdtls_bin,
  '--jvm-arg=-javaagent:' .. jdtls_pkg .. '/lombok.jar',
  '-configuration',
  jdtls_pkg .. '/' .. config_folder,
  '--data',
  workspace,
}

local config = {
  flags = {
    debounce_text_changes = 80,
  },
  on_attach = on_attach,
  root_dir = root_dir,
  settings = {
    java = {
      -- format = {
      --   settings = {
      --     url = '~/.local/share/eclipse/eclipse-java-google-style.xml',
      --     profile = 'GoogleStyle',
      --   },
      -- },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = home .. '/.sdkman/candidates/java/17.0.11-amzn',
          },
          {
            name = "JavaSE-21",
            path = home .. '/.sdkman/candidates/java/21.0.9-amzn',
          },
        },
      },
    },
  },
  cmd = cmd,
}

jdtls.start_or_attach(config)
