local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
	local format = require("plugins.lsp.format").format
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
			{ "äd", M.diagnostic_goto(true), desc = "Next Diagnostic" },
			{ "åd", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
			{ "äe", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
			{ "åe", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
			{ "äw", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
			{ "åw", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
			{ "<M-CR>", "<cmd>lua require('fastaction').code_action()<cr>", desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
			{ "<leader>r=", format, desc = "Format Document", has = "documentFormatting" },
			{ "<leader>r=", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
		}
		if require("util").has("inc-rename.nvim") then
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
	local clients = require("util").get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

function M.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end
	local spec = M.get()
	local opts = require("util").opts("nvim-lspconfig")
	local clients = require("util").get_clients({ bufnr = buffer })
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
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M
