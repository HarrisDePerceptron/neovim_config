return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- 1. KEYMAPS
    opts.keymap = opts.keymap or {}

    -- Your existing mapping for Ctrl + l
    opts.keymap["<C-l>"] = { "show", "show_documentation", "hide_documentation" }

    -- New mapping: Ctrl + Enter to accept the selection
    opts.keymap["<C-CR>"] = { "select_and_accept", "fallback" }

    -- 2. VISUALS: Show "Type" text (Kind) next to the name
    opts.completion = opts.completion or {}
    opts.completion.menu = opts.completion.menu or {}
    opts.completion.menu.draw = opts.completion.menu.draw or {}

    -- Define the columns in the suggestion window
    opts.completion.menu.draw.columns = {
      { "kind_icon" }, -- The icon (e.g. 𝑓)
      { "label", "label_description", gap = 1 }, -- The name + details
      { "kind" }, -- The text type (e.g. "Function")
    }
  end,
}
