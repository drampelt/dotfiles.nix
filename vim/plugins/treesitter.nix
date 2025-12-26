{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    settings = {
      #indent.enable = true;
      highlight.enable = true;
    };
    folding.enable = false;
    nixvimInjections = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };
}
