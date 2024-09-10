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
require("nvim-tree").setup({
    renderer = {
        full_name = true
    },
    view = {
        width = {
            max = 50
        }
    }
})

-- Start buftabline
require("buftabline").setup()

-- Start Telescope with vertical layout and mappings
local actions = require("telescope.actions")
require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        mappings = {
            i = {
                ["<UP>"] = actions.cycle_history_prev,
                ["<DOWN>"] = actions.cycle_history_next,
                ["<C-ESC>"] = actions.close },
            n = {
                ["o"] = actions.select_default,
            }
        }
    }
})

-- start nvim-comment
require("nvim_comment").setup()
--



-- Set global variables

-- https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
vim.g.mapleader = " "

-- https://github.com/kana/vim-submode/blob/master/doc/submode.txt#L216
vim.g.submode_keep_leaving_key = true
-- Stop submode timing out
vim.g.submode_timeout = 0
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

-- Close Vim if NvimTree is the last buffer
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        if (string.find(vim.api.nvim_buf_get_name(0), ".git//")) then
            return
        end
        if (vim.fn.winnr("$") > 2 or (vim.fn.winnr("$") == 1 and string.find(vim.api.nvim_buf_get_name(0), "NvimTree_"))) then
            return
        else
            vim.cmd("NvimTreeClose")
        end
    end
})

-- Save state of Buffer when leaving. This saves the position of the cursor (unless it's NVimTree)
vim.api.nvim_create_autocmd(
    "BufLeave",
    {
        callback = function()
            if (string.find(vim.api.nvim_buf_get_name(0), "NvimTree_")) then
                return
            end
            vim.b.winview = vim.fn.winsaveview()
        end
    }
)

-- Load state of Buffer when entering. This restores the position of the cursor (unless it's NiimTree)
vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        callback = function()
            if (string.find(vim.api.nvim_buf_get_name(0), "NvimTree_")) then
                return
            end
            if (vim.b.winview) then
                vim.fn.winrestview(vim.b.winview)
            end
        end
    }
)

-- Change tab highlight colour for tokyodark colorscheme
vim.api.nvim_create_autocmd(
    "BufEnter",
    { command = "highlight TabLineSel guifg=NONE guibg=NONE" }
)
--



-- User commands
--
-- General
-- Used when exiting .git buffer (see Vim only commands below). Workaround for NVimTree being focused instead of previous buffer
vim.api.nvim_create_user_command("Q",
    function() vim.cmd("q | wincmd p") end,
    { bang = true })

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

-- Telescope
-- This import is a duplication but good to have for clarity
local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
vim.api.nvim_create_user_command("F",
    function(args)
        extensions.live_grep_args.live_grep_args({ default_text = args.args })
        if (args.args ~= "") then
            -- Puts telescope picker in normal mode 1 ms after opening (need the delay to wait for the picker to open)
            vim.defer_fn(function() vim.cmd.stopinsert() end, 1)
        end
    end,
    { nargs = "?" })
vim.api.nvim_create_user_command("Ff",
    function(args)
        builtin.find_files({ default_text = args.args })
        if (args.args ~= "") then
            -- Puts telescope picker in normal mode 1 ms after opening (need the delay to wait for the picker to open)
            vim.defer_fn(function() vim.cmd.stopinsert() end, 1)
        end
    end,
    { nargs = "?" })
--



-- Mappings
-- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings-set

-- General
vim.keymap.set('n', '<Leader>s', ":update<CR>")
vim.keymap.set('n', '<Leader>w', ":quit<CR>")
-- Tab and shift tab to indent and de-indent in normal and insert mode (tab already indents in insert mode but just adding for clarity)
vim.keymap.set('n', '<TAB>', ">>")
vim.keymap.set('n', '<S-TAB>', "<<")
vim.keymap.set('i', '<TAB>', "<C-t>")
vim.keymap.set('i', '<S-TAB>', "<C-d>")

-- Telescope
local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
vim.keymap.set('n', '<Leader>p', builtin.find_files)
vim.keymap.set('n', '<Leader>o', extensions.live_grep_args.live_grep_args)

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
vim.cmd("colorscheme tokyodark")

-- Submodes:verbose imap <CR>
-- delbuffer doesn't work with bd but that's ok!
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

-- Uses the custom user command :Q when in git buffer (see :Q above)
vim.cmd([[cabbrev q <c-r>=(stridx(bufname(''), '.git//') >= 0 ? 'Q' : 'q')<CR>]])
--
