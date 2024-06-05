{
  description = "@andystopia's collection of nix flake templates";

  outputs = {self} : { 
    templates = { 
      fenix-rust =  {
        path = ./fenix-rust;
        description = ''
        Generate a rust project that can create docker's, utilizes lld for faster linking, and builds cross platform for linux.
        '';
      };
      typst = {
       path = ./typst;   
       description = "Plain typst project";
      };
      typst-math = {
        path = ./typst-math;
        description = ''Instantiate a typst instance with my math template, and a (mostly) configured VSCodium.'';
      };
      empty-dev-shell = {
        path = ./empty-dev-shell;
        description = ''
        Easily fillable dev-shell
        that will allow the user to quickly define shell dependencies they
        want.        
      '';
      };

      basic-r = {
        path = ./basic-r;
        description = ''
          Have a ready-to-go R environment, with the 
          ability to knit using Nix build.
        '';
      };

      # TODO: implement running with nix run 
      haskell-94 = {
        path = ./haskell-94;
        description = ''
          A ready to go working cabal and hls installation
        '';
      };
    };
  };
}
