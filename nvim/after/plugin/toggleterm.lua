local toggleterm = require('toggleterm')

toggleterm.setup({
    open_mapping = [[<leader>.]],
    hide_number = true,
    start_in_insert = true,
    direction = 'float', -- vertical | float | tab
    transparent = true,
})

vim.keymap.set('n', '<C-S-l>', function()
    local width = vim.fn.winwidth(0)
    vim.api.nvim_win_set_width(0, width - 2)
end)

vim.keymap.set('n', '<C-S-h>', function()
    local width = vim.fn.winwidth(0)
    vim.api.nvim_win_set_width(0, width + 2)
end)

vim.keymap.set('t', '<C-S-l>', function()
    local width = vim.fn.winwidth(0)
    vim.api.nvim_win_set_width(0, width - 2)
end)

vim.keymap.set('t', '<C-S-h>', function()
    local width = vim.fn.winwidth(0)
    vim.api.nvim_win_set_width(0, width + 2)
end)
