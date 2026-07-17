local M = {}

---@type PluginLspKeys
M._keys = nil

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false then
    return
  end

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
  }, require("common").opts("nvim-lspconfig").format or {}))
end

---@return (LazyKeys|{has?:string})[]
function M.get()
  if not M._keys then
    ---@class PluginLspKeys
    -- stylua: ignore
    M._keys =  {
      { "<leader>dd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>dl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
      { "gR", "<cmd>Telescope lsp_references<cr>", desc = "References"},
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      -- { "äd", M.diagnostic_goto(true), desc = "Next Diagnostic" },
      -- { "åd", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
      -- { "äe", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      -- { "åe", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      -- { "äw", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      -- { "åw", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      { "<M-CR>", "<cmd>lua require('fastaction').code_action()<cr>", desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { "<leader>r=", M.format, desc = "Format Document", has = "documentFormatting" },
      { "<leader>r=", M.format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
    }
    if require("common").has("inc-rename.nvim") then
      M._keys[#M._keys + 1] = {
        "rr",
        function()
          require("inc_rename")
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename",
        has = "rename",
      }
    else
      M._keys[#M._keys + 1] = { "rr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    end
  end
  return M._keys
end
--
---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = require("common").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if require("common").client_supports_method(client, method) then
      return true
    end
  end
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = vim.deepcopy(M.get())
  local opts = require("common").opts("nvim-lspconfig")
  local clients = require("common").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

function M.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil

  return function()
    vim.diagnostic.jump({
      count = next and 1 or -1,
      severity = severity,
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr })
      end,
    })
  end
end

return {
  "neovim/nvim-lspconfig",

  enabled = vim.g.walcriz.core.lsp,

  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
    { "folke/lazydev.nvim", opts = {} },
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    "ray-x/lsp_signature.nvim",
    "Chaitanyabsprip/fastaction.nvim",
  },

  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
    },

    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },

    servers = vim.tbl_deep_extend("force", {
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
          },
        },
      },
    }, require("plugins.lang._loader").load().servers),

    disabled_filetypes = {},

    setup = {},
  },

  config = function(_, opts)
    local util = require("common")
    local lang = require("plugins.lang._loader").load()
    util.on_attach(function(client, buffer)
      M.on_attach(client, buffer)

      local handler = lang.setup_handlers[client.name]
      if handler then
        handler(client, buffer)
      end
    end)

    -- Format command
    vim.cmd([[
      command! Format execute 'lua vim.lsp.buf.format({ async = true })'
    ]])

    local icons = vim.g.walcriz.icons.diagnostics
    opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics, {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.Error,
          [vim.diagnostic.severity.WARN] = icons.Warn,
          [vim.diagnostic.severity.INFO] = icons.Info,
          [vim.diagnostic.severity.HINT] = icons.Hint,
        },
      },
    })

    vim.diagnostic.config(opts.diagnostics)

    require("plugins.lang._lazyload").setup(lang.langs)

    local servers = opts.servers
    local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if lang.filetype_overrides[server] then
        server_opts.filetypes = lang.filetype_overrides[server]
      end

      if lang.on_new_config_handlers[server] then
        local user_on_new_config = lang.on_new_config_handlers[server]
        local existing_on_new_config = server_opts.on_new_config
        server_opts.on_new_config = function(new_config, root_dir)
          if existing_on_new_config then
            existing_on_new_config(new_config, root_dir)
          end
          user_on_new_config(new_config, root_dir)
        end
      end

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      vim.lsp.config(server, server_opts)
      vim.lsp.enable(server)
    end

    local mlsp = require("mason-lspconfig")

    for server, server_opts in pairs(servers) do
      if server_opts then
        setup(server)
      end
    end

    mlsp.setup({ automatic_enable = true })
  end,
}
