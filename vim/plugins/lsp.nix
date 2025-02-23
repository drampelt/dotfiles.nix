{ lib, ... }:
{
  plugins = {
    lsp-lines = { enable = true; };
    lsp-format = { enable = true; };
    lsp-signature.enable = true;
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        html = { enable = true; };
        elixirls = { enable = true; };
        pylsp = { 
          enable = true; 
          settings = {
            plugins = {
              pylsp_mypy = {
                enabled = true;
                # report_progress = true;
                overrides = ["--python-executable" (lib.nixvim.mkRaw "py_path") true] ;
              };
              ruff.enabled = true;
              rope.enabled = true;
              rope_autoimport.enabled = true;
            };
          };
        };
        # basedpyright = {
        #   enable = true;
        #   extraOptions = {
        #     settings = {
        #       python.pythonPath = lib.nixvim.mkRaw "py_path";
        #     };
        #   };
        # };
      };
      keymaps = {
        silent = true;
        lspBuf = {
          # gd = {
          #   action = "definition";
          #   desc = "Goto Definition";
          # };
          # gr = {
          #   action = "references";
          #   desc = "Goto References";
          # };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          J = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  }; 

  extraConfigLuaPre = ''
    local venv_path = os.getenv('VIRTUAL_ENV') -- or vim.fn.exepath('python')
    local path_python = vim.fn.exepath('python')
    local py_path = nil
    if venv_path ~= nil then
      py_path = venv_path .. "/bin/python3"
    elseif path_python ~=nil then
      py_path = path_python
    else
      py_path = vim.g.python3_host_prog
    end
    print(py_path)
	'';

  keymaps = [
  ];
}
