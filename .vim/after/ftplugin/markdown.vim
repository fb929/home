" Soft wrap at word boundaries, no hard line breaks
setlocal wrap
setlocal linebreak
setlocal breakindent
setlocal textwidth=0

" Indentation
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

" Hide markup characters (*bold*, links) outside the cursor line
setlocal conceallevel=2
setlocal concealcursor=

" Open files with all folds expanded
setlocal foldlevel=99

" Continue lists and quotes on Enter
setlocal formatoptions+=ro
setlocal comments=b:-,b:*,b:+,b:>

" Move by visual lines when wrap is on
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" Headings
highlight markdownH1 cterm=bold ctermfg=214 gui=bold guifg=#ffaf00
highlight markdownH2 cterm=bold ctermfg=208 gui=bold guifg=#ff8700
highlight markdownH3 cterm=bold ctermfg=172 gui=bold guifg=#d78700
highlight link markdownH4 markdownH3
highlight link markdownH5 markdownH3
highlight link markdownH6 markdownH3
highlight link markdownHeadingDelimiter markdownH3

" Emphasis
highlight markdownBold cterm=bold gui=bold
highlight markdownItalic cterm=italic gui=italic
highlight markdownBoldItalic cterm=bold,italic gui=bold,italic

" Inline code, code blocks, links, lists
highlight markdownCode ctermfg=108 guifg=#87af87
highlight markdownCodeDelimiter ctermfg=244 guifg=#808080
highlight markdownLinkText cterm=underline ctermfg=75 gui=underline guifg=#5fafff
highlight markdownUrl ctermfg=244 guifg=#808080
highlight markdownListMarker ctermfg=208 guifg=#ff8700
highlight markdownBlockquote ctermfg=244 guifg=#808080
