local function setup_godot_remote_pipe()
  -- paths to check for project.godot file
  local paths_to_check = { "/", "/../" }
  local is_godot_project = false
  local godot_project_path = ""
  local cwd = vim.fn.getcwd()

  -- iterate over paths and check
  for _, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. "project.godot") then
      is_godot_project = true
      godot_project_path = cwd .. value
      break
    end
  end

  if not is_godot_project then
    return
  end

  -- check if server is already running in godot project path
  local pipe_path = godot_project_path .. "server.pipe"
  local is_server_running = vim.uv.fs_stat(pipe_path)

  -- start server, if not already running
  if not is_server_running then
    vim.fn.serverstart(pipe_path)
  end
end

return {
  lsp = "gdscript",
  init = setup_godot_remote_pipe,
  settings = {},
}
