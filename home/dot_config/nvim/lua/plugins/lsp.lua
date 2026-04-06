-- 🔑 Shared on_attach (used by ALL LSPs including TS tools)
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  map("n", "gd", vim.lsp.buf.definition, "Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Declaration")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

  map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

  map("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
end

return {
  -- 🧠 Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- 🔗 Mason bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    opts = {
      automatic_installation = true,
    },
  },

  -- 📦 Schema store
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- 🧠 Better Lua LSP
  {
    "folke/neodev.nvim",
    ft = "lua",
    opts = {},
  },

  -- 🔄 LSP progress UI
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },

  -- ⚡ LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
      "folke/neodev.nvim",
    },

    config = function()
      local lspconfig = require("lspconfig")

      -- safe require
      local ok_schemastore, schemastore = pcall(require, "schemastore")

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = { enable = false },
            },
          },
        },

        pyright = {},

        jsonls = ok_schemastore and {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        } or {},

        yamlls = ok_schemastore and {
          settings = {
            yaml = {
              schemas = schemastore.yaml.schemas(),
            },
          },
        } or {},

        bashls = {},
        html = {},
        cssls = {},
        eslint = {},

        -- ruff: Python linting/diagnostics via LSP (replaces nvim-lint for Python)
        ruff = {},

        -- stylua: Lua formatter via LSP
        stylua = {},
      }

      for name, opts in pairs(servers) do
        opts.on_attach = on_attach
        opts.capabilities = capabilities
        lspconfig[name].setup(opts)
      end

      -- diagnostics UI
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        float = { border = "rounded", source = "always" },
        underline = true,
        severity_sort = true,
      })
    end,
  },

  -- 🔥 TypeScript (replaces tsserver completely)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },

    opts = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      return {
        on_attach = on_attach,
        capabilities = capabilities,

        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = "all",

          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }
    end,

    config = function(_, opts)
      require("typescript-tools").setup(opts)

      -- 🔥 Useful keymaps
      vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
      vim.keymap.set("n", "<leader>tR", "<cmd>TSToolsRenameFile<CR>", { desc = "Rename File" })
      vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsAddMissingImports<CR>", { desc = "Add Missing Imports" })
      vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "Remove Unused Imports" })
    end,
  },

  -- 🎨 Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- 🔍 Linting
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- ruff diagnostics now come from the ruff LSP server
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- 🧰 Tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = "mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "black",
        "isort",
        "ruff",
        "prettier",
        "eslint_d",
      },
    },
  },
}
