return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    -- "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
  },
  opts = {
    options = {
      theme = "catppuccin",
      globalstatus = true,
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        -- stylua: ignore
        {
          function() return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " ",
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1 },
      },
      lualine_x = {
        -- stylua: ignore
        ---@diagnostic disable: undefined-field
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
       -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        ---@diagnostic enable: undefined-field
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      -- stylua: ignore
      lualine_z = {
        function() return " " .. os.date("%R") end,
      },
    },
  },
}
