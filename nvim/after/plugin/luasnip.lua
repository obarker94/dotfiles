local ls = require("luasnip") --{{{

-- require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}

-- Virtual Text{{{
local types = require("luasnip.util.types")
ls.config.set_config({
    history = true,                            --keep around last snippet local to jump back
    updateevents = "TextChanged,TextChangedI", --update changes as you type
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "●", "GruvboxOrange" } },
            },
        },
        -- [types.insertNode] = {
        -- 	active = {
        -- 		virt_text = { { "●", "GruvboxBlue" } },
        -- 	},
        -- },
    },
}) --}}}

-- Key Maps
vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.expand_or_jumpable() then
        ls.expand()
    end
end)
vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable() then
        ls.jump(1)
    end
end)
vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable() then
        ls.jump(-1)
    end
end)
