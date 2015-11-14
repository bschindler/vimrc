set nocompatible              " be iMproved, required
filetype off                  " required

function! GetRunningOS()
	if has("win32") || has("win16") || has("win64")
		return "win"
	endif
	if has("unix")
		if system('uname')=~'Darwin'
			return "mac"
		else
			return "linux"
		endif
	endif
endfunction
let os=GetRunningOS()

if os == "win"
	" set the runtime path to include Vundle and initialize
	set rtp+=~/vimfiles/bundle/Vundle.vim
	" alternatively, pass a path where Vundle should install plugins
	call vundle#begin('~/vimfiles/bundle')
else
	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Papercolor
Plugin 'NLKNguyen/papercolor-theme'


" Fast file-source switcher
Plugin 'derekwyatt/vim-fswitch'

" vim airline
Plugin 'bling/vim-airline'

" os-specific config/plugins
if os == "win"
	" ctrlp
	Plugin 'kien/ctrlp.vim'
else
	" Git plugin not hosted on GitHub
	Plugin 'git://git.wincent.com/command-t.git'
	" YouCompleteMe
	Plugin 'Valloric/YouCompleteMe'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Now comes configuration. Lets start with the os-specific stuff
if os == "win"
	" Use a good font for windows
	set guifont=DejaVu_Sans_Mono_for_Powerline:h9:cANSI
	" airline wants utf-8 encoding
	set encoding=utf8
	" fix backspace behavior for windows
	set backspace=indent,eol,start
	" On windows, I have to enable syntax highlighting... grr!
	syntax on
else
	set t_Co=256
endif

" Reenable the filetype plugin
filetype plugin indent on

" enable search highlighting
set hlsearch

" airline setup
" use powerline fonts for the airline
let g:airline_powerline_fonts = 1
" fix airline not showing on startup
set laststatus=2

" Use papercolor scheme
set background=dark
colorscheme PaperColor

" Whitespace visualization
set list
set listchars=tab:>·,trail:·

" Configure line numbers
set number
set relativenumber

