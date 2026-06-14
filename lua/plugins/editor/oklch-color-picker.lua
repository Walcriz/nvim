return {
  {
    "eero-lehtinen/oklch-color-picker.nvim",
    enabled = vim.g.walcriz.core.color_picker and not vim.g.walcriz.core.minimal,
    event = "VeryLazy",
    cmd = "ColorPickOklch",
    keys = {
      {
        "<leader>v",
        function()
          require("oklch-color-picker").pick_under_cursor()
        end,
        desc = "Color pick under cursor",
      },
    },
    opts = {
      patterns = {
        glsl_vec_linear = {
          priority = 5,
          format = "raw_rgb_float",
          ft = { "glsl" },

          custom_parse = function(match)
            local bit = require("bit")

            local values = {}
            for num in string.gmatch(match, "[-%d%.]+") do
              values[#values + 1] = tonumber(num)
            end

            if #values < 3 then
              return 0xFFFFFF
            end

            local r = math.floor(math.max(0, math.min(1, values[1])) * 255)
            local g = math.floor(math.max(0, math.min(1, values[2])) * 255)
            local b = math.floor(math.max(0, math.min(1, values[3])) * 255)

            return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
          end,

          -- MUST have exactly two empty groups
          "vec3%(()[%d.,%s]+()%)",
          "vec4%(()[%d.,%s]+()%)",
        },
      },
    },
  },
}
