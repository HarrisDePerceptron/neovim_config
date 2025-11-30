return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
      "DiffviewLog",
      "DiffviewRefresh",
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed", -- nice for merge conflict resolution
          disable_diagnostics = true,
        },
      },
      default_args = {
        DiffviewOpen = { "--imply-local" },
        DiffviewFileHistory = { "--follow" }, -- follow renames for file history
      },
    },
    keys = {
      -- Open repo diff vs HEAD / pick ranges
      { "<leader>gd", ":DiffviewOpen<CR>", desc = "Diffview: Open (HEAD/index)" },
      -- Diff two commits/branches visually (you’ll be prompted in cmdline)
      { "<leader>gD", ":DiffviewOpen ", desc = "Diffview: Open (custom range)" },
      -- Current file history browser (side-by-side diffs)
      { "<leader>gh", ":DiffviewFileHistory %<CR>", desc = "Diffview: File history (current file)" },
      -- Repo history browser
      { "<leader>gH", ":DiffviewFileHistory<CR>", desc = "Diffview: Repo history" },
      -- Toggle file list sidebar
      { "<leader>gf", ":DiffviewToggleFiles<CR>", desc = "Diffview: Toggle files panel" },
      -- Close
      { "<leader>gq", ":DiffviewClose<CR>", desc = "Diffview: Close" },
      -- Refresh (useful after new commits)
      { "<leader>gr", ":DiffviewRefresh<CR>", desc = "Diffview: Refresh" },
    },
  },
}
