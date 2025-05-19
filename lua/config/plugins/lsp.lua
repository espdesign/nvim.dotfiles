return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require("lspconfig").lua_ls.setup { capabilities = capabilities, } -- Fix typo here (capabilites -> capabilities)
      require('lspconfig').ruff.setup({
        init_options = {
          settings = {
            logLevel = "debug" -- Ruff language server settings go here
          }
        }
      })
      require('lspconfig').pyright.setup({
        capabilities = capabilities,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          -- python = {
          --   analysis = {
          --     -- Ignore all files for analysis to exclusively use Ruff for linting
          --     ignore = { '*' },
          --   },
          -- },
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_handler', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Disable Ruff hover
          if client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end

          -- Enable format-on-save
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
