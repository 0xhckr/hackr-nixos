{pkgs, ...}: {
  services.ollama = {
    enable = true;
    loadModels = ["qwen3-coder:30b"];
    package = pkgs.ollama-rocm;
  };

  # Enable ROCm kernel modules in initrd
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Ollama is socket-activated but kept stopped by default;
  # the vicinae script toggles it on demand.
  systemd.services.ollama.wantedBy = [];

  # Allow start/stop ollama without a password prompt for vicinae script
  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start ollama.service";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop ollama.service";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart ollama.service";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
