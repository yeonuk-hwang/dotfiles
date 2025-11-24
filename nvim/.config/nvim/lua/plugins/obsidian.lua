return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre /Users/yeonuk/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal/*.md",
      "BufEnter oil:///Users/yeonuk/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal/",
      "BufNewFile /Users/yeonuk/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      footer = {
        enabled = false,
      },
      workspaces = {
        {
          name = "personal",
          path = "/Users/yeonuk/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal",
        },
      },
      ---@class obsidian.config.CompletionOpts
      ---
      ---@field nvim_cmp? boolean
      ---@field blink? boolean
      ---@field min_chars? integer
      ---@field match_case? boolean
      ---@field create_new? boolean
      completion = (function()
        return {
          nvim_cmp = false,
          blink = true,
          min_chars = 2,
          match_case = true,
          create_new = true,
        }
      end)(),
      ui = { enable = false },
      daily_notes = {
        folder = "periodic-notes/daily-notes",
      },
      templates = {
        folder = "templates",
        time_format = "%H:%M", -- 24시간제 시간
      },
      attachments = {
        img_folder = "/attachments",
      },
      notes_subdir = "1.Inbox",
      new_notes_location = "notes_subdir",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z1-9가-힣-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "ObsidianNoteEnter",
        callback = function(ev)
          local set = function(keymap, command, desc)
            vim.keymap.set("n", keymap, command, {
              buffer = ev.buf,
              desc = desc,
            })
          end

          set("<leader>ff", "<cmd>Obsidian quick_switch<cr>", "find obsidian vault")
          set("<leader><leader>", "<cmd>Obsidian quick_switch<cr>", "find obsidian vault")
          set("<leader>/", "<cmd>Obsidian search<cr>", "grep obsidian vault")
          set("<leader>ip", "<cmd>Obsidian paste_image<cr>", "paste image from the clipboard")
          set("<leader>ip", "<cmd>Obsidian paste_image<cr>", "paste image from the clipboard")
          set("<leader>ob", "<cmd>Obsidian backlinks<cr>", "obsidian backlinks")
          set("<leader>ol", "<cmd>Obsidian links<cr>", "obsidian links")
          set("<leader>od", "<cmd>Obsidian dailies<cr>", "obsidian dailies")
          set("<leader>otd", "<cmd>Obsidian today<cr>", "obsidian open or create the today note")
          set("<leader>otm", "<cmd>Obsidian tomorrow<cr>", "obsidian open or create the tomorrow note")
          set("<leader>oyd", "<cmd>Obsidian yesterday<cr>", "obsidian open or create the yesterday note")
          set("<leader>oit", "<cmd>Obsidian template<cr>", "obsidian insert a template into the current note")
          set("<leader>on", "<cmd>Obsidian new<cr>", "obsidian create a new note")
          set("<leader>gd", "<cmd>Obsidian follow_link <cr>", "obsidian create a new note")
        end,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
    },
  },
}
