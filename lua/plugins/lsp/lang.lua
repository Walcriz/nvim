local loader = require("plugins.lang._loader")
local data = loader.load()

local deps = {}
for _, lang in ipairs(data.langs) do
  local lang_spec = lang
  for _, dep in ipairs(lang.dependencies or {}) do
    local d = type(dep) == "table" and vim.deepcopy(dep) or { dep }

    local existing_enabled = d.enabled
    d.enabled = function(...)
      if existing_enabled ~= nil then
        local ex = existing_enabled
        if type(existing_enabled) == "function" then
          ex = existing_enabled(...)
        end
        if not ex then
          return false
        end
      end
      return loader.is_enabled(lang_spec.lsp, lang_spec)
    end

    table.insert(deps, d)
  end
end

return deps
