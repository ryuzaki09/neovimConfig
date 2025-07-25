-- return {
--   "olimorris/codecompanion.nvim",
--   opts = {},
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   config = function()
--     require("codecompanion").setup({
--       strategies = {
--         chat = {
--           adapter = "openai",
--           tools = {
--             ["mcp"] = {
--               callback = function()
--                 return require("mcphub.extensions.codecompanion")
--               end,
--               description = "Call tools and resources from the MCP Servers",
--               opts = {
--                 requires_approval = true,
--               },
--             },
--           },
--         },
--       },
--       adapters = {
--         openai = function()
--           return require("codecompanion.adapters").extend("openai", {
--             env = {
--               api_key = "",
--             },
--           })
--         end,
--       },
--     })
--   end,
-- }
------@diagnostic disable-next-line: unused-local
local function generate_slash_commands()
  local commands = {}
  for _, command in ipairs({ "buffer", "file", "help", "symbols" }) do
    commands[command] = {
      opts = {
        provider = LazyVim.pick.picker.name, -- dynamically resolve the provider
      },
    }
  end
  return commands
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = true,
    opts = {
      display = {
        chat = {
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          auto_scroll = false,
        },
      },
      strategies = {
        chat = {
          adapter = "openai",
          tools = {
            ["mcp"] = {
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                requires_approval = true,
              },
            },
          },
          roles = {
            llm = "CodeCompanion",
            user = "Me",
          },
          slash_commands = generate_slash_commands(),
          keymaps = {
            close = {
              modes = {
                n = "q",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
      },
      inline = {
        adapter = "openai",
      },
    },
    keys = {
      {
        "<leader>ac",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion actions",
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion chat",
      },
      {
        "<leader>ad",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        noremap = true,
        silent = true,
        desc = "CodeCompanion add to chat",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "olimorris/codecompanion.nvim", "saghen/blink.compat" },
    event = "InsertEnter",
    opts = {
      enabled = function()
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end,
      completion = {
        accept = {
          auto_brackets = {
            kind_resolution = {
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue", "codecompanion" },
            },
          },
        },
      },
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
