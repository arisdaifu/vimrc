"gvim plugin for highlighting hex codes to help with tweaking colors
"description
"This plugin looks for hex codes of the format #ffffff or #fff and toggles a highlight in that color. It is useful for editing colorschemes, and generally any config file dealing with colors. 
"Only works with the graphical version of vim.
"Last Change: 2010 Jan 21
"Maintainer: Yuri Feldman <feldman.yuri1@gmail.com>
"License: WTFPL - Do What The Fuck You Want To Public License.
"Email me if you'd like.
let s:HexColored = 0
let s:HexColors = []

map <Leader><F2> :call HexHighlight()<Return>
function! HexHighlight()
    if has("gui_running")
        if s:HexColored == 0
            let hexGroup = 4
            let lineNumber = 0
            while lineNumber <= line("$")
                let currentLine = getline(lineNumber)
                let hexLineMatch = 1
                while match(currentLine, '#\x\{6}', 0, hexLineMatch) != -1
                    let hexMatch = matchstr(currentLine, '#\x\{6}', 0, hexLineMatch)
                    exe 'hi hexColor'.hexGroup.' guifg='.hexMatch.' guibg='.hexMatch
                    exe 'let m = matchadd("hexColor'.hexGroup.'", "'.hexMatch.'", 25, '.hexGroup.')'
                    let s:HexColors += ['hexColor'.hexGroup]
                    let hexGroup += 1
                    let hexLineMatch += 1
                endwhile
                let lineNumber += 1
            endwhile
            unlet lineNumber hexGroup
            let s:HexColored = 1
            echo "Highlighting hex colors..."
        elseif s:HexColored == 1
            for hexColor in s:HexColors
                exe 'highlight clear '.hexColor
            endfor
            call clearmatches()
            let s:HexColored = 0
            echo "Unhighlighting hex colors..."
        endif
    else
        echo "hexHighlight only works with a graphical version of vim"
    endif
endfunction
