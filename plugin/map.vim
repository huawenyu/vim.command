" Version:      1.0

if exists('g:loaded_local_map') || &compatible
  finish
else
  let g:loaded_local_map = 'yes'
endif


" Plugins' map {{{1
if CheckPlug('vim-workspace', 1)
    nnoremap <C-s> :ToggleWorkspace<cr>
    " restore-session: vim -S
    "nnoremap <C-s> :Obsess
    "nnoremap <C-s> :Savews<cr>
    Shortcut! <C-s>    Workspace save
endif


if CheckPlug('vim-table-mode', 1)
    nnoremap <leader>tm :TableModeToggle<cr>
    Shortcut! <space>tm    Switch table mode
endif


" Quick Jump
" ver1: open-file by <leader>o
" ver2: open-file by ;o       " the <leader>o take by jump-history, which like Ctrl-o
" ver3: open-file by ;u
" ver4: open-file by ;f       " quick & easy-remember
if HasPlug('neovim-fuzzy')
    function! s:JumpI(mode)
        if v:count == 0
            if a:mode
                let ans = input("FuzzySymbol ", utils#GetSelected(a:mode))
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
                let ans = input("FuzzyOpen ", utils#GetSelected(a:mode))
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
                let ans = input("FuzzyFunction ", utils#GetSelected(a:mode))
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
    nnoremap <silent> ;i  :<c-u>call <SID>JumpI(0)<cr>
    vnoremap          ;i  :<c-u>call <SID>JumpI(1)<cr>
    nnoremap <silent> ;f  :<c-u>call <SID>JumpO(0)<cr>
    vnoremap          ;f  :<c-u>call <SID>JumpO(1)<cr>
    "nnoremap         ;f  :ls<cr>:b<Space>
    nnoremap <silent> <leader>;  :<c-u>call <SID>JumpComma(0)<cr>
    vnoremap          <leader>;  :<c-u>call <SID>JumpComma(1)<cr>
elseif HasPlug('old@fzf-cscope.vim')
    " if HasPlug('vista.vim')
    "     nnoremap <silent> ;e    :Vista finder ctags<cr>
    " else
    "     nnoremap ;e    :TagCatPreN <c-r>=utils#GetSelected('n')<cr><cr>
    " endif
    echo "NOP, redirect to cscope."
elseif HasPlug('fzf-cscope.vim')
    " File
    " FileCatV, FileCatPreN (preview)
    nnoremap <silent> <leader>ff    :FileCatN<cr>
    vnoremap <silent> <leader>ff    :<c-u>FileCatN<cr>
    nnoremap <silent>        ;ff    :FileCatN<cr>
    vnoremap <silent>        ;ff    :<c-u>FileCatN<cr>
    " All files
    nnoremap <silent> <leader>fF    :FileCatN!<cr>
    vnoremap <silent> <leader>fF    :<c-u>FileCatN!<cr>
    nnoremap <silent>        ;fF    :FileCatN!<cr>
    vnoremap <silent>        ;fF    :<c-u>FileCatN!<cr>

    " Function called
    nnoremap <silent> <leader>fc    :call cscope#preview('3', 'n', 1)<cr>
    vnoremap <silent> <leader>fc    :<c-u>call cscope#preview('3', 'v', 1)<cr>

    " Function calling
    nnoremap <silent> <leader>fC    :call cscope#preview('2', 'n', 1)<cr>
    vnoremap <silent> <leader>fC    :<c-u>call cscope#preview('2', 'v', 1)<cr>

    " symbol
    nnoremap <silent> <leader>fs    :call cscope#preview('0', 'n', 1)<cr>
    vnoremap <silent> <leader>fs    :<c-u>call cscope#preview('0', 'v', 1)<cr>
    " symbol assign value
    nnoremap <silent> <leader>fS    :call cscope#preview('9', 'n', 1)<cr>
    vnoremap <silent> <leader>fS    :<c-u>call cscope#preview('9', 'v', 1)<cr><cr>

    " tExt
    nnoremap          <leader>fe    :CscopeText! <c-r>=utils#GetSelected('n')<cr>
    vnoremap          <leader>fe    :<c-u>CscopeText! <c-r>=utils#GetSelected('v')<cr>
    nnoremap          <leader>fE    :CscopeGrep! <c-r>=utils#GetSelected('n')<cr>
    vnoremap          <leader>fE    :<c-u>CscopeGrep! <c-r>=utils#GetSelected('v')<cr>
endif

" Buffer & lines
if CheckPlug('fzf.vim', 1)
    nnoremap <silent> <leader>fb    :Buffers<cr>
    vnoremap <silent> <leader>fb    :<c-u>Buffers<cr>
    nnoremap <silent> <leader>fl    :BLines<cr>
    vnoremap <silent> <leader>fl    :<c-u>BLines<cr>
endif

" Setup shortcut
Shortcut! <space>ff    Jump file partial
Shortcut! <space>fF    Jump file all
Shortcut! <space>fe    Jump function
Shortcut! <space>fs    Jump symbol
Shortcut! <space>fS    Jump symbol withou preview
Shortcut! <space>fb    Jump buffer
Shortcut! <space>fl    Jump line


if CheckPlug('c-utils.vim', 1)
    function! s:JumpComma(mode)
        if v:count == 0
            call utils#Declaration()
        else
        endif
    endfunction

    nnoremap <silent> <leader><leader>  :<c-u>call <SID>JumpComma(0)<cr>
    vnoremap          <leader><leader>  :<c-u>call <SID>JumpComma(1)<cr>
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
    "noremap <F3> :Autoformat<CR>
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
        "noremap <silent> <leader>ff :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <leader>fd :GscopeFind d <C-R><C-W><cr>
        noremap <silent> <leader>fa :GscopeFind a <C-R><C-W><cr>

        "let g:gutentags_plus_nomap = 1
        "noremap <silent> <leader>fs :cs find s <C-R><C-W><cr>
        "noremap <silent> <leader>fg :cs find g <C-R><C-W><cr>
        "noremap <silent> <leader>fc :cs find c <C-R><C-W><cr>
        "noremap <silent> <leader>ft :cs find t <C-R><C-W><cr>
        "noremap <silent> <leader>fe :cs find e <C-R><C-W><cr>
        ""noremap <silent> <leader>ff :cs find f <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fi :cs find i <C-R>=expand("<cfile>")<cr><cr>
        "noremap <silent> <leader>fd :cs find d <C-R><C-W><cr>
        "noremap <silent> <leader>fa :cs find a <C-R><C-W><cr>
    endif
endif


if CheckPlug('vim-emacscommandline', 1)
    "let g:EmacsCommandLine[Command]Disable = 1
    "let g:EmacsCommandLineBeginningOfLineMap = ['<C-B>', '<C-A>']

    "let g:EmacsCommandLineBeginningOfLineMap
    "let g:EmacsCommandLineEndOfLineMap
    let g:EmacsCommandLineBackwardCharDisable = 1
    let g:EmacsCommandLineForwardCharDisable = 1
    let g:EmacsCommandLineBackwardWordMap = ['<C-B>']
    let g:EmacsCommandLineForwardWordMap = ['<C-F>']
    let g:EmacsCommandLineDeleteCharDisable = 1
    let g:EmacsCommandLineBackwardDeleteCharDisable = 1
    "let g:EmacsCommandLineKillLineMap
    "let g:EmacsCommandLineBackwardKillLineMap
    let g:EmacsCommandLineKillWordMap = ['<C-D>']
    let g:EmacsCommandLineBackwardKillWordMap = '<C-W>'
    "let g:EmacsCommandLineDeleteBackwardsToWhiteSpaceMap
    "let g:EmacsCommandLineOlderMatchingCommandLineMap
    "let g:EmacsCommandLineNewerMatchingCommandLineMap
    "let g:EmacsCommandLineFirstLineInHistoryMap
    "let g:EmacsCommandLineLastLineInHistoryMap
    "let g:EmacsCommandLineSearchCommandLineMap
    "let g:EmacsCommandLineTransposeCharMap
    "let g:EmacsCommandLineYankMap
    "let g:EmacsCommandLineUndoMap
    "let g:EmacsCommandLineAbortCommandMap
    "let g:EmacsCommandLineToggleExternalCommandMap
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


if CheckPlug('nnn.vim', 1) | " {{{1
    " Disable default mappings
    let g:nnn#set_default_mappings = 0

    " Then set your own
    "nnoremap <silent> <a-e> :NnnPicker<CR>

    " Or override
    " Start nnn in the current file's directory
    "nnoremap <leader>n :NnnPicker '%:p:h'<CR>
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
    "nnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('n')"<CR>
    "vnoremap <silent> <leader>tt :exec "VtrLoad" \| exec "call vtr#SendCommandEx('v')"<CR>
    "nnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('n')"<CR>
    "vnoremap <silent> <leader>tw :exec "VtrLoad" \| exec "call vtr#ExecuteCommand('v')"<CR>

    "nnoremap <silent> <leader>tf :exec "VtrLoad" \| exec "VtrSendFile"<CR>
    "nnoremap <silent> <leader>tl :exec "VtrLoad" \| exec "VtrSendLinesToRunner"<CR>
    "nnoremap <silent> <leader>tj :exec "VtrLoad" \| exec "VtrBufferPasteHere"<CR>
    "nnoremap <silent> <leader>tg :exec "VtrLoad" \| exec "VtrFlushCommand"<CR>
    "nnoremap <silent> <leader>tc :exec "VtrLoad" \| exec "VtrClearRunner"<CR>
endif


if CheckPlug('taboo.vim', 1)
    nnoremap <silent> ;1     1gt
    nnoremap <silent> ;2     2gt
    nnoremap <silent> ;3     3gt
    nnoremap <silent> ;4     4gt
    nnoremap <silent> ;5     5gt
    nnoremap <silent> ;6     6gt
    nnoremap <silent> ;7     7gt
    nnoremap <silent> ;8     8gt
    nnoremap <silent> ;9     9gt
    nnoremap <silent> ;0     10gt

    nnoremap <silent> ;tt   :TabooOpen new-tab<CR>
    nnoremap <silent> ;tc   :tabclose<CR>
    nnoremap          ;tr   :TabooRename <C-R>=expand('%:t:r')<CR>
elseif CheckPlug('vim-tabber', 1)
    nnoremap <silent> ;1     1gt
    nnoremap <silent> ;2     2gt
    nnoremap <silent> ;3     3gt
    nnoremap <silent> ;4     4gt
    nnoremap <silent> ;5     5gt
    nnoremap <silent> ;6     6gt
    nnoremap <silent> ;7     7gt
    nnoremap <silent> ;8     8gt
    nnoremap <silent> ;9     9gt
    nnoremap <silent> ;0     10gt

    "set tabline=%!tabber#TabLine()
    "
    "let g:tabber_wrap_when_shifting = 1
    let g:tabber_predefined_labels = { 1: 'code', 2: 'config', 3: 'patch' }
    let g:tabber_filename_style = 'filename'    " README.md

    "let g:tabber_divider_style = 'compatible'
    let g:tabber_divider_style = 'unicode'
    "let g:tabber_divider_style = 'fancy'

    nnoremap <silent> ;tt   :TabberNew<CR>
    "nnoremap          ;tc   :tabclose<CR>
    "nnoremap          ;tr   :TabberLabel <C-R>=expand('%:t:r')<CR>
    "nnoremap          ;tm   :TabberMove<CR>
    "nnoremap          ;th   :TabberShiftLeft<CR>
    "nnoremap          ;tl   :TabberShiftRight<CR>
    "nnoremap          ;ts   :TabberSwap<CR>
    "nnoremap <silent> ;aa   :TabberSelectLastActive<CR>
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
    vnoremap <silent> ;ww :<C-u>Ydv<CR>
    nnoremap <silent> ;ww :<C-u>Ydc<CR>
    "noremap <leader>yd :<C-u>Yde<CR>
elseif executable('~/tools/dict')
    nmap ;ww :R! ~/tools/dict <C-R>=expand('<cword>') <cr>
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
endif


if CheckPlug('vim-which-key', 1) | " {{{1
    "noremap <silent> ;?            :<c-u>WhichKey ';'<cr>
    "noremap <silent> <leader>?     :<c-u>WhichKey '<leader>'<cr>
endif


if CheckPlug('vim-argwrap', 1) | " {{{1
    nnoremap <silent> <leader>A :ArgWrap<CR>
    Shortcut! <space>A    Format arguments
endif

