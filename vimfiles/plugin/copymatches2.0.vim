" Plugin to copy matches (search hits which may be multiline).
" Version 2012-05-03 from http://vim.wikia.com/wiki/VimTip478
"
" :CopyMatches      copy matches to clipboard (each match has newline added)
" :CopyMatches x    copy matches to register x
" :CopyMatches X    append matches to register x
" :CopyMatches -    display matches in a scratch buffer (does not copy)
" :CopyMatches pat  (after any of above options) use 'pat' as search pattern
" :CopyMatches!     (with any of above options) insert line numbers
" Same options work with the :CopyLines command (which copies whole lines).

" Jump to first scratch window visible in current tab, or create it.
" This is useful to accumulate results from successive operations.
" Global function that can be called from other scripts.

" Append match, with line number as prefix if wanted.
function! s:Matcher(hits, match, linenums, subline)
  if !empty(a:match)
    let prefix = a:linenums ? printf('%3d  ', a:subline) : ''
    "[note]：修改，加入了行号
    call add(a:hits,[a:subline, prefix . a:match])
  endif
  return a:match
endfunction

" Append line numbers for lines in match to given list.
function! s:MatchLineNums(numlist, match)
  let newlinecount = len(substitute(a:match, '\n\@!.', '', 'g'))
  if a:match =~ "\n$"
    let newlinecount -= 1  " do not copy next line after newline
  endif
  call extend(a:numlist, range(line('.'), line('.') + newlinecount))
  return a:match
endfunction

" Return list of matches for given pattern in given range.
" If 'wholelines' is 1, whole lines containing a match are returned.
" This works with multiline matches.
" Work on a copy of buffer so unforeseen problems don't change it.
" Global function that can be called from other scripts.
function! GetMatches(line1, line2, pattern, wholelines, linenums)
  let savelz = &lazyredraw
  set lazyredraw
  let lines = getline(1, line('$'))
  new
  setlocal buftype=nofile bufhidden=delete noswapfile
  silent put =lines
  1d
  let hits = []
  let sub = a:line1 . ',' . a:line2 . 's/' . escape(a:pattern, '/')
  if a:wholelines
    let numlist = []  " numbers of lines containing a match
    let rep = '/\=s:MatchLineNums(numlist, submatch(0))/e'
  else
    let rep = '/\=s:Matcher(hits, submatch(0), a:linenums, line("."))/e'
  endif
  silent execute sub . rep . (&gdefault ? '' : 'g')
  close
  if a:wholelines
    let last = 0  " number of last copied line, to skip duplicates
    for lnum in numlist
      if lnum > last
        let last = lnum
        let prefix = a:linenums ? printf('%3d  ', lnum) : ''
        "[note]：修改，加入了行号
        call add(hits, [lnum, prefix . getline(lnum)])
      endif
    endfor
  endif
  let &lazyredraw = savelz
  return hits
endfunction

" Copy search matches to a register or a scratch buffer.
" If 'wholelines' is 1, whole lines containing a match are returned.
" Works with multiline matches. Works with a range (default is whole file).
" Search pattern is given in argument, or is the last-used search pattern.
function! s:CopyMatches(bang, line1, line2, args, wholelines)
  "如果焦点在搜索结果窗口，则退出，什么也不做
  if bufname("%")=="SearchSideBar"
    :close
    return
  endif
  let l = matchlist(a:args, '^\%(\([a-zA-Z"*+-]\)\%($\|\s\+\)\)\?\(.*\)')
  let reg = empty(l[1]) ? '+' : l[1]
  let pattern = empty(l[2]) ? @/ : l[2]
  let s:hits = GetMatches(a:line1, a:line2, pattern, a:wholelines, a:bang)
  let msg = 'No non-empty matches'
  if !empty(s:hits)
    if reg == '-'
      if Mybuffer_find("SearchSideBar") < 0 
        let SideBarWidth=&columns/4
        exe 'silent vertical belowright'.SideBarWidth. 'new SearchSideBar'
        setlocal nonumber
        setlocal nowrap 
        setlocal statusline=[AdvanceSearch] 
        "不扫描当前缓冲区的任何内容，不自动补全。
        setlocal complete=
        """Now map enter to Jump to line noly works on this buffer
        map <buffer> <cr> :call SearchJumpLine()<cr>
        map <buffer> <RightMouse> :call SearchJumpLine()<cr>
      endif
     call s:SearchWinPrint(0) 
    else
      "execute 'let @' . reg . ' = join(s:hits, "\n") . "\n"'
      let templist=[]
      for element in s:hits
        "silent put =element[1]
        call add(templist,element[1])
      endfor
      execute 'let @' . reg . ' = join(templist, "\n") . "\n"'
    endif
    let msg = 'Number of matches: ' . len(s:hits)
  endif
  redraw  " so message is seen
  echo msg
endfunction
command! -bang -nargs=? -range=% CopyMatches call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 0)
command! -bang -nargs=? -range=% CopyLines call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 1)
command!  CopyWinLineNumToggle call s:SearchWinPrint(1)
func! SearchJumpLine()
  if bufname("%") != "SearchSideBar" 
    echo "AdvanceSearch windows is not active,exit!"
    return
  endif
  let curline=line('.')
  if curline ==0
    echo "Title row!!"
    return
  endif
  let elementLine=0
  for element in s:hits
    "echo element[1]
    let elementLine=elementLine+len(split(element[1],"\n"))
    "echo elementLine
    if curline <= elementLine
      exe ":normal \<C-W>h"
      exe ":normal".element[0]."G"
      exe ":normal zz"
      exe ":normal \<C-W>l"
      set cursorline
      echo "Jump to :".element[0]
      break
    endif
  endfor
endfunction
"根据buff名称查找window，如果存在就跳转到该window
func! Mybuffer_find(filename)
  let b = bufwinnr(a:filename) " find the window where the buffer is opened
  if b == -1 | return b | endif
  exe b.'wincmd w' 
  "jump to the window found
  return b
endfunction
"在输出窗口打印结果
"默认不打印行号
let g:SearchWinPrintFlag=0
func! s:SearchWinPrint(DesignFlag)
  if Mybuffer_find("SearchSideBar") < 0 
    echo "Execue CopyMatches or CopyLines First!"
    return
  endif
  "指定了不用显示行号
  if a:DesignFlag == 0
    let g:SearchWinPrintFlag = 1
  else
    "根据flag的奇偶特性来toggle是否输出行号
    let g:SearchWinPrintFlag +=1
  endif
  setlocal modifiable
  exec ":normal ggVGd"
  normal! G0m'
  if g:SearchWinPrintFlag%2 ==1 
    for element in s:hits
      silent put =element[1]
    endfor
  else
    for element in s:hits
      let _templine=join(element," ")
      silent put =_templine
    endfor
  endif
  exec ":normal ggdd"
  setlocal nomodifiable
  setlocal buftype="nofile"
  setlocal nomodified
  " Jump to first line of hits and scroll to middle.
  "''+1normal! zz
  return 
endfunction
