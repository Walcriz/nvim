local M = {}

local config = require("config")
M.did_init = false function M.init()
  if not M.did_init then
    M.did_init = true

    -- Set leader key
    vim.g.mapleader = config.leader

    -- Bootstrap lazy.nvim
    require("bootstrap")

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    M.load("options")

    -- Setup lazy.nvim
    require("config.lazysetup")

    -- delay notifications till vim.notify was replaced or after 500ms
    require("util").lazy_notify()

    -- Load Tab Profiles here to make sure they get loaded
    M.setuptabs()

    -- Add missing filetypes
    M.add_filetypes()
  end
end

function M.after()
  -- Load autocmds and such
  if vim.fn.argc(-1) == 0 then
    -- Loading of autocmds and keymaps can wait
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("WalVim", { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        M.load("autocmds")
        M.load("keymaps")
      end,
    })
  else
    -- Load autocmds and keymaps so they affect current buffers
    M.load("autocmds")
    M.load("keymaps")
  end
end

function M.load(name) -- Fully taken from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua
  local Util = require("lazy.core.util")
  local function _load(mod)
    Util.try(function()
      require(mod)
    end, {
    msg = "Failed loading " .. mod,
    on_error = function(msg)
      local modpath = require("lazy.core.cache").find(mod)
      if modpath then
        Util.error(msg)
      end
    end,
  })
end

-- Load config
_load("config." .. name)

if vim.bo.filetype == "lazy" then
  -- HACK: Neovim may have overwritten options of the Lazy ui, so reset this here
  vim.cmd([[do VimResized]])
end
end

function M.setuptabs()
  local util = require("util")
  local profiles = require("config.tabprofiles")

  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
      local buf = args.buf

      -- 1. Check for EditorConfig properties on this buffer
      --    Neovim parses .editorconfig and stores the result in b:editorconfig (a table) if enabled :contentReference[oaicite:0]{index=0}
      local ec = vim.b[buf].editorconfig
      if ec and type(ec) == "table" then
        -- EditorConfig uses 'indent_size' (or 'tab_width') and 'indent_style'
        local size = tonumber(ec.indent_size or ec.tab_width)
        local style = ec.indent_style  -- "tab" or "space"

        if size then
          vim.notify("Using Editorconfig: " .. size .. " " .. style, vim.log.levels.INFO)
          -- Convert EditorConfig style into expandtab setting
          -- build a profile
          util.setuptabs(buf, {
            tabsize = size,
            usetabs = (style == "tab"),
          })
          return
        end
      end

      local guess = require("guess-indent").guess_from_buffer(buf)
      if guess == nil then
        vim.notify("Using preset indentation for " .. vim.api.nvim_get_option_value("filetype", { buf = buf }), vim.log.levels.INFO)
        util.set_preset_indentation(buf)
      else
        vim.notify("Using Indent Guess " .. guess, vim.log.levels.INFO)
        util.set_indent(buf, guess)
      end
    end,
  })

  vim.cmd([[
  " settab command
  command! -nargs=? SetTab lua require("util").set_tab(<f-args>)
  command! -nargs=? Tab lua require("util").set_tab(<f-args>)
  command! -nargs=? SetSpace lua require("util").set_space(<f-args>)
  command! -nargs=? Space lua require("util").set_space(<f-args>)
  ]])

  local opt = vim.opt
  local profile = profiles.default
  if profile.usetabs then
    opt.tabstop = profile.tabsize
    opt.shiftwidth = profile.tabsize

    opt.softtabstop = 0
    opt.expandtab = false
  else
    opt.shiftwidth = profile.tabsize
    opt.expandtab = true

    if profile.visualtabsize then
      opt.tabstop = profile.visualtabsize
    else
      opt.tabstop = 10 -- Default to some awakward value
    end
    opt.softtabstop = 0
  end

  opt.smarttab = true
end

function M.add_filetypes()
  vim.filetype.add({
    extension = {
      astro = "astro",
    },
  })
  vim.filetype.add({
    extension = {
      htc = "htc",
    },
  })
  vim.filetype.add({
    extension = {
      rs = "rust",
    }
  })
  vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  })
end

return M
