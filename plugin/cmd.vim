" Version:      1.0

if exists('g:loaded_hw_command') || &compatible
  finish
else
  let g:loaded_hw_command = 'yes'
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
        autocmd VimResized * wincmd =

        if g:vim_confi_option.auto_save
            autocmd InsertLeave * write
        endif

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

        autocmd filetype vim,vimwiki,tmux,txt  C0
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

    augroup END

"}}}


" Commands {{{2
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


if HasPlug('accelerated-jk')
    " Accelerated_jk
    " when wrap, move by virtual row
    "let g:accelerated_jk_enable_deceleration = 1
    let g:accelerated_jk_acceleration_table = [1,2,3]

    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)
    "nmap j <Plug>(accelerated_jk_gj_position)
    "nmap k <Plug>(accelerated_jk_gk_position)
endif


if HasPlug('vim.config')
    " Section 'String'
        "map <leader>ds :call Asm() <CR>
        " For local replace
        "nnoremap <leader>vm [[ma%mb:call signature#sign#Refresh(1) <CR>
        nnoremap <leader>vr :<C-\>e SelectedReplace('n')<CR><left><left><left>
        vnoremap <leader>vr :<C-\>e SelectedReplace('v')<CR><left><left><left>

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

endif



" vim:set ft=vim et sw=4:

