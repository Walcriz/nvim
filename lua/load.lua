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

return M
