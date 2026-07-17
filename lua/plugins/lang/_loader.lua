local M = {}

local function mason_name(lsp_name, lang)
  if type(lang) == "table" and lang.mason then
    return lang.mason
  end
  return lsp_name
end

--- Does nvim-lspconfig (or native vim.lsp.config) know how to start this server?
local function lspconfig_has(lsp_name)
  if vim.lsp.config then
    local ok, cfg = pcall(function()
      return vim.lsp.config[lsp_name]
    end)
    if ok and cfg then
      return true
    end
  end
  local ok, configs = pcall(require, "lspconfig.configs")
  if ok and configs[lsp_name] then
    return true
  end
  return false
end

function M.is_enabled(lsp_name, lang)
  local cfg = vim.g.walcriz or {}
  for _, name in ipairs(cfg.enabled_lsps or {}) do
    if name == lsp_name then
      return true
    end
  end

  local pkg_name = mason_name(lsp_name, lang)
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    -- no mason at all, fall back purely to lspconfig availability
    return lspconfig_has(lsp_name)
  end

  local has_pkg = registry.has_package(pkg_name)
  if has_pkg then
    local pkg_ok, pkg = pcall(registry.get_package, pkg_name)
    if pkg_ok and pkg:is_installed() then
      return true
    end
    return false -- mason knows it but it isn't installed yet
  end

  -- mason has never heard of this server -> nothing to install via mason,
  -- so treat "lspconfig knows it" as good enough
  return lspconfig_has(lsp_name)
end

function M.is_installed(lsp_name, lang)
  local pkg_name = mason_name(lsp_name, lang)
  local ok, registry = pcall(require, "mason-registry")
  if ok and registry.has_package(pkg_name) then
    return registry.get_package(pkg_name):is_installed()
  end
  return lspconfig_has(lsp_name)
end

M.data = nil

function M.load()
  if M.data then
    return M.data
  end

  local servers = {}
  local setup_handlers = {}
  local on_new_config_handlers = {}
  local filetype_overrides = {}
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
        if lang.filetypes then
          filetype_overrides[lang.lsp] = lang.filetypes
        end
        if lang.dependencies then
          vim.list_extend(dependencies, lang.dependencies)
        end
        if lang.init then
          local init_ok, init_err = pcall(lang.init)
          if not init_ok then
            vim.notify("plugins.lang." .. name .. " init(): " .. tostring(init_err), vim.log.levels.ERROR)
          end
        end
        table.insert(langs, lang)
      end
    end
  end

  M.data = {
    servers = servers,
    setup_handlers = setup_handlers,
    on_new_config_handlers = on_new_config_handlers,
    filetype_overrides = filetype_overrides,
    dependencies = dependencies,
    langs = langs,
  }
  return M.data
end

return M
