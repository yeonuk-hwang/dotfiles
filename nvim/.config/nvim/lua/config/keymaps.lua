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

-- Markdown Headings
local function number_headings()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local counts = { 0, 0, 0, 0, 0, 0 } -- H1 ~ H6 카운터
  local new_lines = {}

  -- 🟢 [설정] 번호를 매기지 않을 헤딩 제목들 (소문자로 입력하세요)
  local ignore_list = {
    "table of contents",
    "toc",
  }

  for _, line in ipairs(lines) do
    -- 헤딩(#) 감지
    local hashes, title = line:match("^(#+)%s+(.*)")

    if hashes then
      -- 1. 일단 제목에서 기존 번호(숫자+점)를 제거하여 순수 텍스트만 추출
      local clean_title = title:gsub("^[%d%.]+%s*", "")
      local lower_title = clean_title:lower() -- 비교를 위해 소문자 변환

      -- 2. 제외 목록에 있는지 확인
      local is_ignored = false
      for _, ignore_str in ipairs(ignore_list) do
        -- 정확히 일치하는 경우 (부분 일치를 원하면 string.find 사용)
        if lower_title == ignore_str then
          is_ignored = true
          break
        end
      end

      if is_ignored then
        -- 🟢 제외 대상인 경우: 번호 없이 헤딩과 제목만 출력 (카운터 증가 X)
        table.insert(new_lines, hashes .. " " .. clean_title)
      else
        -- 🟢 일반 헤딩인 경우: 카운터 증가 및 번호 부여 로직 수행
        local depth = #hashes
        counts[depth] = counts[depth] + 1
        -- 하위 레벨 카운터 초기화
        for i = depth + 1, 6 do counts[i] = 0 end

        -- 번호 문자열 생성
        local num_str = ""
        for i = 1, depth do
          if counts[i] > 0 then
            num_str = num_str .. counts[i] .. "."
          end
        end

        table.insert(new_lines, hashes .. " " .. num_str .. " " .. clean_title)
      end
    else
      -- 헤딩이 아닌 줄은 그대로 유지
      table.insert(new_lines, line)
    end
  end

  -- 버퍼 업데이트
  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  print("Markdown headings numbered (excluded specific titles)!")
end

vim.api.nvim_create_user_command('NumberHeadings', number_headings, {})
