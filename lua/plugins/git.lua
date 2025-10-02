-- lua/plugins/git.lua
return {
  -- Inline hunks, signs, and hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
        map("n", "]h", gs.next_hunk,  "Next hunk")
        map("n", "[h", gs.prev_hunk,  "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
      end,
    },
  },

  -- Magit-like status/stage/commit inside NVIM
  {
    "TimUntersberger/neogit",
    cmd = { "Neogit" },
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        integrations = { diffview = true },
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = true,
        kind = "split",
      })
      vim.keymap.set("n", "<leader>gs", function() neogit.open({ kind = "split" }) end, { desc = "Neogit status" })
    end,
  },

  -- Clean diffs in splits/tabs + file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewLog" },
    config = function()
      require("diffview").setup({})
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff (HEAD..)" })
      vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", { desc = "Diff vs origin" })
      vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (current file)" })
      vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
    end,
  },

  -- Git pickers via Telescope
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
      { "<leader>gc", function() require("telescope.builtin").git_commits() end,  desc = "Git commits (repo)" },
      { "<leader>gC", function() require("telescope.builtin").git_bcommits() end, desc = "Git commits (buffer)" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,   desc = "Git status (Telescope)" },
      { "<leader>gt", function() require("telescope.builtin").git_stash() end,    desc = "Git stash" },
    },
  },
}
