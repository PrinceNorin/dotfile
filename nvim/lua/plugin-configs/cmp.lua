local cmp = require "cmp"
local snippy = require('snippy')

cmp.setup {
  preselect = cmp.PreselectMode.None,
  -- completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
  experimental = { native_menu = false, ghost_text = false },
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },
  formatting = {
    format = require("lspkind").cmp_format {
      mode = "symbol_text",
      maxwidth = 50,
    },
  },
  mapping = {
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    -- Close menu when escape, but don't go into normal mode from insert mode
    -- ["<Esc>"] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
      -- behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
    },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "buffer" },
    { name = "path" },
    { name = "nvim_lua" },
    { name = "dotenv" },
    { name = "treesitter" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

-- Use buffer source for `/`
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Auto pairs
local cmp_autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done { map_char = { tex = "" } }
)
