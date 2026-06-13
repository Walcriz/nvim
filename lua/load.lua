local M = {}

function M.load_config(name)
  local function load_module(mod)
    local ok = pcall(require, mod)
    if ok then
      return
    end
  end

  if vim.g.vscode then
    -- VSCode overrides
    load_module("visualstudio." .. name)
  else
    -- Shared config
    load_module("config." .. name)
  end

  -- Machine-local overrides
  load_module("_local." .. name)

  if vim.bo.filetype == "lazy" then
    -- HACK: Neovim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
end

function M.auto_load_config()
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

return M
