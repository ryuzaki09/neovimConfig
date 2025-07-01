local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- require("mcphub").setup({
--   extensions = {
--     avante = {
--       make_slash_commands = true, -- make /slash commands from MCP server prompts
--     },
--     -- codecompanion = {
--     --   -- Show the mcp tool result in the chat buffer
--     --   show_result_in_chat = true,
--     --   make_vars = true, -- make chat #variables from MCP server resources
--     --   make_slash_commands = true, -- make /slash_commands from MCP server prompts
--     -- },
--   },
-- })

-- require("avante").setup({
--   -- other config
--   -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
--   system_prompt = function()
--     local hub = require("mcphub").get_hub_instance()
--     return hub:get_active_servers_prompt()
--   end,
--   -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
--   custom_tools = function()
--     return {
--       require("mcphub.extensions.avante").mcp_tool(),
--     }
--   end,
-- })

require("codecompanion").setup({
  strategies = {
    chat = {
      tools = {
        ["mcp"] = {
          -- calling it in a function would prevent mcphub from being loaded before it's needed
          callback = function()
            return require("mcphub.extensions.codecompanion")
          end,
          description = "Call tools and resources from the MCP Servers",
        },
      },
    },
  },
})

require("lualine").setup({
  sections = {
    lualine_x = {
      { require("mcphub.extensions.lualine") },
    },
  },
})
-- require("codecompanion").setup({
--   strategies = {
--     chat = {
--       adapter = "openai",
--       tools = {
--         ["mcp"] = {
--           callback = require("mcphub.extensions.codecompanion"),
--           description = "Call tools and resources from the MCP Servers",
--           opts = {
--             requires_approval = true,
--           },
--         },
--       },
--     },
--   },
--   adapters = {
--     openai = function()
--       return require("codecompanion.adapters").extend("openai", {
--         env = {
--           api_key = "",
--         },
--       })
--     end,
--   },
-- })
