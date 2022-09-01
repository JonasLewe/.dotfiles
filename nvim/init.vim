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

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline' 
Plug 'mhinz/vim-startify' " vim start page
Plug 'https://github.com/preservim/nerdtree' " adds file tree 
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive' " git wrapper 
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme gruvbox

let mapleader = " "
nnoremap <Space> <NOP>

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

" save undo-trees in files
set undofile
set undodir=$HOME/.config/nvim/undo
" number of undo saved
set undolevels=10000
set undoreload=10000

"Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
