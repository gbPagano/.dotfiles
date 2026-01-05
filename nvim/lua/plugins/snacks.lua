return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    image = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          -- auto_close = true,
          -- This is the specific setting to close after opening a file
          jump = { close = true },
        },
      },
      win = {
        input = {
          keys = {
            ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<c-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<c-w>"] = { "cycle_win", mode = { "i", "n" } },
            ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<c-p>"] = { "focus_preview", mode = { "i", "n" } },
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = {
      enabled = true,
      -- stylua: ignore
			preset = {
      	header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████]],
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "s", desc = "Sync Plugins", action = ":Lazy sync" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = '~/.dotfiles/nvim/'})" },
          { icon = " ", key = "d", desc = "Dotfiles", action = ":lua Snacks.dashboard.pick('files', {cwd = '~/.dotfiles/'})" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
    },
  },
  -- stylua: ignore
	keys = {
    { "<leader>td", function() Snacks.toggle.dim():toggle() end, desc = "" },
	},
}
