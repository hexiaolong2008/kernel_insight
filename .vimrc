"===================================================
"vim config
"===================================================
syntax on
set backspace=indent,eol,start
set helplang=cn
set encoding=utf-8
set hls
set incsearch
set mouse=a
set nu
"set relativenumber
set autoindent  
set cindent 
set showmatch
set ai! 
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
noremap <C-s>    :wa<cr><cr>
vnoremap    y    "+y
vnoremap    x    "+x
noremap     yy   "+yy
noremap     dd   "+dd
noremap     p    "+p
nnoremap    o    o<Esc>
inoremap    <C-v>   <Esc>"+pa

command! BcloseOthers call <SID>BufCloseOthers()
function! <SID>BufCloseOthers()
   let l:currentBufNum   = bufnr("%")
   let l:alternateBufNum = bufnr("#")
   for i in range(1,bufnr("$"))
     if buflisted(i)
       if "" != bufname(i)
	 if i!=l:currentBufNum
	   execute("bdelete ".i)
	 endif
       endif
     endif
   endfor
endfunction
map <silent> <F3> viw
map <silent> <F4> :BcloseOthers<cr>
map <silent> <F5> :set mouse=a<cr>
map <silent> <F6> :set mouse=<cr>

"===================================================
"Taglist config
"===================================================
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=0
nmap <silent> <F7> :Tlist<cr>

"===================================================
"WinManager config
"===================================================
"let g:winManagerWindowLayout='TagList|FileExplorer'
let g:AutoOpenWinManager = 0
"nmap <silent> <F8> :WMToggle<cr>

"===================================================
"Cscope config
"===================================================
set cscopequickfix=s-,g-,c-,d-,i-,t-,e-

if filereadable("cscope.out")
    cs add cscope.out
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

nmap <C-c>s :cs find s <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>g :cs find g <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>d :cs find d <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>c :cs find c <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>t :cs find t <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>e :cs find e <C-R>=expand("<cword>")<CR><CR> :copen<CR><CR>
nmap <C-c>f :cs find f <C-R>=expand("<cfile>")<CR><CR> :copen<CR><CR>
nmap <C-c>i :cs find i <C-R>=expand("<cfile>")<CR><CR> :copen<CR><CR>

"===================================================
"MiniBufExplorer config
"===================================================
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 
let g:miniBufExplUseSingleClick = 1
hi MBEVisibleNormal ctermbg=green 
hi MBEVisibleChanged ctermbg=red
hi MBEChanged ctermbg=red


"===================================================
"NERDTree config
"===================================================
let NERDChristmasTree=1
let NERDTreeShowHidden=1
let NERDTreeWinPos='right'
let NERDTreeHighlightCursorline=1
nmap <silent> <F8> :NERDTreeToggle<cr>

