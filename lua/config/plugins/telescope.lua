return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require("telescope").setup {
        defaults = {
        },
        pickers = {
          find_files = {
            theme = "ivy",
            hidden = true,
          }
        },
        extensions = {
          fzf = {},
        }
      }

      require("telescope").load_extension('fzf')

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Find files in current directory" })
      vim.keymap.set("n", "<space>fn", function()
          builtin.find_files(
            { cwd = vim.fn.stdpath("config") }
          )
        end,
        { desc = "Find neovim files" }
      )
      vim.keymap.set('n', '<leader>fb', function()
        builtin.live_grep(
          { grep_open_files = true }
        )
      end, { desc = 'Telescope Search across all open buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


      require "config.telescope.multigrep".setup()
    end
  }
}
