local set = vim.opt_local

-- set.shiftwidth = 4
-- set.number = true
-- set.relativenumber = true
-- ~/.config/nvim/ftplugin/python.lua

-- Set Python-specific buffer-local options
set.expandtab = true -- Use spaces instead of tabs
set.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
set.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
set.softtabstop = 4  -- Number of spaces that <Tab> counts for while performing editing operations
-- vim.bo.textwidth = 88      -- Optional: Set preferred line length (e.g., for black or ruff)
-- vim.bo.colorcolumn = "+1"  -- Optional: Show a color column at textwidth + 1

-- ----------------------------------------------------------------------------
-- UV Integration and Keymappings
-- ----------------------------------------------------------------------------

-- Keymap to run the current Python file using `uv run %`
-- This is a buffer-local mapping, non-recursive, and silent.
vim.keymap.set('n', '<leader>ru', '<cmd>!uv run %<CR>', {
  buffer = true,
  noremap = true,
  silent = true,
  desc = "Run current file with uv"
})

-- ----------------------------------------------------------------------------
-- Notes on Virtual Environments, LSP, Formatting, and Linting with UV
-- ----------------------------------------------------------------------------

-- 1. UV and Virtual Environments:
--    - `uv` typically creates and manages a virtual environment in a `.venv` directory
--      within your project.
--    - `uv` commands (like `uv pip install`, `uv run`) automatically detect and
--      use this `.venv` if it exists in the current directory or parent directories.
--    - For Neovim to fully leverage this environment for LSPs, formatters, and linters,
--      these tools need to use the Python interpreter and packages from `.venv`.

-- 2. `uv.nvim` Plugin (Highly Recommended):
--    - Consider using a dedicated plugin like `benomahony/uv.nvim`.
--    - This plugin can help automatically activate the `uv` virtual environment
--      for Neovim, manage `uv` commands from within Neovim, and simplify integration.
--    - If you use `uv.nvim`, it will handle much of the environment setup needed
--      for other tools. Refer to its documentation for specific features and keymaps
--      (e.g., it often provides its own keymaps for running files, adding packages).

-- 3. Language Server Protocol (LSP):
--    - Your LSP client (e.g., `nvim-lspconfig` with `pyright`, `basedpyright`, or `ruff-lsp`)
--      should be configured to use the Python interpreter from the `.venv` created by `uv`.
--    - `ruff-lsp`: If you use `ruff` (which `uv` is by the same creators), `ruff-lsp` is an
--      excellent choice. It generally detects project-specific `ruff` and environments well.
--      Ensure `ruff-lsp` is correctly set up in your main `nvim-lspconfig` configuration.
--    - `pyright`/`basedpyright`: You might need to configure `pyright` to find the venv.
--      This can often be done via a `pyproject.toml` file in your project root:
--      ```toml
--      [tool.pyright]
--      venvPath = "."  // Project root
--      venv = ".venv"  // Name of the virtual environment directory
--      ```
--      Alternatively, your global LSP setup for Pyright might need hints or dynamic
--      configuration to pick up the correct venv path. `uv.nvim` can also assist here.

-- 4. Formatting and Linting:
--    - These are generally configured globally in your Neovim setup (e.g., using
--      plugins like `conform.nvim` for formatting and `nvim-lint` for linting, or relying
--      on `ruff-lsp` for both).
--    - Ruff: `ruff` is an extremely fast Python linter and formatter. It can replace
--      tools like Flake8, Black, isort, etc.
--      - For formatting with `conform.nvim`:
--        ```lua
--        -- In your conform.nvim setup (global Neovim config):
--        -- require("conform").setup({
--        --   formatters_by_ft = {
--        --     python = { "ruff_format" }, -- or {"ruff", "format"} depending on conform version
--        --     -- Alternatively, you can use "black" or other formatters.
--        --   },
--        --   format_on_save = {
--        --     timeout_ms = 500,
--        --     lsp_fallback = true,
--        --   },
--        -- })
--        ```
--      - For linting: `ruff-lsp` provides linting diagnostics directly. If not using
--        `ruff-lsp`, you can configure `nvim-lint` with `ruff`.

-- This ftplugin focuses on buffer-local settings. Global configurations for LSP,
-- formatters, linters, and plugins like `uv.nvim` should reside in your main
-- Neovim configuration files (e.g., init.lua or related modules).

-- Optional: Define a buffer-local leader if you prefer one for Python files
-- vim.g.maplocalleader = ',' -- Example: set local leader to comma

-- You can add more Python-specific, buffer-local keymappings or settings below.
-- For example, if you use nvim-dap-python for debugging:
-- (Note: DAP setup is more involved and mostly global, these are just example keymaps)
-- vim.keymap.set('n', '<LocalLeader>db', function() require('dap').toggle_breakpoint() end, { buffer = true, noremap = true, silent = true, desc = "DAP: Toggle breakpoint" })
-- vim.keymap.set('n', '<LocalLeader>dc', function() require('dap').continue() end, { buffer = true, noremap = true, silent = true, desc = "DAP: Continue" })

vim.notify("Python ftplugin loaded (uv-focused)", vim.log.levels.INFO, { title = "Neovim" })
