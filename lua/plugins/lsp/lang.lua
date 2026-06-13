local loader = require("plugins.lang._loader")
local data = loader.load()

local deps = {}
for _, lang in ipairs(data.langs) do
  for _, dep in ipairs(lang.dependencies or {}) do
    local d = type(dep) == "table" and vim.deepcopy(dep) or { dep }

    local existing_enabled = d.enabled
    d.enabled = function()
      if existing_enabled ~= nil then
        local ex = existing_enabled
        if type(ex) == "function" then
          ex = ex()
        end
        if not ex then
          return false
        end
      end
      return loader.is_enabled(lang.lsp, lang)
    end

    table.insert(deps, d)
  end
end

return deps
