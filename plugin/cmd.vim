" Version:      1.0

if exists('g:loaded_local_command') || &compatible
  finish
else
  let g:loaded_local_command = 'yes'
endif


" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
if g:vim_confi_option.auto_restore_cursor
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
endif


let g:previous_window = -1
function SmartInsert()
  if &buftype == 'terminal'
    if g:previous_window != winnr()
      startinsert
    endif
    let g:previous_window = winnr()
  else
    let g:previous_window = -1
  endif
endfunction
au BufEnter * call SmartInsert()


if g:vim_confi_option.auto_qf_height
    " Maximize the window after entering it, be sure to keep the quickfix window
    " at the specified height.
    au WinEnter * call MaximizeAndResizeQuickfix(5)

    " Maximize current window and set the quickfix window to the specified height.
    function MaximizeAndResizeQuickfix(quickfixHeight)
        " Redraw after executing the function.
        set lazyredraw
        " Ignore WinEnter events for now.
        set ei=WinEnter

        "??? Maximize current window.
        "wincmd _

        " If the current window is the quickfix window
        if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix")
            " Maximize previous window, and resize the quickfix window to the
            " specified height.

            " ???
            "wincmd p
            "resize
            "wincmd p

            exe "resize " . a:quickfixHeight
        else
            " Current window isn't the quickfix window, loop over all windows to
            " find it (if it exists...)
            let i = 1
            let currBufNr = winbufnr(i)
            while (currBufNr != -1)
                " If the buffer in window i is the quickfix buffer.
                if (getbufvar(currBufNr, "&buftype") == "quickfix")
                    " Go to the quickfix window, set height to quickfixHeight, and jump to the previous
                    " window.
                    exe i . "wincmd w"
                    exe "resize " . a:quickfixHeight
                    wincmd p
                    break
                endif
                let i = i + 1
                let currBufNr = winbufnr(i)
            endwhile
        endif
        set ei-=WinEnter
        set nolazyredraw
    endfunction


    " function! AdjustWindowHeight(minheight, maxheight)
    "     return
    "     let l = 1
    "     let n_lines = 0
    "     let w_width = winwidth(0)
    "     while l <= line('$')
    "         " number to float for division
    "         let l_len = strlen(getline(l)) + 0.0
    "         let line_width = l_len/w_width
    "         let n_lines += float2nr(ceil(line_width))
    "         let l += 1
    "     endw
    "     let exp_height = max([min([n_lines, a:maxheight]), a:minheight])
    "     if (abs(winheight(0) - exp_height)) > 2
    "         exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
    "     endif
    " endfunction

    " augroup adjustView
    "     autocmd!
    "     au FileType qf call AdjustWindowHeight(2, 10)
    " augroup END
endif

"autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufEnter * if &buftype == 'terminal' | silent! normal A | endif
autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal A | endif

if g:vim_confi_option.upper_keyfixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    "cmap Tabe tabe
endif

" Autocmd {{{2

    " Maximizes the current window if it is not the quickfix window.
    function! SetIndentTabForCfiletype()
        " auto into terminal-mode
        if &buftype == 'quickfix'
            call AdjustWindowHeight(2, 10)
            return
        endif

        let my_ft = &filetype
        if (my_ft == "c" || my_ft == "cpp" || my_ft == "diff" )
            execute ':C8'

            " If logfile reset NonText bright, this will override it.
            "" The 'NonText' highlighting will be used for 'eol', 'extends' and 'precedes'
            "" The 'SpecialKey' for 'nbsp', 'tab' and 'trail'.
            "hi NonText          ctermfg=238
            "hi SpecialKey       ctermfg=238
        elseif (my_ft == 'vimwiki')
            execute ':C0'
        endif
    endfunction

    " Support:
    "   - Plug 'tpope/vim-sensible'
    "   - Note 'tpope/vim-sensible'
    "   - note:readme
    "   - @note readme
    function! s:plug_note_getname(beginwith)
        " |/\zs|	\zs	\zs	anything, sets start of match
        " |/\ze|	\ze	\ze	anything, sets end of match
        "
        " echo matchstr("Plug 'tpope/vim-sensible'", 'Plug\s\+''\zs[^'']\+\ze''\{-\}')
        " echo matchstr("note:z.lua", 'note[.: @]\zs\S\+\ze[\s|$]\{-\}')
        " echo matchstr("'@note:z.lua'", '\([''"]\)\zs.\{-}\ze\1')
        " echo matchstr("@note:nvim", 'note[.: @]\zs.\{-}\ze[\}\]\) ,;''"]\{-\}$')
        "
        " echo matchstr("@note readme", '@note\s\+\zs\w\+\ze[\s|$]\{-\}')
        " echo matchstr("@note z.lua ", '@note\s\+\zs\S\+\ze[\s|$]\{-\}')
        " echo matchstr("@note:z.lua ", '@note\s\+\zs\w\+\ze[\s|$]\{-\}')
        "
        let curline = getline('.')
        let notename = matchstr(curline, a:beginwith. '\s\+''\zs[^'']\+\ze''\{-\}')
        if empty(notename)
            let notename = matchstr(curline, 'note[.: @]\zs.\{-}\ze[\}\]\) ,;''"]\{-\}$')
            if empty(notename) | return "" | endif
        endif

        let items = split(notename, '/')
        if len(items) < 2
          return notename
        else
          return items[1]
        endif
    endfunction

    function! s:plug_note()
        "if &ft ==# 'notes' | q | return | endif

        let name = s:plug_note_getname("Plug")
        if empty(name) | let name = s:plug_note_getname("Note") | endif

        " Forwardto K's handler
        if empty(name) | call feedkeys("K", 'n') | return | endif

        "if has_key(g:plugs, name)
            if CheckPlug('vim-notes', 1)
                if g:notes_dir_order != g:notes_dir_order_type.vim
                    let g:notes_directories = reverse(g:notes_directories)
                endif

                vsp | exec 'Note' name

                if g:notes_dir_order != g:notes_dir_order_type.vim
                    let g:notes_directories = reverse(g:notes_directories)
                endif
            elseif CheckPlug(g:vim_confi_option.plug_note, 1)
                let dir = PlugGetDir(g:vim_confi_option.plug_note)
                exec 'tabe '. dir. 'docs/'. name. '.note'
            else
                for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
                    exec 'tabe' doc
                endfor
            endif
        "endif
    endfunction

    augroup filetype_auto
        " Voom/VOom:
        " <Enter>             selects node the cursor is on and then cycles between Tree and Body.
        " <Tab>               cycles between Tree and Body windows without selecting node.
        " <C-Up>, <C-Down>    move node or a range of sibling nodes Up/Down.
        " <C-Left>, <C-Right> move nodes Left/Right (promote/demote).
        "
        autocmd!

        "autocmd VimLeavePre * cclose | lclose
        autocmd InsertEnter,InsertLeave * set cul!
        " Sometime crack the tag file
        "autocmd BufWritePost,FileWritePost * call RetagFile()

        " current position in jumplist
        autocmd CursorHold * normal! m'
        "autocmd BufEnter term://* startinsert

        "if has('nvim')
        "    "autocmd BufNew,BufEnter term://* startinsert
        "    autocmd BufEnter,BufEnter * if &buftype == 'terminal' | :startinsert | endif
        "endif

        " Always show sign column
        autocmd BufEnter * sign define dummy
        autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

        "ShellCmd like: $ rusty-tags vi --output=".tags"
        "autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/

        " Set filetype base on extension
        autocmd BufNewFile,BufRead *.c.rej,*.c.orig,h.rej,*.h.orig,patch.*,*.diff,*.patch set ft=diff
        autocmd BufNewFile,BufRead *.c,*.c,*.h,*.cpp,*.C,*.CXX,*.CPP set ft=c

        "autocmd BufNewFile,BufRead *.md  setfiletype markdown
        "autocmd BufNewFile,BufRead,BufEnter *.wiki  set ft=markdown    | " Cause vimwiki file navigator keymap fail
        "autocmd FileType vimwiki set syntax=markdown                   | " Please config g:vimwiki_ext2syntax

        autocmd BufWritePre [\,:;'"\]\)\}]* throw 'Forbidden file name: ' . expand('<afile>')

        "autocmd filetype vimwiki  nnoremap <buffer> <a-o> :VoomToggle vimwiki<CR>
        autocmd filetype vimwiki  nnoremap <buffer> <a-'> :VoomToggle markdown<CR>
        "autocmd filetype vimwiki  nnoremap <a-n> :VimwikiMakeDiaryNote<CR>
        "autocmd filetype vimwiki  nnoremap <a-i> :VimwikiDiaryGenerateLinks<CR>

        autocmd filetype markdown nnoremap <buffer> <a-'> :VoomToggle markdown<CR>
        autocmd filetype python   nnoremap <buffer> <a-'> :VoomToggle python<CR>
        autocmd filetype c,cpp    nnoremap <buffer> <a-'> :VoomToggle txt2tags<CR>

        autocmd filetype vim,vimwiki,txt  C0
        "autocmd filetype c,cpp,diff      C8
        "autocmd filetype zsh,bash        C2
        "autocmd filetype vim,markdown    C08

        "autocmd filetype log nnoremap <buffer> <leader>la :call log#filter(expand('%'), 'all')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>le :call log#filter(expand('%'), 'error')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>lf :call log#filter(expand('%'), 'flow')<CR>
        "autocmd filetype log nnoremap <buffer> <leader>lt :call log#filter(expand('%'), 'tcp')<CR>

        " Test
        "nnoremap <silent> <leader>t :<c-u>R <C-R>=printf("python -m doctest -m trace --listfuncs --trackcalls %s \| tee log.test", expand('%:p'))<cr><cr>
        autocmd FileType python nnoremap <buffer> <leader>tt :<c-u>R <C-R>=printf("python -m doctest %s \| tee log.test", expand('%:p'))<cr><cr>
        autocmd FileType python nnoremap <buffer> <leader>tr :<c-u>R <C-R>=printf("python -m trace --trace %s \|  grep %s", expand('%:p'), expand('%'))<cr><cr>

        " :help K  (powerman/vim-plugin-viewdoc)
        if g:vim_confi_option.keywordprg_filetype
            autocmd FileType python setlocal keywordprg=pydoc
            " sudo apt-get install cppman   (https://github.com/aitjcize/cppman)
            autocmd FileType cpp setlocal keywordprg=:te\ cppman
        endif

        if !empty(g:vim_confi_option.plug_note)
           "autocmd FileType vim,zsh,vimwiki,markdown,media nnoremap <buffer> <silent> K :call <sid>plug_note()<cr>

           ""autocmd FileType notes nnoremap <buffer> <silent> K :call <sid>plug_note()<cr>
           ""
           ""command! ShowPlugNote call <sid>plug_note()
           ""autocmd FileType vim setlocal keywordprg=:ShowPlugNote
        endif

    augroup END

"}}}


" Commands {{{2
    command! -nargs=* Wrap set wrap linebreak nolist
    "command! -nargs=* Wrap PencilSoft

    ""command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
    "command! -nargs=+ -bang -complete=shellcmd
    "      \ NeoMake execute ':NeomakeCmd make '. <q-args>

    command! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

    command! -nargs=* C0  setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
    command! -nargs=* C08 setlocal autoindent cindent expandtab   tabstop=8 shiftwidth=2 softtabstop=8
    command! -nargs=* C2  setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
    command! -nargs=* C4  setlocal autoindent cindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
    command! -nargs=* C8  setlocal autoindent cindent noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

    " :R ls -l   grab command output int new buffer
    " :R! ls -l   only show output in another tab
    "command! -nargs=+ -bang -complete=shellcmd R call s:R(<bang>1, <q-args>)
    command! -nargs=+ -bang -complete=shellcmd R execute ':NeomakeRun! '.<q-args>

    "Misc
    command! -bang -nargs=* -complete=file Grep call utilgrep#_Grep('grep<bang>',<q-args>)
    command! -bang -nargs=* -complete=file GrepAdd call utilgrep#_Grep('grepadd<bang>', <q-args>)
    command! -bang -nargs=* -complete=file LGrep call utilgrep#_Grep('lgrep<bang>', <q-args>)
    command! -bang -nargs=* -complete=file LGrepAdd call utilgrep#_Grep('lgrepadd<bang>', <q-args>)
    "command! -bang -nargs=* -complete=file Replace call utilgrep#ReplaceAll(<f-args>)

    "add commas to a number, e.g. change 31415926 to 31,415,926
    "command! Int3 execute ':%s/\(\d\)\(\(\d\d\d\)\+\d\@!\)\@=/\1,/g'
"}}}


if CheckPlug('vim-venu', 1)
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
endif


if CheckPlug('accelerated-jk', 1)
    " Accelerated_jk
    " when wrap, move by virtual row
    "let g:accelerated_jk_enable_deceleration = 1
    let g:accelerated_jk_acceleration_table = [1,2,3]

    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)
    "nmap j <Plug>(accelerated_jk_gj_position)
    "nmap k <Plug>(accelerated_jk_gk_position)
endif


if CheckPlug('vim.config', 1) "{{{1
    " Section 'String'
        "map <leader>ds :call Asm() <CR>
        nnoremap <leader>dt :%s/\s\+$//g
        nnoremap <leader>dd :g/<C-R><C-w>/ norm dd
        vnoremap <leader>dd :<c-u>g/<C-R>*/ norm dd
        " For local replace
        "nnoremap <leader>vm [[ma%mb:call signature#sign#Refresh(1) <CR>
        nnoremap <leader>vr :<C-\>e SelectedReplace('n')<CR><left><left><left>
        vnoremap <leader>vr :<C-\>e SelectedReplace('v')<CR><left><left><left>
        " remove space from emptyline
        "nnoremap <leader>v<space> :%s/^\s\s*$//<CR>
        "vnoremap <leader>v<space> :s/^\s\s*$//<cr>

        " count the number of occurrences of a word
        "nnoremap <leader>vc :%s/<C-R>=expand('<cword>')<cr>//gn<cr>
        nnoremap <leader>vn :%s///gn<cr>
        Shortcut! <space>vn    Tool count

        " For global replace
        nnoremap <leader>vR gD:%s/<C-R>///g<left><left>
        "
        "nnoremap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <cr>
        "vnoremap <leader>vr ""y:%s/<C-R>=escape(@", '/\')<CR>/<C-R>=escape(@", '/\')<CR>/g<Left><Left>
        "
        "vnoremap <leader>vr :<C-\>e tmp#CurrentReplace() <CR>
        "nnoremap <leader>vr :Replace <C-R>=expand('<cword>') <CR> <C-R>=expand('<cword>') <cr>

    " Section 'Execute'
        " Plug : asynctasks.vim : ~/.vim_tasks.ini : wad|sysinit
        nnoremap <leader>mk :AsyncStop! <bar> AsyncTask! wad<CR>
        nnoremap <leader>ma :AsyncStop! <bar> AsyncTask! sysinit<CR>

        nnoremap <leader>mw :R! ~/tools/dict <C-R>=expand('<cword>') <cr>
        nnoremap <leader>mf :call utilquickfix#QuickFixFilter() <CR>
        nnoremap <leader>mc :call utilquickfix#QuickFixFunction() <CR>

        Shortcut! <space>mk    Make wad
        Shortcut! <space>ma    Make init
        Shortcut! <space>mf    QuickFix filter
        Shortcut! <space>mc    QuickFix show caller
        Shortcut! <space>mw    Tool dictionary

    function MyMenuExec(...)
        let strCmd = join(a:000, '')
        silent! call s:log.info('MyExecArgs: "', strCmd, '"')
        exec strCmd
    endfunc

    function! SelectedReplace(mode)
        let l:save_cursor = getcurpos()
        let sel_str = hw#misc#GetWord(a:mode)

        let nr = winnr()
        if getwinvar(nr, '&syntax') == 'qf'
            call setpos('.', l:save_cursor)
            return "%s/\\<". sel_str. '\>/'. sel_str. '/gI'
        else
            delmarks un
            normal [[mu%mn
            call signature#sign#Refresh(1)
            redraw
            return "'u,'ns/\\<". sel_str. '\>/'. sel_str. '/gI'
        endif
    endfunction


    " Check is git repo
    function! YvIsGit()
        silent! !git rev-parse --is-inside-work-tree
        if v:shell_error == 0
            return 1
        endif
    endfunction


    function! TwikiPreview(query, preview)
        let __func__ = "TwikiPreview() "

        if !CheckPlug('fzf.vim', 1) | return | endif

        if a:query ==# 'n'
            silent! call s:log.info(__func__, " from nmap ", a:query)
            let query = utils#GetSelected('n')
        elseif a:query ==# 'v'
            silent! call s:log.info(__func__, " from vmap ", a:query)
            let query = utils#GetSelected('v')
        else
            silent! call s:log.info(__func__, " from N/A ", a:query)
            let query = a:query
        endif

        let char1st = strcharpart(query, 0, 1)
        if char1st !=# '"' && char1st !=# "'"
            let query = "'". query. "'"
        endif

        " Don't use --vimgrep, for it output the same file:line several times
        "   rg -H --no-heading --vimgrep -w
        let cmdStr = "rg -L -H --color never --no-heading --no-column --with-filename --line-number ". query. " $MYPATH_WIKI"
        silent! call s:log.info(__func__, cmdStr)

        call fzf#vim#grep(
                    \   cmdStr, 0,
                    \   a:preview ? fzf#vim#with_preview('up:60%')
                    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
                    \   a:preview)
    endfunction

    nnoremap <silent> <leader>fw    :<c-u>call TwikiPreview(' ', 1)<cr>
    vnoremap <silent> <leader>fw    :<c-u>call TwikiPreview('v', 1)<cr>
    Shortcut! <space>fw    Wiki search, [n]All, [v]Text
endif


if CheckPlug('quickmenu.vim', 1)

    call quickmenu#append("# Format|String", '')
        "call quickmenu#append("(F3) Autoformat",                            "Autoformat", "")
        call quickmenu#append("Null",                                       "", "Do nothing")
        call quickmenu#append("Replace last search",                        "execute '%s///gc'", "")
        call quickmenu#append("Replace search with `%{expand('<cword>')}`", 'call MyMenuExec("%s//", expand("<cword>"), "/gc")', "")
        call quickmenu#append("Remove empty lines",                         "g/^$/d", "delete blank lines, remove multi blank line")
        call quickmenu#append("Remove extra empty lines",                   "%s/\\n\\{3,}/\\r\\r/e", "replace three or more consecutive line endings with two line endings (a single blank line)")
        call quickmenu#append("(df) Remove ending space",                   "%s/\\s\\+$//g", "remove unwanted whitespace from line end")
        call quickmenu#append("(dd) Remove lines of last search",           "g//norm dd", '')
        call quickmenu#append("(ft) Wrap lines",                            "!fmt -c -w 100 -u -s", '')


    " new section: empty action with text starts with "#" represent a new section
    call quickmenu#append("# Execute", '')
        "call quickmenu#append(text="Run %{expand('%:t')}", action='!./%', help="Run current file", ft="c,cpp,objc,objcpp")
        "sed -i ':a;s/\B[0-9]\{3\}\>/,&/;ta' numbers.txt
        "call quickmenu#append("Update TAGs",          "NeomakeSh! tagme", "")

    call quickmenu#append("# Tmux(mark from 'u' to 'n')", '')
        call quickmenu#append("(tf) Exec file",     'VtrSendFile',  "Execute the file itself bin: python, awk")
        call quickmenu#append("(tt) Send mark/sel", 'call VtrSendCommandEx("n")', "only execute the command")
        call quickmenu#append("(tw) Exec mark/sel", 'call VtrExecuteCommand("n")', "execute the command, also insert the output")
        call quickmenu#append("(tl) Send current",  'VtrSendLinesToRunner', "")
        call quickmenu#append("(tj) Copy buffer",   'VtrBufferPasteHere', "copy the marked pane's output")
        call quickmenu#append("(tg) reset-command", 'VtrFlushCommand', "If no lines, repeat last-command, so this will flush last-command")
        call quickmenu#append("(tc) clear",         'VtrClearRunner', "")

endif


if CheckPlug('vim-quickui', 1) "{{{1

    " enable to display tips in the cmdline
    let g:quickui_show_tip = 1
    let g:quickui_border_style = 2
    let g:quickui_color_scheme = 'papercol dark'  | " 'borland' 'gruvbox' 'papercol dark'

    " Sugar 'Pop-preview'
      augroup YvQuickUI
        au!

        if CheckPlug('vim-which-key', 1)
            nnoremap <silent> ;j?            :WhichKey ';j'<cr>
        endif

        "" Sometime mess up the colortheme of a special-window
        "nnoremap <silent> ;;             :call quickui#tools#preview_tag('') <bar> "Pop-Define" <cr>
    " Sugar 'tag'
        nnoremap <silent> ;jj            :call quickui#tools#list_buffer('e') <bar> 'Buffer' <cr>
        nnoremap <silent> ;jt            :call quickui#tools#list_buffer('tabedit') <bar> 'Buffer2Tab' <cr>
        nnoremap <silent> ;jf            :call quickui#tools#list_function() <bar> 'Pop-functions' <cr>

        au FileType qf noremap <silent><buffer> ;; :call quickui#tools#preview_quickfix() <bar> 'Prev-context' <cr>
      augroup END


    " Sugar 'terminal'
        function! TermExit(code)
            echom "terminal exit code: ". a:code
        endfunc

        let opts = {'w':80, 'h':10, 'callback':'TermExit'}
        let opts.title = 'Terminal Popup'
        nnoremap <silent> ;ji            :call quickui#terminal#open('zsh', opts) <bar> 'Terminal' <cr>

    " Sugar 'git branch'
    if YvIsGit()
        let content = []

        let branches = systemlist("git branch --list --format='%(refname:short)'")
        for branch in branches
            call add(content, [branch, 'silent !git checkout '. branch])
        endfor

        let opts = {'title': 'Select one branch'}
      augroup YvQuickUI
        nnoremap <silent> ;jb            :call quickui#listbox#open(content, opts) <bar> 'Switch-branch'  <cr>
        nnoremap <silent> ;jd            :call quickui#textbox#command('git diff', opts) <bar> 'Pop diff'  <cr>
      augroup END
    endif

    " Sugar 'Context menu'
        function! YvContextMenu()
            if CheckPlug('fzf.vim', 1)
                let content = [
                        \ ["&Caller `%{expand('<cword>')}`",     "call cscope#run('0', expand('<cword>'))" ],
                        \ ["C&allee `%{expand('<cword>')}`",     "call cscope#run('2', expand('<cword>'))"],
                        \ ["&Prev Caller `%{expand('<cword>')}", "call cscope#preview('0', expand('<cword>'), 1)" ],
                        \ ["P&rev Callee `%{expand('<cword>')}", "call cscope#preview('2', expand('<cword>'), 1)"],
                        \ ['-',                                  ''],
                        \ ["&Symbol `%{expand('<cword>')}`",   "exec 'TagCatN! '. expand('<cword>')" ],
                        \ ["Prev S&ymbol `%{expand('<cword>')}`",   "exec 'TagCatPreN! '. expand('<cword>')" ],
                        \ ["&VTag `%{YvGetSel()}`",              "exec 'TagCatV! '. YvGetSel()" ],
                        \ ["VTa&g `%{YvGetSel()}`",              "exec 'TagCatPreV! '. YvGetSel()" ],
                        \ ['-',            ''],
                        \ ["&Files",       "FileCatV" ],
                        \ ["All F&iles",   "FileCatV!" ],
                        \ ["Prev Fil&es",  "FileCatPreN" ],
                        \ ["Pre&v Files",  "FileCatPreV" ],
                        \ ['-',            ''],
                        \ ["Text Searc&h", "exec 'RgType '. expand('<cword>')" ],
                        \ ["Li&nes",       "BLines" ],
                        \ ]
            else
                let content = [
                        \ ["Find &Symbol",     "exec 'cs find s '. expand('<cword>')" ],
                        \ ["Find &Definition", "exec 'cs find g '. expand('<cword>')" ],
                        \ ["Find &Caller",     "exec 'cs find c '. expand('<cword>')" ],
                        \ ["Find &Callee",     "exec 'cs find d '. expand('<cword>')" ],
                        \ ["Find &Text",       "exec 'cs find e '. expand('<cword>')" ],
                        \ ["Find &Symbol",     "call cscope#Symbol()" ],
                        \ ]
            endif

            " set cursor to the last position
            let opts = {'index':g:quickui#context#cursor}
            call quickui#context#open(content, opts)
        endfunction

        augroup YvQuickUI
            "au FileType c,cpp,log noremap <silent><buffer> <silent> K            :call YvContextMenu() <cr>
        augroup END



    " Menu 'Editor':
    call quickui#menu#switch('Editor') "Editor {{{2

        call quickui#menu#reset()    | " clear all the menus

        " hit space twice to open menu
        noremap <silent> ;m  :call quickui#menu#open('Editor')<cr>

        " install a 'File' menu, use [text, command] to represent an item.
        call quickui#menu#install('&File', [
                    \ [ "&New File\tCtrl+n", 'echo 0' ],
                    \ [ "&Open File\t(F3)",  'echo 1' ],
                    \ [ "&Close",            'echo 2' ],
                    \ [ "--",                '' ],
                    \ [ "&Save\tCtrl+s",     'echo 3'],
                    \ [ "Save &As",          'echo 4' ],
                    \ [ "Save All",          'echo 5' ],
                    \ [ "--",                '' ],
                    \ [ "E&xit\tAlt+x",      'echo 6' ],
                    \ ])

        " items containing tips, tips will display in the cmdline
        call quickui#menu#install('Ed&it', [
                    \ [ '&Replace', 'call MyMenuExec("%s//", expand("<cword>"), "/gc")', "Replace search with `%{expand('<cword>')}`" ],
                    \ [ '&Delete',  'g/^$/d',                                            'Remove empty lines' ],
                    \ [ '&Blank',   "%s/\\n\\{3,}/\\r\\r/e",                             'Remove extra empty lines' ],
                    \ [ '&Wrap (ft)',    "!fmt -c -w 100 -u -s",                              'Wrap lines' ],
                    \ ])

        " items containing tips, tips will display in the cmdline
        call quickui#menu#install('&View', [
                    \ [ '&Split',            'split',               "Split window" ],
                    \ [ '&V-Split',          'vsplit',              'Vertical split window' ],
                    \ [ "--",                '',                    '' ],
                    \ [ 'Switch &Outline',   "VoomToggle markdown", '' ],
                    \ [ 'Switch &Maximizer', "MaximizerToggle",     '' ],
                    \ [ 'Switch NERDTr&ee',  "NERDTreeTabsToggle",  '' ],
                    \ [ 'Switch &TagBar',    "TagbarToggle",        '' ],
                    \ ])

        " script inside %{...} will be evaluated and expanded in the string
        call quickui#menu#install("&Option", [
                    \ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
                    \ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
                    \ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
                    \ ])


        if CheckPlug('vim-fugitive', 1) && YvIsGit()
            call quickui#menu#install('&Git', [
                    \ [ '&Diff',   'Gvdiff',  "fugitive" ],
                    \ [ '&Status', "Gstatus", 'fugitive' ],
                    \ [ '&Blame',  "Gblame",  'fugitive' ],
                    \ [ '&Log',    "GV",      'fugitive' ],
                    \ ])
        endif


        call quickui#menu#install('&QuickFix', [
                    \ [ 'Make &wad',  'NeoMake -i -s -j6 -C daemon/wad',       "make wad" ],
                    \ [ 'Make &init', "NeoMake -i -s -j6 -C sysinit",          'make init' ],
                    \ [ '&Filter',    "call utilquickfix#QuickFixFilter()",    'Filter QuickFix' ],
                    \ [ '&Caller',    "call utilquickfix#QuickFixFunction() ", 'Find the caller' ],
                    \ ])

        call quickui#menu#install('&Misc', [
                    \ [ '&Count',     'call MyMenuExec("%s/", expand("<cword>"), "//gn")', "Count `%{expand('<cword>')}`" ],
                    \ [ '&Number',    "normal gA",                                         'Convert number' ],
                    \ [ '&Translate', "R! ~/tools/dict <C-R>=expand('<cword>')",           "Translate `%{expand('<cword>')}`" ],
                    \ [ 'Update &Tag',    "NeomakeSh! tagme",                                         '' ],
                    \ ])

        " register HELP menu with weight 10000
        call quickui#menu#install('H&elp', [
                    \ ["&Cheatsheet", 'help index', ''],
                    \ ['T&ips', 'help tips', ''],
                    \ ['--',''],
                    \ ["&Tutorial", 'help tutor', ''],
                    \ ['&Quick Reference', 'help quickref', ''],
                    \ ['&Summary', 'help summary', ''],
                    \ ], 10000)

endif

" vim:set ft=vim et sw=4:
