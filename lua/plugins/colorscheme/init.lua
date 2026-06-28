local cfg = vim.g.walcriz or {}
local name = cfg.appearance.colorscheme

if not name then
  return {}
end

local ok, spec = pcall(require, "plugins.colorscheme." .. name)
if not ok then
  vim.notify("Failed to load colorscheme: " .. name, vim.log.levels.ERROR)
  return {}
end

return spec
