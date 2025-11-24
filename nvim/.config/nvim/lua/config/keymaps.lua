-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local function copy_to_clipboard(content, message)
  vim.fn.setreg("+", content)
  vim.notify(message .. ": " .. content, vim.log.levels.INFO)
end

-- 파일 경로 관련
vim.keymap.set("n", "<leader>yp", function()
  copy_to_clipboard(vim.fn.expand("%:."), "Copied relative path")
end, { desc = "Yank relative path" })

vim.keymap.set("n", "<leader>yP", function()
  copy_to_clipboard(vim.fn.expand("%:p"), "Copied absolute path")
end, { desc = "Yank absolute path" })

vim.keymap.set("n", "<leader>yn", function()
  copy_to_clipboard(vim.fn.expand("%:t"), "Copied filename")
end, { desc = "Yank filename" })

-- 보너스: 파일명과 라인 번호
vim.keymap.set("n", "<leader>yl", function()
  local path = vim.fn.expand("%:.")
  local line = vim.fn.line(".")
  local content = path .. ":" .. line
  copy_to_clipboard(content, "Copied path with line")
end, { desc = "Yank path with line number" })

-- Visual 모드: 경로 + 라인 범위
vim.keymap.set("v", "<leader>yl", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local path = vim.fn.expand("%:.")
  -- GitHub: file.py#L10-L20
  local result = start_line == end_line and string.format("%s#L%d", path, start_line)
    or string.format("%s#L%d-L%d", path, start_line, end_line)

  vim.fn.setreg("+", result)
  vim.notify("📋 " .. result, vim.log.levels.INFO)
end, { desc = "Yank path with line range" })
