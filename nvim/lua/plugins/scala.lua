-- nvim-metals: full-featured Scala LSP via Metals
-- Metals manages its own installation — no Mason needed
return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",  -- optional: debugging support
    },
    config = function()
      local metals = require("metals")
      local metals_config = metals.bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
        enableSemanticHighlighting = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        -- Standard LSP keymaps
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "K", vim.lsp.buf.hover, "Hover docs")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")

        -- Metals-specific
        map("n", "<leader>mc", metals.commands, "Metals commands")
        map("n", "<leader>mi", metals.organize_imports, "Organize imports")
        map("n", "<leader>mh", metals.hover_worksheet, "Hover worksheet")

        -- DAP (if nvim-dap is available)
        local ok, dap = pcall(require, "dap")
        if ok then
          require("metals").setup_dap()
          map("n", "<leader>dc", dap.continue, "Debug: continue")
          map("n", "<leader>dr", dap.repl.toggle, "Debug: REPL")
          map("n", "<leader>db", dap.toggle_breakpoint, "Debug: breakpoint")
          map("n", "<leader>dK", require("dap.ui.widgets").hover, "Debug: hover")
        end
      end

      -- Trigger Metals startup when opening Scala files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
      })
    end,
  },
}
