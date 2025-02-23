_:
{
  imports = [
    ./plugins/completion.nix
    ./plugins/git.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/trouble.nix
  ];

  plugins = {
    indent-blankline.enable = true;
    leap.enable = true;
    web-devicons.enable = true;
  };

  keymaps = [
    {
      key = "_";
      action = ":normal gcc<CR><DOWN>";
      mode = "n";
    }
    {
      key = "_";
      action = "<Esc>:normal gvgc<CR>";
      mode = "v";
    }
  ];

  extraConfigVim = ''
    let g:mapleader=","

    " Tabs
    set tabstop=2
    set softtabstop=2
    set expandtab
    set shiftwidth=2
    set autoindent

    " Display
    set number
    set showcmd
    set cursorline
    set wildmenu
    set lazyredraw
    set showmatch
    set mouse=a
    set relativenumber

    " Searching
    set incsearch
    set hlsearch

    " Folding
    set foldenable
    set foldlevelstart=10
    set foldnestmax=10
    set foldmethod=indent

    " Escape
    inoremap jj <esc>

    """ Colemak-Vim Arrow keys """
    " - k/K is the new n/N.
    " - s/S is the new i/I ["inSert"].
    "
    " - l/L skip to the beginning and end of lines
    " - Ctrl-l joins lines
    " - r replaces i as the "inneR" modifier

    " UENI arrows. Swap 'gn'/'ge' and 'n'/'e'.
    " Also, m -> h for colemak-dh

    noremap <expr> e (v:count == 0 ? 'gj' : 'j')
    noremap <expr> u (v:count == 0 ? 'gk' : 'k')
    noremap i l
    noremap n h

    " noremap <C-e> <C-u>
    " noremap <C-n> <C-d>

    " Switch panes.
    nnoremap N <C-w>h
    nnoremap I <C-w>l
    nnoremap E <C-w>j
    nnoremap U <C-w>k

    " Switch buffers.
    nnoremap <C-i> :tabnext<CR>
    nnoremap <C-n> :tabprevious<CR>

    noremap <C-Tab> <C-^>

    noremap q u
    noremap Q <C-r>
    noremap <Leader>q q

    " Last search.
    noremap k n
    noremap K N

    " _r_ = inneR text objects.
    onoremap r i

    " Easy mappings for BOL EOL
    noremap l g^
    noremap L g$

    """Misc Mappings"""
    noremap ; :
    noremap : ;
    noremap U <C-r>
    nnoremap <CR> o<Esc>
    nnoremap <silent> j :noh<CR>
    nnoremap p p=`]
    "noremap s i
    "noremap S I
    noremap <space> i
    inoremap <C-e> <C-p>
    inoremap <C-p> <C-r>

    " Clipboard
    set clipboard=unnamed
  '';
}
