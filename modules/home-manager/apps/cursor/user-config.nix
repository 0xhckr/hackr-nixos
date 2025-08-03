{ lib, pkgs, ... }:
{
  programs.vscode = {
    profiles.default.userSettings = {
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "explorer.confirmDelete" = false;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "cursor.cpp.enablePartialAccepts" = true;
      "editor.gotoLocation.multipleDefinitions" = "goto";
      "editor.tabSize" = 2;
      "[nix]" = {
        "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
      };
      "vscord.app.privacyMode.enable" = true;
      "workbench.navigationControl.enabled" = false;
      "workbench.sideBar.location" = "right";
      "editor.matchBrackets" = "near";
      "editor.guides.indentation" = false;
      "editor.language.colorizedBracketPairs" = [ ];
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.guides.bracketPairs" = "active";
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      "workbench.iconTheme" = "vs-trae-seti";
      "chat.commandCenter.enabled" = false;
      "editor.renderLineHighlight" = "none";
      "gitlens.currentLine.enabled" = false;
      "gitlens.currentLine.pullRequests.enabled" = false;
      "editor.lineNumbers" = "relative";
      "window.menuBarVisibility" = "compact";
      "window.commandCenter" = true;
      "workbench.layoutControl.enabled" = false;
      "window.titleBarStyle" = if pkgs.stdenv.isLinux then "native" else "custom";
      "workbench.colorTheme" = lib.mkForce "Oscura Midnight";
      "editor.cursorBlinking" = "smooth";
      "json.schemaDownload.enable" = true;
    };
  };
}