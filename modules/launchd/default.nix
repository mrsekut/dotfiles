{ ... }:

{
  launchd.agents.prototyping-runner = {
    enable = true;
    config = {
      ProgramArguments = [ "/Users/mrsekut/.bun/bin/prototyping-runner" ];
      EnvironmentVariables = {
        PATH = "/Users/mrsekut/.nix-profile/bin:/Users/mrsekut/.bun/bin:/usr/bin:/bin";
      };
      WorkingDirectory = "/Users/mrsekut/Desktop/dev/github.com/mrsekut/prototypings";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
