return {
  -- Template files
  {
    "cvigilv/esqueleto.nvim",
    lazy = false,
    opts = {
      autouse = true,

      wildcards = {
        expand = true,
        lookup = {
          cs_namespace = function()
            local Path = require("plenary.path")
            local scan = require("plenary.scandir")

            -- 1. Find the .csproj file above us
            local file = vim.fn.expand("%:p")
            local dir  = Path:new(file):parent()
            local csproj
            while dir.filename ~= "/" do
              local found = scan.scan_dir(dir.filename, { depth = 1, search_pattern = "%.csproj$" })
              if #found > 0 then
                csproj = found[1]
                break
              end
              dir = dir:parent()
            end
            if not csproj then
              return "DefaultNamespace"
            end

            -- 2. Read RootNamespace from the csproj
            local root_ns
            for _, line in ipairs(vim.fn.readfile(csproj)) do
              local ns = line:match("<RootNamespace>(.-)</RootNamespace>")
              if ns then
                root_ns = ns
                break
              end
            end
            if not root_ns then
              return "DefaultNamespace"
            end

            -- 3. Compute the path *under* the csproj folder
            local proj_dir = Path:new(csproj):parent().filename
            -- Note: we ask for the file’s parent dir (the folder), then make it relative
            local rel = Path:new(file):parent():make_relative(Path:new(csproj):parent().filename)

            -- 4. Turn that into a “.Suffix” (dropping empty)
            local suffix = rel:gsub("[/\\]", "."):gsub("^%.", ""):gsub("%.$", "")
            if suffix == "" then
              return root_ns
            else
              return root_ns .. "." .. suffix
            end
          end,
        },
      }
    },

    config = function(_, opts)
      require("esqueleto").setup(opts)

      vim.cmd [[
      augroup esqueleto
      autocmd!
      augroup END
      ]]

      vim.api.nvim_create_user_command("Fill", function()
        vim.cmd("EsqueletoInsert")
      end, { nargs = 0 })
    end,

    event = { "BufNewFile", "BufReadPost" },
  },
}
