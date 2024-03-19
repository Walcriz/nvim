local Util = require("lazy.core.util")

local M = {}

M.autoformat = false

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    Util.info("Enabled format on save", { title = "Format" })
  else
    Util.warn("Disabled format on save", { title = "Format" })
  end
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false then
    return
  end
  local ft = vim.bo[buf].filetype

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      return client.name ~= "null-ls"
    end,
  }, require("util").opts("nvim-lspconfig").format or {}))
end

function M.on_attach(client, buf)
  local guess = require("guess-indent").guess_from_buffer()
  if guess == nil then
    local profiles = require("config.tabprofiles")
    local profile = profiles.lang[vim.bo.filetype]
    if not profile == nil then
      require("util").setuptabs(vim.opt_local, profile)
    end
  else
    require("util").set_indent(guess)
  end

  -- dont format if client disabled it
  if
      client.config
      and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false
  then
    return
  end

  -- if client.supports_method("textDocument/formatting") then
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
  --     buffer = buf,
  --     callback = function()
  --       if M.autoformat then
  --         M.format()
  --       end
  --     end,
  --   })
  -- end
end

return M
