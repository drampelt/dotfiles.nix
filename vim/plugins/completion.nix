{ ... }:
{
  plugins = {
    copilot-lua = {
      enable = true;
      suggestion = {
        keymap = {
          next = "<S-Space>";
          #prev = "<C-[>";
        };
      };
    };

    nvim-autopairs = {
      enable = true;
    };

    cmp-nvim-lsp = { enable = true; };
    cmp-buffer = { enable = true; };
    cmp-path = { enable = true; };
    cmp-emoji = { enable = true; };
    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        sources = [
          { name = "git"; }
          { name = "nvim_lsp"; }
          { name = "emoji"; }
          {
            name = "buffer"; # text within current buffer
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path"; # file system paths
            keywordLength = 3;
          }
        ];
        mapping = {
          "<C-e>" = "cmp.mapping.select_next_item()";
          "<C-u>" = "cmp.mapping.select_prev_item()";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
          # "<Tab>" = ''
          #   cmp.mapping(function(fallback)
          #     if require("copilot.suggestion").is_visible() then
          #       print("a")
          #       require("copilot.suggestion").accept()
          #     elseif cmp.visible() then
          #       print("b")
          #       -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          #       cmp.mapping.confirm({ select = true })
          #     else
          #       print("c")
          #       fallback()
          #     end
          #   end, {
          #     "i",
          #     "s",
          #   })
          # '';
          "<CR>" = "cmp.mapping.confirm()";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          #"<C-Space>" = "cmp.mapping.complete()";
          "<C-Space>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.mapping.abort()
                require("copilot.suggestion").next()
              else
                cmp.mapping.complete()
              end
            end, {"i", "s"})
          '';
        };
      };
    };
  }; 

  keymaps = [
  ];
}
