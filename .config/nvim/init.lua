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
vim.opt.background = "dark"

-- Leader key
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<F3>", ":Neotree toggle<CR>", { silent = true })

-- Plugins
require("lazy").setup({

  -- Colorscheme — rice themed
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
      color_overrides = {
        mocha = {
          -- Backgrounds: pure black
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",

          -- Surfaces: subtle stepping from black
          surface0 = "#0a0a0a",
          surface1 = "#141414",
          surface2 = "#1e1e1e",

          -- Overlays/dim: steel grays
          overlay0 = "#5a6a7a",
          overlay1 = "#6a7a8a",
          overlay2 = "#7a8a9a",

          -- Text: warm gray spectrum
          subtext0 = "#9aabb0",
          subtext1 = "#b0c0c5",
          text = "#cdd3e0",

          -- Accents: pink/magenta primary
          pink = "#D27389",
          mauve = "#BB607B",
          red = "#BB607B",
          maroon = "#D27389",

          -- Syntax: steel for blue-ish roles
          blue = "#7a8a9a",
          lavender = "#D27389",

          -- Muted warm tones for strings/etc
          peach = "#c0a070",
          yellow = "#c0a070",
          green = "#7a9a7a",
          teal = "#6a8a8a",
          sky = "#7a9aaa",
          sapphire = "#8a9aaa",

          -- Floating window borders
          flamingo = "#6a7a8a",
          rosewater = "#cdd3e0",
        },
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

  -- Smear cursor — rice pink
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.3,
      distance_stop_animating = 0.5,
      hide_target_hack = true,
      cursor_color = "#D27389",
    },
  },

})

-- Visual highlight override for visibility on pure black bg + CRTty transparency
vim.api.nvim_set_hl(0, "Visual", { bg = "#4a2a30" })
