return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  opts = {
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      mason = true,
      noice = true,
      notify = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
