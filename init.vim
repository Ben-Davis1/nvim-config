let mapleader = " "

" https://dev.to/elvessousa/my-basic-neovim-setup-253l
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
set inccommand=split
set mouse=a
set number
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu
set encoding=UTF-8

set wildignore=*/node_modules/*

filetype plugin indent on
syntax on

set t_Co=256

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

call plug#begin()
    " Appearance
    Plug 'vim-airline/vim-airline'
    Plug 'ryanoasis/vim-devicons'
Plug 'sonph/onehalf', { 'rtp': 'vim' }

Plug 'https://github.com/ap/vim-buftabline.git'

" Utilities
    Plug 'sheerun/vim-polyglot'
    Plug 'jiangmiao/auto-pairs'
    Plug 'ap/vim-css-color'
    Plug 'preservim/nerdtree'

    " Completion / linters / formatters
    Plug 'neoclide/coc.nvim',  {'branch': 'release'}
    Plug 'plasticboy/vim-markdown'

    " Git
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'psliwka/vim-smoothie'
Plug 'alvan/vim-closetag'

Plug 'tpope/vim-commentary'
Plug 'kana/vim-submode'

:h

call plug#end()

syntax on
set t_Co=256
set cursorline
colorscheme onehalfdark
let g:airline_theme='onehalfdark'
let g:ale_fixers = { 'javascript': ['prettier'] }
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1
let g:ale_virtualtext_cursor = 0
let g:submode_keep_leaving_key = 1


" lightline
" let g:lightline = { 'colorscheme': 'onehalfdark' }

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
autocmd VimEnter * wincmd w | q
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" :autocmd BufEnter * silent! normal! g`"



command! -bang -nargs=+ -complete=dir S call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

command -nargs=1 Gc :Git commit -m <q-args> | :Git push
command -nargs=1 Gca :Git add . | :Git commit -m <q-args> | :Git push
command -nargs=? Gb :Git fetch | :Git checkout <q-args> | :Git pull
command Gbd :Git checkout development | :Git fetch | :Git pull
command -nargs=1 Gbn :Git checkout -b <q-args>

:set nofixendofline

nnoremap <silent> <expr> <Leader>p fugitive#head() != '' ? ':GFiles<CR>' : ':Files<CR>'
nnoremap <silent> <Leader>. :NERDTreeFind<CR>:
nnoremap <silent> <Leader>/ :NERDTreeToggle<CR>

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

