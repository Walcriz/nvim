return {
  lsp = "qmlls",

  setup = function(client)
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.semantic_tokens.enable(false, { client_id = client.id })
  end,
}
