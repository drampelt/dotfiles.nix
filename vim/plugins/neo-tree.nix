{ ... }:
{
  plugins.neo-tree = {
    enable = true;

    settings.window.mappings = {
      e = "";
    };
  }; 

  keymaps = [
    {
      mode = ["n"];
      key = "<leader><leader>";
      action = "<cmd>Neotree toggle<cr>";
      options = { desc = "Open/Close neo-tree"; };
    }
  ];
}
