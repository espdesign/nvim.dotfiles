print("Advent of neovim")

require("config.lazy")
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.opt.shell = "/bin/zsh"
vim.api.nvim_create_autocmd('TextYankPost', {

  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- remove rterminal line numbers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
-- ctrl+d, terminal normal mode (to exit)
local job_id = 0
vim.keymap.set("n", "<space>`", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
  job_id = vim.bo.channel
end)
-- example custom keymap to send command to terminal
vim.keymap.set("n", "<space>example", function()
  vim.fn.chansend(job_id, { "ls -al\r\n'" })
end)
vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ', -- Character for a tab (e.g., a right-pointing triangle followed by a space)
  -- Some people prefer '→ ' or '» ' or even '│─' for a more connected look
  trail = '·', -- Character for trailing whitespace (e.g., a middle dot)
  space = ' ', -- Character for a space (can be set to '·' or similar if you want all spaces visible)
  -- Note: If 'space' is ' ', only "special" spaces like those caught by 'multispace' or 'nbsp' will be shown with a distinct char.
  -- To see all regular spaces, you'd use something like: space = '·'
  multispace = '·' -- Character for multiple consecutive spaces (if 'space' is ' ')
  -- This will show a middle dot for each space in a sequence of two or more.
}
