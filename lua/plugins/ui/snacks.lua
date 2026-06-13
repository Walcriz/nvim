return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = false },
      indent = {
        enabled = true,
        char = "▎",
        animate = { enabled = false },
        scope = { enabled = false },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        ui_select = false,
        win = {
          input = {
            keys = {
              ["<C-BS>"] = { "<c-s-w>", mode = { "i" }, expr = true },
            },
          },
        },
        matcher = {
          history_bonus = true,
        },
      },
      quickfile = { enabled = true },
      styles = {
        input = {
          border = "rounded",
          relative = "cursor",
          row = -3,
          col = 0,
          width = 40,
          keys = {
            ["<C-BS>"] = { "<c-s-w>", mode = { "i" }, expr = true },
          },
        },
      },
      notifier = {
        enabled = true,
      }
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Queue for pending selections
      local select_queue = {}
      local select_in_progress = false

      -- Wrapper function to process the queue
      local function process_queue()
        if select_in_progress then
          return
        end

        local next_call = table.remove(select_queue, 1)
        if not next_call then
          return
        end

        local items, opts, on_choice = unpack(next_call)

        -- Check for optional buffer restriction
        if opts and opts.buf then
          local current_buf = vim.api.nvim_get_current_buf()
          if current_buf ~= opts.buf then
            -- If current buffer doesn't match, put it back at the end of the queue and try later
            table.insert(select_queue, next_call)
            -- Retry after a short delay
            vim.defer_fn(process_queue, 50)
            return
          end
        end

        select_in_progress = true

        local delay = (opts and opts.delay) or 0
        if opts and opts.prompt and opts.prompt:find("skeleton") then
          delay = 100
        end

        local function pick()
          Snacks.picker.select(items, opts, function(item, idx)
            select_in_progress = false
            if on_choice then
              on_choice(item, idx)
            end
            -- Process the next item in the queue
            process_queue()
          end)
        end

        if delay > 0 then
          vim.defer_fn(pick, delay)
        else
          pick()
        end
      end

      -- Override vim.ui.select
      vim.ui.select = function(items, opts, on_choice)
        table.insert(select_queue, { items, opts, on_choice })
        process_queue()
      end
    end,
  },
}
