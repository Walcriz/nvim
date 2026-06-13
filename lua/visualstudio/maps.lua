local map = require("common").keymap

-- ================ --
-- CMDS
-- ================ --
vim.api.nvim_create_user_command("Format", function()
  require("vscode").action("editor.action.formatDocument")
end, {})

-- ================ --
-- LSP
-- ================ --

map("n", "<leader>dd", "<cmd>lua require('vscode').action('editor.action.showHover')<cr>", { desc = "Line Diagnostics" })
map("n", "gd", function() require("vscode").action("editor.action.revealDefinition") end, { desc = "Goto Definition" })
map("n", "gD", function() require("vscode").action("editor.action.revealDeclaration") end, { desc = "Goto Declaration" })
map("n", "gi", function() require("vscode").action("editor.action.goToImplementation") end, { desc = "Goto Implementation" })
map("n", "gt", function() require("vscode").action("editor.action.goToTypeDefinition") end, { desc = "Goto Type Definition" })
map("n", "gR", function() require("vscode").action("editor.action.goToReferences") end, { desc = "References" })
map("n", "K", function() require("vscode").action("editor.action.showHover") end, { desc = "Hover" })
map("n", "gK", function() require("vscode").action("editor.action.triggerParameterHints") end, { desc = "Signature Help" })
map("i", "<c-k>", function() require("vscode").action("editor.action.triggerParameterHints") end, { desc = "Signature Help" })
map("n", "rr", function() require("vscode").action("editor.action.rename") end, { desc = "Rename" })
map({ "n", "v" }, "<M-CR>", function() require("vscode").action("editor.action.quickFix") end, { desc = "Code Action" })
map("n", "<leader>r=", function() require("vscode").action("editor.action.formatDocument") end, { desc = "Format Document" })
map("v", "<leader>r=", function() require("vscode").action("editor.action.formatSelection") end, { desc = "Format Range" })

-- Diagnostic navigation
map("n", "äd", function() require("vscode").action("editor.action.marker.next") end, { desc = "Next Diagnostic" })
map("n", "åd", function() require("vscode").action("editor.action.marker.prev") end, { desc = "Prev Diagnostic" })

-- ================ --
-- Search
-- ================ --

local vscode = require("vscode")

-- Switch buffer / command history
map("n", "<leader>,", function() vscode.action("workbench.action.showAllEditors") end, { desc = "Switch Buffer" })
map("n", "<leader>:", function() vscode.action("workbench.action.showCommands") end, { desc = "Command History" })

-- find
map("n", "<leader>fb", function() vscode.action("workbench.action.showAllEditors") end, { desc = "Buffers" })
map("n", "ff", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find Files (cwd)" })
map("n", "FF", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find Files (root dir)" })
map("n", "<leader>fr", function() vscode.action("workbench.action.openRecent") end, { desc = "Recent" })

-- git
map("n", "<leader>gc", function() vscode.action("git.viewHistory") end, { desc = "commits" })
map("n", "<leader>gs", function() vscode.action("workbench.view.scm") end, { desc = "status" })

-- search
map("n", "<leader>sb", function() vscode.action("actions.find") end, { desc = "Buffer" })
map("n", "<leader>sc", function() vscode.action("workbench.action.showCommands") end, { desc = "Command History" })
map("n", "<leader>sC", function() vscode.action("workbench.action.showCommands") end, { desc = "Commands" })
map("n", "<leader>sd", function() vscode.action("workbench.actions.view.problems") end, { desc = "Diagnostics" })
map("n", "fg", function() vscode.action("workbench.action.findInFiles") end, { desc = "Grep (root dir)" })
map("n", "<leader>sG", function() vscode.action("workbench.action.findInFiles") end, { desc = "Grep (cwd)" })
map("n", "<leader>sh", function() vscode.action("workbench.action.openWalkthrough") end, { desc = "Help Pages" })
map("n", "<leader>sk", function() vscode.action("workbench.action.openGlobalKeybindings") end, { desc = "Key Maps" })
map("n", "<leader>sm", function() vscode.action("workbench.action.showAllSymbols") end, { desc = "Jump to Mark" })
map("n", "<leader>so", function() vscode.action("workbench.action.openSettings") end, { desc = "Options" })

-- word search
map("n", "<leader>sw", function()
  vscode.action("workbench.action.findInFiles", {
    args = { query = vim.fn.expand("<cword>") },
  })
end, { desc = "Word (root dir)" })
map("n", "<leader>sW", function()
  vscode.action("workbench.action.findInFiles", {
    args = { query = vim.fn.expand("<cword>") },
  })
end, { desc = "Word (cwd)" })

-- colorscheme
map("n", "<leader>uC", function() vscode.action("workbench.action.selectTheme") end,
  { desc = "Colorscheme with preview" })

-- symbols
map("n", "<leader>ss", function() vscode.action("workbench.action.gotoSymbol") end, { desc = "Goto Symbol" })
map("n", "<leader>sS", function() vscode.action("workbench.action.showAllSymbols") end,
  { desc = "Goto Symbol (Workspace)" })

-- ================ --
-- File Explorer
-- ================ --
map("n", "<leader>tt", function() require("vscode").action("workbench.view.explorer") end, { desc = "File Browser" })
map("n", "fn",         function() require("vscode").action("workbench.view.explorer") end, { desc = "File Browser" })
map("n", "<leader>e",  function() require("vscode").action("workbench.files.action.showActiveFileInExplorer") end, { desc = "Find File in Explorer" })

-- ================ --
-- Search / Replace
-- ================ --
map("n", "<leader>sr", function() require("vscode").action("workbench.action.replaceInFiles") end, { desc = "Replace in Files (Spectre)" })
map("n", "<leader>st", function()
  require("vscode").action("workbench.action.findInFiles", {
    args = { query = "TODO|FIX|FIXME" },
  })
end, { desc = "Todo" })

-- ================ --
-- Git
-- ================ --
map("n", "<leader>gg", function() require("vscode").action("workbench.view.scm") end, { desc = "Open Git (Neogit)" })

-- ================ --
-- Diagnostics / Trouble
-- ================ --
map("n", "]t",         function() require("vscode").action("editor.action.marker.next") end, { desc = "Next Todo Comment" })
map("n", "[t",         function() require("vscode").action("editor.action.marker.prev") end, { desc = "Prev Todo Comment" })
map("n", "<leader>xt", function() require("vscode").action("workbench.actions.view.problems") end, { desc = "Todo (Trouble)" })
map("n", "<leader>xT", function() require("vscode").action("workbench.actions.view.problems") end, { desc = "Todo/Fix/Fixme (Trouble)" })
map("n", "<leader>dl", function() require("vscode").action("workbench.action.showOutputChannels") end, { desc = "LSP Info / Output Channels" })

-- ================ --
-- DAP (Debug)
-- ================ --
map("n", "<leader>db", function() require("vscode").action("editor.debug.action.toggleBreakpoint") end, { desc = "Toggle Breakpoint" })
map("n", "<leader>ds", function() require("vscode").action("workbench.action.debug.continue") end, { desc = "Start/Continue" })
map("n", "<leader>do", function() require("vscode").action("workbench.action.debug.stepOver") end, { desc = "Step Over" })
map("n", "<leader>di", function() require("vscode").action("workbench.action.debug.stepInto") end, { desc = "Step Into" })
map("n", "<F7>",       function() require("vscode").action("workbench.action.debug.continue") end, { desc = "Start/Continue" })
map("n", "<F8>",       function() require("vscode").action("workbench.action.debug.stepOver") end, { desc = "Step Over" })
map("n", "<F6>",       function() require("vscode").action("workbench.action.debug.stepInto") end, { desc = "Step Into" })
