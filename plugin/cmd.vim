" Version:      1.0

if exists("g:loaded_hw_command") || &cp || v:version < 700
    finish
endif
let g:loaded_hw_command = 1

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

endif


" Autocmd {{{2

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

        func! s:ftMarkdown()
            nnoremap <buffer>  <a-'> :VoomToggle markdown<cr>
            nnoremap <buffer>  <a-u> :VoomToggle fmr<cr>
        endfunc
        autocmd filetype markdown,vimwiki call <sid>ftMarkdown()
        "autocmd filetype vimwiki  nnoremap <buffer> <a-o> :VoomToggle vimwiki<CR>
        "autocmd filetype vimwiki  nnoremap <a-n> :VimwikiMakeDiaryNote<CR>
        "autocmd filetype vimwiki  nnoremap <a-i> :VimwikiDiaryGenerateLinks<CR>

        autocmd filetype python   nnoremap <buffer> <a-'> :VoomToggle python<CR>
        autocmd filetype c,cpp    nnoremap <buffer> <a-'> :VoomToggle txt2tags<CR>

        command! -nargs=* C0  setlocal autoindent cindent expandtab   tabstop=4 shiftwidth=4 softtabstop=4
        command! -nargs=* C08 setlocal autoindent cindent expandtab   tabstop=8 shiftwidth=2 softtabstop=8
        command! -nargs=* C2  setlocal autoindent cindent expandtab   tabstop=2 shiftwidth=2 softtabstop=2
        command! -nargs=* C4  setlocal autoindent cindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
        command! -nargs=* C8  setlocal autoindent cindent noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

        "autocmd filetype vim,tmux,txt    C0
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
        nnoremap <leader>vr      :"Replace                   "<c-U><C-\>e SelectedReplace('n')<CR><left><left><left>
        vnoremap <leader>vr                                  :<C-\>e SelectedReplace('v')<CR><left><left><left>

    " Section 'Execute'
        " Plug : asynctasks.vim : ~/.vim_tasks.ini : wad|sysinit
        nnoremap  <leader>mk     :"(diag)Make wad                   "<c-U>AsyncStop! <bar> AsyncTask! wad<CR>
        nnoremap  <leader>ma     :"(diag)Make all                   "<c-U>AsyncStop! <bar> AsyncTask! sysinit<CR>

        nnoremap  <leader>mw     :"(tool)Dictionary                 "<c-U>R! ~/tools/dict <C-R>=expand('<cword>') <cr>
        nnoremap  <leader>mf     :"(quickfix)filter                 "<c-U>call utilquickfix#QuickFixFilter() <CR>
        nnoremap  <leader>mc     :"(quickfix)add caller field       "<c-U>call utilquickfix#QuickFixFunction() <CR>

        nnoremap  <silent>;q     :"(vim.command)SmartClose          "<c-U>SmartClose<cr>

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


    " https://github.com/szw/vim-smartclose
    command! -bang -nargs=0 -range SmartClose :call s:smart_close(<bang>0)
    fun! s:is_auxiliary(buffer)
        return !getbufvar(a:buffer, '&modifiable') || !getbufvar(a:buffer, '&buflisted') || (getbufvar(a:buffer, '&buftype') != '')
    endfun

    fun! s:smart_close(bang)
        let current_buffer = bufnr('%')

        if s:is_auxiliary(current_buffer) || a:bang
            silent! exe 'q'
        else
            let auxiliary_buffer = 0

            for b in tabpagebuflist()
                if s:is_auxiliary(b) && (b > auxiliary_buffer)
                    let auxiliary_buffer = b
                endif
            endfor

            if auxiliary_buffer
                silent! exe 'noautocmd ' . bufwinnr(auxiliary_buffer) . 'wincmd w'
                silent! exe 'noautocmd q'
                silent! exe 'noautocmd ' . bufwinnr(current_buffer) . 'wincmd w'
            else
                silent! exe 'q'
            endif
        endif
    endfun

endif


" vim:set ft=vim et sw=4:

