" Version:      1.0

if exists('g:loaded_local_map2') || &compatible
  finish
else
  let g:loaded_local_map2 = 'yes'
endif


"=========================================================
" <Ctl-*>       Jump vim-windows/tmux-panes [hjkl]
" <Alt-*>       Jump tmux-panes [hjkl], View toggle
" <leader>*     View open
" z*            Show info
" q*            List
" ;*            View open 2
"
" Donnot map:
" <space>*      Cause the input <space> not work
" ;*            Cause 'f*' repeat mode fail, maybe plugin 'clever-f.vim' can release the key ';'
"=========================================================


" Key maps {{{1
    "" Stop that stupid window from popping up
    "map q: :q

    "" Disable F1 built-in help key by: re-replace last search
    "map <F1> :<c-u>%s///gc<cr>
    map <F1> :<c-u>%s//<C-R>"/gc<cr>

    " map <leader><Esc> :AnsiEsc<cr>
    nnoremap <C-c> <silent> <C-c>
    "nnoremap <buffer> <Enter> <C-W><Enter>     | " vimwiki use this to create a new link
    nnoremap <C-q> :<c-u>qa!<cr>

    inoremap <S-Tab> <C-V><Tab>

    nnoremap j gj
    nnoremap k gk

    " https://www.reddit.com/r/vim/comments/53bpb4/alternatives_to_esc/
    " https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping
    " @ver1: using jj, but how about the select-mode, the 'j' as move
    "noremap   jj <Esc>
    "noremap!  jj <Esc>
    " @ver2: want input ';' at the end of current line, then exit by hit two ';;', which will auto remove the first wanted ';'
    "nnoremap ;; <Esc>
    "inoremap ;; <Esc>
    "vnoremap ;; <Esc>
    " @ver3: confuse it's insert mode or normal mode, or if enter multiple i
    "noremap   ii <Esc>
    "noremap!  ii <Esc>
    " @ver4:
    inoremap ,, <Esc>`^
    onoremap ,, <Esc>`^
    vnoremap ,, <Esc>`<
    cnoremap ,, <c-u><Esc>


    " vp doesn't replace paste buffer
    function! RestoreRegister()
        let @" = s:restore_reg
        let @+ = s:restore_reg | " sometime other plug use this register as paste-buffer
        return ''
    endfunction
    function! s:Repl()
        let s:restore_reg = @"
        return "p@=RestoreRegister()\<cr>"
    endfunction
    vnoremap <silent> <expr> p <sid>Repl()

    "================================================= {{{2
    "    Finger candy: same-bind a-, c-, leader-
    "
    " Alt+HJKL   move around tmux pane
    " Ctrl+HJKL  move around vim-window/tmux-pane
    nnoremap <silent> <a-o> <C-o>
    nnoremap <silent> <a-i> <C-i>

    nnoremap <silent> <leader>o <C-o>
    nnoremap <silent> <leader>i <C-i>
    nnoremap <silent> <leader>] <C-]>
    "inoremap <silent> <leader>[ <C-[>

    " Substitue for MaboXterm diable <c-h>
    nnoremap <leader>h <c-w>h
    nnoremap <leader>j <c-w>j
    nnoremap <leader>k <c-w>k
    nnoremap <leader>l <c-w>l

    nnoremap <leader>q :<c-u>qa<cr>
    nnoremap <leader>s :w<cr> :echom "Saved"<CR>
    "" Esc too far, use Ctrl+Enter as alternative
    "inoremap <a-CR> <Esc>
    "vnoremap <a-CR> <Esc>

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Format {
        vnoremap <Leader>ff =<cr>
        nnoremap <Leader>ff =<cr>
        "     Most UNIX-like programming environments offer generic tools for formatting text. These include fmt, fold, sed, perl, and par. 
        "     vnoremap qq c<C-R>=system('wc -c | perl -pe chomp', @")<CR><ESC>
        autocmd FileType vimwiki vnoremap <leader>ff :!fmt -c -w 100 -u -s <cr>
    " }

    " Replace by vim-tmux-navigator
    "nnoremap <c-h> <c-w>h
    "nnoremap <c-j> <c-w>j
    "nnoremap <c-k> <c-w>k
    "nnoremap <c-l> <c-w>l
    "=================================================}}}

    if has("nvim")
        let b:terminal_scrollback_buffer_size = 2000
        let g:terminal_scrollback_buffer_size = 2000

        " i: enter interact-mode, 'esc' exit interact-mode and enter vi-mode
        " But so far conflict with gdb mode
        "tnoremap <Esc> <C-\><C-n>
        "
        "tnoremap <leader>h <C-\><C-n><c-w>h
        "tnoremap <leader>j <C-\><C-n><c-w>j
        "tnoremap <leader>k <C-\><C-n><c-w>k
        "tnoremap <leader>l <C-\><C-n><c-w>l

        tnoremap <c-h> <C-\><C-n><C-w>h
        tnoremap <c-j> <C-\><C-n><C-w>j
        tnoremap <c-k> <C-\><C-n><C-w>k
        tnoremap <c-l> <C-\><C-n><C-w>l
    endif

    "[Cause command mode pause when press 'w', note:map](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
    "For when you forget to sudo.. Really Write the file.
    cmap <C-w> w !sudo tee % >/dev/null
    " Show current color's name: zS show syntax[vim-scriptease]
    nnoremap zC :echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")<cr>
    nnoremap zc :echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")<cr>

    "" FIXME: Revert this f70be548
    "" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    "map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$
    " Automatically jump to end of text you pasted
    "vnoremap <silent> y y`]
    vnoremap <silent> p p`]
    nnoremap <silent> p p`]
    " Paste in insert mode
    inoremap <silent> <a-i> <c-r>"

    " Navigate quickfix
    nnoremap <silent> <c-n> :cn<cr>
    nnoremap <silent> <c-p> :cp<cr>

    " Navigate locallist
    nnoremap <silent> <leader>n :lne<cr>
    nnoremap <silent> <leader>p :lp<cr>
" }}}



" View keymap {{{1
    "autocmd WinEnter * if !utils#IsLeftMostWindow() | let g:tagbar_left = 0 | else | let g:tagbar_left = 1 | endif
    function! s:ToggleTagbar()
        " Detect which plugins are open
        if exists('t:NERDTreeBufName')
            let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
        else
            let nerdtree_open = 0
        endif

        if nerdtree_open
            if CheckPlug('tagbar', 1)
                let g:tagbar_left = 0
            elseif CheckPlug('vista.vim', 1)
                let g:vista_sidebar_position = 'vertical botright'
            endif
        else
            " left
            if utils#IsLeftMostWindow()
                if CheckPlug('tagbar', 1)
                    let g:tagbar_left = 1
                elseif CheckPlug('vista.vim', 1)
                    let g:vista_sidebar_position = 'vertical topleft'
                endif
            " right
            else
                if CheckPlug('tagbar', 1)
                    let g:tagbar_left = 0
                elseif CheckPlug('vista.vim', 1)
                    let g:vista_sidebar_position = 'vertical botright'
                endif
            endif
        endif

        if CheckPlug('tagbar', 1)
            TagbarToggle
        elseif CheckPlug('vista.vim', 1)
            let tagbar_open = bufwinnr('__vista__') != -1
            if tagbar_open
                Vista! ctags
            else
                Vista ctags
            endif
        endif


        "" Jump back to the original window
        "let w:jumpbacktohere = 1
        "for window in range(1, winnr('$'))
        "  execute window . 'wincmd w'
        "  if exists('w:jumpbacktohere')
        "    unlet w:jumpbacktohere
        "    break
        "  endif
        "endfor
    endfunction

    function! s:R(cap, ...)
        if a:cap
            tabnew
            setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
            exec ":r !". join(a:000)
        else
            tabnew | enew | exec ":term ". join(a:000)
        endif
    endfunction

    " Reload all opened files
        fun! PullAndRefresh()
            set noconfirm
            !git pull
            bufdo e!
            set confirm
        endfun

        nmap ;gr call PullAndRefresh()
    " --End

    "nnoremap <f3> :VimwikiFollowLink
    if CheckPlug('vim-maximizer', 1)
        nnoremap <silent> <a-w> :MaximizerToggle<CR>
    elseif CheckPlug('maximize', 1)
        nnoremap <silent> <a-w> :MaximizeWindow<CR>
    endif
    if CheckPlug('vim-nerdtree-tabs', 1)
        nnoremap <silent> <a-e> :NERDTreeTabsToggle<cr>
    elseif CheckPlug('nerdtree', 1)
        nnoremap <silent> <a-e> :NERDTreeToggle<cr>
    endif

    "nnoremap <silent> <a-f> :Null<CR>
    "nnoremap <silent> <a-g> :Null<CR>
    "nnoremap <silent> <a-q> :Null<CR>

    " Paste in insert mode: don't know who reset this, set again here
    inoremap <silent> <a-i> <c-r>"

    nnoremap <silent> <a-'> :VoomToggle<cr>
    nnoremap <silent> <a-;> :<c-u>call <SID>ToggleTagbar()<CR>
    "nnoremap <silent> <a-;> :TMToggle<CR>
    "nnoremap <silent> <a-.> :BuffergatorToggle<CR>
    "nnoremap <silent> <a-,> :VoomToggle<CR>
    "nnoremap <silent> <a-[> :Null<CR>
    "nnoremap <silent> <a-]> :Null<CR>
    "nnoremap <silent> <a-\> :Null<CR>

"}}}


" Keymaps {{{2
    " Toggle source/header
    "nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>
    nnoremap <silent> <leader>a  :<c-u>call CurtineIncSw()<cr>

    if CheckPlug('vim-sleuth', 1)
        nnoremap <leader>fd :Sleuth<cr>
    elseif CheckPlug('detectindent', 1)
        nnoremap <leader>fd :DetectIndent<cr>
    endif

    " Set log
    "nnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
    "vnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
    " Lint: -i ignore-error and continue, -s --silent --quiet

    "bookmark
    nnoremap <silent> <leader>mm :silent! call mark#MarkCurrentWord(expand('<cword>'))<CR>
    "nnoremap <leader>mf :echo(statusline#GetFuncName())<CR>
    "nnoremap <leader>mo :BookmarkLoad Default
    "nnoremap <leader>ma :BookmarkShowAll <CR>
    "nnoremap <leader>mg :BookmarkGoto <C-R><c-w>
    "nnoremap <leader>mc :BookmarkDel <C-R><c-w>
    "
    map W <Plug>(expand_region_expand)
    map B <Plug>(expand_region_shrink)

    nnoremap          <leader>v] :NeomakeSh! tagme<cr>
    nnoremap <silent> <leader>vi :call utils#VoomInsert(0) <CR>
    vnoremap <silent> <leader>vi :call utils#VoomInsert(1) <CR>


    " Search
    nnoremap <leader>gg :<C-\>e utilgrep#Grep(0, 0, "daemon/wad", 1)<cr>
    vnoremap <leader>gg :<C-\>e utilgrep#Grep(0, 1, "daemon/wad", 1)<cr>
    nnoremap <leader>vv :<C-\>e utilgrep#Grep(0, 0, "", 1)<cr>
    vnoremap <leader>vv :<C-\>e utilgrep#Grep(0, 1, "", 1)<cr>

    nnoremap ;gg :<C-\>e utilgrep#Grep(0, 0, "daemon/wad", 0)<cr>
    vnoremap ;gg :<C-\>e utilgrep#Grep(0, 1, "daemon/wad", 0)<cr>
    nnoremap ;vv :<C-\>e utilgrep#Grep(0, 0, "", 0)<cr>
    vnoremap ;vv :<C-\>e utilgrep#Grep(0, 1, "", 0)<cr>


    vnoremap <silent> <leader>yy :<c-u>call utils#GetSelected("/tmp/vim.yank")<CR>
    nnoremap <silent> <leader>yy :<c-u>call vimuxscript#Copy() <CR>
    nnoremap <silent> <leader>yp :r! cat /tmp/vim.yank<CR>

    xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
    xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
    vnoremap // y:vim /\<<C-R>"\C/gj %

    " Search-mode: hit cs, replace first match, and hit <Esc>
    "   then hit n to review and replace
    vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
          \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
    onoremap s :normal vs<CR>

    "nnoremap gf :<c-u>call utils#GotoFileWithLineNum()<CR>
    nnoremap <silent> <leader>gf :<c-u>call utils#GotoFileWithPreview()<CR>

    if CheckPlug('vim-sleuth', 1)
        nnoremap <silent> <leader>gl :GV<CR>
    endif

    nnoremap <silent> mm :<c-u>call utils#MarkSelected('n')<CR>
    vnoremap <silent> mm :<c-u>call utils#MarkSelected('v')<CR>
"}}}


" Filetype autocmd Keymaps {{{2
    function! SingleCompileSplit()
        if winwidth(0) > 200
            let g:SingleCompile_split = "vsplit"
            let g:SingleCompile_resultsize = winwidth(0)/2
        else
            let g:SingleCompile_split = "split"
            let g:SingleCompile_resultsize = winheight(0)/3
        endif
    endfunction



    if mapcheck('<leader>ee', 'n') == ""
        "" execute file that I'm editing in Vi(m) and get output in split window
        "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
        "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
        "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

        nnoremap <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
        nnoremap <leader>eo :SCViewResult<CR>
    endif

    nnoremap <leader>el :VlogDisplay \| Messages \| VlogClear<CR><CR>


    augroup filetype_auto_eval
        if CheckPlug('vim-eval', 1)
            autocmd FileType vim nnoremap <buffer> <leader>ee <Plug>eval_viml
            autocmd FileType vim vnoremap <buffer> <leader>ee <Plug>eval_viml_region
        elseif CheckPlug('vim-quickrun', 1)
            autocmd FileType vim noremap <buffer> <leader>ee :QuickRun<cr>
        endif

        autocmd FileType javascript nnoremap <buffer> <leader>ee  :DB mongodb:///test < %
        autocmd FileType javascript vnoremap <buffer> <leader>ee  :'<,'>w! /tmp/vim.js<cr><cr> \| :DB mongodb:///test < /tmp/vim.js<cr><cr>
    augroup END

"}}}
