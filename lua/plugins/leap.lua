return {
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      leap.add_default_mappings()

      -- Optional: improve highlight visibility
      vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "#ffffff", bg = "#ff007c", bold = true })
      vim.api.nvim_set_hl(0, "LeapLabelSecondary", { fg = "#ffffff", bg = "#5f00ff", bold = true })

      vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#555555" })
      vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#00ffff", bold = true, underline = true })

      leap.opts.highlight_unlabeled_phase_one_targets = true
      leap.opts.safe_labels = {} -- optional: makes it assign more jump targets
    end,
  },
}
