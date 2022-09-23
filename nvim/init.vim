:set exrc
:set number
:set hidden
:set nowrap
:set noerrorbells
:set relativenumber
:set autoindent
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

call plug#begin()

Plug 'mhinz/vim-startify' " vim start page
Plug 'https://github.com/preservim/nerdtree' " adds file tree 
Plug 'https://github.com/vim-airline/vim-airline' 
Plug 'vim-airline/vim-airline-themes'
Plug 'gruvbox-community/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/syntastic'
Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'tpope/vim-fugitive' " git wrapper 
Plug 'airblade/vim-gitgutter' " show git status column
"Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'tmsvg/pear-tree'
Plug 'mhinz/vim-startify'

call plug#end()

colorscheme gruvbox

let mapleader = " "
nnoremap <Space> <NOP>

"nnoremap <c-w>h <c-w>s

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

let g:airline_powerline_fonts = 1

" save undo-trees in files
set undofile
set undodir=$HOME/.config/nvim/undo

" number of undo saved
set undolevels=10000
set undoreload=10000

set ttimeoutlen=100

"Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
