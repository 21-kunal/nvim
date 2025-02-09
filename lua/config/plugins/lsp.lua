return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on Lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local border = {

        { '╭', 'FloatBorder' }, -- top-left corner
        { '─', 'FloatBorder' }, -- top horizontal
        { '╮', 'FloatBorder' }, -- top-right corner
        { '│', 'FloatBorder' }, -- left vertical
        { '╯', 'FloatBorder' }, -- bottom-left corner
        { '─', 'FloatBorder' }, -- bottom horizontal
        { '╰', 'FloatBorder' }, -- bottom-right corner
        { '│', 'FloatBorder' }, -- right vertical
      }

      -- Add the rounded border to hover and signature help popup windows
      local handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      -- Define LSP attach behavior
      vim.api.nvim_create_autocmd("LspAttach", {

        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then return end

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Key mappings for LSP
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Auto-format on save for supported file types
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format({
                bufnr = event.buf,
                filter = function(c)
                  return c.supports_method("textDocument/formatting")
                end,
              })
            end,
          })
        end,
      })


      -- LSP capabilities from blink/cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- LSP server configurations
      local servers = {
        clangd = { handlers = handlers },
        -- gopls = {handlers = handlers},
        lua_ls = { handlers = handlers },
        ts_ls = { handlers = handlers },
        html = { handlers = handlers },
      }

      -- Mason setup
      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      require("mason-lspconfig").setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
