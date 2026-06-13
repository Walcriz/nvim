local M = {}

function M.is_enabled(lsp_name, lang)
  local cfg = vim.g.walcriz or {}
  for _, name in ipairs(cfg.enabled_lsps or {}) do
    if name == lsp_name then
      return true
    end
  end

  local mason_name = lang.mason or lsp_name
  local ok, registry = pcall(require, "mason-registry")
  if ok and registry.has_package(mason_name) then
    local pkg_ok, pkg = pcall(registry.get_package, mason_name)
    if pkg_ok and pkg:is_installed() then
      return true
    end
  end

  return false
end

function M.is_installed(lsp_name)
  local ok, registry = pcall(require, "mason-registry")
  if ok then
    return registry.has_package(lsp_name)
  end
  vim.notify("mason-registry not found!", vim.log.levels.ERROR)
  return false
end

M.data = nil
function M.load()
  if M.data then
    return M.data
  end

  local servers = {}
  local setup_handlers = {}
  local on_new_config_handlers = {}
  local dependencies = {}
  local langs = {}
  local dir = vim.fn.stdpath("config") .. "/lua/plugins/lang"
  for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    if name ~= "_loader" and name ~= "_lazyload" then
      local ok, lang = pcall(require, "plugins.lang." .. name)
      if not ok then
        vim.notify("plugins.lang." .. name .. ": " .. tostring(lang), vim.log.levels.ERROR)
      elseif lang.lsp then
        servers[lang.lsp] = lang.settings or {}
        if lang.setup then
          setup_handlers[lang.lsp] = lang.setup
        end
        if lang.on_new_config then
          on_new_config_handlers[lang.lsp] = lang.on_new_config
        end
        if lang.dependencies then
          vim.list_extend(dependencies, lang.dependencies)
        end
        table.insert(langs, lang)
      end
    end
  end
  M.data = {
    servers = servers,
    setup_handlers = setup_handlers,
    on_new_config_handlers = on_new_config_handlers,
    dependencies = dependencies,
    langs = langs,
  }

  return M.data
end

return M
