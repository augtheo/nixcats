local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
    colorschemeName = 'onedark'
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

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
    { import = "myLuaConf.plugins.alpha", },
    { import = "myLuaConf.plugins.colorful-winsep", },
    { import = "myLuaConf.plugins.completion", },
    { import = "myLuaConf.plugins.lualine", },
    { import = "myLuaConf.plugins.markdown-preview"},
    { import = "myLuaConf.plugins.mini-files" },
    { import = "myLuaConf.plugins.mini-utils" },
    { import = "myLuaConf.plugins.noice"},
    { import = "myLuaConf.plugins.snacks", },
    { import = "myLuaConf.plugins.telescope", },
    { import = "myLuaConf.plugins.treesitter", },
    { import = "myLuaConf.plugins.utils", },
    { import = "myLuaConf.plugins.which-key"},
}
