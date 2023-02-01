local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
-- Install your plugins here
return require("lazy").setup {
  -- My plugins here
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "windwp/nvim-autopairs",
    commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347",
    event = "VeryLazy",
    config = function()
      require "user.autopairs"
    end,
  }, -- Autopairs, integrates with both cmp and treesitter
  {
    "numToStr/Comment.nvim",
    commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67",
    event = "VeryLazy",
    config = function()
      require "user.comment"
    end,
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", commit = "32d9627123321db65a4f158b72b757bcaef1a3f4", lazy = true },
  { "kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352", lazy = true },
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
      { "<leader>e", "<leader>fe", desc = "Explorer NvimTree", remap = true },
    },
    deactivate = function()
      vim.cmd [[NvimTreeToggle]]
    end,
    config = function()
      require "user.nvim-tree"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    commit = "83bf4dc7bff642e145c8b4547aa596803a8b4dc4",
    event = "VeryLazy",
    config = function()
      require "user.bufferline"
    end,
  },
  { "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" },
  {
    "nvim-lualine/lualine.nvim",
    commit = "a52f078026b27694d2290e34efa61a6e4a690621",
    event = "VeryLazy",
    config = function()
      require "user.lualine"
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda",
    event = "VeryLazy",
    config = function()
      require "user.toggleterm"
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    commit = "628de7e433dd503e782831fe150bb750e56e55d6",
    event = "VeryLazy",
    config = function()
      require "user.project"
    end,
  },
  {
    "lewis6991/impatient.nvim",
    commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6",
    config = function()
      require "user.impatient"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6",
    event = "BufReadPost",
    config = function()
      require "user.indentline"
    end,
  },
  {
    "goolord/alpha-nvim",
    commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31",
    event = "VimEnter",
    config = function()
      require "user.alpha"
    end,
  },

  -- Colorschemes
  { "folke/tokyonight.nvim", commit = "66bfc2e8f754869c7b651f3f47a2ee56ae557764" },

  -- cmp plugins
  {
    "hrsh7th/nvim-cmp",
    commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc",
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      { "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" }, -- buffer completions
      { "hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" }, -- path completions
      { "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" },
      { "saadparwaiz1/cmp_luasnip" },
      { "tzachar/cmp-tabnine", build = "./install.sh" },
    },
    config = function()
      require "user.cmp"
    end,
  }, -- The completion plugin

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda",
    dependencies = {
      { "williamboman/mason.nvim", commit = "bfc5997e52fe9e20642704da050c415ea1d4775f" },
      { "williamboman/mason-lspconfig.nvim", commit = "0eb7cfefbd3a87308c1875c05c3f3abac22d367c" },
      { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" }, -- for formatters and linters
      { "lukas-reineke/lsp-format.nvim" },
      {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
          require("lspsaga").setup {}
        end,
      },
    },
    config = function()
      require "user.lsp"
    end,
  },

  {
    "RRethy/vim-illuminate",
    commit = "a2e8476af3f3e993bb0d6477438aad3096512e42",
    event = "BufReadPost",
    config = function()
      require "user.illuminate"
    end,
  },

  -- copilot
  {
    "github/copilot.vim",
    config = function()
      require "user.copilot"
    end,
  },

  -- which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {}
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    commit = "76ea9a898d3307244dce3573392dcf2cc38f340f",
    config = function()
      require "user.telescope"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "8e763332b7bf7b3a426fd8707b7f5aa85823a5ac",
    config = function()
      require "user.treesitter"
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f",
    event = "BufReadPre",
    config = function()
      require "user.gitsigns"
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    commit = "6b12294a57001d994022df8acbe2ef7327d30587",
    lazy = true,
    dependencies = {
      { "rcarriga/nvim-dap-ui", commit = "1cd4764221c91686dcf4d6b62d7a7b2d112e0b13" },
      { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" },
    },
    config = function()
      require "user.dap"
    end,
  },

  -- Rust
  {
    "simrat39/rust-tools.nvim",
    -- lazy-load on filetype
    ft = "rust",
    config = function()
      require("rust-tools").setup {
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },

  -- Go
  {
    "crispgm/nvim-go",
    ft = "go",
    config = function()
      require("go").config.update_tool("quicktype", function(tool)
        tool.pkg_mgr = "yarn"
      end)
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- Outline
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    config = function()
      require "user.aerial"
    end,
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
}
