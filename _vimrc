"  < 跨平台环境设置 > {{{
let g:iswindows64=has("win64")
let g:iswindows =g:iswindows64||has( "win32") 
if g:iswindows
  let g:islinux=0
else
  let g:islinux=1
  "设置跨平台的vim插件的路径，本用户生效时放在在linux用户的~/.vimfiles目录下
  let g:myvimfiles=expand("~").'/.vimfiles'
  if isdirectory(g:myvimfiles)
    set runtimepath+=~/.vimfiles
  endif
endif
"  < 判断是终端还是 Gvim >
let g:isGUI=has("gui_running")
augroup vimrc
  autocmd!
augroup end
"}}}
"  < 编码配置 > {{{
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码 
" 文件格式，fileformat默认跟随平台而变，但vim相关文件已设置au命令保持unix格式
"set fileformat=dos                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型
"}}}
" < 自定义配置 > {{{
let mapleader = ","
let g:mapleader = ","
set timeoutlen=1000                         "leader和命令键等待时间
" 历史记录数
set history=1000
"禁止生成临时文件
set noswapfile
"clipboard 不设置共享剪切板
"set clipboard+=unnamed
" set vb t_vb=                                "关闭提示音
""autocmd BufRead,BufNewFile,BufEnter * lcd %:p:h    " 自动切换目录为当前编辑文件所在目录
set autochdir
syntax on                                             "启用语法高亮
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=2                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=2                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set textwidth=0                                       "设为0禁止自动换行
set formatoptions+=mM                                 " m - Also break at a multi-byte character above 255. This is useful for  " Asian text where every character is a word on its own.
" M - When joining lines, don't insert a space before or after a " multi-byte character. Overrules the 'B' flag.
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
"set foldenable                                        "启用折叠
""set foldmethod=indent                                 "indent 折叠方式
"set foldmethod=marker                                "marker 折叠方式
set nocompatible                                        "取消vi兼容性
set backspace=indent,eol,start                          "设置backspace删除内容
"set scrolloff=2                                         " Keep 2 lines (top/bottom) for scope 上下移动光标时, 始终保持光标上或下有两行在屏幕上.
"set linebreak                                          "line break after a word.(只在单词结束后换行, 避免把一个单词显示在两行. 中文不建议打开这个选项)
"set nojoinspaces                                       "no space add when join two lines.(用j命令合并两行时, 不在之间加空格.)
set autoread                                          " 当文件在外部被修改，自动更新该文件
set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用

"}}}
"<成对符号自动补全>{{{
"在状态栏，也可以显示状态
let g:completePairs=0
command! ToggleCompletePairs :call ToggleCompletePairs()
function! ToggleCompletePairs()
  if g:completePairs ==0   
    let g:completePairs=1
    :inoremap ( ()<ESC>i 
    :inoremap ) <c-r>=ClosePair(')')<CR>
    :inoremap { {<CR>}<ESC>O
    :inoremap } <c-r>=ClosePair('}')<CR>
    :inoremap < <><ESC>i
    :inoremap > <c-r>=ClosePair('>')<CR>
    :inoremap [ []<ESC>i
    :inoremap ] <c-r>=ClosePair(']')<CR>
    :inoremap " ""<ESC>i
    :inoremap ' ''<ESC>i
    echom 'Enbale Aoto complete Pairs'
  elseif g:completePairs ==1 
    let g:completePairs=0
    :iunmap (
    :iunmap )
    :iunmap {
    :iunmap }
    :iunmap <
    :iunmap >
    :iunmap [
    :iunmap ]
    :iunmap "
    :iunmap '
    echom 'Disbale Aoto complete Pairs'
  else
    let g:completePairs=0
  endif
endfunction
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endfunction
"}}}
"  < 界面配置 > {{{
set wildmenu                                          "Tab键命令时，在命令栏上方显示候选项，
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=1                                       "设置命令行的高度为2，默认为1
set linespace=2                                      "行间距
set cursorline                                        "突出显示当前行
if g:iswindows
  set guifont=Space_Mono_for_Powerline:h12
  set guifontwide=Microsoft_Yahei_Mono:h12:cGB2312                         "中文字体
endif
set nowrap                                            "设置自动换行，默认不自动换行，需要自动换行的类型用au命令设置
set shortmess=atI                                     "去掉欢迎界面
"配置输入法im，在正常模式下，不使用输入法
if g:iswindows && g:isGUI
  set noimdisable
  set imsearch=2
  set imcmdline
  augroup vimrc
  autocmd! InsertLeave * set iminsert=0 
  autocmd! InsertEnter * set iminsert=2
  autocmd! FocusGained * call IM_auto_change(mode())
  function! IM_auto_change(mode)
    echom mode()
    if a:mode == 'n' 
      silent set iminsert=2   
      "避免无法切换
      exe ":normal :"
    elseif a:mode == 'v'|| a:mode == 'V' 
      silent set iminsert=2   
      "避免无法切换
      exe ":normal \<esc>"
      exe ":normal :"
      exe ":normal gv"
    endif
  endfunction
  augroup end
endif
" 设置 gVim 窗口初始位置及大<ESC>小
""if g:isGUI
"""au GUIEnter * simalt ~x                           "窗口启动时自动最大化
""winpos 130 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
""set lines=48 columns=120                          "指定窗口大小，lines为高度，columns为宽度
""endif
"设置帮助文件语言，由于下载了7.4版本的中文帮助，所以800版本以上优先使用en
if version >= 700 && version <800
  set helplang=cn
else
  set helplang=en
endif
" 设置代码配色方案
if g:isGUI
  autocmd VimEnter * call g:AtColorshemeWithTime() "跟随时间自动的设置colorscheme
  "因为自动缩进的指示线，偶尔不正常，利用timer的特性，进入gui界面后强制执行一次后就完美了。
  func! DelayCall(timer)
    call AtColorshemeWithTime()
  endfunction
  let timer = timer_start(5,'DelayCall') "不加参数，只执行一次
else
  colorscheme desert               "终端配色方案
endif
let g:molokai_original = 1 "molokai
let g:rehash256 = 1        "molokai


if g:isGUI
  "光标配置
  set guicursor+=v:ver10-Cursor-blinkon0/lCursor      "普通模式下，鼠标光标变为竖线
  augroup vimrc
    autocmd cursorhold * set guicursor +=n:block-Cursor-blinkon0/lCursor
    autocmd CursorMoved * set guicursor -=n:block-Cursor-blinkon0/lCursor
  augroup end
endif

" Return to last edit position when opening files (You want this!)
augroup vimrc
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end
" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
  set guioptions-=m "Menu"
  set guioptions-=T "Toolbar"
  set guioptions-=r "right roll bar"
  set guioptions-=R "right roll bar"
  set guioptions-=l "left roll bar"
  set guioptions-=L "left roll bar"
  set guioptions+=e ""显示标签栏
  "set guioptions+=c "Don't use message-box,use console confirm
  nnoremap <silent> <F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
        \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
        \endif<CR>
endif
"启用directx渲染字体"
if g:isGUI
  set guioptions+=ipM
  if g:iswindows
    if (v:version == 704 && has("patch393")) || v:version > 704
      "set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1
      set renderoptions=type:directx,renmode:5,taamode:1
    endif
  endif
endif

function! g:AtColorshemeWithTime()
  let hr = str2nr(strftime('%H'))
  if hr <= 20 && hr >=18
    let i = 6
  elseif hr <= 8 || hr >=20
    let i = 6
  else
    let i = 6
  endif
  let nowcolors = 'eclipse zellner morning solarized desert evening molokai slate'
  try
    execute 'colorscheme '.split(nowcolors)[i]
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
  endtry
  redraw
  echo i.":".g:colors_name
endfunction
"}}}
"<设置tab标题>{{{
"这是一个坑，填了很久。
"guitabline用于设置非gui界面的tab title。guitablabel用于设置Gui版本的tab
"title。如果要启用gui版tab，需要在guioptions增加e参数。
if g:isGUI 
  set guioptions+=e
  set guitablabel=%{GuiTabLabel()}
  function! GuiTabLabel()
    " add the tab number
    let label = '['.tabpagenr()
    " modified since the last save?
    let buflist = tabpagebuflist(v:lnum)
    let labeltype=''
    for bufnr in buflist
      if getbufvar(bufnr, '&modified')
        let label = '+'.label
      endif
      if getbufvar( bufnr, "&buftype" ) == 'help'
        let labeltype .= 'H'  
      elseif getbufvar( bufnr, "&buftype" ) == 'quickfix'
        let labeltype .= 'Q'
      endif
    endfor
    " count number of open windows in the tab
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
      let label .= ', '.wincount
    endif
    let label .= '] '
    "add help or quickfix tabline
    if labeltype !=''
      let label = label.'['.labeltype.']'
    endif
    " add the file name without path information
    let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
    let label .= fnamemodify(n, ':t')
    return label
  endfunction
else
  set tabline=%!MyTabLine()
  function! MyTabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
      " select the highlighting for the buffer names
      if t + 1 == tabpagenr()
        let s .= '%#TabLineSel#'
      else
        let s .= '%#TabLine#'
      endif
      " empty space
      let s .= ' '
      " set the tab page number (for mouse clicks)
      let s .= '%' . (t + 1) . 'T'
      " set page number string
      let s .= t + 1 . ' '
      " get buffer names and statuses
      let n = ''  "temp string for buffer names while we loop and check buftype
      let m = 0 " &modified counter
      let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
      " loop through each buffer in a tab
      for b in tabpagebuflist(t + 1)
        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
        if getbufvar( b, "&buftype" ) == 'help'
          let n .= '[H]'  ". fnamemodify( bufname(b), ':t:s/.txt$//' ) "我修改：注释掉了帮助的文件名
        elseif getbufvar( b, "&buftype" ) == 'quickfix'
          let n .= '[Q]'
        else
          "let n .= pathshorten(bufname(b))
          let n = fnamemodify( bufname(b), ':t:s/.txt$//' ) "我修改：避免buff出现/P/V等问题
        endif
        " check and ++ tab's &modified count
        if getbufvar( b, "&modified" )
          let m += 1
        endif
        " no final ' ' added...formatting looks better done later
        if bc > 1
          let n .= ' '
        endif
        let bc -= 1
      endfor
      " add modified label [n+] where n pages in tab are modified
      if m > 0
        "let s .= '[' . m . '+]'
        let s.= '+ '
      endif
      " add buffer names
      if n == ''
        let s .= '[No Name]'
      else
        let s .= n
      endif
      " switch to no underlining and add final space to buffer list
      "let s .= '%#TabLineSel#' . ' '
      let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      let s .= '%=%#TabLine#%999XX'
    endif
    return s
  endfunction
endif
"}}}
"< 彩色状态栏 >{{{
""backup:set statusline=[%{getcwd()}][%f]%r%m%*%=\|Row:%l/%L,Col:%c][%p%%][Filetype=%Y][%{&encoding},%{&ff}]
set statusline=[%F]%r%m
set statusline+=[%{File_size(@%)}%*] "获取文件大小
set statusline+=%*%=
set statusline+=\ %Y\ \| "filetype
set statusline+=%=\ %{&ff}\ \|\%{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\&bomb)?\",B\":\"\").\"\ \|\"}\ %-8.(%l:%c%)%*
set statusline+=\ %P\|%L
if version >= 700
  "default the statusline to gray when entering Vim
  hi statusline guibg=gray
  au BufWritePost * hi StatusLine  guibg=lightGreen
  au InsertEnter * call InsertStatuslineColor(v:insertmode)
  au InsertChange * call InsertStatuslineColor(v:insertmode)
  au InsertLeave * hi statusline guibg=gray 
  ""离开插入模式后，如果键盘大写锁定，则切换为小写。需要cap.ahk脚本配合。
  ""[note]由于后来在autohotkey中添加了Cap状态指示器，与这个功能冲突，所以关闭。
  ""au InsertLeave *  :silent! !start /b cap_vim_turnoff.ahk  
endif
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=orange ""magenta
  elseif a:mode == 'r'
    hi statusline guibg=lightred
  else
    hi statusline guibg=red
  endif
endfunction
function! File_size(f)
  let l:size = getfsize(expand(a:f))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    return l:size.' bytes'
  elseif l:size < 1024*1024
    return printf('%.1f', l:size/1024.0).'k'
  elseif l:size < 1024*1024*1024
    return printf('%.1f', l:size/1024.0/1024.0) . 'm'
  else
    return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
  endif
endfunction
"}}}
"< 寄存器和session配置 >  {{{
"用于将所有内容复制到系统剪切板，在离开[Clip Board]时
augroup vimrc
  autocmd VimLeavePre \[Clip*Board\] :%y+
augroup end
""command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
""autocmd VimLeavePre * WipeReg
""vim退出时不保存buff
""set viminfo -=%
""set sessionoptions=winpos
""au VimLeave * mksession! $HOME\session.vim
""au VimEnter * silent source $HOME\session.vim
"}}}
"< 自定义键盘命令 >{{{
nnoremap <leader>w :silent w<cr>
nnoremap <f6> :set wrap!<cr>:echo "[".strftime("%H:%M:%S")."] set wrap!"<cr>

nnoremap <C-A> ggVG "映射全选+复制 ctrl+a
"复制当前行到系统剪切板
nnoremap <A-d> :let @*=getline('.')<cr>:echo 'Copy current line:['.line('.').']'<cr>
nnoremap <F4> :close<CR>
nnoremap <A-F4> :confirm q<CR>

" Moving around, tabs and buffers
" Map space to / (search) and c-space to ? (backgwards search)
nnoremap <A-space> <PageUp><cr>
nnoremap <space> <PageDown><cr>
"map hlsearch Toggle
nnoremap <leader><cr> :set hlsearch!<cr>
" Smart way to move btw. windows
"nnoremap <C-j> <C-W>j                  "移动到上边的窗口
"nnoremap <C-k> <C-W>k                  "移动到下边的窗口
"nnoremap <C-h> <C-W>h                  
"nnoremap <C-l> <C-W>l                 
nnoremap <C-up> <C-W>+<C-W>+           "调整分割窗口大小
nnoremap <C-down> <C-W>-               "调整分割窗口大小
nnoremap <C-left> <C-W>><C-W>>         "调整分割窗口大小
nnoremap <C-right> <C-W><              "调整分割窗口大小

"nnoremap <leader>c :bdelete<cr>
nnoremap <leader>n :rightbelow vnew! temp<cr>

""Quickly move current line
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
""Quickly add empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
if g:isGUI
  ""Quickly change font size in GUI,only for gui vim
  command! BiggerFont  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! SmallerFont :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
endif
"自定义搜索
""set hlsearch
"即时搜索
set incsearch
set magic                   " 设置魔术
" 当输入查找命令时，再启用高亮
"noremap n :set hlsearch<cr>n
"noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?
noremap * *:set hlsearch<cr>
"N n相关映射在IndexedSearch插件中定义了
""Saner behavior of n and N
"nnoremap <expr> n  'Nn'[v:searchforward]
"nnoremap <expr> N  'nN'[v:searchforward]
"nnoremap <expr> n  ':set hlsearch<cr>'.'Nn'[v:searchforward].'zvzz'
"nnoremap <expr> N  ':set hlsearch<cr>'.'nN'[v:searchforward].'zvzz'

nnoremap gg  ggzv
nnoremap G   Gzv
xnoremap <  <gv
xnoremap >  >gv
"visual select刚修改或复制的文本
" '[ To the first character of the previously changed or yanked text. {not in Vi} 
" '] To the last character of the previously changed or yanked text. {not in Vi} 
nnoremap gp `[v`]
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab && Buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>tn :tabnew!<cr>
nnoremap <leader>v :vsplit<cr> 
nnoremap <leader>s :split<cr>
nnoremap <A-l> :bnext<cr>
nnoremap <A-h> :bpre<cr>
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""alt+n切换Vim的标签页
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 让gvim支持Alt+n来切换标签页
function! Tabmap_Initialize()
  for i in range(1, 9)
    exe "nnoremap <A-".i."> ".i."gt"
  endfor
  exe "nnoremap <A-0> 10gt"
endfunction
augroup vimrc
autocmd VimEnter * call Tabmap_Initialize()
augroup end
"快速编辑录制的宏，默认编辑寄存器”，可以指定寄存器
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
"快捷输入时间
inoremap <silent> <c-g><c-t>  <c-r>=repeat(complete(col('.'), map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<cr>
"}}}
"" < 高级搜索 >{{{
""修改了copymatchs.vim的内容
""搜索最近的模式，然后分割一个窗口，将结果放到新窗口
nnoremap  <F5>  :CopyLines -<CR> 
nnoremap  <S-F5>  :CopyLines! -<CR> 
nnoremap  <C-F5>  :CopyMatches -<CR> 
nnoremap  <C-S-F5> :let @/='^\s\{0,5}\w\{0,5}map'<CR>:CopyLines -<CR> "在_vimrc中搜索键盘映射命令
"}}}
"< 不同文件类型的个性化设置 >{{{
augroup vimrc
autocmd VimEnter \[Clip*Board\] setlocal wrap|nnoremap j gj|nnoremap k gk
autocmd BufRead,BufNewFile *.txt setlocal ft=txt wrap linespace=4 |nnoremap j gj|nnoremap k gk|let g:indentLine_enabled=0
autocmd BufRead,BufNewFile rfc*.txt setlocal ft=txt wrap linespace=4 |nnoremap j gj|nnoremap k gk|let @c='^\s*\d\..*$'
autocmd BufRead,BufNewFile *.log  setlocal ft=log 
autocmd BufRead,BufNewFile *.py,*.pyw  setlocal nobomb foldenable foldmethod=indent fileformat=unix| ToggleCompletePairs
autocmd BufRead,BufNewFile *.ahk setlocal foldenable foldmethod=indent bomb 
autocmd BufRead,BufNewFile *.json setlocal foldenable foldmethod=indent filetype=JAVASCRIPT 
autocmd BufRead,BufNewFile *.bat,*.cmd setlocal fileencoding=gbk fileformat=dos  bomb  
augroup end
"}}}
"< 恢复上次退出时的窗口大小和位置 >{{{
"if g:isGUI
"  function! ScreenFilename()
"    if has('amiga')
"      return "s:.vimsize"
"    elseif g:iswindows
"      return $HOME.'\_vimsize'
"    else
"      return $HOME.'/.vimsize'
"    endif
"  endfunction
"
"  function! ScreenRestore()
"    " Restore window size (columns and lines) and position
"    " from values stored in vimsize file.
"    " Must set font first so columns and lines are based on font size.
"    let f = ScreenFilename()
"    if g:isGUI && g:screen_size_restore_pos && filereadable(f)
"      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
"      for line in readfile(f)
"        let sizepos = split(line)
"        if len(sizepos) == 5 && sizepos[0] == vim_instance
"          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
"          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
"          return
"        endif
"      endfor
"    endif
"  endfunction
"
"  function! ScreenSave()
"    " Save window size and position.
"    if g:isGUI && g:screen_size_restore_pos
"      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
"      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
"            \ (getwinposx()<0?0:getwinposx()) . ' ' .
"            \ (getwinposy()<0?0:getwinposy())
"      let f = ScreenFilename()
"      if filereadable(f)
"        let lines = readfile(f)
"        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
"        call add(lines, data)
"      else
"        let lines = [data]
"      endif
"      call writefile(lines, f)
"    endif
"  endfunction
"
"  if !exists('g:screen_size_restore_pos')
"    let g:screen_size_restore_pos = 1
"  endif
"  if !exists('g:screen_size_by_vim_instance')
"    let g:screen_size_by_vim_instance = 1
"  endif
"  augroup WinPosSave
"  autocmd!
"  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
"  autocmd VimLeavePre,vimResized * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
"  augroup end
"endif
"}}}
"< F9一键编译 >{{{ 
"对于脚本，如果要带参数运行，请使用p寄存器
"let @p="-t file"       
nnoremap <F9> :call CompileRun()<CR>
inoremap <F9> <esc>:call CompileRun()<CR>
func! CompileRun()
  if &filetype != 'vim'
    exec "silent w"
  endif
  if &filetype == 'vim'
    "利用timer的异步机制，延时保存vim文件。可以避免_vimrc等文件立即保存时，因本函数正在执行而报错。
    let VimDelaySaveTimer = timer_start(5, 'SaveVimFile',{'repeat':1})
  elseif &filetype == 'dosbatch'
    exec "silent !start cmd /c % ".@p
    echo "Saved and Run ".@%." ,option:".@p
  elseif &filetype == 'autohotkey'
    exec "silent! !start /b % ".@p
    echo "Saved and Reload ".@%." ,option:".@p
  elseif &filetype == 'sh'
    :!bash %
  elseif &filetype == 'python'
    if expand("%:e") =="py"
      exec "silent !start python % ".@p
    elseif expand("%:e") =="pyw"
      exec "silent !start pythonw % ".@p
    else
      echo "Warn:file type error!"
    endif
    echo "Saved and Run ".@%." ,option:".@p
  elseif &filetype == 'html'
    exec "silent! !start /b % ".@p
    echo "Saved and open ".@%." ,option:".@p
  elseif &filetype == 'txt'
    "在syntax/2html.vim中，修改font-size: 1em为1.2em,增加显示字体大小
    let a:cls=g:colors_name
    "exec "colorscheme eclipse"
    exec "set nonumber" 
    exec ":silent %TOhtml" 
    exec ":w! ".@%
    exec "silent! !start /b %"
    exec "silent close"
    exec "set number" 
    exec "colorscheme ".a:cls
  elseif &filetype == 'markdown'
    let a:codeSetting="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
    let a:fileLine1=getline(1)
    if a:codeSetting != a:fileLine1
      let fail=append(0,a:codeSetting)
      exec "silent w"
    endif
    let a:MyFileName=expand("%:t:r")
    exec "silent! !start /b markdown_py.bat % "." -f ".a:MyFileName.".html ".@p." &&".a:MyFileName.".html"
    echo "Saved and open ".@%." ,option:".@p
  else
    echo "Filetype " &filetype
  endif
endfunc
func! SaveVimFile(VimDelaySaveTimer)
  silent :w
  echom "Saved and sourced ".@%." ,option:".@p
endfunc
"}}}
"< 调用浏览器打开网址  >{{{
" Evoke a web browser
if g:iswindows
  function! Browser ()
    let a:line0 = getline (".")
    let a:line = matchstr (a:line0, "http[^ ]*")
    if a:line==""
      let a:line = matchstr (a:line0, "ftp[^ ]*")
    endif
    if a:line==""
      let a:line = matchstr (a:line0, "file[^ ]*")
    endif
    let a:line = escape (a:line, "#?&;|%")
    ":if line==""
    " let line = "\"" . (expand("%:p")) . "\""
    ":endif
    if a:line !=""
      if g:iswindows
        exec ":silent! !start /min explorer " .  a:line 
      endif
    else
      echo a:line
    endif
  endfunction
  nnoremap <leader>K :call Browser ()<CR>
endif
"}}}
"< 禁用默认插件库中不常用的插件  >{{{
"let g:loaded_2html_plugin = 1	
let g:loaded_getscriptPlugin = 1	
let g:loaded_gzip = 1	
let g:loaded_logipat = 1	
let g:loaded_matchparen = 1	
"let g:loaded_netrwPlugin = 1	
let g:loaded_rrhelper = 1	
let g:loaded_spellfile_plugin = 1	
let g:loaded_tarPlugin = 1	
let g:loaded_vimballPlugin = 1	
let g:loaded_zipPlugin = 1	
"}}}
"< _vimrc配置> {{{
filetype indent plugin on
" vim 文件折叠方式为 marker
augroup ft_vim
  au!
  au BufEnter *vimrc  setlocal foldmethod=marker
  if g:iswindows
    " Fast editing of the .vimrc
    nnoremap <leader>e :tabnew $myvimrc<cr>
    ""修改_virmrc文件自动保存
    augroup vimrc
    :silent autocmd! bufwritepost _vimrc source $myvimrc
    :silent autocmd! BufWritePre *.vim,*vimrc setlocal fileformat=unix
    augroup end
  else
    " Fast editing of the .vimrc
    if filereadable(expand("$VIM")."/vimrc")
      nnoremap <leader>e :e! $VIM/vimrc<cr>
      augroup vimrc
        " When vimrc is edited, reload it
        autocmd! bufwritepost vimrc source $VIM/vimrc
      augroup end
    elseif filereadable(expand("$HOME")."/.vimrc")
      nnoremap <leader>e :e! $HOME/.vimrc<cr>
      augroup vimrc
        " When vimrc is edited, reload it
        autocmd! bufwritepost .vimrc source $HOME/.vimrc
      augroup end
    elseif filereadable(expand("~")."/.vim/vimrc")
      nnoremap <leader>e :e! ~/.vim/vimrc<cr>
      augroup vimrc
        " When vimrc is edited, reload it
        autocmd! bufwritepost *.vimrc source ~/.vim/vimrc
      augroup end
    endif
  endif
augroup end
" }}}
"<进入v模式时显示侧滑块；无按键一段时间后自动隐藏> {{{
"由于隐藏滑块时整个界面会重绘，导致闪动，不用这个功能了。
"let &stl.='%{RedrawStatuslineColors(mode())}'
""利用更换模式时，重绘statusline来启动侧边滑块
"function! RedrawStatuslineColors(mode)
"    if a:mode == 'v' 
"      set guioptions+=r
"    endif
"endfunction
"autocmd cursorhold * set guioptions-=r
"}}}
"<格式化Json源码> {{{
command! JsonFormat :execute '%!python -m json.tool'
\ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
\ | :setlocal ft=javascript
\ | :setlocal foldmethod=indent
\ | :1
"}}}
"                          << 以下为常用插件配置 >>
"  < gvimfullscreen 工具配置 > 请确保已安装了工具 {{{
"""  < vimtweak 工具配置 > 请确保以已装了工具:
"""gvimfullscreen.x86.dll gvimfullscreen.x64.dll需要放入系统path目录中才能找到，我放在d:\Program Files\Vim\vimfiles\
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
  nnoremap <C-F11> :call FullScreendllCall("ToggleFullScreen", 0)<CR>
  func! FullScreendllCall(para,transprent)
    if g:iswindows64
      call libcallnr($vim."//vimfiles//gvimfullscreen.x64.dll",a:para,a:transprent)
    elseif g:iswindows
      call libcallnr($vim."//vimfiles//gvimfullscreen.x86.dll",a:para,a:transprent)
    endif
  endfunction
endif
"}}}
"  < vimtweak 工具配置 > 请确保以已装了工具 {{{
"""vimtweak.x86.dll vimtweak.x64.dll需要放入系统path目录中才能找到，我放在d:\Program Files\Vim\vimfiles\
""" 这里只用于窗口透明与置顶
""" 常规模式下 Ctrl + Up（上方向键） 增加不透明度，Ctrl + Down（下方向键） 减少不透明度，<Leader>t 窗口置顶与否切换
if (g:iswindows && g:isGUI)
  let g:Current_Alpha = 245
  let g:Top_Most = 0
  func! Alpha_add()
    let g:Current_Alpha = g:Current_Alpha + 10
    if g:Current_Alpha > 255
      let g:Current_Alpha = 255
    endif
    call TweakLibCall("SetAlpha",g:Current_Alpha)
    echo g:Current_Alpha
  endfunc
  func! Alpha_sub()
    let g:Current_Alpha = g:Current_Alpha - 4
    if g:Current_Alpha < 155
      let g:Current_Alpha = 155
    endif
    call TweakLibCall("SetAlpha",g:Current_Alpha)
    echo g:Current_Alpha
  endfunc
  func! TweakLibCall(para,transprent)
    "echo "func para :" a:para a:transprent
    if g:iswindows64
      "echo "win64"
      call libcallnr($vim."//vimfiles//vimtweak.x64.dll",a:para,a:transprent)
    elseif g:iswindows
      call libcallnr($vim."//vimfiles//vimtweak.x86.dll",a:para,a:transprent)
    endif
  endfunction
  func! Top_window()
    if  g:Top_Most == 0
      call TweakLibCall("EnableTopMost",1)
      let g:Top_Most = 1
    else
      call TweakLibCall("EnableTopMost",0)
      let g:Top_Most = 0
    endif
  endfunc
  augroup Transparent
    autocmd GUIEnter * call TweakLibCall("SetAlpha",240)
    autocmd FocusLost * call TweakLibCall("SetAlpha",180)
    autocmd FocusGained	 * call TweakLibCall("SetAlpha",g:Current_Alpha)
  augroup end
  "快捷键设置
  nnoremap <A-up> :call Alpha_add()<CR>
  nnoremap <A-down> :call Alpha_sub()<CR>
  ""nnoremap <leader>t :call Top_window()<CR>
endif

"}}}
"  < AsyncRun插件配置 > {{{
"https://github.com/skywind3000/asyncrun.vim
"wget --no-check-certificate https://codeload.github.com/skywind3000/asyncrun.vim/zip/master
let g:asyncrun_bell =2  "运行完成之后提示音
let g:asyncrun_encs = 'gbk' "解决中文乱码问题
let g:asyncrun_encs = 'utf-8' "解决中文乱码问题
"}}}
"  < uodotree插件配置 > {{{
"  https://github.com/mbbill/undotree
" wget --no-check-certificate https://codeload.github.com/mbbill/undotree/zip/master
nnoremap <F3> :UndotreeToggle<cr>
if has("persistent_undo")
  if g:iswindows
    set undodir=$HOME\.vimundofile\
  elseif g:islinux
    set undodir=$HOME/.vimundofile/
  endif
  if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
  endif
  set undofile
endif
"}}}
"  < IndentLine插件配置 >{{{
" https://github.com/Yggdroot/indentLine
let g:indentLine_color_gui = '#A4E57E'
let g:loaded_indentLine=0
let g:indentLine_enabled=1
let g:indentLine_color_term = 239
let g:indentLine_char="┆"
"}}}
"  < MyNote插件配置 >{{{
function! MyNote()
setlocal nonumber lines=16 columns=50                          "指定窗口大小，lines为高度，columns为宽度
winpos 835 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
colorscheme molokai  
call Top_window()
endfunction
augroup vimrc
  autocmd VimEnter MyNote.txt call MyNote()
augroup end
  augroup vimrc  
    autocmd InsertEnter * set listchars-=trail:⣿
    autocmd InsertLeave * set listchars+=trail:⣿
  augroup end
" }}}
"  <  Backup配置 >{{{
" 使用cbackup插件进行管理，以下配置不用了
" cbackup管理最近的10个修改备份文件
"set writebackup                             "保存文件前建立备份，保存成功后删除该备份
""set nobackup                                "设置无备份文件
"set backup
"" 设置backup dir
"if g:iswindows
""  set backupdir=$home\.vimbak
"elseif g:islinux 
"  set backupdir=$HOME/.vim/backup
"endif
"if !isdirectory(&backupdir)
"  call mkdir(&backupdir, "p")
"endif
""" 设置backup file后缀
"au BufWritePre * call InitBex()
"fun! InitBex()
" execute "silent set backupext=_". strftime("%y%m%d_%H%M") . ".bak"
"endfun

" }}}
"  <  terminal配置 >{{{
if has('terminal')
nnoremap <leader>tt :call Open_terminal_win()<CR>
function! Open_terminal_win()
  :below vnew terminal
  :terminal ++curwin 
  tnoremap <Esc> <C-W>N
  set notimeout ttimeout timeoutlen=100
  augroup vimrc
    au BufWinEnter * if &buftype == 'terminal' | setlocal bufhidden=hide | endif
  augroup end
endfunction

endif


" }}}
