{ ... }:
{
  plugins.neo-tree = {
    enable = true;

    window.mappings = {
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
