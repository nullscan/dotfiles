set nocompatible				" use vim defaults
set ls=2						" allways show status line
set tabstop=4					" numbers of spaces of tab character
set shiftwidth=4				" numbers of spaces to (auto)indent
set scrolloff=3					" keep 3 lines when scrolling
set cindent						" cindent
set smartindent					" smart indent
set autoindent					" always set autoindenting on
set showcmd						" display incomplete commands
set hlsearch					" highlight searches
"set highlight=8r,db,es,hs,mb,Mr,nu,rs,sr,tb,vr,ws  " dont know what this does really, just use it
set incsearch					" do incremental searching
set visualbell t_vb=			" turn off error beep/flash
set novisualbell				" turn off visual bell
set nobackup					" real men NEVER use backups
set number						" show line numbers
set ignorecase 					" ignore case if all is lower case. Use \C to get case sensitivity
set smartcase
set title
set nofsync 					" improves performance
set ttyfast						" smoother changes
set modeline					" last lines in document sets vim mode
set modelines=3					" number lines checked for modelines
set shortmess=atI				" Abbreviate messages
set nostartofline				" don't jump to first character when paging
set whichwrap=b,s,h,l,<,>,[,]	" move freely between files
set showmode					" display the current mode
set showmatch					" show matching brackets/parenthesis
set wildmode=list:longest,full	" comand <Tab> completion, list matches and
								" complete the longest common part, then,
								" cycle through the matches
set shortmess+=filmnrxoOtT		" abbrev. of messages (avoids 'hit enter')
set pastetoggle=<F12>			" pastetoggle (sane indentation on pastes)
								" just press F12 when you are going to
								" paste several lines of text so they won't
								" be indented
								" When in paste mode, everything is inserted
								" literally.
set ruler						" show the ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
set showcmd						" show partial commands in status line and
								" selected characters/lines in visual mode
set matchpairs+=<:>				" which patterns can be matched with %
" set mouse=a						" enable mouse ussage in console vim
set viewoptions=folds,options,cursor,unix,slash
set report=0 					" always report how many lines are changed
set autochdir 					" automaticaly chdir of vim path to the file open in buffer


set rtp+=/usr/lib/python3/dist-packages/powerline/bindings/vim/
set t_Co=256
set laststatus=2
let g:Powerline_symbols = "fancy"

" Enable built in useful options
syntax on	" syntax highlighing
filetype plugin indent on	" enable filetype detection
au BufNewFile,BufRead *.j2 set ft=jinja
" let Tlist_Exit_OnlyWindow = 1
let g:tagbar_left = 1
let g:tagbar_usearrows = 1
" custom status line for C, C++ and header files
" au BufRead *.cpp,*.c,*.h set statusline=\File:\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L\ \ %=\ %r%{ShowFuncName()}%h
au BufRead *.cpp,*.c,*.h set statusline=\ %f%m%r%h%w\ \in\ \%{CurDir()}\ %{ShowFuncName()}\%=%([%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y]%)\ %([%04.4l\ \(of\ \%04.4L),%-03.3v][%p%%]\ \ASCII=%-04.4b\ HEX=0x%-04.4B\%)
" Open new buffer in new tab
"au BufAdd,BufNewFile * nested tab sball
autocmd FileType cpp,c,h TagbarOpen
set statusline=\ %f%m%r%h%w\ \in\ \%{CurDir()}\ %=%([%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y]%)\ %([%04.4l\ \(of\ \%04.4L),%-03.3v][%p%%]\ \ASCII=%-04.4b\ HEX=0x%-04.4B\%)

call plug#begin()
Plug 'pearofducks/ansible-vim'
call plug#end()

filetype off
let &runtimepath.=',~/.vim/bundle/ale'
filetype plugin on

function! ShowFuncName()
	let lnum = line(".")
	let col = col(".")
	let f_ = substitute(getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')), ",\\=[^,]{", "", "")
	let f = search("\\%" . lnum . "l" . "\\%" . col . "c")
	return f_
endfunction

function! CurDir()
    let curdir = substitute(getcwd(), '/home/poly/', "~/", "g")
    return curdir
endfunction

function! FormatSource()
	execute ":write"
	execute "!astyle % &> /dev/null"
	execute ":e ".expand("%")
	syntax on
	filetype on
endfunction

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

if has("gui_running")
	" See ~/.gvimrc
	set guifontset=tahoma.8   	" use this font
	set lines=40				" height = 50 lines
	set columns=90				" width = 100 columns
	set background=dark			" adapt colors for background
	set selectmode=mouse,key,cmd
	colorscheme inkpot
else
	colorscheme delek			" use this color scheme
	set background=dark			" adapt colors for background
endif

if has("autocmd")
   " Restore cursor position
   au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

   " Filetypes (au = autocmd)
   au FileType helpfile set nonumber       " no line numbers when viewing help
   au FileType helpfile nnoremap <buffer><cr> <c-]>    " Enter selects subject
   au FileType helpfile nnoremap <buffer><bs> <c-T>    " Backspace to go back

   " When using mutt, text width=72
   au FileType mail,tex set textwidth=72

   " Automatically chmod +x Shell,Perl and Python scripts
   au BufWritePost *.sh,*.pl,*.py !chmod +x %

   " Automatically astyle C/C++/header files when writing the buffer.
   " Requires astyle and a working astyle config file
   au BufWritePost *.cpp,*.c,*.h call FormatSource()

   " File formats
   au BufNewFile,BufRead	*.pls			set syntax=dosini
   au BufNewFile,BufRead	modprobe.conf	set syntax=modconf
   au BufNewFile,BufRead	*.j2	set ft=jinja
endif

"Uncomment if you want diffrent statusline colors for normal and edit modes
"if version >= 700
"	au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
"   au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"endif

" Keyboard mappings
" map F1 to open previous buffer
map <F1> :previous<CR>
" map F2 to open next buffer
map <F2> :next<CR>
" map F3 to make command
map <silent> <F3> :exec ":!make"<CR>
map <silent> <S-F3> :exec ":!make clean"<CR>
" map F7 to open the corresponding .h or .c(pp) file to the one curently displayed in a new tab. a.vim plugin
map <F7> :AT<CR>
" map F4 to open previous tab
nmap <silent> <F4> :tabprevious<CR>
" map F5 to open next tab
nmap <silent> <F5> :tabnext<CR>
" F4 in insert mode: exit insert, switch tab, enter insert again
imap <silent> <F4> <ESC>:tabprevious<CR>i
" map F5 to open next tab
imap <silent> <F5> <ESC>:tabnext<CR>i
" map F6 to cycle through window splits
map <silent> <F6> :exec ":!aspell -c %"<CR>
" turn off highlighted search
map <silent> <C-N> :silent noh<CR>

" edit my .vimrc file in a split
map ,v :sp ~/.vimrc<cr>

" edit my .vimrc file
map ,e :e ~/.vimrc<cr>

" update the system settings from my vimrc file
map ,u :source ~/.vimrc<cr>

" Common command line typos
nmap :Q :q
nmap :W :w
nmap :wQ :wq

" Command to strip all lines in file from trailing white spaces and tabs
cmap trims %s/\s\+$//
cmap trimt %s/\t\+$//

" Page Up and Page Down using space and backspace
map <space> <c-f>
map <backspace> <c-b>

nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <ESC>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>
nmap <silent> <C-A-c> :!make clean<CR>
map <silent> <C-A-c> :!make clean<CR>
nmap <silent> <C-A-m> :!make install<CR>
map <silent> <C-A-m> :!make install<CR>

map <C-Left> <C-w>w<CR>

au BufWritePre ?* mkview
au BufWritePost ?* silent loadview
au BufReadPost ?* silent loadview

" source /usr/share/vim/vimcurrent/ftplugin/man.vim
