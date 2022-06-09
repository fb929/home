" tabs
set paste
set tabstop=4
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set expandtab
set tabpagemax=100
map <C-Left>	:tabprev<CR>
map <C-Right>	:tabnext<CR>
map <C-n>	:tabnew

" navigation arrow
set nocp

" ignore registry
"set ic
" color find
set hls
" incremental search
set is

" default encode
set encoding=utf-8
" term encode (must coincide "encoding")
set termencoding=utf-8
" file encodings and sequence determination
set fileencodings=utf8,cp1251,koi8-r

" fix backspace in CentOS
set backspace=indent,eol,start

" default colorscheme
colorscheme my

" ru map
map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >

""" HIGHLIGHT
" default syntax on
syntax on

" my highlight group
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitepace
" and spaces before a tab
" and spaces used for indenting (so you use only tabs for indenting):
match ExtraWhitespace /\s\+$\| \+\ze\t\|\t\+/

" auto chmod
au BufWritePost * if getline(1) =~ "^#!.*/bin/"|silent !chmod a+x %

" highlight MySQL
if has("autocmd")
	autocmd BufRead *.sql set filetype=mysql
endif

" highlight config files
autocmd BufReadPost config set filetype=config

if version >= 714
	" highlight trailing spaces
	au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)

	" highlight tabs between spaces
	au BufNewFile,BufRead * let b:mtabbeforesp=matchadd('ErrorMsg', '\v(\t+)\ze( +)', -1)
	au BufNewFile,BufRead * let b:mtabaftersp=matchadd('ErrorMsg', '\v( +)\zs(\t+)', -1)

	" highlight string longer than eighty symbol
	au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>177v', -1)
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>180v.\+', -1)
endif

" set tabs settings for html files
augroup html
	autocmd!
	autocmd BufRead,BufNewFile *.html match none
	autocmd BufRead,BufNewFile *.html set shiftwidth=2
	autocmd BufRead,BufNewFile *.html set tabstop=2
	autocmd BufRead,BufNewFile *.html set smarttab
	autocmd BufRead,BufNewFile *.html set expandtab
	autocmd BufRead,BufNewFile *.html set autoindent
	autocmd BufRead,BufNewFile *.html set smartindent
	autocmd BufNewFile,BufRead *.html let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
augroup END
augroup xml
	autocmd!
	autocmd BufRead,BufNewFile *.xml match none
	autocmd BufRead,BufNewFile *.xml set shiftwidth=4
	autocmd BufRead,BufNewFile *.xml set tabstop=4
	autocmd BufRead,BufNewFile *.xml set smarttab
	autocmd BufRead,BufNewFile *.xml set expandtab
	autocmd BufRead,BufNewFile *.xml set autoindent
	autocmd BufRead,BufNewFile *.xml set smartindent
	autocmd BufNewFile,BufRead *.xml let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
augroup END
augroup yml
	autocmd!
	autocmd BufRead,BufNewFile *.yml* match none
	autocmd BufRead,BufNewFile *.yml* set shiftwidth=4
	autocmd BufRead,BufNewFile *.yml* set tabstop=4
	autocmd BufRead,BufNewFile *.yml* set smarttab
	autocmd BufRead,BufNewFile *.yml* set expandtab
	autocmd BufRead,BufNewFile *.yml* set autoindent
	autocmd BufRead,BufNewFile *.yml* set smartindent
	autocmd BufNewFile,BufRead *.yml* let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
augroup END
augroup yaml
	autocmd!
	autocmd BufRead,BufNewFile *.yaml* match none
	autocmd BufRead,BufNewFile *.yaml* set shiftwidth=4
	autocmd BufRead,BufNewFile *.yaml* set tabstop=4
	autocmd BufRead,BufNewFile *.yaml* set smarttab
	autocmd BufRead,BufNewFile *.yaml* set expandtab
	autocmd BufRead,BufNewFile *.yaml* set autoindent
	autocmd BufRead,BufNewFile *.yaml* set smartindent
	autocmd BufNewFile,BufRead *.yaml* let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
	autocmd BufNewFile,BufRead *.yaml* let b:mtrailingws=matchadd('ErrorMsg', '\t\+', -1)
augroup END
augroup eyaml
	autocmd!
	autocmd BufRead,BufNewFile *.eyaml* match none
	autocmd BufRead,BufNewFile *.eyaml* set shiftwidth=4
	autocmd BufRead,BufNewFile *.eyaml* set tabstop=4
	autocmd BufRead,BufNewFile *.eyaml* set smarttab
	autocmd BufRead,BufNewFile *.eyaml* set expandtab
	autocmd BufRead,BufNewFile *.eyaml* set autoindent
	autocmd BufRead,BufNewFile *.eyaml* set smartindent
	autocmd BufNewFile,BufRead *.eyaml* let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
	autocmd BufNewFile,BufRead *.eyaml* let b:mtrailingws=matchadd('ErrorMsg', '\t\+', -1)
augroup END
augroup py
	autocmd!
	autocmd BufRead,BufNewFile *.py* match none
	autocmd BufRead,BufNewFile *.py* set shiftwidth=4
	autocmd BufRead,BufNewFile *.py* set tabstop=4
	autocmd BufRead,BufNewFile *.py* set smarttab
	autocmd BufRead,BufNewFile *.py* set expandtab
	autocmd BufRead,BufNewFile *.py* set autoindent
	autocmd BufRead,BufNewFile *.py* set smartindent
	autocmd BufNewFile,BufRead *.py* let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
augroup END

" fix term in screen
if match($TERM, "screen")!=-1
	set term=xterm-256color
	set t_ut=
	let g:GNU_Screen_used = 1
else
	set t_ut=
	let g:GNU_Screen_used = 0
endif

" screen-ify an external command.
function InScreen(command)
	return g:GNU_Screen_used ? 'screen '.a:command : a:command
endfunction

" for get settings from comment in file
set modeline
set modelines=5

set hidden

function OldTabs()
	:set tabstop=8
	:set shiftwidth=8
	:set noexpandtab
	:match ExtraWhitespace /\s\+$\| \+\ze\t\|^\t*\zs \+/
endfunction
