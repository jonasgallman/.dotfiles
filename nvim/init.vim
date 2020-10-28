" Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if &compatible
    set nocompatible
endif

" Declare group for autocmd for whole init.vim, and clear it
" Otherwise every autocmd will be added to group each time vimrc sourced!
augroup vimrc
  autocmd!
augroup END

" Install Plugins ---------------------- {{{
" +----------------+
" | install plugin |
" +----------------+

call plug#begin("$VIMCONFIG/plugged")

" general
Plug 'honza/vim-snippets' " snippets
Plug 'morhetz/gruvbox' " color theme
Plug 'itchyny/lightline.vim' " status bar
Plug 'lambdalisue/suda.vim' " write with sudo'
Plug 'blueyed/vim-diminactive' " dim color of non-focused windows
Plug 'AndrewRadev/splitjoin.vim' " Split arrays in PHP / struct in Go / other things

" git

" syntax highlighting

" lsp
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" markdown / writting
"Plug 'junegunn/goyo.vim', { 'for': 'markdown' } " Distraction-free
"Plug 'junegunn/limelight.vim', { 'for': 'markdown' } " Hyperfocus-writing
"Plug 'godlygeek/tabular' " Align plugin (useful for markdown tables for example)
"Plug 'christoomey/vim-titlecase' " Titlecase with gt
"Plug 'rhysd/vim-grammarous', { 'for': 'markdown' } " show grammar mistakes
"Plug 'reedes/vim-wordy' " Verify quality of writting (see :Wordy)
"Plug 'reedes/vim-lexical' " Dictionnary, thesaurus...
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Golang
Plug 'fatih/vim-go', {'for': 'go'} " general plugin
Plug 'godoctor/godoctor.vim', {'for': 'go'} " refactoring
Plug 'sebdah/vim-delve', {'for': 'go'} " debugger
"Plug 'Phantas0s/go-analyzer.vim' " Custom plugin 
" Plug '$XDG_CONFIG_HOME/workspace/vim-plugins/go-analyzer.vim'

" Javascript
" Plug 'pangloss/vim-javascript'
" Plug 'leafgarland/typescript-vim'
" Plug 'mxw/vim-jsx' " For react
" Plug 'posva/vim-vue' " For Vue

" GDScript (Godot Game Engine)
" Plug 'calviken/vim-gdscript3'

call plug#end()
" }}}
" Plugin Config ---------------------- {{{

" +---------------+
" | plugin config |
" +---------------+

" source every plugin configs
for file in split(glob("$VIMCONFIG/pluggedconf/*.nvimrc"), '\n')
    execute 'source' file
endfor

if exists("g:did_load_filetypes")
  filetype off
  filetype plugin indent off
endif
set runtimepath+=$VIMCONFIG/godoctor.vim
filetype on
filetype plugin indent on

" Impossible to put it in vim-delve.nvimrc file...
let g:delve_breakpoint_sign = ""
let g:delve_tracepoint_sign = ""

" close the buffer
"nnoremap <leader>db :Bdelete!<cr>

"let g:vim_markdown_folding_disabled = 1
" }}}
" General Bindings ---------------------- {{{

" +-----------------+
" | general binding |
" +-----------------+

syntax on

" create horizontal window
nnoremap <c-w>h <c-w>s

" open devdocs.io with firefox and search the word under the cursor
command! -nargs=? DevDocs :call system('type -p open >/dev/null 2>&1 && open https://devdocs.io/#q=<args> || firefox -url https://devdocs.io/#q=<args>')
autocmd vimrc FileType python,ruby,rspec,javascript,go,html,php,eruby,coffee,haml nnoremap <buffer><leader>D :execute "DevDocs " . fnameescape(expand('<cword>'))<CR>

" arrow keys resize windows
nnoremap <Left> :vertical resize -10<CR>
nnoremap <Right> :vertical resize +10<CR>
nnoremap <Up> :resize -10<CR>
nnoremap <Down> :resize +10<CR>

imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>


" Quit neovim terminal
tnoremap <C-\> <C-\><C-n>


" restore the position of the last cursor when you open a file
autocmd vimrc BufReadPost * call general#RestorePosition()

" edit vimrc with f5 and source it with f6
nnoremap <silent> <leader><f5> :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader><f6> :source $MYVIMRC<CR>

" delete trailing space when saving files
autocmd vimrc BufWrite *.php,*.js,*.jsx,*.vue,*.twig,*.html,*.sh,*.yaml,*.yml,*.clj,*.cljs,*.cljc :call general#DeleteTrailingWS()


" Simple Zoom / Restore window (like Tmux)
nnoremap <silent><leader>z :call general#ZoomToggle()<CR>

" Save files as root
cnoremap w!! execute ':w suda://%'
" }}}
" Set options ---------------------- {{{

" +--------------+
" | Set  options |
" +--------------+

" colorscheme
"colorscheme hypnos
autocmd vimenter * colorscheme gruvbox
set background=dark

" no swap file
set noswapfile
" set the directory where the swap file will be saved
set backupdir=$VIMCONFIG/backup
set directory=$VIMCONFIG/swap

" save undo trees in files
set undofile
set undodir=$VIMCONFIG/undo

" number of undo saved
set undolevels=10000 " How many undos
set undoreload=10000 " number of lines to save for undo

" set line number
set number

" use 4 spaces instead of tab (to replace existing tab use :retab)
" copy indent from current line when starting a new line
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Save session
nnoremap <leader>ss :mksession! $VIMCONFIG/sessions/*.vim<C-D><BS><BS><BS><BS><BS>
" Reload session
nnoremap <leader>sl :so $VIMCONFIG/sessions/*.vim<C-D><BS><BS><BS><BS><BS>

" when at 3 spaces, and I hit > ... indent of 4 spaces in total, not 7
set shiftround

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" set list
set list listchars=tab:\┆\ ,trail:·,nbsp:±

" doesn't prompt a warning when opening a file and the current file was modified but not saved 
set hidden

" avoid delay
set updatetime=300

" always show signcolumns
set signcolumn=yes

" don't give |ins-completion-menu| messages.
set shortmess+=c

" doesn't display the mode status
set noshowmode

" Keep cursor more in middle when scrolling down / up
set scrolloff=999

" write automatically when quitting buffer
set autowrite

" Fold related
set foldlevelstart=0 " Start with all folds closed
set foldtext=general#FoldText()

" Show the substitution LIVE
set inccommand=nosplit

" Better ex autocompletion
set wildmenu
set wildmode=list:longest,full

" relative / hybrid line number switch
set number relativenumber

" for vertical pane in git diff tool
set diffopt+=vertical

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

autocmd vimrc FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

if executable("rg") 
    set grepprg=rg\ --vimgrep
endif

" }}}
