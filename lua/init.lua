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

  -- Treesitter trickery
  require("nvim-treesitter.configs").setup({ rainbow = { enable = true } })
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
      local guess = require("guess-indent").guess_from_buffer(args.buf)
      if guess == nil then
        local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
        local profile = profiles.lang[filetype]
        if profile ~= nil then
          require("util").setuptabs(vim.opt_local, profile)
        end
      else
        require("util").set_indent(guess)
      end
    end,
  })

  -- local augroup = util.augroup("tabprofiles")
  -- util.autocmd({ "FileReadPost" }, {
  --   group = augroup,
  --   callback = function()
  --     if require("guess-indent").guess_from_buffer() == nil then
  --       local profile = profiles.lang[vim.bo.filetype]
  --       if not profile == nil then
  --         util.setuptabs(vim.opt_local, profile)
  --       end
  --     end
  --   end,
  -- })

  vim.cmd([[
  " settab command
  command! SetTab lua require("util").set_tab()
  command! Tab lua require("util").set_tab()
  command! -nargs=? SetSpace lua require("util").set_space(<f-args>)
  command! -nargs=? Space lua require("util").set_space(<f-args>)
  ]])

  util.setuptabs(vim.opt, profiles.default)
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
