return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      python = { "ruff_format", "ruff_organize_imports", stop_after_first = false },
    },
  },
}
