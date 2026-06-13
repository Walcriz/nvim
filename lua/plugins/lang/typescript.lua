return {
  lsp = "tsserver",

  setup = function()
    require("common").on_attach(function(client, buffer)
      if client.name == "tsserver" then
        -- stylua: ignore
        vim.keymap.set("n", "<leader>ro", "<cmd>TypescriptOrganizeImports<CR>",
          { buffer = buffer, desc = "Organize Imports" })
        -- stylua: ignore
        vim.keymap.set("n", "<leader>rR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
      end
    end)
  end,
}
