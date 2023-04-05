:set exrc
:set number
:set hidden
:set noerrorbells
:set relativenumber
:set smartindent
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set termguicolors
:set smarttab
:set mouse=a
:set incsearch
:set scrolloff=8
:set signcolumn=yes
:set nocompatible

" Use system clipboard
set clipboard=unnamedplus

" Define installed plugins
call plug#begin()

" Make nvim pretty again
Plug 'mhinz/vim-startify' " vim start page
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'gruvbox-community/gruvbox'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-emoji'

" Functional plugins
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"Plug 'scrooloose/syntastic'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive' " git wrapper
Plug 'mbbill/undotree'
Plug 'theprimeagen/harpoon'
Plug 'airblade/vim-gitgutter' " show git status column
Plug 'nvim-lua/plenary.nvim' " needed for telescope
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }

" Other plugins
Plug 'ThePrimeagen/vim-be-good' " vim learning game

call plug#end()


set encoding=UTF-8
set completefunc=emoji#complete


" Define visuals
" colorscheme gruvbox
colorscheme tokyonight-moon
" colorscheme jellybeans
" colorscheme atom
lua require'colorizer'.setup()


" save undo-trees in files
set undofile
set undodir=$HOME/.config/nvim/undo

" number of undo saved
set undolevels=10000
set undoreload=10000
set ttimeoutlen=100

" vim rebindings
let mapleader = " "
nnoremap <Space> <NOP>

" open netrw
nnoremap <leader>pv <cmd>Ex<cr>

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let g:airline_powerline_fonts = 1

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" esc in insert & visual mode
inoremap kj <esc>
vnoremap kj <esc>

" Undotree
nnoremap <leader>u <cmd>UndotreeToggle<cr>

" esc in command mode
cnoremap kj <C-C>
" Note: In command mode mappings to esc run the command for some odd
" historical vi compatibility reason. We use the alternate method of
" existing which is Ctrl-C

" open terminal below all splits
cabbrev bterm bo term


"" syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

"" Magma Python REPL
"nnoremap <silent><expr> <Leader>r  :MagmaEvaluateOperator<CR>
"nnoremap <silent>       <Leader>rr :MagmaEvaluateLine<CR>
"xnoremap <silent>       <Leader>r  :<C-u>MagmaEvaluateVisual<CR>
"nnoremap <silent>       <Leader>rc :MagmaReevaluateCell<CR>
"nnoremap <silent>       <Leader>rd :MagmaDelete<CR>
"nnoremap <silent>       <Leader>ro :MagmaShowOutput<CR>
"
"let g:magma_automatically_open_output = v:false
"let g:magma_image_provider = "ueberzug"
