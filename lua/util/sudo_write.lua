local M = {}

-- =========================
-- config
-- =========================

M.config = {
  cache_ttl = 300, -- seconds
  max_retries = 3,
  use_sudo_timestamp = true,
}

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
end

-- =========================
-- cache (memory only)
-- =========================

local cache = {
  password = nil,
  expires = 0,
  backend = nil,
}

local function cache_valid()
  return cache.password ~= nil and os.time() < cache.expires
end

local function set_cache(pw, backend)
  cache.password = pw
  cache.backend = backend
  cache.expires = os.time() + M.config.cache_ttl
end

local function clear_cache()
  cache.password = nil
  cache.backend = nil
  cache.expires = 0
end

-- =========================
-- helpers
-- =========================

local function cmdmsg(text, hl)
  vim.schedule(function()
    vim.api.nvim_echo({ { text, hl or "None" } }, false, {})
  end)
end

local function is_remote(path)
  return path:match("^%a+://") ~= nil
end

local function detect_backend()
  if vim.fn.executable("sudo") == 1 then
    return "sudo"
  elseif vim.fn.executable("doas") == 1 then
    return "doas"
  else
    return nil
  end
end

local function prompt_password(backend)
  local user = os.getenv("USER") or "user"
  local prompt

  if backend == "sudo" then
    prompt = "[sudo] password for " .. user .. ": "
  else
    prompt = "[doas] password: "
  end

  local ok, pw = pcall(vim.fn.inputsecret, prompt)

  if not ok then
    return nil -- cancelled with Ctrl-C
  end

  return pw -- may be empty string (allowed)
end

-- =========================
-- sudo/doas validate
-- =========================

local function validate_password(backend, pw, cb)
  if backend ~= "sudo" or not M.config.use_sudo_timestamp then
    cb(true)
    return
  end

  vim.system(
    { "sudo", "-S", "-v" },
    { stdin = pw .. "\n", text = true },
    function(obj)
      vim.schedule(function()
        cb(obj.code == 0)
      end)
    end
  )
end

-- =========================
-- privileged write
-- =========================

local function privileged_write(backend, password, file, content, cb)
  local cmd

  if backend == "sudo" then
    cmd = { "sudo", "-S", "tee", file }
  else
    cmd = { "doas", "tee", file }
  end

  vim.system(
    cmd,
    { stdin = password .. "\n" .. content, text = true },
    function(obj)
      vim.schedule(function()
        cb(obj.code == 0, obj.stderr)
      end)
    end
  )
end

-- =========================
-- retry loop
-- =========================

local function retry_loop(file, content, backend, tries)
  if tries > M.config.max_retries then
    cmdmsg("Authentication failed", "ErrorMsg")
    clear_cache()
    return
  end

  local pw = prompt_password(backend)

  if pw == nil then
    cmdmsg("Cancelled", "None")
    return
  end

  validate_password(backend, pw, function(valid)
    if not valid then
      vim.notify("Sorry, try again.", vim.log.levels.INFO, { title = "Privileged Write" })
      retry_loop(file, content, backend, tries + 1)
      return
    end

    privileged_write(backend, pw, file, content, function(ok)
      if ok then
        set_cache(pw, backend)
        vim.cmd("edit!")
        vim.notify("Saved with " .. backend, vim.log.levels.INFO)
      else
      cmdmsg("Write failed — retrying", "WarningMsg")
        retry_loop(file, content, backend, tries + 1)
      end
    end)
  end)
end

-- =========================
-- remote write via temp file
-- =========================

local function remote_write(path)
  local tmp = vim.fn.tempname()

  vim.cmd("write! " .. tmp)
  vim.cmd("silent keepalt edit " .. tmp)

  retry_loop(tmp,
    table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n") .. "\n",
    detect_backend(),
    1
  )

  vim.cmd("edit! " .. path)
end

-- =========================
-- main entry
-- =========================

function M.save_with_sudo()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.cmd("write")
    return
  end

  if is_remote(file) then
    remote_write(file)
    return
  end

  if not (vim.bo.modifiable
        and vim.fn.filereadable(file) == 1
        and vim.fn.filewritable(file) == 0) then
    vim.cmd("write")
    return
  end

  local backend = detect_backend()
  if not backend then
    cmdmsg("Neither sudo nor doas found", "ErrorMsg")
    return
  end

  local content =
      table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n") .. "\n"

  -- cached path
  if cache_valid() and cache.backend == backend then
    privileged_write(backend, cache.password, file, content, function(ok)
      if ok then
        vim.cmd("edit!")
        cmdmsg("Saved with " .. backend, "MoreMsg")
      else
        clear_cache()
        retry_loop(file, content, backend, 1)
      end
    end)
    return
  end

  retry_loop(file, content, backend, 1)
end

return M
