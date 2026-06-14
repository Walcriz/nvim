local M = {
  root_patterns = { ".git" },
}

function M.safe_require(name)
  local ok, mod = pcall(require, name)
  return ok and mod or nil
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.augroup(name)
  return vim.api.nvim_create_augroup("walcriz_" .. name, { clear = true })
end

function M.autocmd(action, opts)
  return vim.api.nvim_create_autocmd(action, opts)
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.get_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil

  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r and path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    local marker = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = marker and vim.fs.dirname(marker) or vim.loop.cwd()
  end
  return root
end

function M.get_clients(opts)
  local ret = vim.lsp.get_clients(opts)

  if opts and opts.filter then
    ret = vim.tbl_filter(opts.filter, ret)
  end

  return ret
end

function M.client_supports_method(client, method)
  -- Prefix method if needed
  method = method:find("/") and method or "textDocument/" .. method

  -- Look up capability based on method
  local capability_map = {
    ["textDocument/hover"] = "hoverProvider",
    ["textDocument/definition"] = "definitionProvider",
    ["textDocument/completion"] = "completionProvider",
    ["textDocument/signatureHelp"] = "signatureHelpProvider",
    ["textDocument/references"] = "referencesProvider",
    ["textDocument/rename"] = "renameProvider",
    ["textDocument/codeAction"] = "codeActionProvider",
    ["textDocument/formatting"] = "documentFormattingProvider",
    ["textDocument/rangeFormatting"] = "documentRangeFormattingProvider",
    ["textDocument/onTypeFormatting"] = "documentOnTypeFormattingProvider",
  }

  local cap = capability_map[method]
  if not cap then
    -- fallback: check if method exists in dynamicCapabilities
    return client.server_capabilities[method] ~= nil
  end
  return client.server_capabilities[cap] ~= nil
end

return M
