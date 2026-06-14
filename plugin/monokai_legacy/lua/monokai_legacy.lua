local vim = vim

local M = {}

M.palette = {
  name = "monokai-legacy",

  base0 = "#1F1E1F",
  base1 = "#1E1D1E",
  base2 = "#232223",
  base3 = "#2A292A",
  base4 = "#313031",
  base5 = "#474547",
  base6 = "#6A6768",
  base7 = "#A3A0A1",
  base8 = "#D8D5D6",

  border = "#504945",
  brown = "#504945",

  white = "#EEE1E3",
  darkened = "#929190",
  grey = "#72696A",
  black = "#101010",

  pink = "#FF6188",
  green = "#A9DC76",
  aqua = "#78DCE8",
  yellow = "#FFD866",
  orange = "#FC9867",
  purple = "#AB9DF2",
  red = "#FD6883",

  diff_add = "#3d5213",
  diff_remove = "#4a0f23",
  diff_change = "#27406b",
  diff_text = "#23324d",

  transparent = vim.g.walcriz.appearance.transparent_background and "NONE" or "#232223",
  param = "#FFDDC3",
  const = "#D5D5D5",
  popupSel = "#353336",
  popup = "#1d1b1e",
  black2 = "#353336",
  darker_black = "#19181b",
  linehighlight = "#353336",
}

local default_config = {
  italics = true,
  custom_hlgroups = {},
}

local function remove_italics(config, colors)
  if not config.italics and colors.style == "italic" then
    colors.style = nil
  end
  return colors
end

local function highlighter(config)
  return function(group, color)
    color = remove_italics(config, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""
    vim.cmd(("highlight %s %s %s %s %s"):format(group, style, fg, bg, sp))
  end
end

function M.syntax(p)
  return {
    Normal = { fg = p.white, bg = p.base2 },
    NormalFloat = { bg = p.darker_black },

    CursorLine = { bg = p.linehighlight },
    Visual = { bg = p.base4 },

    LineNr = { fg = p.base5, bg = p.base2 },
    SignColumn = { bg = p.base2 },

    StatusLine = { fg = p.base7, bg = p.base3 },
    StatusLineNC = { fg = p.grey, bg = p.base3 },

    Comment = { fg = p.base6, style = "italic" },
    Constant = { fg = p.const },
    String = { fg = p.yellow },
    Number = { fg = p.purple },
    Boolean = { fg = p.purple },
    Function = { fg = p.green },
    Keyword = { fg = p.pink, style = "italic" },
    Type = { fg = p.purple, style = "bold" },
    Identifier = { fg = p.white },
    Operator = { fg = p.pink },
    Delimiter = { fg = "#939293" },

    Include = { fg = p.pink },
    Label = { fg = p.pink },
  }
end

function M.plugins(p)
  local math_group = { fg = p.yellow }
  local strike_group = { fg = p.grey }
  local todo_group = { fg = p.aqua }
  local uri_group = { fg = p.aqua, style = "underline" }

  return {
    -- Treesitter / LSP core
    ["@boolean"] = { fg = p.purple },
    ["@character"] = { fg = p.yellow },
    ["@comment"] = { fg = p.base6, style = "italic" },
    ["@conceal"] = { fg = p.grey },
    ["@conditional"] = { fg = p.pink },
    ["@conditional.ternary"] = { fg = p.pink },
    ["@constant.builtin"] = { fg = p.purple },
    ["@constant.macro"] = { fg = p.purple },
    ["@debug"] = { fg = p.pink },
    ["@define"] = { fg = p.aqua },
    ["@definition"] = { fg = p.green },
    ["@definition.associated"] = { fg = p.green },
    ["@definition.constant"] = { fg = p.green },
    ["@definition.enum"] = { fg = p.green },
    ["@definition.field"] = { fg = p.green },
    ["@definition.function"] = { fg = p.green },
    ["@definition.import"] = { fg = p.white },
    ["@definition.macro"] = { fg = p.green },
    ["@definition.method"] = { fg = p.green },
    ["@definition.namespace"] = { fg = p.white },
    ["@definition.parameter"] = { fg = p.param },
    ["@definition.type"] = { fg = p.green },
    ["@definition.var"] = { fg = p.green },
    ["@error"] = { fg = p.red },
    ["@exception"] = { fg = p.pink },
    ["@field"] = { fg = p.white },
    ["@float"] = { fg = p.purple },
    ["@function.macro"] = { fg = p.green, style = "italic" },
    ["@keyword"] = { fg = p.pink, style = "italic" },
    ["@keyword.operator"] = { fg = p.pink },
    ["@keyword.return"] = { fg = p.pink },
    ["@label"] = { fg = p.pink },
    ["@math"] = math_group,
    ["@namespace"] = { fg = p.purple },
    ["@number"] = { fg = p.purple },
    ["@operator"] = { fg = p.pink },
    ["@parameter.reference"] = { fg = p.white },
    ["@preproc"] = { fg = p.green },
    ["@property"] = { fg = p.white },
    ["@punctuation.special"] = { fg = p.pink },
    ["@reference"] = { fg = p.white },
    ["@repeat"] = { fg = p.pink },
    ["@scope"] = { fg = p.white },
    ["@storageclass.lifetime"] = { fg = p.aqua },
    ["@strike"] = strike_group,
    ["@string"] = { fg = p.yellow },
    ["@string.escape"] = { fg = p.purple },
    ["@string.regex"] = { fg = p.purple },
    ["@string.special"] = { fg = p.purple },
    ["@symbol"] = { fg = p.purple },
    ["@tag"] = { fg = p.pink },
    ["@tag.attribute"] = { fg = p.green },
    ["@tag.delimiter"] = { fg = p.white },
    ["@text"] = { fg = p.green },
    ["@text.danger"] = { fg = p.red, style = "bold" },
    ["@text.diff.add"] = { fg = p.diff_add },
    ["@text.diff.delete"] = { fg = p.diff_remove },
    ["@text.emphasis"] = { style = "bold" },
    ["@text.environment"] = { fg = p.purple },
    ["@text.environment.name"] = { fg = p.aqua },
    ["@text.literal"] = { fg = p.yellow },
    ["@text.math"] = math_group,
    ["@text.note"] = { fg = p.aqua, style = "bold" },
    ["@text.quote"] = { fg = p.grey },
    ["@text.reference"] = { fg = p.orange, style = "italic" },
    ["@text.strike"] = strike_group,
    ["@text.strong"] = { style = "bold" },
    ["@text.title"] = { fg = p.yellow, style = "bold" },
    ["@text.todo"] = todo_group,
    ["@text.underline"] = { style = "underline" },
    ["@text.uri"] = uri_group,
    ["@text.warning"] = { fg = p.yellow, style = "bold" },
    ["@todo"] = todo_group,
    ["@type.definition"] = { fg = p.aqua },
    ["@type.qualifier"] = { fg = p.pink },
    ["@uri"] = uri_group,

    -- General syntax groups
    String = { fg = p.yellow },
    Character = { fg = p.yellow },
    Number = { fg = p.purple },
    Boolean = { fg = p.purple },
    Float = { fg = p.purple },
    Identifier = { fg = p.white },
    Statement = { fg = p.pink },
    Conditional = { fg = p.pink },
    Repeat = { fg = p.pink },
    Operator = { fg = p.pink },
    Keyword = { fg = p.pink, style = "italic" },
    Exception = { fg = p.pink },
    PreProc = { fg = p.green },
    Define = { fg = p.pink },
    Macro = { fg = p.pink },
    PreCondit = { fg = p.pink },
    StorageClass = { fg = p.aqua },
    Structure = { fg = p.aqua },
    Typedef = { fg = p.aqua },
    Special = { fg = p.white },
    SpecialChar = { fg = p.pink },
    SpecialComment = { fg = p.base6, style = "italic" },
    Tag = { fg = p.orange },
    Todo = { fg = p.orange },
    Comment = { fg = p.base6, style = "italic" },
    Underlined = { style = "underline" },
    Ignore = {},
    Error = { fg = p.red },
    Terminal = { fg = p.white, bg = p.base2 },
    EndOfBuffer = { fg = p.base2 },
    Conceal = { fg = p.grey },
    NonText = { fg = p.base5 },
    Whitespace = { fg = p.base5 },
    SpecialKey = { fg = p.pink },
    Title = { fg = p.yellow, bg = p.transparent, style = "bold" },
    FloatTitle = { fg = p.border, bg = p.aqua, style = "bold" },
    Directory = { fg = p.aqua },
    MatchParen = { fg = p.pink },
    Question = { fg = p.yellow },
    ModeMsg = { fg = p.white, style = "bold" },
    MoreMsg = { fg = p.white, style = "bold" },
    ErrorMsg = { fg = p.red, style = "bold" },
    WarningMsg = { fg = p.yellow, style = "bold" },
    Cursor = { style = "reverse" },
    vCursor = { style = "reverse" },
    iCursor = { style = "reverse" },
    lCursor = { style = "reverse" },
    CursorIM = { style = "reverse" },
    CursorColumn = { bg = p.base3 },
    CursorLine = { bg = p.linehighlight },
    CursorLineNr = { fg = p.orange, bg = p.linehighlight },
    ColorColumn = { bg = p.base3 },
    Visual = { bg = p.base4 },
    VisualNOS = { bg = p.base3 },
    Search = { fg = p.base2, bg = p.yellow },
    IncSearch = { fg = p.base2, bg = p.orange },
    LineNr = { fg = p.base5, bg = p.base2 },
    SignColumn = { fg = p.white, bg = p.base2 },
    StatusLine = { fg = p.base7, bg = p.base3 },
    StatusLineNC = { fg = p.grey, bg = p.base3 },
    VertSplit = { fg = p.brown },
    Folded = { fg = p.grey, bg = p.base3 },
    FoldColumn = { fg = p.white, bg = p.black },
    WildMenu = { fg = p.white, bg = p.orange },
    QuickFixLine = { fg = p.purple, style = "bold" },
    Debug = { fg = p.orange },
    debugBreakpoint = { fg = p.base2, bg = p.red },
    DiffAdd = { bg = p.diff_add },
    DiffDelete = { bg = p.diff_remove },
    DiffChange = { bg = p.diff_change },
    DiffText = { bg = p.diff_text },
    diffAdded = { fg = p.green },
    diffRemoved = { fg = p.pink },

    -- UI / completion / popup
    Normal = { fg = p.white, bg = p.base2 },
    FloatBorder = { fg = p.border, bg = p.black },
    PmenuSelBold = { fg = p.base4, bg = p.orange },
    PmenuThumb = { fg = p.purple, bg = p.green },
    PmenuSbar = { bg = p.base3 },

    CmpDocumentation = { fg = p.white, bg = p.base1 },
    CmpDocumentationBorder = { fg = p.white, bg = p.base1 },
    CmpItemAbbr = { fg = p.white },
    CmpItemAbbrMatch = { fg = p.aqua },
    CmpItemAbbrMatchFuzzy = { fg = p.aqua },
    CmpItemKindDefault = { fg = p.white },
    CmpItemMenu = { fg = p.base6 },

    CmpItemKindKeyword = { fg = p.pink },
    CmpItemKindVariable = { fg = p.pink },
    CmpItemKindConstant = { fg = p.pink },
    CmpItemKindReference = { fg = p.pink },
    CmpItemKindValue = { fg = p.pink },

    CmpItemKindFunction = { fg = p.aqua },
    CmpItemKindMethod = { fg = p.aqua },
    CmpItemKindConstructor = { fg = p.aqua },

    CmpItemKindClass = { fg = p.orange },
    CmpItemKindInterface = { fg = p.orange },
    CmpItemKindStruct = { fg = p.orange },
    CmpItemKindEvent = { fg = p.orange },
    CmpItemKindEnum = { fg = p.orange },
    CmpItemKindUnit = { fg = p.orange },

    CmpItemKindModule = { fg = p.yellow },

    CmpItemKindProperty = { fg = p.green },
    CmpItemKindField = { fg = p.green },
    CmpItemKindTypeParameter = { fg = p.green },
    CmpItemKindEnumMember = { fg = p.green },
    CmpItemKindOperator = { fg = p.green },

    -- Telescope
    TelescopeMatching = { fg = p.aqua },

    -- Tree / file explorer
    NvimTreeFolderName = { fg = p.white },
    NvimTreeRootFolder = { fg = p.pink },
    NvimTreeSpecialFile = { fg = p.white, style = "NONE" },
    NvimTreeStatusLine = { bg = p.transparent },
    NvimTreeStatusLineNC = { bg = p.transparent },

    -- Extra exact groups from your theme
    TabLineFill = { bg = p.transparent },
    TabLineSel = { bg = p.darker_black },
    TabLine = { bg = p.transparent },

    -- General
    Delimiter = {
      fg = "#939293",
    },
    -- Treesitter
    ["@keyword.function"] = {
      fg = p.pink,
      style = "italic",
    },
    Include = {
      fg = p.pink,
    },
    ["@include"] = {
      fg = p.pink,
    },
    ["@function"] = {
      fg = p.green,
    },
    ["@parameter"] = {
      fg = p.param,
      style = "italic",
    },
    ["@function.builtin"] = {
      fg = p.aqua,
      style = "italic",
    },
    ["@function.call"] = {
      fg = p.green,
    },
    ["@method"] = {
      fg = p.green,
    },
    ["@method.call"] = {
      fg = p.green,
    },
    ["@annotation"] = {
      fg = p.aqua,
      style = "italic,bold",
    },
    ["@attribute"] = {
      fg = p.aqua,
      style = "italic,bold",
    },
    ["@constructor"] = {
      fg = p.green,
      style = "bold",
    },
    ["@constant"] = {
      fg = p.const,
    },
    ["@character.special"] = {
      fg = p.aqua,
      style = "italic,bold",
    },
    ["@type"] = {
      fg = p.purple,
      style = "bold",
    },
    Type = {
      fg = p.purple,
      style = "bold",
    },
    Function = {
      fg = p.green,
    },
    Constant = {
      fg = p.const,
    },
    Label = {
      fg = p.pink,
    },
    ["@type.builtin"] = {
      fg = p.pink,
    },
    ["@variable.builtin"] = {
      fg = p.pink,
      style = "bold",
    },
    ["@storageclass"] = {
      fg = p.pink,
    },
    ["@punctuation.delimiter"] = {
      fg = "#838c8c",
    },
    ["@variable"] = {
      fg = "#fcfcfa",
    },
    ["@punctuation.bracket"] = {
      fg = "#9b9cf1",
    },

    -- Git
    GitGutterAdd = {
      fg = p.green,
    },
    GitGutterChange = {
      fg = p.aqua,
    },
    GitGutterDelete = {
      fg = p.red,
    },
    GitGutterChangeDelete = {
      fg = p.red,
    },

    -- Rainbow
    TSRainbow1 = {
      fg = "#FFD865",
    },
    TSRainbow2 = {
      fg = "#AB9DF2",
    },
    TSRainbow3 = {
      fg = "#67ACB5",
    },

    LightlineLeft_active_tabsel = {
      fg = "#abb2bf",
      bg = "#3e4452",
    },

    -- Popup menu
    PmenuSel = {
      bg = p.popupSel,
    },

    Pmenu = {
      bg = p.popup,
    },

    BlinkCmpKindVariable = {
      fg = p.pink,
    },

    BlinkCmpKindFunction = {
      fg = p.green,
    },

    BlinkCmpKindMethod = {
      fg = p.green,
    },

    BlinkCmpKindConstructor = {
      fg = p.green,
    },

    BlinkCmpKindClass = {
      fg = p.purple,
    },

    BlinkCmpKindInterface = {
      fg = p.aqua,
    },

    BlinkCmpKindModule = {
      fg = p.const,
    },

    BlinkCmpKindProperty = {
      fg = p.aqua,
    },

    BlinkCmpKindField = {
      fg = p.param,
    },

    BlinkCmpKindSnippet = {
      fg = p.yellow,
    },

    BlinkCmpKindKeyword = {
      fg = p.white,
    },

    BlinkCmpKindEnum = {
      fg = p.orange,
    },

    BlinkCmpKind = {
      fg = p.white,
    },

    -- Telescope
    TelescopeBorder = {
      fg = p.darker_black,
    },

    TelescopePromptBorder = {
      fg = p.black2,
    },

    TelescopePromptNormal = {
      fg = p.white,
      bg = p.black2,
    },

    TelescopePromptPrefix = {
      fg = p.red,
      bg = p.black2,
    },

    TelescopeNormal = { bg = p.darker_black },

    TelescopePreviewTitle = {
      fg = p.black,
      bg = p.green,
    },

    TelescopePromptTitle = {
      fg = p.black,
      bg = p.red,
    },

    TelescopeResultsTitle = {
      fg = p.black,
      bg = p.aqua,
    },

    TelescopeSelection = { bg = p.black2, fg = p.white },

    TelescopeResultsDiffAdd = {
      fg = p.green,
    },

    TelescopeResultsDiffChange = {
      fg = p.yellow,
    },

    TelescopeResultsDiffDelete = {
      fg = p.red,
    },

    -- Which key
    WhichKeyFloat = {
      bg = p.darker_black,
    },

    -- Float menus
    NormalFloat = {
      bg = p.darker_black,
    },

    WinSeparator = {
      fg = p.base6,
    },

    -- Tabbar
    -- LightlineLeft_tabline_tabsel = {
    -- 	bg = "#020204",
    -- },
    -- LightlineRight_tabline_tabsel = {
    -- 	bg = "#020204",
    -- },

    IndentBlankline = {
      fg = "#29272b",
    },

    ["lsp.type.function"] = {
      fg = p.green,
    },
    ["lsp.type.method"] = {
      fg = p.green,
    },
    -- also add TS groups
    TSField = { fg = p.green },
    TSProperty = { fg = p.green },

    MarkdownLevel1 = { fg = p.yellow },
    MarkdownLevel2 = { fg = p.red },
    MarkdownLevel3 = { fg = p.purple },
    MarkdownLevel4 = { fg = p.aqua },
    MarkdownLevel5 = { fg = p.green },

    -- Understrike
    MarkdownLevelBackground = { bg = p.black },

    -- Flash
    FlashMatch = { fg = p.white, bg = p.black },
    FlashCurrent = { fg = p.white, bg = p.base4 },
    FlashLabel = { fg = p.pink, bg = p.black },
  }
end

function M.setup(config)
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"

  config = vim.tbl_deep_extend("force", default_config, config or {})
  local p = M.palette

  vim.g.colors_name = p.name

  local hl = highlighter(config)

  local syntax = vim.tbl_deep_extend("force", M.syntax(p), config.custom_hlgroups or {})
  local plugins = vim.tbl_deep_extend("force", M.plugins(p), config.custom_hlgroups or {})

  for group, color in pairs(syntax) do
    hl(group, color)
  end

  for group, color in pairs(plugins) do
    hl(group, color)
  end

  if vim.g.walcriz.appearance.transparent_background then
    vim.cmd([[
      hi Normal guibg=NONE ctermbg=NONE
      hi LineNr guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
    ]])
  end
end

return M
