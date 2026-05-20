-- Bootstrap lazy.nvim
local lazypath = "/home/vyevd/.local/share/nvim/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Leader key
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<F3>", ":Neotree toggle<CR>", { silent = true })

-- Plugins
require("lazy").setup({

  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        neo_tree = true,
      },
    },
    init = function()
      vim.cmd("colorscheme catppuccin-mocha")
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      window = { width = 30 },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
    },
  },

  -- Smear cursor
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.3,
      distance_stop_animating = 0.5,
      hide_target_hack = true,
      cursor_color = "#E6D47B",
    },
  },

})
