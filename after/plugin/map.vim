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
" https://vimways.org/2018/for-mappings-and-a-tutorial/
    " Basic {{{2
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

        noremap  j gj
        vnoremap j gj
        noremap  k gk
        vnoremap k gk
        vnoremap > >gv
        vnoremap < <gv


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
        " @ver5: save & exit insert-mode
        inoremap jj <c-o>:w<cr><ESC>

        " Save in insert mode, comment out it for anoy when you input the letter 'k'.
        "inoremap kk <c-o>:w<cr>

        "nnoremap <silent> ;ww :w!<cr>
        " Temporarily turns off search highlighting
        nnoremap <silent> <Return> :nohls<Return><Return>

        " Lazy macro repeat
        nmap <leader>.  @@


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
        " Finger candy: same-bind a-, c-, leader-
        " Alt+HJKL   move around tmux pane
        " Ctrl+HJKL  move around vim-window/tmux-pane
        nnoremap <silent> <a-o>   :colder<cr>
        nnoremap <silent> <a-i>   :cnewer<cr>

        nnoremap <silent> <leader>o <C-o>
        nnoremap <silent> <leader>i <C-i>
        nnoremap <silent> <leader>; <C-]>
        "inoremap <silent> <leader>[ <C-[>

        " Take as map hole
        "nnoremap <silent> <leader>,,,

        " Substitue for MaboXterm diable <c-h>
        nnoremap <leader>h <c-w>h
        nnoremap <leader>j <c-w>j
        nnoremap <leader>k <c-w>k
        nnoremap <leader>l <c-w>l

        " Replace by vim-tmux-navigator
        "nnoremap <c-h> <c-w>h
        "nnoremap <c-j> <c-w>j
        "nnoremap <c-k> <c-w>k
        "nnoremap <c-l> <c-w>l

        nnoremap <leader>q :<c-u>qa<cr>

        "" Esc too far, use Ctrl+Enter as alternative
        "inoremap <a-CR> <Esc>
        "vnoremap <a-CR> <Esc>

        " Adjust viewports to the same size
        map <leader>= <C-w>=

        " Go to end of parenthesis/brackets/quotes
        " <C-o> is used to issue a normal mode command without leaving insert mode.
        inoremap <C-e>      <C-o>A

        " Navigate quickfix
        nnoremap <silent> <c-n> :cn<cr>
        nnoremap <silent> <c-p> :cp<cr>

        " Navigate locallist
        nnoremap <silent> <leader>n :lne<cr>
        nnoremap <silent> <leader>p :lp<cr>

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
        nnoremap <leader>fo     :<c-u>call FileOpenDoc()<cr>
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


        augroup filetype_auto_eval
            if HasPlug('vim-eval')
                autocmd FileType vim nnoremap <buffer> <leader>ee <Plug>eval_viml
                autocmd FileType vim vnoremap <buffer> <leader>ee <Plug>eval_viml_region
            elseif HasPlug('vim-quickrun')
                autocmd FileType vim noremap <buffer> <leader>ee :QuickRun<cr>
            endif

            autocmd FileType javascript nnoremap <buffer> <leader>ee  :DB mongodb:///test < %
            autocmd FileType javascript vnoremap <buffer> <leader>ee  :'<,'>w! /tmp/vim.js<cr><cr> \| :DB mongodb:///test < /tmp/vim.js<cr><cr>
        augroup END

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
        if mapcheck('<leader>ee', 'n') == ""
            "" execute file that I'm editing in Vi(m) and get output in split window
            "nnoremap <silent> <leader>x :w<CR>:silent !chmod 755 %<CR>:silent !./% > /tmp/vim.tmpx<CR>
            "            \ :tabnew<CR>:r /tmp/vim.tmpx<CR>:silent !rm /tmp/vim.tmpx<CR>:redraw!<CR>
            "vnoremap <silent> <unique> <leader>ee :NR<CR> \| :w! /tmp/1.c<cr> \| :e /tmp/1.c<cr>

            Shortcut! <space>ee    Tool compile & run
            nnoremap <leader>ee :call SingleCompileSplit() \| SCCompileRun<CR>
            Shortcut! <leader>eo    Tool View Result
            nnoremap <leader>eo :SCViewResult<CR>
        endif

        nnoremap <leader>el :VlogDisplay \| Messages \| VlogClear<CR><CR>


    " nvim.terminal map {{{2
        if has("nvim")
            let b:terminal_scrollback_buffer_size = 2000
            let g:terminal_scrollback_buffer_size = 2000

            " Terminal exit-to-text-mode, i: enter interact-mode
            " conflict with gdb mode
            "   tnoremap <Esc> <C-\><C-n>
            tnoremap <c-o>     <C-\><C-n>

            "tnoremap <leader>h <C-\><C-n><c-w>h
            "tnoremap <leader>j <C-\><C-n><c-w>j
            "tnoremap <leader>k <C-\><C-n><c-w>k
            "tnoremap <leader>l <C-\><C-n><c-w>l

            tnoremap <c-h> <C-\><C-n><C-w>h
            tnoremap <c-j> <C-\><C-n><C-w>j
            tnoremap <c-k> <C-\><C-n><C-w>k
            tnoremap <c-l> <C-\><C-n><C-w>l
        endif

    " Show current color's name: zS show syntax[vim-scriptease]
    nnoremap zC :echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")<cr>
    nnoremap zc :echomsg synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")<cr>

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

        " Automatically jump to end of text you pasted
        "vnoremap <silent> y y`]
        vnoremap <silent> p p`]
        nnoremap <silent> p p`]

        " now it is possible to paste many times over selected text
        xnoremap <expr> p 'pgv"'.v:register.'y'

        " Paste in insert mode
        inoremap <silent> <a-i> <c-r>"
        Shortcut! <leader><a-i> Paste in insert mode


        map W <Plug>(expand_region_expand)
        map B <Plug>(expand_region_shrink)

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
            vnoremap         ;bb    :<c-u>Rg <c-r>=utils#GetSelected('v')<cr>
            vnoremap  <leader>bb    :<c-u>Rg <c-r>=utils#GetSelected('v')<cr>

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

