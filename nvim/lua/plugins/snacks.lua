return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = true },
		-- indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			win = {
				input = {
					keys = {
						["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
					},
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		-- scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		-- words = { enabled = true },
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
          { icon = " ", key = "c", desc = "Nvim Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('~/.dotfiles/configs/nvim')})" },
          { icon = " ", key = "d", desc = "Dotfiles", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('~/.dotfiles')})" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
		},
	},
  -- stylua: ignore
  keys = {
    -- Top Pickers & Explorer
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fc", function() Snacks.picker.files({cwd = vim.fn.expand('~/.dotfiles/configs/nvim')}) end, desc = "Find Config File" },
    { "<leader>fd", function() Snacks.picker.files({cwd = vim.fn.expand('~/.dotfiles')}) end, desc = "Find Dotfile" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    -- { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command History" },
  },
}
