{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  users.users.daniel = {
    name = "daniel";
    home = "/Users/daniel";
  };

  home-manager.users.daniel = { pkgs, ... }: 
  let starshipWorkingPkgs = import (fetchTarball ("https://github.com/NixOS/nixpkgs/archive/06ff90f540d0dcf77a5aa34fb1ad323da8c1f8f7.tar.gz")) {};
  in
  {
    home.packages = with pkgs; [
      difftastic duf fd fasd ffmpeg fx git-crypt htop kopia ncdu ripgrep wget xh yt-dlp
    ];

    home.file.".ideavimrc".source = ./ideavimrc;

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
        };
        init = {
          defaultBranch = "main";
        };
        core = {
          sshCommand = "/usr/bin/ssh";
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

    programs.starship.enable = true;
    programs.starship.package = starshipWorkingPkgs.pkgs.starship;

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

      noremap <expr> n (v:count == 0 ? 'gj' : 'j')
      noremap <expr> e (v:count == 0 ? 'gk' : 'k')
      noremap i l

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

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initExtra = ''
      eval "$(fasd --init auto)"
      test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
      export ANDROID_HOME="''${HOME}/Library/Android/sdk"
      export PATH="''${ANDROID_HOME}/tools:''${ANDROID_HOME}/platform-tools:''${PATH}"
      setopt prompt_sp
      export EDITOR=vim
      export BAT_PAGER="less -R"
      '';
      shellAliases = {
        gdm = "git branch --merged | egrep -v '(^\\*|master|staging|main)' | xargs git branch -d";
        k = "kubectl";
        ks = "kubectl --namespace staging";
        ksys = "kubectl --namespace kube-system";
        kp = "kubectl --namespace production";
        km = "kubectl --namespace monitoring";
        ki = "kubectl --namespace internal";
        kn = "kubectl --namespace ingress-nginx";
        kw = "kubectl --namespace whistler";
      };
    };
  };
}
