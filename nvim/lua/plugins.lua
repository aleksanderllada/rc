return {
  "folke/neodev.nvim",
  "nvim-telescope/telescope.nvim",
  "RRethy/vim-illuminate",
  "nvim-lualine/lualine.nvim",
  "Shatur/neovim-ayu",
  "Mr-LLLLL/interestingwords.nvim",
  "nvim-treesitter/nvim-treesitter",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  -- "simrat39/rust-tools.nvim",
  "hashivim/vim-terraform",
  "petertriho/nvim-scrollbar",
  { "FabianWirth/search.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }
  },
  { 'Bekaboo/deadcolumn.nvim' },
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  { 'akinsho/toggleterm.nvim', version = "*", config = true },

  {
    'wsdjeg/vim-fetch',
    event = { 'BufReadPre', 'BufNewFile' },
  },

  { "folke/which-key.nvim",
    opts = {
      preset = "helix",
      win = {
      }
    }
  },

  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,  -- if you want to enable the plugin
      message_template = " <author> • <date> • <summary> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%d/%m/%y %H:%M", -- template for the date, check Date format section for more options
      display_virtual_text = 0, -- disable virtual text
      virtual_text_column = 120,
      max_commit_summary_length = 40
    }
  },

  { "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<leader>/',
        block = '<leader>cb',
      },
      opleader = {
          line = '<leader>/',
          block = '<leader>cb',
      },
    }
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        -- command_palette = true, -- position the cmdline and popupmenu together
        -- long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
        -- lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },

  { 'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
        NvimTree = true,
      },
      maximum_length = 30,
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },

  { "neovim/nvim-lspconfig",
    lazy = false,
    -- dependencies = {
    --   { "ms-jpq/coq_nvim", branch = "coq" },
    --   { "ms-jpq/coq.artifacts", branch = "artifacts" },
    --   { 'ms-jpq/coq.thirdparty', branch = "3p" }
    -- },
    -- init = function()
    --   vim.g.coq_settings = {
    --       auto_start = 'shut-up',
    --       completion = {
    --         always = true,
    --       },
    --   }
    -- end,
    -- config = function()
    -- end,
  },

  { "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()'
  },

  { "frankroeder/parrot.nvim",
    dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
    -- optionally include "rcarriga/nvim-notify" for beautiful notifications
    config = function()
      require("parrot").setup {
        toggle_target = "split",
        providers = {
          anthropic = {
            name = "anthropic",
            endpoint = "https://api.anthropic.com/v1/messages",
            model_endpoint = "https://api.anthropic.com/v1/models",
            api_key = "",
            params = {
              chat = { max_tokens = 4096 },
              command = { max_tokens = 4096 },
            },
            topic = {
              model = "claude-3-5-haiku-latest",
              params = { max_tokens = 32 },
            },
            headers = function(self)
              return {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = self.api_key,
                ["anthropic-version"] = "2023-06-01",
              }
            end,
            models = {
              "claude-sonnet-4-20250514",
              "claude-3-7-sonnet-20250219",
              "claude-3-5-sonnet-20241022",
              "claude-3-5-haiku-20241022",
            },
            preprocess_payload = function(payload)
              for _, message in ipairs(payload.messages) do
                message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
              end
              if payload.messages[1] and payload.messages[1].role == "system" then
                -- remove the first message that serves as the system prompt as anthropic
                -- expects the system prompt to be part of the API call body and not the messages
                payload.system = payload.messages[1].content
                table.remove(payload.messages, 1)
              end
              return payload
            end,
          },
        },
      }
    end,
  },
}
