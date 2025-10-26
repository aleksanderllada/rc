-- set the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- set limit column
vim.opt.colorcolumn = "80"

-- set number of lines to scroll
vim.opt.scrolloff = 10

-- set line numbers
vim.opt.number = true

-- configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

-- preview substitutions live
vim.opt.inccommand = "split"

-- show which line your cursor is on
vim.opt.cursorline = true

-- indenting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- do not yank text when pasting
vim.api.nvim_set_keymap("v", "p", "P", {noremap=true, silent=true})

-- vim-terraform options
vim.g.terraform_align = 1
vim.g.terraform_fmt_on_save = 1

-- lazy loading
require("config.lazy")

-- ayu theme
require('ayu').setup({})
local colors = require('ayu.colors')

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    pcall(vim.cmd.colorscheme, "ayu")
  end,
})

-- Setup treesitter --
----------------------
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go",
    "json", "yaml", "toml", "html", "css", "javascript", "typescript", "tsx",
    "python", "java", "rust", "bash", "dockerfile", "terraform", "gotmpl",
    "helm",
  },
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
  },
})

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    [".*%.ctmpl"] = "helm",
    [".*%.tpl"] = "helm",
  },
})

-- Setup Scrollbar --
---------------------
require("scrollbar").setup({
  handle = {
    color = "#bbbbbb",
  },
})

-- Setup LSP --
---------------
vim.lsp.enable('terraformls')
vim.lsp.config('terraformls', {
  filetypes = { "terraform", },
  cmd = { 'terraform-ls', 'serve', '-log-file', vim.fs.dirname(require('vim.lsp.log').get_filename()) .. "/terraform-ls.log" },
})

-- Setup mason --
-----------------
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()

-- Setup rust-tools --
----------------------
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- Setup nvim-tree --
---------------------
local function nvim_tree_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,     opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,               opts('Help'))
  vim.keymap.set("n", "E",     ":qa<CR>",                          opts("Quit"))
  vim.keymap.set("n", "s",     api.node.open.vertical,             opts("Open: Vertical Split"))
  vim.keymap.set("n", "<C-x>", api.node.open.horizontal,           opts("Open: Horizontal Split"))
end

require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  hijack_cursor = true,
  respect_buf_cwd = true,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 45,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  git = {
    enable = false,
  },
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost", "VimEnter"}, {
  callback = function(args)
    vim.api.nvim_del_autocmd(args.id)
    vim.cmd "NvimTreeOpen"
    vim.schedule(function()
      vim.cmd "wincmd p"
    end)
  end,
})

-- Setup lualine --
-----------------------
local git_blame = require('gitblame')
require('lualine').setup({
  options = {
    globalstatus = true,
  },
  sections = {
    lualine_c = {
      'filename',
      {
        function()
          if git_blame.is_blame_text_available() then
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            return "L" .. row .. git_blame.get_current_blame_text()
          end
        end
      }
    },
    lualine_x = {
      'searchcount', 'filetype', -- 'fileformat', 'encoding', 'lsp_status'
    }
  }
})

-- Setup terminal --
--------------------
require("toggleterm").setup({
  -- size can be a number or function which is passed the current terminal
  size = 18,
  hide_numbers = true, -- hide the number column in toggleterm buffers
  autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = false,
  persist_mode = false, -- if set to true (default) the previous terminal mode will be remembered
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  responsiveness = {
    horizontal_breakpoint = 135,
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return ""
    end
  },
})
vim.api.nvim_set_keymap("n", "t", ":ToggleTerm<CR>", {noremap=true, silent=true})

-- Setup telescope --
---------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<S-f>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<S-g>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Setup interestingwords --
----------------------------
interestingwords = require("interestingwords").setup {
  search_count = true,
  navigation = true,
  scroll_center = true,
  search_key = "<CR>",
  cancel_search_key = "<leader>ic",
  color_key = "<leader>ik",
  cancel_color_key = "<leader>iK",
  select_mode = "random",  -- random or loop
}

-- Setup search --
------------------
local get_visual_selection = function()
  local lines
  local start_row, start_col = vim.fn.getpos("v")[2], vim.fn.getpos("v")[3]
  local end_row, end_col = vim.fn.getpos(".")[2], vim.fn.getpos(".")[3]
  if end_row < start_row then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  elseif end_row == start_row and end_col < start_col then
      start_col, end_col = end_col, start_col
  end
  start_row = start_row - 1
  start_col = start_col - 1
  end_row = end_row - 1
  if vim.api.nvim_get_mode().mode == 'V' then
    lines = vim.api.nvim_buf_get_text(0, start_row, 0, end_row, -1, {})
  elseif vim.api.nvim_get_mode().mode == 'v' then
    lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
  end
  vim.cmd("normal! ")
  if lines == nil then
    return ""
  end

  local line = ""
  for i, v in ipairs(lines) do
    if i == 1 then
      line = line .. vim.fn.escape(v, "\\")
    else
      line = line .. "\\n" .. vim.fn.escape(v, "\\")
    end
  end

  return line
end

require("search").setup({
  tabs = {
    { name = "All",      tele_func = builtin.live_grep },
    { name = "Lines",    tele_func = builtin.current_buffer_fuzzy_find },
    { name = "Files",    tele_func = builtin.find_files },
    { name = "Commits",  tele_func = builtin.git_bcommits },
    { name = "Commands", tele_func = builtin.command_history },
  },
})

vim.keymap.set('n', '<S-f>', function()
    local w = vim.fn.getreg('/'):gsub("\\C\\V\\<(.*)\\>", "%1")
    require('search').open({default_text=w})
  end,
  { desc = 'Open search' })

vim.keymap.set('v', '<S-f>', function()
    require('search').open({default_text=get_visual_selection()})
  end,
  { desc = 'Open search' })

-- Setup illuminate --
----------------------
require('illuminate').configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
})

-- Setup noice --
-----------------
require("noice").setup({
  routes = {
    -- Hide written messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    -- Ignore certain lsp servers for progress messages
    {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local client = vim.tbl_get(message.opts, "progress", "client")
          return client == "lua_ls"
        end,
      },
      opts = { skip = true },
    },
  },
})

local t_opts = {silent = true}

-- Setup parrot --
------------------
vim.keymap.set('v', 'A', ':PrtPopup<CR>', { desc = 'Parrot ask in a popup' })
vim.keymap.set('v', 'R', ':PrtRewrite<CR>', { desc = 'Parrot rewrite' })

-- Setup key mappings
-- quit and save
vim.keymap.set('n', 'E', ':qa<CR>')       -- Shift-e to quit
vim.keymap.set('n', 'W', ':wa<CR>')       -- Shift-w to save

-- navigate splits
vim.keymap.set("n", "<S-Right>", "<C-w>l", t_opts)    -- Shift-Right to Navigate Left
vim.keymap.set("n", "<S-Left>", "<C-w>h", t_opts)     -- Shift-Left to Navigate Right
vim.keymap.set("n", "<S-Up>", "<C-w>k", t_opts)       -- Shift-Up to Navigate Up
vim.keymap.set("n", "<S-Down>", "<C-w>j", t_opts)     -- Shift-Down to Navigate Down

-- terminal mode navigation
vim.keymap.set('t', '<esc>',     '<C-\\><C-N>', t_opts)
vim.keymap.set('t', '<S-Left>',  '<C-\\><C-N><C-w>h', t_opts)
vim.keymap.set('t', '<S-Down>',  '<C-\\><C-N><C-w>j', t_opts)
vim.keymap.set('t', '<S-Up>',    '<C-\\><C-N><C-w>k<C-w>l', t_opts)
vim.keymap.set('t', '<S-Right>', '<C-\\><C-N><C-w>l', t_opts)

-- copy to / from system clipboard
vim.api.nvim_set_keymap("v", "<C-c>", '"*y :let @+=@*<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap("i", "<C-v>", '"+p', {noremap=true, silent=true})

-- undo / redo
vim.api.nvim_set_keymap("n", "<C-z>", "<cmd>undo<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "<C-S-z>", "<cmd>redo<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("i", "<C-z>", "<cmd>undo<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("i", "<C-S-z>", "<cmd>redo<CR>", {noremap=true, silent=true})

-- barbar
local opts = { noremap = true, silent = true }

-- move to previous/next tab
vim.api.nvim_set_keymap('n', '<C-Left>', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Right>', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', opts)

-- re-order to previous/next
vim.api.nvim_set_keymap('n', '<C-S-Left>', '<Cmd>BufferMovePrevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-S-Right>', '<Cmd>BufferMoveNext<CR>', opts)

-- Close buffer
vim.api.nvim_set_keymap('n', '<S-q>', '<Cmd>BufferClose<CR>', opts)

-- Magic buffer-picking mode
vim.api.nvim_set_keymap('n', '<C-p>',   '<Cmd>BufferPick<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)
