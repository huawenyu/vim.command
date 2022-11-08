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
            nnoremap <silent> <a-w>                                             :MaximizerToggle<cr>
            nnoremap <silent> <leader>vw     :"(view)maximize Windows      "<c-U>MaximizerToggle<cr>
        elseif HasPlug('maximize')
            nnoremap <silent> <a-w>                                             :MaximizeWindow<cr>
            nnoremap <silent> <leader>vw     :"(view)maximize Windows      "<c-U>MaximizeWindow<cr>
        else
            nnoremap <silent> <a-w>                                              :ZoomToggle<cr>
            nnoremap <silent>  <leader>vw     :"(view)maximize Windows      "<c-U>ZoomToggle<cr>

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
            nnoremap <silent> <a-e>                                     :NERDTreeTabsToggle<cr>
            nnoremap <silent>  <leader>ve    :"(view)Explore       "<c-U>NERDTreeTabsToggle<cr>
        elseif HasPlug('nerdtree')
            nnoremap <silent> <a-e>                                     :NERDTreeToggle<cr>
            nnoremap <silent>  <leader>ve    :"(view)Explore       "<c-U>NERDTreeToggle<cr>
        endif

        " Paste in insert mode: don't know who reset this, set again here
        inoremap <silent> <a-i> <c-r>"

        nnoremap <silent>  <a-'>   :VoomToggle<cr>
        nnoremap <silent>  <a-;>   :QFix<cr>
        nnoremap <silent>  <a-/>   :call <SID>ToggleTagbar()<cr>
        nnoremap <silent>  <leader>vo     :"(view)Outline          "<c-U>VoomToggle<cr>
        nnoremap <silent>  <leader>vq     :"(view)Quickfix         "<c-U>QFix<cr>
        nnoremap <silent>  <leader>vt     :"(view)Taglist          "<c-U>call <SID>ToggleTagbar()<cr>

        "nnoremap <silent> <a-;> :TMToggle<CR>
        "nnoremap <silent> <a-.> :BuffergatorToggle<CR>
        "nnoremap <silent> <a-,> :VoomToggle<CR>
        "nnoremap <silent> <a-[> :Null<CR>
        "nnoremap <silent> <a-]> :Null<CR>
        "nnoremap <silent> <a-\> :Null<CR>

        nnoremap <silent>   ;vi         :"(helper)Insert outline header     "<c-U>call utils#VoomInsert(0) <CR>
        vnoremap <silent>   ;vi                                             :<c-U>call utils#VoomInsert(1) <CR>
    " Sugar {{{2
        silent! Shortcut! <space>m    [vim.command] 1.Marks colorize word; 2.Make; 3.Improve quickfix; 4.Macro record/play;

        " bookmark/color
        if HasPlug('vim-mark')
            nnoremap <silent> <leader>mm  :"(color)Toggle Colorize word        "<c-U>silent! call mark#MarkCurrentWord(expand('<cword>'))<cr>
            "vnoremap <silent> <leader>mm  :<c-u>silent! call mark#GetVisualSelection()<cr>
            nnoremap <silent> <leader>mx  :"(color)Clear all colorize word   "<c-U>silent! call mark#ClearAll()<cr>
        endif


        " Suppose record macro in register `q`:
        "vnoremap <leader>mm  :normal @q
        if HasPlug('vim-macroscope')
            "nnoremap <leader>mr     :<c-U>Macroscope
            "nnoremap <leader>mp     :<c-U>Macroplay<cr>
        endif


        if HasPlug('rainbow_parentheses.vim')
            nnoremap <silent> <leader>m[   :"Colorize brace     "<c-U>RainbowParentheses!!<cr>
        endif


    " File helper {{{2
        nnoremap                 ;ss     :"Save file as          "<c-U>FileSaveAs<space>
        nnoremap <silent> <leader>ss     :"Save file as          "<c-U>FileSaveAs<cr>

        "[Cause command mode pause when press 'w', note:map](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
        "For when you forget to sudo.. Really Write the file.
        cmap <C-w> w !sudo tee % >/dev/null

        " Toggle source/header
        "nnoremap <silent> <leader>a  :<c-u>FuzzyOpen <C-R>=printf("%s\\.", expand('%:t:r'))<cr><cr>
        nnoremap <silent> <leader>a  :"(*)Toggle source/header   "<c-U>call CurtineIncSw()<cr>

        if HasPlug('vim-sleuth')
            nnoremap <leader>fd :"Auto detect indent   "<c-U>Sleuth<cr>
        elseif HasPlug('detectindent')
            nnoremap <leader>fd :"Auto detect indent   "<c-U>DetectIndent<cr>
        endif

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
        nnoremap <leader>cw     vip:"(*)Auto wrapline paragraph   "<c-U>'<,'>!fmt -c -w 100 -u -s <cr>
        vnoremap <leader>cw     :!fmt -c -w 100 -u -s <cr>

    " repl/execute {{{2
        "if mapcheck('<leader>ee', 'n') == ""
        "    "" execute file that I'm editing in Vi(m) and get output in split window
        "    "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
        "    "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
        "    "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

        "    silent! Shortcut! <space>ee    Tool compile & run
        "    nnoremap <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
        "    silent! Shortcut! <leader>eo    Tool View Result
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
        endif


        silent! Shortcut! <space>y     [vim.command] Copy: <y*> yy-Copy-to-tmpfile, yp-Paste-from-tmpfile

        vnoremap <silent> <leader>yy    :<c-u>call utils#GetSelected('v', "/tmp/vim.yank")<CR>
        nnoremap <silent> <leader>yy    :"Copy text to tmpfile       "<c-U>call vimuxscript#Copy() <CR>
        nnoremap <silent> <leader>yp    :"Paste text from tmpfile    "<c-U>r! cat /tmp/vim.yank<CR>

        xnoremap *      :<c-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR>
        xnoremap #      :<c-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR>
        vnoremap // y   :vim /\<<C-R>"\C/gj %


    " Text/Motion {{{2
        silent! Shortcut! <space>c     [vim.command] Text Uppercase word: <c*> Capitalize, Uppercase, Lowercase

        nnoremap <leader>cc :"Text Capitalize word        "<c-U>CapitalizeWord<CR>
        nnoremap <leader>cu :"Text UPPERCASE word         "<c-U>UppercaseWord<CR>
        nnoremap <leader>cl :"Text lowercase word         "<c-U>LowercaseWord<CR>
        nnoremap <leader>c<space> :"Text Just one space        "<c-U>JustOneInnerSpace<CR>
        nnoremap <leader>cd :"Text remove trailing spaces"<c-U>RemoveTrailingSpaces<CR>

    " Git/grep {{{2
        " Search {{{3
            " Search-mode: hit cs, replace first match, and hit <Esc>
            "   then hit n to review and replace
            vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
                  \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
            onoremap s :normal vs<CR>

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

                silent! Shortcut! <space>g     [vim.command] Git: <g*> gutteR, Nexthunk, PrevHunk, stAge, Undo

                nnoremap <silent> <leader>gv   :"(git)GutterToggle          "<c-U>GitGutterToggle <cr>
                nnoremap <silent> <leader>gr   :"(git)Gutter                "<c-U>GitGutter <cr>
                "nnoremap <silent> <leader>gf  :"(git)Gutter sink-to QuickFix "<c-U>GitGutterQuickFix \| copen <cr>

                " Jump between hunks
                nnoremap <silent> <leader>gn   <Plug>(GitGutterNextHunk)
                nnoremap <silent> <leader>gp   <Plug>(GitGutterPrevHunk)

                " Hunk-add and hunk-revert for chunk staging
                nnoremap <silent> <leader>ga   <Plug>(GitGutterStageHunk)
                nnoremap <silent> <leader>gu   <Plug>(GitGutterUndoHunk)
            endif

            if HasPlug('vim-fugitive')
                silent! Shortcut! <space>g     [vim.command] Git: <gt*> tig-explore;  <g*> Diff, Diff-review, Blame, Status

                "nnoremap <leader>bb :VCBlame<cr>
                nnoremap <leader>gl     :"(git)Log side by side    "<c-U>GV<cr>
                nnoremap <leader>gd     :"(git)Diff review         "<c-U>Gvdiff<cr>
                nnoremap <leader>gD     :"(git)Diff review tabs    "<c-U>DiffReview git show
                nnoremap <leader>gb     :"(git)Blame               "<c-U>Git blame<cr>
                nnoremap        ;bb     :"(git)Blame               "<c-U>Git blame<cr>
                nnoremap <leader>gs     :"(git)Status              "<c-U>Gstatus<cr>
            endif

            if HasPlug('tig-explorer.vim')
                nnoremap <leader>gL     :"(tig)Log                 "<c-U>Tig<cr>
                nnoremap <leader>gp     :"(tig)Log --parent        "<c-U>Tig --first-parent -m<cr>
                nnoremap <leader>gP     :"(tig)Log --parent all    "<c-U>Tig --first-parent --all<cr>
                nnoremap <leader>gB     :"(tig)Blame               "<c-U>TigBlame<cr>
            endif

            nnoremap <leader>gc         :"(git)clean-dryrun        "<c-U>AsyncStop! <bar> AsyncTask gitclean-dryrun<cr>
            nnoremap <leader>gx         :"(git)clean               "<c-U>AsyncStop! <bar> AsyncTask gitclean<cr>


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

