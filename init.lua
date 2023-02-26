-- https://github.com/nanotee/nvim-lua-guide
-- https://neovim.io/doc/user/lua.html#lua-builtin
-- https://neovim.io/doc/user/api.html
-- https://neovim.io/doc/user/lua-guide.htm



-- Loads Packer configuration
require("plugins")
--



-- Plugins

-- Start lualine.nvim
require("lualine").setup()

-- Start nvim.tree
require("nvim-tree").setup()

-- Start buftabline
require("buftabline").setup()

-- Start Telescope with vertical layout and mapping to close when pressing escape in insert mode
local actions = require("telescope.actions")
require('telescope').setup({
    defaults = { layout_strategy = 'vertical', mappings = { i = { ["<esc>"] = actions.close } } } })

-- Start nvim-comment
require("nvim_comment").setup()
--



-- Set global variables

-- https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
vim.g.mapleader = " "

-- https://github.com/kana/vim-submode/blob/master/doc/submode.txt#L216
vim.g.submode_keep_leaving_key = true
--



-- Set Vim options
-- https://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
-- https://www.reddit.com/r/neovim/comments/qgwkcu/difference_between_vimo_and_vimopt/

-- https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
vim.opt.clipboard = "unnamedplus"

-- Maybe needed
-- set completeopt=noinsert,menuone,noselect

-- https://medium.com/usevim/vim-101-set-hidden-f78800142855
-- :h hidden
vim.opt.hidden = true

-- :h mouse
vim.opt.mouse = "a"

-- Show line numbers
vim.opt.number = true

-- https://vim.fandom.com/wiki/Control_the_position_of_the_new_window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- https://medium.com/usevim/changing-vims-title-713001d4049c
vim.opt.title = true

-- :h ttimeoutlen
vim.opt.ttimeoutlen = 0

-- Maybe needed
-- set wildignore=*/node_modules/*

-- :h termguicolors
vim.opt.termguicolors = true

-- Stops new line being added
-- :h fixeol
vim.opt.fixeol = false
--



-- Autocmd
-- https://alpha2phi.medium.com/neovim-for-beginners-lua-autocmd-and-keymap-functions-3bdfe0bebe42

-- Open NvimTree on opening Vim
vim.api.nvim_create_autocmd(
    "VimEnter",
    { command = "NvimTreeToggle" }
)

-- Close Vim if NvimTree is the last buffer
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        print(vim.api.nvim_buf_get_name(0))
        if (string.find(vim.api.nvim_buf_get_name(0), ".git//")) then
            return
        end
        if (vim.fn.winnr("$") == 1 and string.find(vim.api.nvim_buf_get_name(0), "NvimTree_")) then
            return
        else
            vim.cmd("NvimTreeClose")
        end
    end
})

--
vim.api.nvim_create_autocmd(
    "BufLeave",
    {
        callback = function()
            vim.b.winview = vim.fn.winsaveview()
        end
    }
)
vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        callback = function()
            if (vim.b.winview) then
                vim.fn.winrestview(vim.b.winview)
            end
        end
    }
)

--



-- User commands

-- Vim fugitive extras by me
-- :h nargs :h q-args
-- Git commit
vim.api.nvim_create_user_command("Gc", ":Git commit -m <q-args> | :Git push", { nargs = 1 })
-- Git commit all
vim.api.nvim_create_user_command("Gca", ":Git add . | :Git commit -m <q-args> | :Git push", { nargs = 1 })
-- Git branch (existing or current)
vim.api.nvim_create_user_command("Gb", ":Git fetch | :Git checkout <q-args> | :Git pull", { nargs = "?" })
-- Git branch development
vim.api.nvim_create_user_command("Gbd", ":Git checkout development | :Git fetch | :Git pull", {})
-- Git branch new
vim.api.nvim_create_user_command("Gbn", ":Git checkout -b <q-args>", { nargs = 1 })
--



-- Mappings
-- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings-set

-- General
vim.keymap.set('n', '<Leader>s', ":update<CR>")
vim.keymap.set('n', '<Leader>w', ":quit<CR>")

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>p', builtin.find_files)
vim.keymap.set('n', '<Leader>o', builtin.live_grep)

-- Nvim tree
vim.keymap.set('n', '<Leader>.', ":NvimTreeFindFile<CR>")
vim.keymap.set('n', '<Leader>/', ":NvimTreeToggle<CR>")

-- Coc
-- What are these ops?
-- What do these do?
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "<cr>"]],
    { silent = true, noremap = true, expr = true, replace_keycodes = false })
vim.keymap.set("i", "<TAB>", [[coc#pum#visible() ? coc#pum#confirm() : "<TAB>"]],
    { silent = true, noremap = true, expr = true, replace_keycodes = false })
--


-- VimScript only configuration

-- :h colorscheme
vim.cmd("colorscheme catppuccin")

-- Submodes:verbose imap <CR>
vim.cmd([[
call submode#enter_with('switchbuffer', 'n', '', '<leader>[', ':bp<CR>')
call submode#enter_with('switchbuffer', 'n', '', '<leader>]', ':bn<CR>')
call submode#map('switchbuffer', 'n', '', '[', ':bp<CR>')
call submode#map('switchbuffer', 'n', '', ']', ':bn<CR>')

call submode#enter_with('delbuffer', 'n', '', '<leader>\', ':bn <CR> :bd#<CR>')
call submode#map('delbuffer', 'n', '', '\', ':bn <CR> :bd#<CR>')

call submode#enter_with('prevbuffer', 'n', '', '<leader>,', ':b#<CR>')
call submode#map('prevbuffer', 'n', '', ',', ':b#<CR>')
]])
--
