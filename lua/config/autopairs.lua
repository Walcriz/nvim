local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')


-----------
-- General
-----------
-- Add spaces between parentheses
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(' ', ' ')
    -- Pair will only occur if the conditional function returns true
    :with_pair(function(opts)
      -- We are checking if we are inserting a space in (), [], or {}
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2]
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. '  ' .. brackets[1][2],
        brackets[2][1] .. '  ' .. brackets[2][2],
        brackets[3][1] .. '  ' .. brackets[3][2]
      }, context)
    end)
}

-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
      :with_pair(cond.none())
      :with_move(function(opts) return opts.char == bracket[2] end)
      :with_del(cond.none())
      :use_key(bracket[2])
      -- Removes the trailing whitespace that can occur without this
      :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
  }
end

-- Move past commas and semicolons
for _,punct in pairs { ",", ";" } do
  require "nvim-autopairs".add_rules {
    require "nvim-autopairs.rule"("", punct)
      :with_move(function(opts) return opts.char == punct end)
      :with_pair(function() return false end)
      :with_del(function() return false end)
      :with_cr(function() return false end)
      :use_key(punct)
  }
end

npairs.add_rules {
  -- arrow key on javascript/c#
  Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript', 'cs' })
    :use_regex(true)
    :set_end_pair_length(2),
}

-- close all of the opened pairs in that line
local get_closing_for_line = function (line)
  local i = -1
  local clo = ''

  while true do
    ---@diagnostic disable-next-line: cast-local-type
    i, _= string.find(line, "[%(%)%{%}%[%]]", i + 1)
    if i == nil then break end
    local ch = string.sub(line, i, i)
    local st = string.sub(clo, 1, 1)

    if ch == '{' then
      clo = '}' .. clo
    elseif ch == '}' then
      if st ~= '}' then return '' end
      clo = string.sub(clo, 2)
    elseif ch == '(' then
      clo = ')' .. clo
    elseif ch == ')' then
      if st ~= ')' then return '' end
      clo = string.sub(clo, 2)
    elseif ch == '[' then
      clo = ']' .. clo
    elseif ch == ']' then
      if st ~= ']' then return '' end
      clo = string.sub(clo, 2)
    elseif clo ~= '' then
      clo = clo .. ch
    end
  end

  return clo
end

npairs.add_rule(Rule("[%(%{%[]", "", {
  "-cs"
})
  :use_regex(true)
  :replace_endpair(function(opts)
    return get_closing_for_line(opts.line)
  end)
  :end_wise(function(opts)
    -- Do not endwise if there is no closing
    return get_closing_for_line(opts.line) ~= ""
  end)
)

-- auto-pair <> for generics but not as greater-than/less-than operators
npairs.add_rule(Rule('<', '>', {
  -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
  -- so that it doesn't conflict with nvim-ts-autotag
  '-html',
  '-javascriptreact',
  '-typescriptreact',
}):with_pair(
    -- regex will make it so that it will auto-pair on
    -- `a<` but not `a <`
    -- The `:?:?` part makes it also
    -- work on Rust generics like `some_func::<T>()`
    cond.before_regex('%a+:?:?$', 3)
  ):with_move(function(opts)
    return opts.char == '>'
  end)
)



-----------
-- Latex
-----------
npairs.add_rule(Rule("$$","$$","tex"))
npairs.add_rules({
  Rule("$", "$",{"tex", "latex"})
    -- don't add a pair if the next character is %
    :with_pair(cond.not_after_regex("%%"))
    -- don't add a pair if  the previous character is xxx
    :with_pair(cond.not_before_regex("xxx", 3))
    -- don't move right when repeat character
    :with_move(cond.none())
    -- don't delete if the next character is xx
    :with_del(cond.not_after_regex("xx"))
    -- disable adding a newline when you press <cr>
    :with_cr(cond.none())
},
  -- disable for .vim files, but it work for another filetypes
  Rule("a","a","-vim")
)

npairs.add_rules({
  Rule("$$","$$","tex")
    :with_pair(function(opts)
      print(vim.inspect(opts))
      if opts.line=="aa $$" then
        -- don't add pair on that line
        return false
      end
    end)
})

-----------
-- C#
-----------

--local get_opening_for_line = function (line)
--  local i = -1
--  local clo = ''

--  while true do
--    ---@diagnostic disable-next-line: cast-local-type
--    i = i + 1
--    if i > string.len(line) then break end
--    c = line:sub(i + 1, i + 1)
--    local ch = string.sub(line, i, i)

--    if ch == '{' then
--      clo = clo .. ch
--    elseif ch == '(' then
--      if clo ~= '' then
--        clo = clo .. ch
--      end
--    elseif ch == '[' then
--      clo = clo .. ch
--    elseif clo ~= '' then
--      clo = clo .. ch
--    end
--  end

--  return clo
--end

-- npairs.add_rule(Rule("[%(%{%[]", "", { "cs" })
--   :use_regex(true)
--   :replace_endpair(function(opts)
--     -- replace everything matching get_opening_for_line(opts.line) with '' on col
--     local buf = opts.bufnr
--     local col = opts.col
--     local row = vim.api.nvim_win_get_cursor(0)[1]

--     vim.schedule(function()
--       vim.api.nvim_buf_set_text(buf, row - 1, col - #get_opening_for_line(opts.line), row - 1, col, { '' })
--     end)

--     return get_opening_for_line(opts.line) .. "\n" .. get_closing_for_line(opts.line)
--   end)
--   :end_wise(function(opts)
--     -- Do not endwise if there is no closing
--     return get_closing_for_line(opts.line) ~= ""
--   end)
-- )

