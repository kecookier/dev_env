let mapleader = ";"    " 比较习惯用;作为命令前缀，右手小拇指直接能按到

set foldenable
" 设置语法折叠
set foldmethod=marker
" 设置折叠区域的宽度
set foldcolumn=0
" 设置折叠层数为
setlocal foldlevel=1
" 新建的文件，刚打开的文件不折叠
autocmd! BufNewFile,BufRead * setlocal nofoldenable


" Plugins " {{{

" 加载插件管理器
" ~/.vim/autoload/pathogen.vim, 之后会自动加载 ~/.vim/bundle/ 目录的所有插件
execute pathogen#infect()
syntax on
filetype plugin indent on

" 插件窗口的宽度，如TagList,NERD_tree等，自己设置
let s:PlugWinSize = 30

" Bundle: taglist
" http://www.vim.org/scripts/script.php?script_id=273
" <leader>t 打开TagList窗口，窗口在右边
nmap <silent> <leader>t :TlistToggle<cr>
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1 "只显示当前buffer的文件
let Tlist_Exit_OnlyWindow = 1 "如果只剩下taglist的window，那么vim直接退出
let Tlist_Use_Right_Window = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 0 "打开侧边栏时，光标不移动到侧边栏，停留在当前位置
let Tlist_WinWidth = s:PlugWinSize
let Tlist_Auto_Open = 0 "启动vim时，不自动打开侧边栏
let Tlist_Display_Prototype = 0
"let Tlist_Close_On_Select = 1


" Bundle: OnnicppComplete
" http://www.vim.org/scripts/script.php?script_id=1520
set completeopt=menu
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_DefaultNamespaces = ["std"]     " 逗号分割的字符串
let OmniCpp_MayCompleteScope = 1
"let OmniCpp_ShowPrototypeInAbbr = 0
let OmniCpp_SelectFirstItem = 2
" c-j自动补全，当补全菜单打开时，c-j,k上下选择
imap <expr> <c-j>      pumvisible()?"\<C-N>":"\<C-X><C-O>"
imap <expr> <c-k>      pumvisible()?"\<C-P>":"\<esc>"
" f:文件名补全，l:行补全，d:字典补全，]:tag补全
imap <C-]>             <C-X><C-]>
imap <C-F>             <C-X><C-F>
imap <C-D>             <C-X><C-D>
imap <C-L>             <C-X><C-L>


" Bundle: nerdcommenter
" http://www.vim.org/scripts/script.php?script_id=1218
" Toggle单行注释/“性感”注释/注释到行尾/取消注释
map <leader>cc ,c<space>
map <leader>cs ,cs
map <leader>c$ ,c$
map <leader>cu ,cu


" Bundle: NERD_tree
" http://www.vim.org/scripts/script.php?script_id=1658
let NERDTreeShowHidden = 1
let NERDTreeWinPos = "right"
let NERDTreeWinSize = s:PlugWinSize
nmap <leader>n :NERDTreeToggle<cr>
nmap <leader>r :NERDTreeFind<cr>


" Bundle: ctags and scope
" 更新ctags和cscope索引
" href: http://www.vimer.cn /2009/10/把vim打造成一个真正的ide2.html
" 稍作修改，提取出DeleteFile函数，修改ctags和cscope执行命令
map <F6> :call Do_CsTag()<cr>
function! Do_CsTag()
    let dir = getcwd()

    "先删除已有的tags和cscope文件，如果存在且无法删除，则报错。
    if ( DeleteFile(dir, "tags") )
        return
    endif
    if ( DeleteFile(dir, "cscope.files") )
        return
    endif
    if ( DeleteFile(dir, "cscope.out") )
        return
    endif

    if(executable('ctags'))
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:isWin)
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find . -iname '*.[ch]' -o -name '*.cpp' > cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
    " 刷新屏幕
    execute "redr!"
endfunction

function! DeleteFile(dir, filename)
    if filereadable(a:filename)
        if (g:isWin)
            let ret = delete(a:dir."\\".a:filename)
        else
            let ret = delete("./".a:filename)
        endif
        if (ret != 0)
            echohl WarningMsg | echo "Failed to delete ".a:filename | echohl None
            return 1
        else
            return 0
        endif
    endif
    return 0
endfunction

" cscope 绑定
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
    " s: C语言符号  g: 定义     d: 这个函数调用的函数 c: 调用这个函数的函数
    " t: 文本       e: egrep模式    f: 文件     i: include本文件的文件
    nmap <leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>
endif


" Bundle: QuickFix
" Quick Fix 设置
map <leader>cw :cw<cr>
map <F3> :cp<cr>
map <F4> :cn<cr>
set cscopequickfix=s-,c-,d-,i-,t-,e-


" Bundle: LookupFile
" http://www.vim.org/scripts/script.php?script_id=1581 增加一行（line 295）: let pattern = '\c' . a:pattern
" 按F5或者;ff打开文件搜索窗口, 使用当前目录下的filenametag文件作为搜索文件
nmap <silent> <leader>ff :LookupFile<cr>
if filereadable("./filenametags")
  let g:LookupFile_TagExpr = '"./filenametags"'
endif
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 0     "不保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
let g:LookupFile_SortMethod = ""                "关闭对搜索结果的字母排序
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'


" Bundle: bufexplorer
" https://www.vim.org/scripts/script.php?script_id=42
"let g:bufExplorerDefaultHelp=0       " Do not show default help.
"let g:bufExplorerShowRelativePath=1  " Show relative paths.
"let g:bufExplorerSortBy='mru'        " Sort by most recently used.
"let g:bufExplorerSplitRight=0        " Split left.
"let g:bufExplorerSplitVertical=1     " Split vertically.
"let g:bufExplorerSplitVertSize = s:PlugWinSize  " Split width
"let g:bufExplorerUseCurrentWindow=1  " Open in new window.
"autocmd BufWinEnter \[Buf\ List\] setl nonumber


" Bundle: DarwIt
" https://www.vim.org/scripts/script.php?script_id=40
" <leader>di  开始画图
" <leader>ds  结束画图


" Bundle: clang-format
" " vim集成
" https://clang.llvm.org/docs/ClangFormat.html?spm=ata.13261165.0.0.2efb343d5C1RZq#vim-integration
" " .clang-format格式说明文档
" https://clang.llvm.org/docs/ClangFormatStyleOptions.html
" map <silent> <leader>kk :pyf /usr/local/share/clang/clang-format.py<cr>
map <silent> <leader>kk :pyf /usr/share/clang/clang-format.py<cr>
map <silent> <leader>ka :%pyf /usr/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<cr>
function! Formatonsave()
    let l:formatdiff = 1
"    pyf /usr/share/clang/clang-format.py
" in macos
    py3f /usr/local/Cellar/clang-format/14.0.3/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()
" // clang-format off
" // 这段代码我不想被格式化
" // clang-format on


" Bundle: Winmanager
" winManager setting
" http://www.vim.org/scripts/script.php?script_id=95
"let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:winManagerWindowLayout = "FileExplorer,BufExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
"let g:bufExplorerMaxHeight=40
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>


" Bundle: FSwitch
" http://www.vim.org/scripts/script.php?script_id=2590
"可以用:A在.h/.cpp间切换
cabbrev A FSHere
"可以用:V在.h/.cpp间切换, 分屏打开
cabbrev L FSSplitLeft
cabbrev R FSSplitRight
au! BufEnter *.h let b:fswitchlocs='reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|,reg:!sscc\(/[^/]\+\|\)/.*!libs\1/**!'
au! BufEnter *.c,*.cpp let b:fswitchlocs='reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|,reg:|libs/.*|**|'


" Bundle: vim-colors-solarized
set background=dark
"set background=light
let g:solarized_visibility = "low"
"colorscheme solarized
"colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set t_Co=256

" " }}}

" set基础设置 " {{{
if (has("win32") || has("win64") || has("win32unix"))
    let g:isWin = 1
else
    let g:isWin = 0
endif
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
set nobackup        " 关闭备份
set noswapfile      " 不使用swp文件，注意，错误退出后无法恢复
set lbr             " 在breakat字符处而不是最后一个字符处断行
set nocompatible    " 关闭vi兼容模式
set number          " 显示行号
set showcmd         " 显示命令
set lz              " 当运行宏时，在命令执行完成之前，不重绘屏幕
set hid             " 可以在没有保存的情况下切换buffer
"set textwidth=120
set autoindent      " 自动缩进
set smartindent     " 智能缩进
set cindent         " C/C++风格缩进
set autoindent      " 自动缩进,和上一行一样缩进

" command line completion operates show match above command line
set wildmenu

" tab转化为2个字符
set expandtab
set smarttab
set shiftwidth=2    " indent space
set tabstop=2       " tab space character

set backspace=eol,start,indent " 设置随意删除,删除到上一行
set whichwrap+=<,>,h,l " 退格键和方向键可以换行

set incsearch       " 在输入要搜索的文字时，vim会实时匹配
set hlsearch        " 高亮搜索
set ignorecase
set magic           " 额，自己:h magic吧，一行很难解释
set showmatch       " 显示匹配的括号,类似当输入一个左括号时会匹配相应的那个右括号

" 不使用beep或flash
set vb t_vb=
set history=400  " vim记住的历史操作的数量，默认的是20
set autoread     " 当文件在外部被修改时，自动重新读取
set mouse=v      " 在所有模式下都允许使用鼠标，还可以是n,v,i,c等
" " }}}

" 快捷键 {{{
map <silent> <leader>ee :e $HOME/.vimrc<cr>
autocmd! bufwritepost *.vimrc source $HOME/.vimrc
nmap <leader>ww :w!<cr>
nmap <C-Z> :shell<cr>
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "<cr>"
    else
        execute "normal /" . l:pattern . "<cr>"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" 用 */# 向 前/后 搜索光标下的单词
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" 用c-j,k在buffer之间切换
nn <C-J> :bn<cr>
nn <C-K> :bp<cr>
" }}}


syntax enable       " 语法高亮
filetype plugin on  " 文件类型插件
autocmd BufEnter * :syntax sync fromstart "Highlight from start of file

" 设置字符集编码，默认使用utf8
if (g:isWin)
    let &termencoding=&encoding " 通常win下的encoding为cp936
    set fileencodings=utf8,cp936,ucs-bom,latin1,gbk,gb2312,gb18030
else
    set encoding=utf8
    set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,latin1
    set termencoding=utf-8
endif

" 状态栏
set laststatus=2      " 总是显示状态栏
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction
"set statusline=[%n]\ %f%m%r%h\ \|\ \ pwd:\ %{CurDir()}\ \ \|%=\|\ %l,%c\ %p%%\ \|\ ascii=%b,hex=%b%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}\ \|\ %{$USER}\ @\ %{hostname()}\


" 恢复上次文件打开位置
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" 删除buffer时不关闭窗口
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction



" Coding "{{{
if has("win32")
    au FileType c,cpp setlocal tags+=$VIM/tags/stl.tags,$VIM/tags/boost.tags
else
    au FileType c,cpp setlocal tags+=$HOME/.tags/stl.tags,$HOME/.tags/boost.tags
endif

set completeopt=menuone,menu,longest,preview  " 智能补全

" Highlight space errors in C/C++ source files (Vim tip #935)
let c_space_errors=1
let java_space_errors=1

"设置C++搜索路径
if has("win32")
    set path=.,e:\Program\\\ Files\Microsoft\\\ Visual\\\ Studio\\\ .NET\\\ 2003\Vc7\include,e:\Program\\\ Files\Microsoft\\\ Visual\\\ Studio\\\ .NET\\\ 2003\Vc7\atlmfc\include,e:\libs\boost_1_43_0\boost,,
endif
" "}}}

" Coding Helper Functions "{{{
function! RemoveTrailingSpace()
    if $VIM_HATE_SPACE_ERRORS != '0' &&
          \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'python' || &filetype == 'vim')
        normal m`
        silent! :%s/\s\+$//e
        normal ``
    endif
endfunction

function! SetupForCLang()
    if has("cscope")
        let db = findfile("cscope.out", ";")
        if (!empty(db))
            let path = strpart(db, 0, match(db, "/cscope.out$"))
            set nocscopeverbose " suppress 'duplicate connection' error
            exe "cs add " . db . " " . path
            set cscopeverbose
        endif
    endif

    if findfile("Jamfile", ";") != "" ||
       \findfile("Jamroot", ";") != "" ||
       \findfile("Jamfile.v2", ";") != "" ||
       \findfile("Jamroot.v2", ";") != ""
        set makeprg=bjam
    endif

    if findfile("BUILD", ";") != ""
        set makeprg=blade
    endif

endfunction

" Command and Auto commands " {{{
" Sudo write
" comm! W exec 'w !sudo tee % > /dev/null' | e!

"Auto commands

if has("win32")
  au GUIEnter * simalt ~x " 启动时自动全屏
endif

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif " restore position in file

au! BufNewFile * set fenc=utf8 ff=unix

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" " }}}

" Filetype detection " {{{
au BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru} setf ruby
au BufRead,BufNewFile {*.md,*.mkd,*.markdown} setf markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}  setf gitcommit

" Recognize standard C++ headers
au BufEnter /usr/include/c++/*          setf cpp
au BufEnter /usr/include/g++-3/*        setf cpp

au BufRead,BufNewFile todo.txt,done.txt setf todo
au BufRead,BufNewFile *.mm              setf xml
au BufRead,BufNewFile *.proto           setf proto
au BufRead,BufNewFile Jamfile*,Jamroot* setf jam
au BufRead,BufNewFile BUILD*,BLADE_ROOT* setf blade
au BufRead,BufNewFile pending.data,completed.data setf task
" "}}}

" Filetype related autosettings " {{{
au FileType jam   set makeprg=bjam
au FileType blade set makeprg=blade
au FileType diff  setlocal shiftwidth=2 tabstop=2
au FileType html  setlocal autoindent indentexpr=
au FileType changelog setlocal textwidth=76
" 把-等符号也作为xml文件的有效关键字，可以用Ctrl-N补全带-等字符的属性名
au FileType {xml,xslt} setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235
au FileType xml        exe 'setlocal equalprg=xmllint\ --format\ --recover\ -'
" "}}}

" 根据不同的文件类型设定<F3>时应该查找的文件 "{{{
au FileType *             let b:vimgrep_files=expand("%:e") == "" ? "**/*" : "**/*." . expand("%:e")
au FileType c,cpp         let b:vimgrep_files="**/*.cpp **/*.cxx **/*.c **/*.h **/*.hpp"
au FileType php           let b:vimgrep_files="**/*.php **/*.htm **/*.html"
au FileType cs            let b:vimgrep_files="**/*.cs"
au FileType vim           let b:vimgrep_files="**/*.vim"
au FileType javascript    let b:vimgrep_files="**/*.js **/*.htm **/*.html"
au FileType python        let b:vimgrep_files="**/*.py"
au FileType xml           let b:vimgrep_files="**/*.xml"
" "}}}

" C++ code auto commands "{{{
au FileType c,cpp inoremap  <buffer>  /**<CR>     /**<CR><CR>/<Esc>kA<Space>@brief<Space>
au FileType c,cpp inoremap  <buffer>  /**<        /**<<Space>@brief<Space><Space>*/<Left><Left><Left>
au FileType c,cpp vnoremap  <buffer>  /**<        /**<<Space>@brief<Space><Space>*/<Left><Left><Left>
au FileType c,cpp inoremap  <buffer>  /**<Space>  /**<Space>@brief<Space><Space>*/<Left><Left><Left>
au FileType c,cpp vnoremap  <buffer>  /**<Space>  /**<Space>@brief<Space><Space>*/<Left><Left><Left>

au FileType c,cpp setlocal include=^\\s*#\\s*include\\s*\"\\zs[^\"]*\\ze\"

" Detect if the current file type is a C-like language.
au BufNewFile,BufRead *.h,*.c,*.cpp,*.objc,*.mm call SetupForCLang()

" Setting for files following the GNU coding standard
au BufEnter /usr/*                  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1  shiftwidth=2  tabstop=8

"" Remove trailing spaces for C/C++, Python and Vim files
au BufWritePre *                  call RemoveTrailingSpace()

" "}}}

" python autocommands "{{{

" Python 自动补全功能，用 Ctrl-N 调用
" isk+=.,表示把小数点和逗号作为word的一部分
" 需要把从http://www.vim.org/scripts/script.php?script_id=850下载的
" pydiction文件放到~/.vim下
"au FileType python set complete+=k~/.vim/tools/pydiction "isk+=.,
let g:pydiction_location = '~/.vim/tools/pydiction/complete-dict'
"defalut g:pydiction_menu_height == 15
""let g:pydiction_menu_height = 20

" 设定python的makeprg
au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"au FileType python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
au FileType python set efm=%[%^(]%\\+('%m'\\,\ ('%f'\\,\ %l\\,\ %v\\,%.%#
au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
" "}}}


augroup filetype
    autocmd! BufRead,BufNewFile BUILD set filetype=blade
augroup end
hi ColorColumn ctermbg=Black guibg=lightgrey
set term=xterm
set term=screen-256color
set cursorline
set cc=120
:hi CursorLine cterm=underline ctermbg=none
silent! colors zenburn

" execute project related configuration in current directory "{{{
autocmd VimEnter * :call s:ReadSession()
function! s:ReadSession()
    let session_file = "./session.vim"
    if filereadable( session_file )
        execute "so " . session_file
    endif
endfunction

autocmd VimLeave * :call s:WriteSession()
function! s:WriteSession()
    let session_file = "./session.vim"
    if filereadable( session_file )
        execute "mks! " . session_file
    endif
endfunction
" }}}


" ===== 2026-10 dev_env 调优（配合 tmux/Ghostty）=====
set mouse=a
if has('termguicolors')
    set termguicolors
endif
