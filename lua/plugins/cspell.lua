-- Define the tools to be installed and the key mapping
local installed_tools = { "codespell", "misspell", "cspell" }
local key_mapping = "<leader>cn"

-- Example config with lazyvim
return {
  -- Auto install those tools with mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = installed_tools,
    },
  },
  -- Set up null-ls to check spelling
  {
    "nvimtools/none-ls.nvim",
    keys = {
      { key_mapping, "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
    },
    dependencies = { "mason.nvim", "davidmh/cspell.nvim", "nvimtools/none-ls-extras.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local cspell = require "cspell"
      local ok, none_ls = pcall(require, "null-ls")
      if not ok then return end

      local b = none_ls.builtins
      local ok2, none_ls_extras = pcall(require, "null-ls-extras")
      if not ok2 then
        print "cspell: failed to load null-ls-extras"
        return
      end

      local sources = {
        -- spell check
        b.diagnostics.codespell,
        -- b.diagnostics.misspell,
        none_ls_extras.misspell.diagnostics,
        -- cspell
        cspell.diagnostics.with {
          -- Set the severity to HINT for unknown words
          diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity["HINT"] end,
        },
        cspell.code_actions,
      }
      -- Define the debounce value
      local debounce_value = 200
      return {
        sources = sources,
        debounce = debounce_value,
        debug = true,
      }
    end,
  },
}
