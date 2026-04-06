return {
  -- Fugitive: the premier Git plugin (tpope)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git log --oneline --graph<CR>", desc = "Git log" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    },
  },

  -- GBrowse handler for GitHub
  { "tpope/vim-rhubarb", dependencies = "tpope/vim-fugitive" },

  -- Gitsigns: hunk indicators and actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- Navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        -- Actions
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        -- Text object
        map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- Diffview: side-by-side diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
  },
}
