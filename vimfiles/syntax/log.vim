" Vim universal .log syntax file
" Language:     log 1.2
" Maintainer:   Tomasz Kalkosiński <spoonman@op.pl>
" Last change:  3 Jan 2007
"
" This is an universal syntax script for all text documents, logs, changelogs, readmes
" and all other strange and undetected filetypes.
" The goal is to keep it very simple. It colors numbers, operators, signs,
" cites, brackets, delimiters, comments, TODOs, errors, debug, changelog tags
" and basic smileys ;]
"
" Changelog:
" 1.2 (03-01-2007)
"                       Add: Changelog tags: add, chg, fix, rem, del linked with Keyword
"                       Add: note to logTodo group
"
" 1.1 (01-07-2006)	Add: International cites
" 			Chg: logString color to Normal
"	 		Chg: Simplified number coloring working better now
"
" 1.0 (28-04-2006)	Initial upload
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn cluster logAlwaysContains add=logTodo,logError

syn cluster logContains add=logNumber,logOperator,logLink

syn match logOperator "[~\-_+*<>\[\]{}=|#@$%&\\/:&\^\.,!?]"

" Common strings
syn match logString "[[:alpha:]]" contains=logOperator

" Numbers
"syn match logNumber "\d\(\.\d\+\)\?"
syn match logNumber "\d"

" Cites
syn region logCite      matchgroup=logOperator  start="\""      end="\""        contains=@logContains,@logAlwaysContains

" utf8 international cites:
" ‚ ’   U+201A (8218), U+2019 (8217)    Polish single quotation
" „ ”   U+201E (8222), U+201d (8221)    Polish double quotation
" « »   U+00AB (171),  U+00BB (187)     French quotes
" ‘ ’   U+2018 (8216), U+2019 (8217)    British quotes
" „ “   U+201E (8222), U+2019 (8217)    German quotes
" ‹ ›   U+2039 (8249), U+203A (8250)    French quotes
syn region logCite      matchgroup=logOperator  start="[‚„«‘„‹]"        end="[’”»’“›]"  contains=@logContains,@logAlwaysContains

syn region logCite      matchgroup=logOperator  start="\(\s\|^\)\@<='"  end="'"         contains=@logContains,@logAlwaysContains

" Comments
syn region logComment   start="("       end=")"         contains=@logContains,logCite,@logAlwaysContains
syn region logComments  matchgroup=logComments start="\/\/"     end="$"         contains=@logAlwaysContains     oneline
syn region logComments  start="\/\*"    end="\*\/"      contains=@logAlwaysContains

syn region logDelims    matchgroup=logOperator start="<"        end=">"         contains=@logContains,@logAlwaysContains oneline
syn region logDelims    matchgroup=logOperator start="{"        end="}"         contains=@logContains,@logAlwaysContains oneline
syn region logDelims    matchgroup=logOperator start="\["       end="\]"                contains=@logContains,@logAlwaysContains oneline 

syn match logLink       "\(http\|https\|ftp\)\(\w\|[\-&=,?\:\.\/]\)*"   contains=logOperator

" Basic smileys
syn match logSmile      "[:;=8][\-]\?\([(\/\\)\[\]]\+\|[OoPpDdFf]\+\)"

" Changelog tags: add, chg, rem, fix
syn match logChangelogs         "\<add\>\s*:" contains=logOperator
syn match logChangelogs         "\<chg\>\s*:" contains=logOperator
syn match logChangelogs         "\<rem\>\s*:" contains=logOperator
syn match logChangelogs         "\<del\>\s*:" contains=logOperator
syn match logChangelogs         "\<fix\>\s*:" contains=logOperator

syn keyword logTodo todo fixme xxx note

syn keyword logError error bug

syn keyword logDebug debug

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
  if version < 508
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink logNumber              Number
  HiLink logString              Normal
  HiLink logOperator            Operator
  HiLink logCite                String
  HiLink logComments            Comment
  HiLink logComment             Comment
  HiLink logDelims              Delimiter
  HiLink logLink                Special
  HiLink logSmile               PreProc
  HiLink logError               Error
  HiLink logTodo                Todo
  HiLink logDebug               Debug
  HiLink logChangelogs          Keyword

  delcommand HiLink

let b:current_syntax = "log"
" vim: ts=8
