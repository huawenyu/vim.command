" Version:      1.0

if exists('g:loaded_local_map') || &compatible
  finish
else
  let g:loaded_local_map = 'yes'
endif


"=========================================================
" <Ctl-*>       Jump vim-windows/tmux-panes [hjkl]
" <Alt-*>       Jump tmux-panes [hjkl], View toggle
" <leader>*     View open
" <leader>j*    Open/format current selection
" ;*            View open 2
" z*            Show info
" q*            List
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

    " Alt+HJKL   move around tmux pane
    " Ctrl+HJKL  move around vim-window/tmux-pane
    nnoremap <silent> <a-o> <C-o>
    nnoremap <silent> <a-i> <C-i>


    " Substitue for MaboXterm diable <c-h>
    nnoremap <leader>jh <c-w>h
    nnoremap <leader>jj <c-w>j
    nnoremap <leader>jk <c-w>k
    nnoremap <leader>jl <c-w>l

    " Replace by vim-tmux-navigator
    "nnoremap <c-h> <c-w>h
    "nnoremap <c-j> <c-w>j
    "nnoremap <c-k> <c-w>k
    "nnoremap <c-l> <c-w>l

    if has("nvim")
        let b:terminal_scrollback_buffer_size = 2000
        let g:terminal_scrollback_buffer_size = 2000

        " i: enter interact-mode, 'esc' exit interact-mode and enter vi-mode
        " But so far conflict with gdb mode
        "tnoremap <Esc> <C-\><C-n>
        "
        "tnoremap <leader>jh <C-\><C-n><c-w>h
        "tnoremap <leader>jj <C-\><C-n><c-w>j
        "tnoremap <leader>jk <C-\><C-n><c-w>k
        "tnoremap <leader>jl <C-\><C-n><c-w>l

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

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

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

    nnoremap <silent> <c-n> :cn<cr>
    nnoremap <silent> <c-p> :cp<cr>

    nnoremap <silent> <leader>n :cn<cr>
    nnoremap <silent> <leader>p :cp<cr>
" }}}

if CheckPlug('vim-workspace', 1)
    nnoremap <C-s> :ToggleWorkspace<cr>
    " restore-session: vim -S
    "nnoremap <C-s> :Obsess
    "nnoremap <C-s> :Savews<cr>
endif


" Quick Jump
if CheckPlug('neovim-fuzzy', 1)
    function! s:JumpI(mode)
        if v:count == 0
            if a:mode
                let ans = input("FuzzySymbol ", utils#GetSelected(''))
                exec 'FuzzySymb '. ans
            else
                FuzzySymb
            endif
        else
        endif
    endfunction
    function! s:JumpO(mode)
        if v:count == 0
            if a:mode
                let ans = input("FuzzyOpen ", utils#GetSelected(''))
                exec 'FuzzyOpen '. ans
            else
                FuzzyOpen
            endif
        else
            exec ':silent! b'. v:count
        endif
    endfunction
    function! s:JumpH(mode)
    endfunction
    function! s:JumpJ(mode)
        if v:count == 0
            if a:mode
                let ans = input("FuzzyFunction ", utils#GetSelected(''))
                exec 'FuzzyFunc '. ans
            else
                FuzzyFunc
            endif
        else
            exec 'silent! '. v:count. 'wincmd w'
        endif
    endfunction
    function! s:JumpK(mode)
        if v:count == 0
        else
            exec 'normal! '. v:count. 'gt'
        endif
    endfunction
    function! s:JumpComma(mode)
        if v:count == 0
            "silent call utils#Declaration()
            call utils#Declaration()
        else
        endif
    endfunction

    " Must install fzy tool(https://github.com/jhawthorn/fzy)
    nnoremap <silent> <leader>i  :<c-u>call <SID>JumpI(0)<cr>
    vnoremap          <leader>i  :<c-u>call <SID>JumpI(1)<cr>
    nnoremap <silent> <leader>o  :<c-u>call <SID>JumpO(0)<cr>
    vnoremap          <leader>o  :<c-u>call <SID>JumpO(1)<cr>
    "nnoremap <silent> <leader>h  :<c-u>call <SID>JumpH(0)<cr>
    "vnoremap          <leader>h  :<c-u>call <SID>JumpH(1)<cr>
    "nnoremap <silent> <leader>j  :<c-u>call <SID>JumpJ(0)<cr>
    "vnoremap          <leader>j  :<c-u>call <SID>JumpJ(1)<cr>
    "nnoremap          <leader>f  :ls<cr>:b<Space>
    nnoremap <silent> <leader>;  :<c-u>call <SID>JumpComma(0)<cr>
    vnoremap          <leader>;  :<c-u>call <SID>JumpComma(1)<cr>
elseif CheckPlug('fzf-cscope.vim', 1)
    nnoremap <silent> <Leader>o          :FileCatN<cr>
    nnoremap <silent> <Leader><leader>o  :FileCatN!<cr>
endif

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

    "nnoremap <f3> :VimwikiFollowLink
  if CheckPlug('vim-maximizer', 1)
    nnoremap <silent> <a-w> :MaximizerToggle<CR>
  elseif CheckPlug('maximize', 1)
    nnoremap <silent> <a-w> :MaximizeWindow<CR>
  endif
    nnoremap <silent> <a-e> :NERDTreeTabsToggle<cr>
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

if CheckPlug('c-utils.vim', 1)
    function! s:JumpComma(mode)
        if v:count == 0
            call utils#Declaration()
        else
        endif
    endfunction

    nnoremap <silent> <leader>;  :<c-u>call <SID>JumpComma(0)<cr>
    vnoremap          <leader>;  :<c-u>call <SID>JumpComma(1)<cr>
endif


if CheckPlug('vim-tmux-navigator', 1)
    "let g:tmux_navigator_no_mappings = 1
    "nnoremap <silent> <a-h> :TmuxNavigateLeft<cr>
    "nnoremap <silent> <a-j> :TmuxNavigateDown<cr>
    "nnoremap <silent> <a-k> :TmuxNavigateUp<cr>
    "nnoremap <silent> <a-l> :TmuxNavigateRight<cr>
    "nnoremap <silent> <a-\> :TmuxNavigatePrevious<cr>
endif


if CheckPlug('vim-easy-align', 1)
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nnoremap ga <Plug>(EasyAlign)
endif


if CheckPlug('deoplete.nvim', 1)
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
endif


if CheckPlug('vim-autoformat', 1)
    noremap <F3> :Autoformat<CR>
endif


if CheckPlug('vim-go', 1)
    au FileType go nmap <leader>gr <Plug>(go-run)
    au FileType go nmap <leader>gb <Plug>(go-build)
    au FileType go nmap <leader>gt <Plug>(go-test)
    au FileType go nmap <leader>gc <Plug>(go-coverage)
    au FileType go nmap <leader>gd <Plug>(go-doc)<Paste>
    au FileType go nmap <leader>gi <Plug>(go-info)
    au FileType go nmap <leader>ge <Plug>(go-rename)
    au FileType go nmap <leader>gg <Plug>(go-def-vertical)
endif


if CheckPlug('fzf.vim', 1)
    nnoremap ;j     :Buffers<cr>
    nnoremap ;l     :BLines<cr>
endif


if CheckPlug('vim-yoink', 1)
    "nmap <c-n> <plug>(YoinkPostPasteSwapBack)
    "nmap <c-p> <plug>(YoinkPostPasteSwapForward)

    nmap qy :Yanks<cr>

    nmap p <plug>(YoinkPaste_p)
    nmap P <plug>(YoinkPaste_P)
    nmap [y <plug>(YoinkRotateBack)
    nmap ]y <plug>(YoinkRotateForward)

    nmap y <plug>(YoinkYankPreserveCursorPosition)
    vmap y <plug>(YoinkYankPreserveCursorPosition)
    xmap y <plug>(YoinkYankPreserveCursorPosition)
endif


if CheckPlug('vim-gutentags', 1)
    if !CheckPlug('fzf-cscope.vim', 1)
        " gutentags_plus
        let g:fzf_cscope_map = 0
        let g:gutentags_plus_nomap = 1
        noremap <silent> <leader>fs :GscopeFind s <C-R><C-W><cr>
        noremap <silent> <leader>fg :GscopeFind g <C-R><C-W><cr>
        noremap <silent> <leader>fc :GscopeFind c <C-R><C-W><cr>
        noremap <silent> <leader>ft :GscopeFind t <C-R><C-W><cr>
        noremap <silent> <leader>fe :GscopeFind e <C-R><C-W><cr>
        noremap <silent> <leader>ff :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fd :GscopeFind d <C-R><C-W><cr>
        noremap <silent> <leader>fa :GscopeFind a <C-R><C-W><cr>

        "let g:gutentags_plus_nomap = 1
        "noremap <silent> <leader>fs :cs find s <C-R><C-W><cr>
        "noremap <silent> <leader>fg :cs find g <C-R><C-W><cr>
        "noremap <silent> <leader>fc :cs find c <C-R><C-W><cr>
        "noremap <silent> <leader>ft :cs find t <C-R><C-W><cr>
        "noremap <silent> <leader>fe :cs find e <C-R><C-W><cr>
        "noremap <silent> <leader>ff :cs find f <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fi :cs find i <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fd :cs find d <C-R><C-W><cr>
        "noremap <silent> <leader>fa :cs find a <C-R><C-W><cr>
    endif
endif


if CheckPlug('coc.nvim', 1)
    " using coc.vim/ale with ccls-cache which base on clang
    nmap <silent> <a-]> <Plug>(coc-definition)
    nmap <silent> <a-\> <Plug>(coc-references)
    "nmap <silent> <a-h> <Plug>(coc-type-definition)
    "nmap <silent> <a-j> <Plug>(coc-implementation)
    nmap <silent> <a-[> call CocAction('doHover')
    nmap <silent> <a-r> <Plug>(coc-rename)
    nmap <silent> <a-,> <Plug>(coc-diagnostic-prev)
    nmap <silent> <a-.> <Plug>(coc-diagnostic-next)

    "autocmd CursorHold * silent call CocActionAsync('highlight')
endif


if CheckPlug('ale.vim', 1)
    nmap <silent> <a-]> :ALEGoToDefinition<cr>
    nmap <silent> <a-\> :ALEFindReferences<cr>
    "nmap <silent> <a-h> :ALESymbolSearch<cr>
    nmap <silent> <a-[> :ALEHover<cr>
    nmap <silent> <a-,> <Plug>(ale_previous_wrap)
    nmap <silent> <a-.> <Plug>(ale_next_wrap)
endif


if CheckPlug('vim-prettier', 1)
    nmap <Leader>fm <Plug>(Prettier)
endif


if CheckPlug('vim-qf', 1)
    ""nnoremap <leader>mn :QFAddNote note:
    "nnoremap <leader>ms :SaveList
    "nnoremap <leader>mS :SaveListAdd
    "nnoremap <leader>ml :LoadList
    "nnoremap <leader>mL :LoadListAdd
    "nnoremap <leader>mo :copen<cr>
    "nnoremap <leader>mn :cnewer<cr>
    "nnoremap <leader>mp :colder<cr>

    "nnoremap <leader>md :Doline
    "nnoremap <leader>mx :RemoveList
    "nnoremap <leader>mh :ListLists<cr>
    ""nnoremap <leader>mk :Keep
    "nnoremap <leader>mF :Reject
endif


if CheckPlug('tabularize', 1)
    if exists(":Tabularize")
        "nnoremap <leader>t= :Tabularize /=<CR>
        "vnoremap <leader>t= :Tabularize /=<CR>
        "nnoremap <leader>t: :Tabularize /:\zs<CR>
        "vnoremap <leader>t: :Tabularize /:\zs<CR>
    endif
endif


if CheckPlug('vim-tmux-runner', 1)
    nnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('n')"<CR>
    vnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('v')"<CR>
    nnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('n')"<CR>
    vnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('v')"<CR>

    nnoremap <silent> <leader>tf :exec "VtrLoad" \| exec "VtrSendFile"<CR>
    nnoremap <silent> <leader>tl :exec "VtrLoad" \| exec "VtrSendLinesToRunner"<CR>
    nnoremap <silent> <leader>tj :exec "VtrLoad" \| exec "VtrBufferPasteHere"<CR>
    nnoremap <silent> <leader>tg :exec "VtrLoad" \| exec "VtrFlushCommand"<CR>
    nnoremap <silent> <leader>tc :exec "VtrLoad" \| exec "VtrClearRunner"<CR>
endif


if CheckPlug('taboo.vim', 1)
    nnoremap <silent> ;1   1gt
    nnoremap <silent> ;2   2gt
    nnoremap <silent> ;3   3gt

    nnoremap <silent> ;tt :TabooOpen new-tab<CR>
    nnoremap <silent> ;tc :tabclose<CR>
    nnoremap          ;tr :TabooRename <C-R>=expand('%:t:r')<CR>
endif


if CheckPlug('vim-notes', 1)
    " :edit note:<name>
    vnoremap <F1> :SplitNoteFromSelectedText<Cr>
endif


if CheckPlug('ctrlp.vim', 1)
    "nnoremap <leader>b :CtrlPBuffer<cr>
endif


if CheckPlug('ultisnips', 1)
    let g:UltiSnipsExpandTrigger="<tab>"
    "let g:UltiSnipsJumpForwardTrigger="<c-n>"
    "let g:UltiSnipsJumpBackwardTrigger="<c-p>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
    let g:UltiSnipsEditSplit="vertical"
endif


if CheckPlug('vim-repl', 1)
    noremap <leader>rr :REPLToggle<Cr>
    noremap <leader>rr :Repl<Cr>

    autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>
    autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
    autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>
endif


if CheckPlug('vim-youdao-translater', 1)
    vnoremap <silent> qw :<C-u>Ydv<CR>
    nnoremap <silent> qw :<C-u>Ydc<CR>
    "noremap <leader>yd :<C-u>Yde<CR>
elseif executable('~/tools/dict')
    nmap qw :R! ~/tools/dict <C-R>=expand('<cword>') <cr>
endif


if CheckPlug('vim-lookup', 1)
    autocmd FileType vim nnoremap <buffer><silent> <c-]>  :call lookup#lookup()<cr>
endif


if CheckPlug('w3m.vim', 1)
    if WINDOWS()
        let $PATH = $PATH . ';c:\Programs\FireFox1.5'
    endif

    " Evoke a web browser
    function! W3mBrowser()
        let line0 = getline(".")
        let aUrl = matchstr(line0, 'http[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')

        if empty(aUrl)
            let aUrl = matchstr(line0, 'ftp[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')
        endif

        if empty(aUrl)
            let aUrl = matchstr(line0, 'file[^ ].\{-}\ze[\}\]\) ,;''"]\{-\}$')
        endif

        let aUrl = escape(aUrl, "#?&;|%")
        "return printf("W3mSplit %s", aUrl)
        exec "W3mSplit ". aUrl
    endfunction

    "nnoremap <leader>jo :<c-u><C-R>=W3mBrowser()<cr>
    nnoremap <leader>jo :call W3mBrowser()<cr>
endif



" Keymaps {{{2
    " Toggle source/header
    "nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>
    nnoremap <silent> <leader>a  :<c-u>call CurtineIncSw()<cr>

    " Most UNIX-like programming environments offer generic tools for formatting text. These include fmt, fold, sed, perl, and par. 
    " vnoremap qq c<C-R>=system('wc -c | perl -pe chomp', @")<CR><ESC>
    vnoremap <leader>jf :!fmt -c -w 100 -u -s <cr>

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

    nnoremap <silent> <leader>v] :NeomakeSh! tagme<cr>
    nnoremap <silent> <leader>vi :call utils#VoomInsert(0) <CR>
    vnoremap <silent> <leader>vi :call utils#VoomInsert(1) <CR>

    nnoremap <silent> <leader>gg :<C-\>e utilgrep#Grep(2,0)<cr><cr>
    vnoremap <silent> <leader>gg :<C-\>e utilgrep#Grep(2,1)<cr><cr>
    nnoremap <silent> <leader>vv :<C-\>e utilgrep#Grep(1,0)<cr><cr>
    vnoremap <silent> <leader>vv :<C-\>e utilgrep#Grep(1,1)<cr><cr>

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
    "nnoremap <silent> <leader>gf :<c-u>call utils#GotoFileWithPreview()<CR>

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


    nnoremap <silent> <leader>eo :SCViewResult<CR>

    augroup filetype_auto_eval
        if CheckPlug('vim-eval', 1)
            autocmd FileType vim nnoremap <buffer> <leader>ee <Plug>eval_viml
            autocmd FileType vim vnoremap <buffer> <leader>ee <Plug>eval_viml_region
        elseif CheckPlug('vim-quickrun', 1)
            autocmd FileType vim noremap <buffer> <leader>ee :QuickRun<cr>
        endif

            autocmd FileType javascript nnoremap <buffer> <leader>ee  :DB mongodb:///test < %
            autocmd FileType javascript vnoremap <buffer> <leader>ee  :'<,'>w! /tmp/vim.js<cr><cr> \| :DB mongodb:///test < /tmp/vim.js<cr><cr>


        if mapcheck('<leader>ee', 'n')
            "" execute file that I'm editing in Vi(m) and get output in split window
            "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
            "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
            "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

            nnoremap <silent> <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
        endif


    augroup END

"}}}
