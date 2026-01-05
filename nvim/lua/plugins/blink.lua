return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",

      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "show_and_insert_or_accept_single", "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },

      ["<C-u>"] = { "scroll_documentation_up", "fallback_to_mappings" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback_to_mappings" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = { auto_show = true },
      ghost_text = { enabled = true },
      list = {
        selection = {
          preselect = false,
        },
      },
    },

    signature = { enabled = true },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },

    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
      },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = true,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
