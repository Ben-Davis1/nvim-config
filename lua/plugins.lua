return require("packer").startup(function(use)
  -- packer.nvim
  -- https://github.com/wbthomason/packer.nvim
  -- Packer manages its own existance
  -- nvim
  use("wbthomason/packer.nvim")

  -- Nvim-web-devicons
  -- https://github.com/nvim-tree/nvim-web-devicons
  -- Icons
  -- nvim
  use("nvim-tree/nvim-web-devicons")

  -- lualine.nvim
  -- https://github.com/nvim-lualine/lualine.nvim
  -- statusline
  -- I removed opt=true from the dependency as it didn't make sense that it was there. Devicons shouldn't be optional
  -- Relies on nvim-web-devicons
  -- nvim
  use("nvim-lualine/lualine.nvim")

  -- nvim-tree.lua
  -- https://github.com/nvim-tree/nvim-tree.lua
  -- File tree
  -- Relies on nvim-web-devicons
  -- nvim
  use("nvim-tree/nvim-tree.lua")

  -- buftabline.nvim
  -- https://github.com/jose-elias-alvarez/buftabline.nvim (unmaintained)
  -- Buffers as tabs
  -- nvim
  use("jose-elias-alvarez/buftabline.nvim")

  -- telescope.nvim
  -- https://github.com/nvim-telescope/telescope.nvim
  -- Fuzzy searching etc
  -- Maybe I need treesitter?
  -- Has bug where live_grep highlighting doesn't work
  -- nvim
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-lua/plenary.nvim" }
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }

  -- nvim-comment
  -- https://github.com/terrortylor/nvim-comment
  -- Easy commenting bindings
  -- nvim
  use("terrortylor/nvim-comment")

  -- tokyodark
  -- https://github.com/tiagovla/tokyodark.nvim
  -- Theme
  -- nvim
  use 'tiagovla/tokyodark.nvim'

  -- coc.nvim
  -- https://github.com/neoclide/coc.nvim
  -- Massive thing: "Make your Vim/Neovim as smart as VS Code". Code completion, lsp etc etc
  -- Has it's own extensions and is configured in coc-settings.json
  -- nvim and vim
  use({ "neoclide/coc.nvim", branch = "release" })

  -- hop
  -- https://github.com/smoka7/hop.nvim
  -- Nvim hop
  -- nvim
  use {
    'smoka7/hop.nvim',
    -- Version
    tag = '*',
    config = function()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- vim-polyglot
  -- https://github.com/sheerun/vim-polyglot
  -- Syntax highlighting for a bunch of languages
  -- vim
  use("sheerun/vim-polyglot")

  -- vim-css-color
  -- https://github.com/ap/vim-css-color
  -- CSS color highlight
  -- vim
  use("ap/vim-css-color")

  -- fugitive.vim
  -- https://github.com/tpope/vim-fugitive
  -- Git integration in vim
  -- vim
  use("tpope/vim-fugitive")

  -- vim-submode
  -- https://github.com/kana/vim-submode
  -- Vim submode stuff
  -- vim
  use("kana/vim-submode")

  -- copilot
  -- https://github.com/github/copilot.vim
  -- GitHub Copilot
  -- vim
  use("github/copilot.vim")
end)
