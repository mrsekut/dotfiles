{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      aws.disabled = true;
      gcloud.disabled = true;

      character = {
        success_symbol = "λ";
        error_symbol = "λ";
      };

      nix_shell = {
        symbol = "nix-shell ";
      };

      cmd_duration = {
        disabled = true;
      };
    };
  };
}
