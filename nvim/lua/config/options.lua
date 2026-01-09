-- Key mapping
vim.g.mapleader = " " -- Set the global leader key to Space, used for general key mappings
vim.g.maplocalleader = "\\" -- Set the local leader key to backslash, used for filetype- or buffer-specific mappings

-- Visual settings
vim.o.termguicolors = true -- Enable 24-bit colors
vim.o.number = true -- Enable line numbers
vim.o.relativenumber = true -- Enable relative line numbers
vim.o.scrolloff = 7 -- Lines to keep above/below cursor unless at start/end of file
vim.o.sidescrolloff = 7 -- Columns to keep left/right of cursor
vim.o.wrap = false -- Disable line wrapping: long lines stay on a single line and require horizontal scrolling
vim.o.cursorline = true -- Highlight the line where the cursor is
vim.o.signcolumn = "yes" -- Always show the sign column (used by LSP diagnostics, Git signs, breakpoints)
vim.o.visualbell = true -- Enable visual cue instead of an audible beep for error notifications
vim.o.winborder = "rounded" -- Use rounded borders for floating windows and popups
vim.o.cmdheight = 0 -- Command line height
vim.o.synmaxcol = 300 -- Syntax highlighting limit
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.laststatus = 3 -- Global statusline instead of one per window

-- Identation
vim.o.expandtab = true -- Insert spaces instead of a real TAB character (\t)
vim.o.tabstop = 2 -- Display a TAB character as 2 spaces wide
vim.o.softtabstop = 2 -- Number of spaces the cursor moves when pressing Tab
vim.o.shiftwidth = 2 -- Number of spaces used for each indentation step (>>, <<, auto-indent)
vim.o.autoindent = true -- Copy indent from current line when starting new line

-- Search settings
vim.o.ignorecase = true -- Make searches case-insensitive by default
vim.o.smartcase = true -- Override ignorecase if the search pattern contains uppercase letters
vim.o.incsearch = true -- Show search matches incrementally while typing the pattern

-- File handling
vim.o.updatetime = 300 -- Idle time before triggers CursorHold events (LSP diagnostics, highlights, git signs)
vim.o.autoread = true -- Auto update file if changed outside of nvim
vim.o.undofile = true -- Enable persistent undo across sessions
vim.o.backup = false -- Disable creation of backup files (file~)
vim.o.writebackup = false -- Disable temporary backup before writing a file
vim.o.swapfile = false -- Disable swap files (.swp), avoiding clutter and conflicts
vim.o.undodir = vim.fn.expand("~/.vim/undodir") -- Directory to store undo history files
vim.o.timeoutlen = 500 -- Time to wait for mapped key sequences (e.g. <leader>)
vim.o.ttimeoutlen = 0 -- Remove delay for terminal key codes (faster <Esc> response)

-- Behavior settings
vim.o.mouse = "a" -- Enable mouse support in all modes
vim.o.hidden = true -- Allow switching buffers without saving changes
vim.o.errorbells = false -- Disable error bells and beeps
vim.o.backspace = "indent,eol,start" -- Enable intuitive backspace behavior in insert mode
vim.o.autochdir = false -- Keep a fixed working directory (avoid auto cd)
vim.o.modifiable = true -- Allow editing buffer contents
vim.o.encoding = "UTF-8" -- Set internal encoding to UTF-8
vim.o.completeopt = "menuone,noinsert,noselect" -- IDE-like completion behavior
vim.opt.iskeyword:append("-") -- Treat dash-separated words as a single word
vim.opt.path:append("**") -- Include subdirectories in search
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard for all yank, delete and paste

-- Split behavior
vim.o.splitbelow = true -- Horizontal splits go below
vim.o.splitright = true -- Vertical splits go right
