-- Editor enhancements: tpope suite + general editing plugins
return {
  -- ── tpope suite ──────────────────────────────────────────────────────────
  -- Repeat plugin maps with .
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- Surround text objects (ys, cs, ds)
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Pairs of bracket mappings ([b ]b, [e ]e, [f ]f, etc.)
  { "tpope/vim-unimpaired", event = "VeryLazy" },

  -- Auto-detect indent settings from the file
  { "tpope/vim-sleuth", event = "BufReadPre" },

  -- Search/substitute/abbreviate with enhanced patterns (:S, :Subvert, crs/crm/crc/cru)
  { "tpope/vim-abolish", event = "VeryLazy" },

  -- Unix file commands (:Rename, :Move, :Delete, :Chmod, :SudoWrite)
  { "tpope/vim-eunuch", cmd = { "Rename", "Move", "Delete", "Chmod", "SudoWrite", "SudoEdit", "Mkdir" } },

  -- Readline-style insert/command-mode bindings (C-a, C-e, C-k, etc.)
  { "tpope/vim-rsi", event = "VeryLazy" },

  -- Project navigation via projections (.projections.json)
  { "tpope/vim-projectionist", event = "VeryLazy" },

  -- Async :make and test dispatch
  { "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Focus", "Start" } },

  -- ── Auto pairs ───────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { lua = { "string" }, javascript = { "template_string" } },
    },
  },

  -- ── Comments ─────────────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- ── Terminal ─────────────────────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal (vertical)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
      { "<C-`>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping = nil,
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
      persist_size = true,
      direction = "float",
      float_opts = { border = "curved" },
    },
  },

  -- ── Illuminate (highlight word under cursor) ─────────────────────────────
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- ── Todo comments ────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    },
  },

  -- ── Trouble (diagnostics list) ───────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<CR>", desc = "Location list" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<CR>", desc = "Quickfix" },
    },
  },
}
