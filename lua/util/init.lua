local M = {}

M.root_patterns = { ".git", "lua" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
      and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace)
      or client.config.root_dir and { client.config.root_dir }
      or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client)
        return require("util").client_supports_method(client, opts.method, opts.bufnr)
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

-- this will return a function that calls telescope.
-- cwd will default to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

function M.telescope_extensions(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    require("telescope.extensions")[builtin](opts)
  end
end

function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    size = { width = 0.9, height = 0.9 },
  }, opts or {})
  require("lazy.util").float_term(cmd, opts)
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = "Option" })
    else
      Util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.enable(false)
    Util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

function M.deprecate(old, new)
  Util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "Neovim" })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.set_indent(buf, indentation)
  local function set_buffer_opt(name, value)
    -- Setting an option takes *significantly* more time than reading it.
    -- This wrapper function only sets the option if the new value differs
    -- from the current value.
    local current = vim.api.nvim_get_option_value(name, { buf = buf })
    if value ~= current then
      vim.api.nvim_set_option_value(name, value, { buf = buf })
    end
  end

  if indentation == "tabs" then
    M.set_preset_indentation(buf, { usetabs = true })
    set_buffer_opt("expandtab", false)
  elseif type(indentation) == "number" and indentation > 0 then
    M.set_preset_indentation(buf)
    M.setuptabs(buf, {
      usetabs = false,
      tabsize = indentation,
    })
  end
end

function M.set_preset_indentation(buf, overrides)
  overrides = overrides or {}
  local profiles = require("config.tabprofiles")
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
  local profile = profiles.lang[filetype]

  profile = vim.tbl_extend("force", profile, overrides)

  if profile ~= nil then
    M.setuptabs(buf, profile)
  else
    M.setuptabs(buf, profiles.default)
  end
end

function M.get_indent_lualine()
  return {
    function()
      -- Get indentation settings
      local expandtab = vim.bo.expandtab
      local shiftwidth = vim.bo.shiftwidth
      local tabstop = vim.bo.tabstop

      if expandtab then
        return 'spc ' .. shiftwidth
      else
        return 'tab ' .. tabstop
      end
    end,
    -- icon = '⇥',  -- Optional icon for style
    -- color = { fg = '#ffffff', gui = 'bold' }  -- Optional styling
  }
end

function M.set_tab(size)
  size = size or 2

  vim.opt_local.expandtab = false
  vim.opt_local.tabstop = size
end

function M.set_space(size)
  size = tonumber(size)
  size = size or 2
  vim.opt_local.expandtab = true
  vim.opt_local.tabstop = size
  vim.opt_local.softtabstop = size
  vim.opt_local.shiftwidth = size
end

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.augroup(name)
  return vim.api.nvim_create_augroup("walvim_" .. name, { clear = true })
end

function M.autocmd(action, opts)
  return vim.api.nvim_create_autocmd(action, opts)
end

function M.setuptabs(buf, profile)
  if profile.usetabs then
    vim.api.nvim_set_option_value("tabstop", profile.tabsize, { buf = buf })
    vim.api.nvim_set_option_value("shiftwidth", profile.tabsize, { buf = buf })
    vim.api.nvim_set_option_value("softtabstop", 0, { buf = buf })
    vim.api.nvim_set_option_value("expandtab", false, { buf = buf })
  else
    vim.api.nvim_set_option_value("shiftwidth", profile.tabsize, { buf = buf })
    vim.api.nvim_set_option_value("expandtab", true, { buf = buf })

    if profile.visualtabsize then
      vim.api.nvim_set_option_value("tabstop", profile.visualtabsize, { buf = buf })
    else
      vim.api.nvim_set_option_value("tabstop", 10, { buf = buf })
    end

    vim.api.nvim_set_option_value("softtabstop", 0, { buf = buf })
  end

  M.highlight_bad_indent(buf, profile.usetabs)
end

function M.telescope_image_preview()
  local supported_images = { "svg", "png", "jpg", "jpeg", "gif", "webp", "avif" }
  local from_entry = require("telescope.from_entry")
  local Path = require("plenary.path")
  local conf = require("telescope.config").values
  local Previewers = require("telescope.previewers")

  local previewers = require("telescope.previewers")
  local image_api = require("image")

  local is_image_preview = false
  local image = nil
  local last_file_path = ""

  local is_supported_image = function(filepath)
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(supported_images, extension)
  end

  local delete_image = function()
    if not image then
      return
    end

    image:clear()

    is_image_preview = false
  end

  local create_image = function(filepath, winid, bufnr)
    image = image_api.hijack_buffer(filepath, winid, bufnr)

    if not image then
      return
    end

    vim.schedule(function()
      image:render()
    end)

    is_image_preview = true
  end

  local function defaulter(f, default_opts)
    default_opts = default_opts or {}
    return {
      new = function(opts)
        if conf.preview == false and not opts.preview then
          return false
        end
        opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
        if type(conf.preview) == "table" then
          for k, v in pairs(conf.preview) do
            opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
          end
        end
        return f(opts)
      end,
      __call = function()
        local ok, err = pcall(f(default_opts))
        if not ok then
          error(debug.traceback(err))
        end
      end,
    }
  end

  -- NOTE: Add teardown to cat previewer to clear image when close Telescope
  local file_previewer = defaulter(function(opts)
    opts = opts or {}
    local cwd = opts.cwd or vim.loop.cwd()
    return Previewers.new_buffer_previewer({
      title = "File Preview",
      dyn_title = function(_, entry)
        return Path:new(from_entry.path(entry, true)):normalize(cwd)
      end,

      get_buffer_by_name = function(_, entry)
        return from_entry.path(entry, true)
      end,

      define_preview = function(self, entry, _)
        local p = from_entry.path(entry, true)
        if p == nil or p == "" then
          return
        end

        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
          preview = opts.preview,
        })
      end,

      teardown = function(_)
        if is_image_preview then
          delete_image()
        end
      end,
    })
  end, {})

  local buffer_previewer_maker = function(filepath, bufnr, opts)
    -- NOTE: Clear image when preview other file
    if is_image_preview and last_file_path ~= filepath then
      delete_image()
    end

    last_file_path = filepath

    if is_supported_image(filepath) then
      create_image(filepath, opts.winid, bufnr)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end

  return { buffer_previewer_maker = buffer_previewer_maker, file_previewer = file_previewer.new }
end

-- Utility function to check if a client supports a method
function M.client_supports_method(client, method, bufnr)
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
