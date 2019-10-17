" Version:      1.0

if exists('g:loaded_mymenu1') || &compatible
  finish
else
  let g:loaded_mymenu1 = 'yes'
endif


" vim-venu: depend Plug 'Timoses/vim-venu' {{{1
    let s:menu1 = venu#create('My first V̂enu')
    call venu#addItem(s:menu1, 'Item of first menu', 'echo "Called first item"')
    call venu#register(s:menu1)

    function! s:myfunction() abort
        echo "I called myfunction"
    endfunction

    let s:menu2 = venu#create('My second V̂enu')
    call venu#addItem(s:menu2, 'Call a function ref', function("s:myfunction"))

    let s:submenu = venu#create('My awesome subV̂enu')
    call venu#addItem(s:submenu, 'Item 1', ':echo "First item of submenu!"')
    call venu#addItem(s:submenu, 'Item 2', ':echo "Second item of submenu!"')

    " Add the submenu to the second menu
    call venu#addItem(s:menu2, 'Sub menu', s:submenu)
    call venu#register(s:menu2)
"}}}

" Quickmenu & KeyMap: depend Plug 'daniel-samson/quickmenu.vim' {{{1
    noremap <silent><F1> :call quickmenu#toggle(0)<cr>
    "noremap <silent><F1> :call quickmenu#bottom(0)<cr>

    "noremap <silent> <leader><space> :call quickmenu#bottom(0)<cr>
    "noremap <silent> <leader>1 :call quickmenu#bottom(1)<cr>

    function MyMenuExec(...)
        let strCmd = join(a:000, '')
        silent! call s:log.info('MyExecArgs: "', strCmd, '"')
        exec strCmd
    endfunc

    " enable cursorline (L) and cmdline help (H)
    let g:quickmenu_options = ""
    "call quickmenu#header("Helper")
    " Clear all the items
    call quickmenu#reset()

    " Section 'Execute'
        nnoremap <leader>mk :Make -i -s -j6 -C daemon/wad <CR>
        nnoremap <leader>ma :Make -i -s -j6 -C sysinit <CR>

    " new section: empty action with text starts with "#" represent a new section
    call quickmenu#append("# Execute", '')
        "call quickmenu#append(text="Run %{expand('%:t')}", action='!./%', help="Run current file", ft="c,cpp,objc,objcpp")
        call quickmenu#append("Update TAGs",          "NeomakeSh! tagme", "")
        call quickmenu#append("Run %{expand('%:t')}", '!./%', "Run current file")
        call quickmenu#append("(ma) make init",       "Make -j6 -i -s  -C sysinit", "")
        call quickmenu#append("(mk) make wad",        "Make -i -s -j6 -C daemon/wad", "")


    call quickmenu#append("# View", '')
        call quickmenu#append("Outline",   'VoomToggle markdown',  "use fugitive's Gvdiff on current document")
        call quickmenu#append("Maximizer", 'MaximizerToggle',  "use fugitive's Gvdiff on current document")
        call quickmenu#append("NERDTree",  'NERDTreeTabsToggle',  "use fugitive's Gvdiff on current document")
        call quickmenu#append("TagBar",    "TagbarToggle", "Switch Tagbar on/off")

    " Section 'Git'
        "nnoremap <leader>bb :VCBlame<cr>
        nnoremap <leader>bb :Gblame<cr>
        nnoremap <leader>bl :GV

    call quickmenu#append("# Git", '')
        call quickmenu#append("git diff",   'Gvdiff',  "use fugitive's Gvdiff on current document")
        call quickmenu#append("git status", 'Gstatus', "use fugitive's Gstatus on current document")
        call quickmenu#append("git blame",  'Gblame',  "use fugitive's Gblame on current document")

    " Section 'String'
        "map <leader>ds :call Asm() <CR>
        nnoremap <leader>df :%s/\s\+$//g
        nnoremap <leader>dd :g/<C-R><C-w>/ norm dd
        vnoremap <leader>dd :<c-u>g/<C-R>*/ norm dd
        " For local replace
        "nnoremap <leader>vm [[ma%mb:call signature#sign#Refresh(1) <CR>
        nnoremap <leader>vr :<C-\>e SelectedReplace()<CR><left><left><left>
        vnoremap <leader>vr :<C-\>e SelectedReplace()<CR><left><left><left>
        " remove space from emptyline
        "nnoremap <leader>v<space> :%s/^\s\s*$//<CR>
        "vnoremap <leader>v<space> :s/^\s\s*$//<cr>

        " count the number of occurrences of a word
        "nnoremap <leader>vc :%s/<C-R>=expand('<cword>')<cr>//gn<cr>

        " For global replace
        nnoremap <leader>vR gD:%s/<C-R>///g<left><left>
        "
        "nnoremap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <cr>
        "vnoremap <leader>vr ""y:%s/<C-R>=escape(@", '/\')<CR>/<C-R>=escape(@", '/\')<CR>/g<Left><Left>
        "
        "vnoremap <leader>vr :<C-\>e tmp#CurrentReplace() <CR>
        "nnoremap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <cr>

    call quickmenu#append("# String", '')
        call quickmenu#append("Replace last search",                        "execute '%s///gc'", "")
        call quickmenu#append("Replace search with `%{expand('<cword>')}`", 'call MyMenuExec("%s//", expand("<cword>"), "/gc")', "")
        call quickmenu#append("Replace last search",                        "execute '%s///gc'", "")
        call quickmenu#append("Remove empty lines",                         "g/^$/d", "delete blank lines, remove multi blank line")
        call quickmenu#append("Remove extra empty lines",                   "%s/\\n\\{3,}/\\r\\r/e", "replace three or more consecutive line endings with two line endings (a single blank line)")
        call quickmenu#append("(df) Remove ending space",                   "%s/\\s\\+$//g", "remove unwanted whitespace from line end")
        call quickmenu#append("(dd) Remove lines of last search",           "g//norm dd", '')

    " Section 'Misc'
    call quickmenu#append("# Misc", '')
        "call quickmenu#append("Turn paste %{&paste? 'off':'on'}",           "set paste!", "enable/disable paste mode (:set paste!)")
        "call quickmenu#append("Turn spell %{&spell? 'off':'on'}",           "set spell!", "enable/disable spell check (:set spell!)")
        call quickmenu#append("Count of selected",            "g Ctrl-G", "Show the number of lines, words and bytes selected")
        call quickmenu#append("Count `%{expand('<cword>')}`", 'call MyMenuExec("%s/", expand("<cword>"), "//gn")', '')
        call quickmenu#append("Convert number",               "normal gA", "")

"}}}

