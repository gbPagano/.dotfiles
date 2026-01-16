return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cd", function()
            vim.cmd.RustLsp({ "renderDiagnostic", "current" })
          end, { desc = "Render Rust diagnostic", buffer = bufnr })

          vim.keymap.set("n", "<leader>ce", function()
            vim.cmd.RustLsp({ "explainError", "current" })
          end, { desc = "Explain Rust error", buffer = bufnr })
        end,
      },
    }
  end,
}
