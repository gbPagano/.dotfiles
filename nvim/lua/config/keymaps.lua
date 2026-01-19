-- Y to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Navigate visual lines normally, but use real lines for jumps (e.g., 10j)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Add undo break-points for punctuation
vim.keymap.set("i", ",", ",<C-g>u")
vim.keymap.set("i", ".", ".<C-g>u")
vim.keymap.set("i", ";", ";<C-g>u")

-- Escape and Clear hlsearch
vim.keymap.set({ "i", "n", "s" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Save and quit file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set({ "n" }, "<C-q>", "<cmd>q<cr><esc>", { desc = "Quit File" })

-- Disable command-line window and search history triggers
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "q/", "<nop>")
vim.keymap.set("n", "q?", "<nop>")

-- Lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Which-key groups
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "find/file" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunks" }, -- git hunks
  { "<leader>t", group = "toggle" },
  { "<leader>u", group = "ui" },
})

-- File search and navigation mappings
-- stylua: ignore start
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = "~/.dotfiles/nvim" }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.files({ cwd = "~/.dotfiles" }) end, { desc = "Find Dotfile" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, { desc = "Recent (cwd)" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>ft", function() Snacks.picker.grep() end, { desc = "Find Text" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- Git stuff
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gB", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (hunks)" })
vim.keymap.set("n", "<leader>gD", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, { desc = "Git Diff (origin)" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
vim.keymap.set({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>ghS", ":Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" })
vim.keymap.set("n", "<leader>ghR", ":Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>ghu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>ghp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>ghb", ":Gitsigns blame_line({ full = true })<CR>", { desc = "Blame Line" })
vim.keymap.set("n", "<leader>ghB", ":Gitsigns blame<CR>", { desc = "Blame Buffer" })
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
vim.keymap.set("n", "]h", ":Gitsigns nav_hunk next<CR>", { desc = "Next Hunk" })
vim.keymap.set("n", "[h", ":Gitsigns nav_hunk prev<CR>", { desc = "Prev Hunk" })
vim.keymap.set("n", "]H", ":Gitsigns nav_hunk last<CR>", { desc = "Last Hunk" })
vim.keymap.set("n", "[H", ":Gitsigns nav_hunk first<CR>", { desc = " Hunk" })
Snacks.toggle({
  name = "Git Blame Line",
  get = function() return require("gitsigns.config").config.current_line_blame end,
  set = function() require("gitsigns").toggle_current_line_blame() end,
}):map("<leader>gb"):map("<leader>tb")
Snacks.toggle({
  name = "Git Signs",
  get = function() return require("gitsigns.config").config.signcolumn end,
  set = function() require("gitsigns").toggle_signs() end,
}):map("<leader>uG"):map("<leader>tG"):map("<leader>ub")
Snacks.toggle({
  name = "Git Word Diff",
  get = function() return require("gitsigns.config").config.word_diff end,
  set = function() require("gitsigns").toggle_word_diff() end,
}):map("<leader>gw")

-- Toggle options
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw"):map("<leader>uw")
Snacks.toggle.diagnostics():map("<leader>td"):map("<leader>ud")
Snacks.toggle.dim():map("<leader>tD"):map("<leader>uD")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL"):map("<leader>tL")
Snacks.toggle.indent():map("<leader>tg"):map("<leader>ug")
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>th")
end
-- stylua: ignore end

-- LSP
Snacks.toggle({
  name = "LSP Virtual Lines",
  get = function()
    local cfg = vim.diagnostic.config()
    return cfg and cfg.virtual_lines == true or (cfg ~= nil and type(cfg.virtual_lines) == "table")
  end,
  set = function(state)
    if state then
      vim.diagnostic.config({
        virtual_lines = { current_line = true },
        virtual_text = false,
      })
    else
      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = { prefix = "●" },
      })
    end
  end,
})
  :map("<leader>uv")
  :map("<leader>tv")
-- Flash jumps
-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Flash Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
-- stylua: ignore end
