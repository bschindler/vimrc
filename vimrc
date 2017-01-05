set nocompatible              " be iMproved, required
filetype off                  " required

function! GetRunningOS()
	if has("win32") || has("win16") || has("win64")
		return "win"
	endif
	if has("unix")
		if ($MSYSTEM =~? 'MINGW\d\d')
			return "win"
		else if system('uname')=~'Darwin'
			return "mac"
		else
			return "linux"
		endif
	else
		return "unknown"
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
Plugin 'vim-airline/vim-airline'

" indent-guides
Plugin 'nathanaelkane/vim-indent-guides'

" clang-format
Plugin 'rhysd/vim-clang-format'

" Wildignore from gitignore
Plugin 'vim-scripts/gitignore'

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

" Set the mapleader for command-t and others
let mapleader = ","

" We need 256 color terminal here
set t_Co=256

" Now comes configuration. Lets start with the os-specific stuff
if os == "win"
	" Use a good font for windows
	set guifont=DejaVu_Sans_Mono_for_Powerline:h9:cANSI
	" fix backspace behavior for windows
	set backspace=indent,eol,start
	" remap ctrl-p to use the same command as command-t to make my life
	" simpler
	nmap <leader>t :CtrlP<cr>

	" ignore list for ctrl-p
	"let g:ctrlp_custom_ignore = {
	"	\ 'dir': '(.svn|bin|bin64)'
	"}

	" Make the cursor work in mintty
	let &t_ti.="\e[1 q"
	let &t_SI.="\e[6 q"
	let &t_EI.="\e[2 q"
	let &t_te.="\e[0 q"
else
	" Looking up declarations. Needs Ycm so is non-windows right now
	nmap <leader>g :YcmCompleter GoTo<cr>

endif

" clang format integration
let g:clang_format#detect_style_file = 1
map <C-K> :ClangFormat<cr>

" airline wants utf-8 encoding
set encoding=utf8

" Reenable the filetype plugin
filetype plugin indent on

" On windows, I have to enable syntax highlighting... grr!
syntax enable

" Add propsto xml
au BufNewFile,BufRead *.props set filetype=xml
au BufNewFile,BufRead *.vcxproj set filetype=xml
au BufNewFile,BufRead *.sln set filetype=xml

" enable search highlighting
set hlsearch

" airline setup
" use powerline fonts for the airline
let g:airline_powerline_fonts = 1
" In general, I use mixed space/tab configuration
let g:airline#extensions#whitespace#mixed_indent_algo = 2

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
" relative numbers tend to be slow
" set relativenumber

" code completion for help
set wildmenu

" For command-t to work nicely, we filter a few files
" wildignore also affects opening of files
set wildignore+=*.o,*.dll,*.pdb,*.exe,*.suo,*.obj,*.bin,*/CMakeFiles/*


" FSWitch mappings
nmap <leader>of :FSHere<cr>
