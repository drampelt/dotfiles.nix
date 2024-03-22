{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.05";

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  home.packages = with pkgs; [
    # Some basics
    coreutils
    curl
    wget
    mosh

    # Dev stuff
    colima
    docker-client
    difftastic
    duf
    du-dust
    fd
    fasd
    ffmpeg
    fx
    git-crypt
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    gradle
    jq
    kotlin
    ncdu
    ripgrep
    ripgrep-all
    xh

    # Other
    kopia
    yt-dlp

    # Useful nix related tools
    comma # run software from without installing it
    niv # easy dependency management for nix projects

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
  ];

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd .";
    fileWidgetOptions = [
      "--preview-window" "wrap"
      "--preview" "'
      if [[ -f {} ]]; then
           file --mime {} | grep -q \\\"text\/.*;\\\" && bat --color \\\"always\\\" {} || (tput setaf 1; file --mime {})
       elif [[ -d {} ]]; then
           exa -l --color always {}
       else;
           tput setaf 1; echo YOU ARE NOT SUPPOSED TO SEE THIS!
       fi'"
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "drampelt@gmail.com";
    userName = "Daniel Rampelt";
    signing.key = "C7F714686365C406";
    signing.signByDefault = true;
    # delta.enable = true;
    # delta.options = {
    #   features = "side-by-side line-numbers decorations";
    #   whitespace-error-style = "22 reverse";
    # };
    ignores = [ "*.swp" ".DS_Store" ".direnv" ];
    extraConfig = {
      alias = {
        lg = "log --graph --date=format:\"%a %b %d, %r\" --pretty=format:\"%Cred%h%Creset - %C(yellow)%ad %Cgreen(%cr)%C(reset)%C(auto) -%d %s %Cblue<%an>%Creset\" --topo-order";
        dft = "difftool";
        showtool = "!showci () { rev=$(git rev-parse \"\${*:-HEAD}\"); git difftool $rev~1 $rev; }; showci";
        shw = "show --ext-diff";
      };
      pull = {
        rebase = true;
        autoStash = true;
      };
      push = {
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        sshCommand = "/usr/bin/ssh";
      };
      rebase = {
        updateRefs = true;
      };
      merge = {
        tool = "opendiff";
      };
      diff = {
        tool = "difftastic";
        external = "difft";
      };
      difftool = {
        prompt = false;
      };
      "difftool \"difftastic\"" = {
        cmd = "difft \"$LOCAL\" \"$REMOTE\"";
      };
      pager = {
        difftool = true;
      };
    };
  };

  programs.htop.enable = true;
  programs.jq.enable = true;

  programs.neovim = {
    enable = true;
    extraConfig = ''
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

      """ Colemak-Vim Mappings"""
      " - k/K is the new n/N.
      " - s/S is the new i/I ["inSert"].
      "
      " - l/L skip to the beginning and end of lines
      " - Ctrl-l joins lines
      " - r replaces i as the "inneR" modifier

      " HNEI arrows. Swap 'gn'/'ge' and 'n'/'e'.
      " Also, m -> h for colemak-dh

      noremap <expr> n (v:count == 0 ? 'gj' : 'j')
      noremap <expr> e (v:count == 0 ? 'gk' : 'k')
      noremap i l
      noremap m h

      noremap <C-e> <C-u>
      noremap <C-n> <C-d>

      " Switch panes.
      nnoremap H <C-w>h
      nnoremap I <C-w>l
      nnoremap N <C-w>j
      nnoremap E <C-w>k

      " Switch buffers.
      nnoremap <C-i> :tabnext<CR>
      nnoremap <C-h> :tabprevious<CR>

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
      noremap <silent> _ :TComment<CR>
      nnoremap p p=`]
      noremap s i
      noremap S I
      noremap <space> i
      inoremap <C-e> <C-p>
      inoremap <C-p> <C-r>

      " Clipboard
      set clipboard=unnamed
    '';
  };

  programs.starship.enable = true;
  #programs.starship.package = starshipWorkingPkgs.pkgs.starship;

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-sensible nord-vim fzf-vim nerdtree vim-nerdtree-tabs vim-airline tcomment_vim vim-gitgutter vim-fugitive vim-surround vim-polyglot vim-nix
    ];
    extraConfig = ''
    let g:mapleader=","

    " Colorscheme
    colorscheme nord
    syntax enable

    " Tabs
    set tabstop=4
    set softtabstop=4
    set expandtab
    set shiftwidth=4
    set autoindent

    autocmd Filetype coffee setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " Display
    set number
    set showcmd
    set cursorline
    set wildmenu
    set lazyredraw
    set showmatch
    set mouse=a

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

    """ Colemak-Vim Mappings"""
    " - k/K is the new n/N.
    " - s/S is the new i/I ["inSert"].
    "
    " - l/L skip to the beginning and end of lines
    " - Ctrl-l joins lines
    " - r replaces i as the "inneR" modifier

    " HNEI arrows. Swap 'gn'/'ge' and 'n'/'e'.
    " Also, m -> h for colemak-dh

    noremap <expr> n (v:count == 0 ? 'gj' : 'j')
    noremap <expr> e (v:count == 0 ? 'gk' : 'k')
    noremap i l
    noremap m h

    noremap <C-e> <C-u>
    noremap <C-n> <C-d>

    " Switch panes.
    nnoremap H <C-w>h
    nnoremap I <C-w>l
    nnoremap N <C-w>j
    nnoremap E <C-w>k

    " Switch buffers.
    nnoremap <C-i> :tabnext<CR>
    nnoremap <C-h> :tabprevious<CR>

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
    noremap <silent> _ :TComment<CR>
    nnoremap p p=`]
    noremap s i
    noremap S I
    noremap <space> i
    inoremap <C-e> <C-p>
    inoremap <C-p> <C-r>

    " NERDTree
    " nnoremap <silent> <Leader><Leader> :NERDTreeToggle<CR>
    nnoremap <silent> <Leader><Leader> :NERDTreeTabsToggle<CR>
    let g:NERDTreeMenuDown='n'
    let g:NERDTreeMenuUp='e'
    let g:NERDTreeMapToggleHidden='H'
    let g:NERDTreeChDirMode = 2              " Vim's cwd follows NERDTree's cwd.
    let g:NERDTreeMapJumpFirstChild = "ge"
    let g:NERDTreeMapJumpLastChild = "gn"
    let g:NERDTreeMapOpenExpl = ""
    let g:NERDTreeMapOpenSplit = "S"
    let g:NERDTreeQuitOnOpen = 0             " Stay open.

    " Airline
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1

    " FZF
    noremap <silent> <C-p> :Files<CR>

    " Clipboard
    set clipboard=unnamed

    " Nerdtree
    let g:nerdtree_tabs_open_on_gui_startup = 0
    '';
  };

  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    matchBlocks = {
      "*" = {
        extraOptions = {
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    plugins = [
      {
        name = "zsh-autoquoter";
        src = pkgs.fetchFromGitHub {
          owner = "ianthehenry";
          repo = "zsh-autoquoter";
          rev = "819a615fbfd2ad25c5d311080e3a325696b45de7";
          sha256 = "15kli851f32cbyisgf7960pmryz5w8ssn4ykpjiyfk05wsixsj5g";
        };
      }
    ];
    initExtra = ''
    eval "$(fasd --init auto)"
    test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
    export ANDROID_HOME="''${HOME}/Library/Android/sdk"
    export PATH="''${ANDROID_HOME}/tools:''${ANDROID_HOME}/platform-tools:''${HOME}/bin:''${PATH}"
    export JAVA_HOME="$(/usr/libexec/java_home)"
    setopt prompt_sp
    export EDITOR=nvim
    export BAT_PAGER="less -R"
    ZAQ_PREFIXES=('git commit( [^ ]##)# -[^ -]#m')
    ZSH_HIGHLIGHT_HIGHLIGHTERS+=(zaq)
    '';
    shellAliases = {
      gdm = "git branch --merged | egrep -v '(^\\*|master|staging|main)' | xargs git branch -d";
      k = "kubectl";
      mssh = "LANG=en_US.UTF-8 mosh --ssh=/usr/bin/ssh";
    };
  };

  # Misc configuration files --------------------------------------------------------------------{{{
  home.file.".ideavimrc".source = ../ideavimrc;

  home.file.".config/karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink "/Users/daniel/.nixpkgs/darwin/config/karabiner/karabiner.json";
}
