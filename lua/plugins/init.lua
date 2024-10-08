return {
  {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-go",
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "eslint-lsp",
        "gopls",
        "clangd",
        "pyright",
        "angular-language-server",
        "js-debug-adapter",
        "typescript-language-server",
        "tailwindcss-language-server", -- Added this line
      },
    },
  },
  {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local ts_utils = require "nvim-lsp-ts-utils"
      ts_utils.setup {
        import_all_scan_buffers = 100,
        update_imports_on_move = true,
        auto_inlay_hints = true,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "typescript",
        "javascript",
        "go",
        "tsx", -- Added this line
      },
      config = function()
        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true,
          },
          indent = {
            enable = true,
          },
          ensure_installed = { "html", "typescript", "tsx", "javascript" }, -- add other languages you need
          fold = {
            enable = true,
          },
        }

        -- Enable folding
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require "configs.lint"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").add_default_mappings(true)
    end,
  },
  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local ok, dap = pcall(require, "dap")
      if not ok then
        return
      end
      dap.configurations.typescript = {
        {
          type = "node2",
          name = "node attach",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
      }
      dap.adapters.node2 = {
        type = "executable",
        command = "node-debug2-adapter",
        args = {},
      }
    end,
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()

      local dap, dapui = require "dap", require "dapui"

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("typescript").setup {
        server = {
          on_attach = function(client, bufnr)
            -- Additional on_attach settings can go here
          end,
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" }, -- Ensure .tsx is included
        },
      }
    end,
  },
  {
    "hrsh8th/nvim-cmp",
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      cmp.setup {
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              path = "[Path]",
            },
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-3),
          ["<C-f>"] = cmp.mapping.scroll_docs(5),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      }
    end,
  },
  {
    "hrsh8th/cmp-nvim-lsp",
    after = "nvim-cmp",
  },
  {
    "hrsh8th/cmp-buffer",
    after = "nvim-cmp",
  },
  {
    "hrsh8th/cmp-path",
    after = "nvim-cmp",
  },
  {
    "hrsh8th/cmp-cmdline",
    after = "nvim-cmp",
  },
  {
    "hrsh8th/cmp-nvim-lua",
    after = "nvim-cmp",
  },
  {
    "L4MON4D3/LuaSnip",
    after = "nvim-cmp",
  },
  {
    "saadparwaiz2/cmp_luasnip",
    after = "nvim-cmp",
  },
  {
    "onsails/lspkind-nvim",
    after = "nvim-cmp",
    config = function()
      require("lspkind").init()
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      local saga = require "lspsaga"
      saga.init_lsp_saga {
        -- your configuration
      }
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },
  {
    "burnettk/vim-angular",
    ft = { "typescript", "html", "css" }, -- Load for Angular-related filetypes
  },
  -- New additions
  {
    "mattn/emmet-vim",
    ft = { "typescript", "typescriptreact", "html" },
    lazy = false,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup {}
    end,
  },
}
