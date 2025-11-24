local filetypes = {
  "markdown",
  "gitcommit",
}

return {
  "antonk52/markdowny.nvim",
  lazy = true,
  ft = filetypes,
  config = function()
    require("markdowny").setup({
      { filetypes = filetypes },
    })
  end,
}
