local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
        colorschemeName = 'onedark'
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
        notify.setup({
                on_open = function(win)
                        vim.api.nvim_win_set_config(win, { focusable = false })
                end,
        })
        vim.notify = notify
        vim.keymap.set("n", "<Esc>", function()
                notify.dismiss({ silent = true, })
        end, { desc = "dismiss notify popup and clear hlsearch" })
end

-- NOTE: you can check if you included the category with the thing wherever you want.
if nixCats('general.extra') then
        -- I didnt want to bother with lazy loading this.
        -- I could put it in opt and put it in a spec anyway
        -- and then not set any handlers and it would load at startup,
        -- but why... I guess I could make it load
        -- after the other lze definitions in the next call using priority value?
        -- didnt seem necessary.
        vim.g.loaded_netrwPlugin = 1
        require("myLuaConf.plugins.mini-files")
end

require('lze').load {
        { import = "myLuaConf.plugins.telescope", },
        { import = "myLuaConf.plugins.treesitter", },
        { import = "myLuaConf.plugins.completion", },
        { import = "myLuaConf.plugins.utils",},
        {
                "markdown-preview.nvim",
                -- NOTE: for_cat is a custom handler that just sets enabled value for us,
                -- based on result of nixCats('cat.name') and allows us to set a different default if we wish
                -- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
                -- you could replace this with enabled = nixCats('cat.name') == true
                -- if you didnt care to set a different default for when not using nix than the default you already set
                for_cat = 'markdown',
                cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle", },
                ft = "markdown",
                keys = {
                        { "<leader>mp", "<cmd>MarkdownPreview <CR>",       mode = { "n" }, noremap = true, desc = "markdown preview" },
                        { "<leader>ms", "<cmd>MarkdownPreviewStop <CR>",   mode = { "n" }, noremap = true, desc = "markdown preview stop" },
                        { "<leader>mt", "<cmd>MarkdownPreviewToggle <CR>", mode = { "n" }, noremap = true, desc = "markdown preview toggle" },
                },
                before = function(plugin)
                        vim.g.mkdp_auto_close = 0
                end,
        },
        {
                "undotree",
                for_cat = 'general.extra',
                cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo", },
                keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" }, },
                before = function(_)
                        vim.g.undotree_WindowLayout = 1
                        vim.g.undotree_SplitWidth = 40
                end,
        },
        {
                "comment.nvim",
                for_cat = 'general.extra',
                event = "DeferredUIEnter",
                after = function(plugin)
                        require('Comment').setup()
                end,
        },
        {
                "indent-blankline.nvim",
                for_cat = 'general.extra',
                event = "DeferredUIEnter",
                after = function(plugin)
                        require("ibl").setup()
                end,
        },
        {
                "nvim-surround",
                for_cat = 'general.always',
                event = "DeferredUIEnter",
                -- keys = "",
                after = function(plugin)
                        require('nvim-surround').setup()
                end,
        },
        {
                "vim-startuptime",
                for_cat = 'general.extra',
                cmd = { "StartupTime" },
                before = function(_)
                        vim.g.startuptime_event_width = 0
                        vim.g.startuptime_tries = 10
                        vim.g.startuptime_exe_path = nixCats.packageBinPath
                end,
        },
        {
                "fidget.nvim",
                for_cat = 'general.extra',
                event = "DeferredUIEnter",
                -- keys = "",
                after = function(plugin)
                        require('fidget').setup({})
                end,
        },
        -- {
        --   "hlargs",
        --   for_cat = 'general.extra',
        --   event = "DeferredUIEnter",
        --   -- keys = "",
        --   dep_of = { "nvim-lspconfig" },
        --   after = function(plugin)
        --     require('hlargs').setup {
        --       color = '#32a88f',
        --     }
        --     vim.cmd([[hi clear @lsp.type.parameter]])
        --     vim.cmd([[hi link @lsp.type.parameter Hlargs]])
        --   end,
        -- },
        { import = "myLuaConf.plugins.lualine", },
        {
                "mini.diff",
                for_cat = 'general.always',
                event = "DeferredUIEnter",
                -- cmd = { "" },
                -- ft = "",
                -- keys = "",
                -- colorscheme = "",
                after = function(plugin)
                        require('mini.diff').setup({
                                view = { style = "sign", signs = { add = "│", change = "│", delete = "┆" } }
                        })
                        -- vim.cmd([[hi GitSignsAdd guifg=#04de21]])
                        -- vim.cmd([[hi GitSignsChange guifg=#83fce6]])
                        -- vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
                end,
        },
        { import = "myLuaConf.plugins.colorful-winsep", },
        {
                "which-key.nvim",
                for_cat = 'general.extra',
                -- cmd = { "" },
                event = "DeferredUIEnter",
                -- ft = "",
                -- keys = "",
                -- colorscheme = "",
                after = function(plugin)
                        require('which-key').setup({
                                win = {
                                        border = "single",
                                },

                                preset = "helix",

                        })
                        require('which-key').add {
                                { "<leader><leader>",  group = "buffer commands" },
                                { "<leader><leader>_", hidden = true },
                                { "<leader>c",         group = "[c]ode" },
                                { "<leader>c_",        hidden = true },
                                { "<leader>d",         group = "[d]ocument" },
                                { "<leader>d_",        hidden = true },
                                { "<leader>g",         group = "[g]it" },
                                { "<leader>g_",        hidden = true },
                                { "<leader>m",         group = "[m]arkdown" },
                                { "<leader>m_",        hidden = true },
                                { "<leader>r",         group = "[r]ename" },
                                { "<leader>r_",        hidden = true },
                                { "<leader>s",         group = "[s]earch" },
                                { "<leader>s_",        hidden = true },
                                { "<leader>t",         group = "[t]oggles" },
                                { "<leader>t_",        hidden = true },
                                { "<leader>w",         group = "[w]orkspace" },
                                { "<leader>w_",        hidden = true },
                        }
                end,
        },
}
