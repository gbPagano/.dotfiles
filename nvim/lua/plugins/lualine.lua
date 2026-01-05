return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "catppuccin",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          function()
            return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          color = { fg = "#f5c2e7" },
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
        -- 1. Status do Profiler (Se você tiver o snacks.nvim instalado)
        -- {
        -- 	function()
        -- 		return require("snacks").profiler.status()
        -- 	end,
        -- 	cond = function()
        -- 		return package.loaded["snacks"]
        -- 	end,
        -- },
        --
        -- -- 2. Noice: Comandos (ex: :w, search count)
        -- {
        -- 	function()
        -- 		return require("noice").api.status.command.get()
        -- 	end,
        -- 	cond = function()
        -- 		return package.loaded["noice"] and require("noice").api.status.command.has()
        -- 	end,
        -- 	color = { fg = "#ff9e64" }, -- Cor alaranjada (Statement)
        -- },
        --
        -- -- 3. Noice: Modo (ex: -- RECORDING --)
        -- {
        -- 	function()
        -- 		return require("noice").api.status.mode.get()
        -- 	end,
        -- 	cond = function()
        -- 		return package.loaded["noice"] and require("noice").api.status.mode.has()
        -- 	end,
        -- 	color = { fg = "#ff007c" }, -- Cor rosa (Constant)
        -- },
        --
        -- -- 4. DAP: Status do Debugger
        -- {
        -- 	function()
        -- 		return "  " .. require("dap").status()
        -- 	end,
        -- 	cond = function()
        -- 		return package.loaded["dap"] and require("dap").status() ~= ""
        -- 	end,
        -- 	color = { fg = "#db4b4b" }, -- Cor vermelha (Debug)
        -- },
        --
        -- 5. Lazy: Verificador de Updates
        -- {
        -- 	require("lazy.status").updates,
        -- 	cond = require("lazy.status").has_updates,
        -- 	color = { fg = "#ff9e64" },
        -- },

        -- 6. Diff (Git) usando dados do gitsigns
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          -- source = function(
          -- 	local gitsigns = vim.b.gitsigns_status_dict
          -- 	if gitsigns then
          -- 		return {
          -- 			added = gitsigns.added,
          -- 			modified = gitsigns.changed,
          -- 			removed = gitsigns.removed,
          -- 		}
          -- 	end
          -- end,
        },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
  },
}
