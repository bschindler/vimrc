set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/vimfiles/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/vimfiles/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Papercolor
Plugin 'NLKNguyen/papercolor-theme'
" ctrlp
Plugin 'kien/ctrlp.vim'


" vim airline
Plugin 'bling/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Reenable the filetype plugin
filetype plugin indent on


" enable search highlighting
set hlsearch
" use powerline fonts for the airline
let g:airline_powerline_fonts = 1
" fix airline not showing on startup
set laststatus=2

set encoding=utf8

" Use papercolor scheme
set background=dark
colorscheme PaperColor

" Use a good font for windows
set guifont=DejaVu_Sans_Mono_for_Powerline:h9:cANSI

" fix backspace behavior for windows
set backspace=indent,eol,start

" Whitespace visualization
set list
set listchars=tab:>·,trail:·

" On windows, I have to enable syntax highlighting... grr!
syntax on
