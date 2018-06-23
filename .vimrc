" General
set nocompatible                " no strict vi compatability
set clipboard^=unnamed          " windows: copy and paste
set noerrorbells		            " shh
set nojoinspaces                " no extra spacing
set nowrap                      " no wrapping
set autoindent                  " auto indenting

" Tab
set expandtab
set shiftwidth=2
set tabstop=2

" UI
set backspace=indent,eol,start  " backspace
set mouse=a                     " enable mouse support
set number			                " line numbering
set wildmenu                    " visual auto-complete
set showmatch                   " show ()[]{}
set ruler			                  " show current line number
set splitbelow		              " split window below
set splitright		              " split window to the right
set modeline                    " show what is done

" Search
set ignorecase		            	" search without case
set nohlsearch	            		" no highlight
set incsearch             			" incremental Searching

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'Valloric/YouCompleteMe' 

call plug#end()

" Colorscheme
set t_Co=256
set background=dark
colorscheme gruvbox
let g:ycm_global_ycm_extra_conf = '/home/pi/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:airline#extensions#ale#enabled = 1
