" Version:      1.0

if exists('g:loaded_local_map2') || &compatible
  finish
else
  let g:loaded_local_map2 = 'yes'
endif


" Help {{{1
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

" Key unmap plugin {{{1
    if HasPlug('DrawIt')
        " release map <leader>w, <leader>r
        unmap <leader>swp
        unmap <leader>rwp
    endif

    if HasPlug('DrawIt')
        unmap <leader>g
    endif


" Key maps {{{1
    " view {{{2
        " toggles the quickfix window.
        command -bang -nargs=? QFix call QFixToggle(<bang>0)
        function! QFixToggle(forced)
            if exists("g:qfix_win") && a:forced == 0
                cclose
                unlet g:qfix_win
            else
                botright copen
                let g:qfix_win = bufnr("$")
            endif
        endfunction

        "nnoremap <f3> :VimwikiFollowLink
        if HasPlug('vim-maximizer')
            nnoremap <silent> <a-w> :MaximizerToggle<CR>
        elseif HasPlug('maximize')
            nnoremap <silent> <a-w> :MaximizeWindow<CR>
        else
            nnoremap <silent> <a-w> :ZoomToggle<CR>

            " Zoom / Restore window.
            function! s:ZoomToggle() abort
                if exists('t:zoomed') && t:zoomed
                    execute t:zoom_winrestcmd
                    let t:zoomed = 0
                else
                    let t:zoom_winrestcmd = winrestcmd()
                    resize
                    vertical resize
                    let t:zoomed = 1
                endif
            endfunction

            command! ZoomToggle call s:ZoomToggle()
        endif
        if HasPlug('vim-nerdtree-tabs')
            nnoremap <silent> <a-e> :NERDTreeTabsToggle<cr>
        elseif HasPlug('nerdtree')
            nnoremap <silent> <a-e> :NERDTreeToggle<cr>
        endif

        "nnoremap <silent> <a-f> :Null<CR>
        "nnoremap <silent> <a-g> :Null<CR>
        "nnoremap <silent> <a-q> :Null<CR>

        " Paste in insert mode: don't know who reset this, set again here
        inoremap <silent> <a-i> <c-r>"

        nnoremap <silent> <a-'> :VoomToggle<cr>
        nnoremap <silent> <a-;> :QFix<CR>
        nnoremap <silent> <a-/> :<c-u>call <SID>ToggleTagbar()<CR>
        "nnoremap <silent> <a-;> :TMToggle<CR>
        "nnoremap <silent> <a-.> :BuffergatorToggle<CR>
        "nnoremap <silent> <a-,> :VoomToggle<CR>
        "nnoremap <silent> <a-[> :Null<CR>
        "nnoremap <silent> <a-]> :Null<CR>
        "nnoremap <silent> <a-\> :Null<CR>

        Shortcut!  <a-'>    View outline
        Shortcut!  <a-;>    View taglist
        Shortcut!  <a-e>    View NerdTree
        Shortcut!  <a-w>    View Maximize window

        nnoremap          <leader>f] :AsyncStop! <bar> AsyncTask! tagme<cr>
        nnoremap <silent> <leader>vi :call utils#VoomInsert(0) <CR>
        vnoremap <silent> <leader>vi :call utils#VoomInsert(1) <CR>
        Shortcut!  <space>vi    Help outline insert
        Shortcut!  <space>f]    Tag generate

        nnoremap <silent> <leader>vc :<c-u>Goyo<CR>
        nnoremap <silent> <leader>vp :<c-u>TogglePencil<CR>
        Shortcut!  <space>vc    Toggle Goyo
        Shortcut!  <space>vp   Toggle Pencil


    " Sugar {{{2
        " bookmark/color
        if HasPlug('vim-mark')
            nnoremap <silent> <leader>mm  :<c-u>silent! call mark#MarkCurrentWord(expand('<cword>'))<cr>
            "vnoremap <silent> <leader>mm  :<c-u>silent! call mark#GetVisualSelection()<cr>
            nnoremap <silent> <leader>mx  :<c-u>silent! call mark#ClearAll()<cr>

            Shortcut! <space>mm    Toggle Mark current-word
            Shortcut! <space>mx    Toggle Mark clear all
        endif


        " Suppose record macro in register `q`:
        "vnoremap <leader>mm  :normal @q
        if HasPlug('vim-macroscope')
            nnoremap <leader>mr     :<c-u>Macroscope
            nnoremap <leader>mp     :<c-u>Macroplay<cr>
            Shortcut! <space>mr    Macro edit `qq`, save by `s`, play by `mp`
        endif


        if HasPlug('rainbow_parentheses.vim')
            nnoremap <silent> <leader>m[   :<c-u>RainbowParentheses!!<cr>
            Shortcut! <space>m[    Toggle RainbowParentheses
        endif


        "nnoremap <leader>mf :echo(statusline#GetFuncName())<CR>
        "nnoremap <leader>mo :BookmarkLoad Default
        "nnoremap <leader>ma :BookmarkShowAll <CR>
        "nnoremap <leader>mg :BookmarkGoto <C-R><c-w>
        "nnoremap <leader>mc :BookmarkDel <C-R><c-w>

    " File helper {{{2
        nnoremap <leader>ss     :<c-u>FileSaveAs<space>
        nnoremap        ;ss     :FileSaveAs<cr>
        nnoremap <leader>fo     :W3m <c-r>=hw#misc#GetWord('http')<cr><cr>

        Shortcut! <space>ss     File Saveas
        Shortcut!       ;ss     File Save directly
        Shortcut! <space>fo     File Open doc
        "Shortcut! <space>fi     Terminal Open

        "[Cause command mode pause when press 'w', note:map](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
        "For when you forget to sudo.. Really Write the file.
        cmap <C-w> w !sudo tee % >/dev/null

        " Toggle source/header
        "nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>
        nnoremap <silent> <leader>a  :<c-u>call CurtineIncSw()<cr>
        Shortcut!  <space>a    Toggle header c/h

        if HasPlug('vim-sleuth')
            nnoremap <leader>fd :Sleuth<cr>
        elseif HasPlug('detectindent')
            nnoremap <leader>fd :DetectIndent<cr>
        endif
        Shortcut!  <space>fd    Help Detect Indent

        " Set log
        "nnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
        "vnoremap <silent> <leader>ll :<c-u>call log#log(expand('%'))<CR>
        " Lint: -i ignore-error and continue, -s --silent --quiet

    " Format {{{2
        " Reserve to cscope/ctags
        " vnoremap <Leader>ff =<cr>
        " nnoremap <Leader>ff =<cr>

        "     Most UNIX-like programming environments offer generic tools for formatting text. These include fmt, fold, sed, perl, and par. 
        "     vnoremap qq c<C-R>=system('wc -c | perl -pe chomp', @")<CR><ESC>
        "autocmd FileType vimwiki vnoremap <leader>ff :!fmt -c -w 100 -u -s <cr>
        vnoremap <leader>ft :!fmt -c -w 100 -u -s <cr>
        Shortcut! <space>ft    Format align lines

    " repl/execute {{{2
        "if mapcheck('<leader>ee', 'n') == ""
        "    "" execute file that I'm editing in Vi(m) and get output in split window
        "    "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
        "    "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
        "    "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

        "    Shortcut! <space>ee    Tool compile & run
        "    nnoremap <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
        "    Shortcut! <leader>eo    Tool View Result
        "    nnoremap <leader>eo :SCViewResult<CR>
        "endif

        "nnoremap <leader>el :VlogDisplay \| Messages \| VlogClear<CR><CR>


    " Copy/paste {{{2
        " " vp doesn't replace paste buffer
        " function! RestoreRegister()
        "     let @" = s:restore_reg
        "     let @+ = s:restore_reg | " sometime other plug use this register as paste-buffer
        "     return ''
        " endfunction
        " function! s:Repl()
        "     let s:restore_reg = @"
        "     return "p@=RestoreRegister()\<cr>"
        " endfunction
        " vnoremap <silent> <expr> p <sid>Repl()

        "" FIXME: Revert this f70be548
        "" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
        "map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

        " Yank from the cursor to the end of the line, to be consistent with C and D.
        nnoremap Y y$
        if HasPlug('vim-oscyank')
            let g:oscyank_max_length = 1000000
            "let g:oscyank_term = 'tmux'  " or 'screen', 'kitty', 'default'
            let g:oscyank_term = 'tmux'
            vnoremap Y :OSCYank<CR>
            "vnoremap Y :call YankOSC52(getreg('+'))<CR>
            Shortcut! Y     Text copy to client-remote-OS
        endif


        vnoremap <silent> <leader>yy :<c-u>call utils#GetSelected('v', "/tmp/vim.yank")<CR>
        nnoremap <silent> <leader>yy :<c-u>call vimuxscript#Copy() <CR>
        nnoremap <silent> <leader>yp :r! cat /tmp/vim.yank<CR>
        Shortcut! <space>yy     Text copy to a tmp/file

        xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
        xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
        vnoremap // y:vim /\<<C-R>"\C/gj %


    " Text/Motion {{{2
        nnoremap <leader>tc :CapitalizeWord<CR>
        nnoremap <leader>tu :UppercaseWord<CR>
        nnoremap <leader>tl :LowercaseWord<CR>
        nnoremap <leader>tos :JustOneInnerSpace<CR>
        nnoremap <leader>tts :RemoveTrailingSpaces<CR>

        Shortcut! <space>tc     Text Capitalize word
        Shortcut! <space>tu     Text UPPERCASE word
        Shortcut! <space>tl     Text lowercase word
        Shortcut! <space>tos    Text Just one space   " just one space on the line, preserving indent
        Shortcut! <space>tts    Text remove trailing spaces

    " Git/grep {{{2
        " Search {{{3
            " Search-mode: hit cs, replace first match, and hit <Esc>
            "   then hit n to review and replace
            vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
                  \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
            onoremap s :normal vs<CR>

            nnoremap         ;bb    :Rg <c-r>=utils#GetSelected('n')<cr>
            nnoremap  <leader>bb    :Rg <c-r>=utils#GetSelected('n')<cr>
            " vnoremap         ;bb    :<c-u>Rg <c-r>=utils#GetSelected('v')<cr>
            " vnoremap  <leader>bb    :<c-u>Rg <c-r>=utils#GetSelected('v')<cr>

            nnoremap         ;gg    :<C-\>e utilgrep#Grep(0, 0, "daemon/wad", 1)<cr>
            nnoremap  <leader>gg    :<C-\>e utilgrep#Grep(0, 0, "daemon/wad", 1)<cr>
            vnoremap         ;gg    :<C-\>e utilgrep#Grep(0, 1, "daemon/wad", 1)<cr>
            vnoremap  <leader>gg    :<C-\>e utilgrep#Grep(0, 1, "daemon/wad", 1)<cr>

            nnoremap         ;vv    :<C-\>e utilgrep#Grep(0, 0, "", 1)<cr>
            nnoremap  <leader>vv    :<C-\>e utilgrep#Grep(0, 0, "", 1)<cr>
            vnoremap         ;vv    :<C-\>e utilgrep#Grep(0, 1, "", 1)<cr>
            vnoremap  <leader>vv    :<C-\>e utilgrep#Grep(0, 1, "", 1)<cr>

            Shortcut!  ;gg    Search wad
            Shortcut!  ;vv    Search all

            " Giveback the 'g' to git
            " nnoremap ;gg :<C-\>e utilgrep#Grep(0, 0, "daemon/wad", 0)<cr>
            " vnoremap ;gg :<C-\>e utilgrep#Grep(0, 1, "daemon/wad", 0)<cr>
            " nnoremap ;vv :<C-\>e utilgrep#Grep(0, 0, "", 0)<cr>
            " vnoremap ;vv :<C-\>e utilgrep#Grep(0, 1, "", 0)<cr>

            nnoremap gf :<c-u>call utils#GotoFileWithLineNum(0)<CR>
            nnoremap <silent> <leader>gf :<c-u>call utils#GotoFileWithPreview()<CR>
            Shortcut! <space>gf    File Goto preview

        " Git {{{3
            if HasPlug('vim-gitgutter')
                " " Reload all opened files
                "     fun! PullAndRefresh()
                "         set noconfirm
                "         !git pull
                "         bufdo e!
                "         set confirm
                "     endfun

                "     nmap ;gr call PullAndRefresh()
                " " --End

                nnoremap <silent> <leader>gv   :GitGutterToggle <cr>
                nnoremap <silent> <leader>gr   :GitGutter <cr>
                "nnoremap <silent> <leader>gf   :GitGutterQuickFix \| copen <cr>

                " Jump between hunks
                nnoremap <silent> <leader>gn   <Plug>(GitGutterNextHunk)
                nnoremap <silent> <leader>gp   <Plug>(GitGutterPrevHunk)

                " Hunk-add and hunk-revert for chunk staging
                nnoremap <silent> <leader>ga   <Plug>(GitGutterStageHunk)
                nnoremap <silent> <leader>gu   <Plug>(GitGutterUndoHunk)

                Shortcut! <space>gv    Git Gutter Toggle
                Shortcut! <space>gq    Git Gutter Quickfix
                Shortcut! <space>gn    Git Hunk Next
                Shortcut! <space>gp    Git Hunk Prev
                Shortcut! <space>ga    Git Hunk Stage
                Shortcut! <space>gu    Git Hunk Undo
            endif

            if HasPlug('vim-fugitive')
                "nnoremap <leader>bb :VCBlame<cr>
                nnoremap <leader>gl     :GV<CR>
                nnoremap <leader>gd     :Gvdiff<CR>
                nnoremap <leader>gD     :DiffReview git show
                nnoremap <leader>gb     :Git blame<cr>
                nnoremap        ;bb     :Git blame<cr>
                nnoremap <leader>gs     :Gstatus<cr>

                Shortcut! <space>gl     Git log
                Shortcut! <space>gd     Git diff vertical
                Shortcut! <space>gD     Git diff side by side
                Shortcut! <space>gb     Git blame
                Shortcut!       ;gb     Git blame
                Shortcut! <space>gs     Git status
            endif

            if HasPlug('tig-explorer.vim')
                nnoremap <leader>gtl     :Tig<cr>
                nnoremap <leader>gtL     :Tig --first-parent -m<cr>
                nnoremap <leader>gtm     :Tig --first-parent --all<cr>
                nnoremap <leader>gtb     :TigBlame<cr>
                Shortcut! <space>gtl     Git(tig) log
                Shortcut! <space>gtL     Git(tig) log --first-parent -m
                Shortcut! <space>gtb     Git(tig) blame
            endif

            nnoremap <leader>gc     :AsyncStop! <bar> AsyncTask gitclean-dryrun<cr>
            nnoremap <leader>gx     :AsyncStop! <bar> AsyncTask gitclean<cr>
            Shortcut! <space>gc     Git clean dryrun
            Shortcut! <space>gx     Git clean


" Helper fucntion {{{1
" Commands {{{2
    " remove trailing spaces
    " make a separate plugin for the commands
    command! RemoveTrailingSpaces :silent! %s/\v(\s+$)|(\r+$)//g<bar>
                \:exe 'normal ``'<bar>
                \:echo 'Remove trailing spaces and ^Ms.'

    command! JustOneInnerSpace :let pos=getpos('.')<bar>
                \:silent! s/\S\+\zs\s\+/ /g<bar>
                \:silent! s/\s$//<bar>
                \:call setpos('.', pos)<bar>
                \:nohl<bar>
                \:echo 'Just one space'

    command! CapitalizeWord :let pos=getpos('.')<bar>
                \:exe 'normal guiw~'<bar>
                \:call setpos('.', pos)

    command! UppercaseWord :let pos=getpos('.')<bar>
                \:exe 'normal gUiw'<bar>
                \:call setpos('.', pos)

    command! LowercaseWord :let pos=getpos('.')<bar>
                \:exe 'normal guiw'<bar>
                \:call setpos('.', pos)

" Functions {{{2
    function! FileOpenDoc()
        let tmuxWname = trim(system("tmux display-message -p '#W'"))
        exec 'FilePre ~/work/'. tmuxWname. "/doc/"
    endfunction

    function! s:FileSaveAs(fname)
        let cfname = expand('%:t')
        if (cfname == 'tmux.log' && !empty(a:fname))
            let tmuxWname = trim(system("tmux display-message -p '#W'"))
            let cmdstr = "w! ~/work/". tmuxWname. "/doc/". a:fname
            "echomsg cmdstr
            exec cmdstr
        else
            " write only when the file changed
            update
        endif
    endfunction
    command! -nargs=? FileSaveAs call <SID>FileSaveAs( '<args>' )

    function! s:ToggleTagbar()
        " Detect which plugins are open
        if exists('t:NERDTreeBufName')
            let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
        else
            let nerdtree_open = 0
        endif

        if nerdtree_open
            if HasPlug('tagbar')
                let g:tagbar_left = 0
            elseif HasPlug('vista.vim')
                let g:vista_sidebar_position = 'vertical botright'
            endif
        else
            " left
            if utils#IsLeftMostWindow()
                if HasPlug('tagbar')
                    let g:tagbar_left = 1
                elseif HasPlug('vista.vim')
                    let g:vista_sidebar_position = 'vertical topleft'
                endif
            " right
            else
                if HasPlug('tagbar')
                    let g:tagbar_left = 0
                elseif HasPlug('vista.vim')
                    let g:vista_sidebar_position = 'vertical botright'
                endif
            endif
        endif

        if HasPlug('tagbar')
            TagbarToggle
        elseif HasPlug('vista.vim')
            Vista!!
        endif
    endfunction

