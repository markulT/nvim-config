-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
-- local on_attach = function(client, buf)
--   require("nvchad.configs.lspconfig").on_attach()
--   if client.name == "tsserver" then
--     local ts_utils = require "nvim-lsp-ts-utils"
--     ts_utils.setup_client(client)
--   end
-- end

local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "tsserver", "gopls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.tailwindcss.setup {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        typescript = "typescript",
        typescriptreact = "typescriptreact",
        javascript = "javascript",
        javascriptreact = "javascriptreact",
        html = "html",
        css = "css",
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
      },
      validate = true,
    },
  },
}
-- typescript

lspconfig.tsserver.setup {
  -- settings = {
  --   typescript = {
  --     inlayHints = {
  --       includeInlayParameterNameHints = "all",
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayEnumMemberValueHints = true,
  --     },
  --   },
  --   javascript = {
  --     inlayHints = {
  --       includeInlayParameterNameHints = "all",
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayEnumMemberValueHints = true,
  --     },
  --   },
  -- },
  -- diagnostics = {
  --   severityOverrides = {
  --     ["missingProps"] = "warning",
  --   },
  -- },
}
lspconfig.eslint.setup {
  settings = {
    packageManager = "npm",
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
    format = true,
  },
  root_dir = function()
    return vim.loop.cwd()
  end,
}
-- Custom configuration for gopls
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      semanticTokens = true,

      -- Enable import optimization
      codelenses = {
        generate = true, -- Runs go generate for a directory
        gc_details = true, -- Toggle the calculation of gc annotations
        regenerate_cgo = true, -- Regenerate cgo definitions
        tidy = true, -- Runs go mod tidy
        upgrade_depdendency = true, -- Upgrade a dependency
        vendor = true, -- Runs go mod vendor
      },
    },
  },
  commands = {
    OrganizeImports = {
      function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
        for _, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
            else
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end,
      description = "Organize Imports",
    },
  },
}
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
  end,
})
