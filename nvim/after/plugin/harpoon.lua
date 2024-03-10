local mark = require("harpoon.mark")
local ui = require("harpoon.ui")


vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>a", function() mark.set_current_at(1) end)
vim.keymap.set("n", "<C-a>", function() ui.nav_file(1) end)

vim.keymap.set("n", "<leader>d", function() mark.set_current_at(2) end, {noremap = true, silent = true})
vim.keymap.set("n", "<C-d>", function() ui.nav_file(2) end)
