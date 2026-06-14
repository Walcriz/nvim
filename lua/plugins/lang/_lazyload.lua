local M = {}
M._initialized = false

local function dep_names(deps)
  local names = {}
  for _, dep in ipairs(deps or {}) do
    local name
    if type(dep) == "table" then
      name = dep.name or dep[1]
    else
      name = dep
    end
    name = name:match("^[^/]+/(.+)$") or name
    table.insert(names, name)
  end
  return names
end

--- @param langs table[] list of lang specs (with .lsp, .mason, .dependencies)
function M.setup(langs)
  if M._initialized then
    return
  end
  M._initialized = true

  local function load_for(predicate, install_first)
    for _, lang in ipairs(langs) do
      if lang.dependencies and predicate(lang) then
        local names = dep_names(lang.dependencies)
        if #names > 0 then
          if install_first then
            -- enabled() now returns true for this lang, so this will
            -- actually install plugins that were skipped at startup
            require("lazy").install({ show = false, wait = true, plugins = names })
          end
          require("lazy").load({ plugins = names })
        end
      end
    end
  end

  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    vim.notify("mason-registry not found!", vim.log.levels.ERROR)
    return
  end

  -- When mason finishes installing a package, install + load matching extra plugins
  registry:on("package:install:success", function(pkg)
    vim.notify(pkg.name .. " installed", vim.log.levels.INFO)
    vim.schedule(function()
      load_for(function(lang)
        return (lang.mason or lang.lsp) == pkg.name
      end, true)
    end)
  end)

  -- When an LSP client attaches, load matching extra plugins (already installed)
  local group = vim.api.nvim_create_augroup("WalcrizLangLazyload", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end
      load_for(function(lang)
        return lang.lsp == client.name
      end, false)
    end,
  })
end

return M
