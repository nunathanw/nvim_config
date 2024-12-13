vim.g.my_vimrc = "~/.config/nvim/init.lua"
vim.wo.number = true
vim.cmd([[
  highlight StatusLine guifg=#ffffff guibg=#1c1c1c
  highlight StatusLineNC guifg=#7f7f7f guibg=#1c1c1c
]])
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':w <CR> :!python % <CR>', { noremap = true, silent = true })

-- Bootstrap Packer if it's not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path
  })
  print("Packer has been installed! Restart Neovim to complete the installation.")
  vim.cmd [[packadd packer.nvim]]
end

-- Initialize Packer
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Python Syntax Highlighting (using Treesitter)
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate', -- Automatically run :TSUpdate to keep Treesitter up to date
  }

     use {
    'williamboman/mason.nvim',
    config = function()
      -- Set up Mason first, ensuring it runs before other configurations
      require('mason').setup()  -- Initialize Mason
    end
  }

  -- Mason integration for LSP servers (e.g., Pyright)
  use {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      -- Set up mason-lspconfig after Mason is initialized
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright' },  -- Ensure Pyright is installed
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }






  -- Autocompletion Plugins
  use 'hrsh7th/nvim-cmp'        -- Main completion plugin
  use 'hrsh7th/cmp-nvim-lsp'    -- LSP source for nvim-cmp
  use 'neovim/nvim-lspconfig'   -- LSP configurations
  use 'hrsh7th/cmp-buffer'      -- Buffer completions for nvim-cmp
  use 'hrsh7th/cmp-path'        -- Path completions for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions for nvim-cmp


  -- Snippet Engine (LuaSnip) for enhanced completion
  use 'L3MON4D3/LuaSnip' -- Snippet engine
end)

-- Setup nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "python",  -- Ensure Python syntax is installed for Treesitter
  highlight = {
    enable = true,  -- Enable syntax highlighting with Treesitter
  },
}

-- Setup nvim-cmp for autocompletion
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body) -- Use LuaSnip for snippet expansion
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' }, -- Snippet completions
  },
})
--
--
-- Find files with Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Live grep (search across files)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- Switch between recently opened files
vim.api.nvim_set_keymap('n', '<leader>fr', ':Telescope oldfiles<CR>', { noremap = true, silent = true })

require('telescope').setup{
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},  -- Ignore these directories during search
  }
}







require('mason').setup({})

-- Mason LSP setup
require('mason-lspconfig').setup({
  ensure_installed = { "pyright" },  -- Ensure Pyright (Python LSP) is installed
})

-- LSP setup for Pyright
require'lspconfig'.pyright.setup{}
