local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'rose-pine/neovim',                name = 'rose-pine' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/playground' },
    { 'theprimeagen/harpoon' },
    { 'mbbill/undotree' },
    { 'kdheepak/lazygit.nvim',           dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'windwp/nvim-autopairs',           event = "InsertEnter",                     opts = {} },
    { 'windwp/nvim-ts-autotag' },
    { 'github/copilot.vim' },
    { 'elentok/format-on-save.nvim' },
    { 'akinsho/toggleterm.nvim',         version = "*",                             config = true },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },
    { 'APZelos/blamer.nvim' },
    { 'sindrets/diffview.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-lualine/lualine.nvim',  dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'folke/trouble.nvim',         dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'VonHeikemen/lsp-zero.nvim',  branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp"
    },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    {
        'ray-x/lsp_signature.nvim',
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    { 'ThePrimeagen/vim-be-good' },
    { 'ThePrimeagen/vim-apm' },
    { "rebelot/kanagawa.nvim" },
    { "nvim-treesitter/nvim-treesitter-context" }
})
