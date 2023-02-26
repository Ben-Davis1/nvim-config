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

-- Start nvim-autopairs
require("nvim-autopairs").setup()

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

-- Close Vim if NvimTree is the last buffer (not working)
-- vim.api.nvim_create_autocmd("BufEnter", {
--     nested = true,
--     callback = function()
--         -- # returns length of table
--         if (#vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf()) then
--             vim.cmd("quit")
--         end
--     end
-- })
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

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>p', builtin.find_files)
vim.keymap.set('n', '<Leader>o', builtin.live_grep)

-- Nvim tree
vim.keymap.set('n', '<Leader>.', ":NvimTreeFindFile<CR>")
vim.keymap.set('n', '<Leader>/', ":NvimTreeToggle<CR>")
--



-- VimScript only configuration

-- :h colorscheme
vim.cmd("colorscheme nightfly")
--

vim.cmd([[
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

call submode#enter_with('switchbuffer', 'n', '', '<leader>[', ':bp<CR>')
call submode#enter_with('switchbuffer', 'n', '', '<leader>]', ':bn<CR>')
call submode#map('switchbuffer', 'n', '', '[', ':bp<CR>')
call submode#map('switchbuffer', 'n', '', ']', ':bn<CR>')

call submode#enter_with('delbuffer', 'n', '', '<leader>\', ':bn <CR> :bd#<CR>')
call submode#map('delbuffer', 'n', '', '\', ':bn <CR> :bd#<CR>')

call submode#enter_with('prevbuffer', 'n', '', '<leader>,', ':b#<CR>')
call submode#map('prevbuffer', 'n', '', ',', ':b#<CR>')

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
nmap <silent> zA :call     CocAction('fold')<CR>

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
]])
