return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          -- prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          prefix = "icons",
          severity = vim.diagnostic.severity.ERROR,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      servers = {
        lua_ls = {},
        ts_ls = {},
      },
      inlay_hints = {
        enabled = false,
      },
    })
  end,
}
