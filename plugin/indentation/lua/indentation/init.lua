local M = {}

M.config = {
  default = {
    usetabs = false,
    tabsize = 2,
    visualtabsize = 4,
  },

  lang = {
    c = { usetabs = false, tabsize = 2 },
    cpp = { usetabs = false, tabsize = 2 },
    cs = { usetabs = false, tabsize = 4 },
    java = { usetabs = false, tabsize = 4 },
    python = { usetabs = true, tabsize = 4 },
    javascript = { usetabs = false, tabsize = 2 },
    typescript = { usetabs = false, tabsize = 2 },
    javascriptreact = { usetabs = false, tabsize = 2 },
    typescriptreact = { usetabs = false, tabsize = 2 },
    lua = { usetabs = true, tabsize = 2 },
    go = { usetabs = false, tabsize = 2 },
    julia = { usetabs = false, tabsize = 4 },
    make = { usetabs = true, tabsize = 2 },
  },
}

function M.set_tab(size)
  size = tonumber(size)
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

function M.apply_profile(buf, profile)
  local opt = vim.opt_local

  if profile.usetabs then
    opt.tabstop = profile.tabsize
    opt.shiftwidth = profile.tabsize
    opt.softtabstop = 0
    opt.expandtab = false
  else
    opt.shiftwidth = profile.tabsize
    opt.expandtab = true

    if profile.visualtabsize then
      opt.tabstop = profile.visualtabsize
    else
      opt.tabstop = 2
    end

    opt.softtabstop = 0
  end

  opt.smarttab = true
end

function M.set_from_preset(buf, ft)
  local profile = M.config.lang[ft] or M.config.default
  if vim.g.walcriz.core.notify_about_indentation then
    vim.notify("Using preset indentation for " .. ft, vim.log.levels.INFO)
  end
  M.apply_profile(buf, profile)
end

function M.setup(user_config)
  if user_config then
    M.config = vim.tbl_deep_extend("force", M.config, user_config)
  end

  require("indentation.guess_indent").setup({
    auto_cmd = false,
    override_editorconfig = true,
  })

  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
      local buf = args.buf
      local ft = vim.bo[buf].filetype

      -- EditorConfig support
      local ec = vim.b[buf].editorconfig
      if ec and type(ec) == "table" then
        local size = tonumber(ec.indent_size or ec.tab_width)
        local style = ec.indent_style

        if size then
          if vim.g.walcriz.core.notify_about_indentation then
            vim.notify("Using EditorConfig: " .. size .. " " .. tostring(style), vim.log.levels.INFO)
          end
          M.apply_profile(buf, {
            tabsize = size,
            usetabs = (style == "tab"),
          })
          return
        end
      end

      -- fallback: guess indent
      local guess = require("indentation")
      if guess.guess_from_buffer then
        local g = guess.guess_from_buffer(buf)
        if g then
          if vim.g.walcriz.core.notify_about_indentation then
            vim.notify("Using indent guess: " .. g, vim.log.levels.INFO)
          end
          vim.bo[buf].shiftwidth = g
          vim.bo[buf].tabstop = g
          vim.bo[buf].expandtab = true
          return
        end
      end

      M.set_from_preset(buf, ft)
    end,
  })

  vim.api.nvim_create_user_command("SetTab", function(opts)
    M.set_tab(opts.args)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("SetSpace", function(opts)
    M.set_space(opts.args)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("Tab", function(opts)
    M.set_tab(opts.args)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("Space", function(opts)
    M.set_space(opts.args)
  end, { nargs = "?" })

  -- apply default on startup buffer
  M.apply_profile(0, M.config.default)
end

return M
