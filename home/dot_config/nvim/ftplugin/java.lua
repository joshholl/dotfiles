-- nvim-jdtls Java filetype plugin
-- Called automatically by Neovim when a .java file is opened

local ok, jdtls = pcall(require, "jdtls")
if not ok then return end

-- Find Mason-installed jdtls
local mason_dir = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason_dir .. "/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
if launcher == "" then
  vim.notify("jdtls not found — run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- OS-specific config dir
local os_config
if vim.fn.has("mac") == 1 then
  os_config = "mac"
elseif vim.fn.has("unix") == 1 then
  os_config = "linux"
else
  os_config = "win"
end
local config_dir = jdtls_path .. "/config_" .. os_config

-- Workspace: one per project root (avoids cross-project symbol pollution)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

-- Bundles for DAP (Java Debug / Test)
local bundles = {}
local java_debug = mason_dir .. "/packages/java-debug-adapter"
local java_test = mason_dir .. "/packages/java-test"

local debug_jar = vim.fn.glob(
  java_debug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true
)
if debug_jar ~= "" then
  vim.list_extend(bundles, { debug_jar })
end
vim.list_extend(bundles, vim.split(
  vim.fn.glob(java_test .. "/extension/server/*.jar", true), "\n", { trimempty = true }
))

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  root_dir = require("jdtls.setup").find_root({
    ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts"
  }),

  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },

  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    (pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities() or {})
  ),

  init_options = {
    bundles = bundles,
  },

  on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
    end

    -- Standard LSP
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

    -- Java-specific
    map("n", "<leader>jo", jdtls.organize_imports, "Organize imports")
    map("n", "<leader>jv", jdtls.extract_variable, "Extract variable")
    map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Extract variable (selection)")
    map("n", "<leader>jc", jdtls.extract_constant, "Extract constant")
    map("v", "<leader>jc", function() jdtls.extract_constant(true) end, "Extract constant (selection)")
    map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extract method")
    map("n", "<leader>jt", jdtls.test_nearest_method, "Test nearest method")
    map("n", "<leader>jT", jdtls.test_class, "Test class")
    map("n", "<leader>ju", "<cmd>JdtUpdateConfig<CR>", "Update config")
  end,
}

jdtls.start_or_attach(config)
