{
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    profiles.default.userSettings = {
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
      "[nix]" = {
        "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
      };
      "[qml]" = {
        "editor.defaultFormatter" = "theqtcompany.qt-qml";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "amp.tab.enabled" = true;
      "chat.commandCenter.enabled" = false;
      "cursor.cpp.enablePartialAccepts" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.gotoLocation.multipleDefinitions" = "goto";
      "editor.guides.bracketPairs" = "active";
      "editor.guides.indentation" = false;
      "editor.language.colorizedBracketPairs" = [];
      "editor.lineNumbers" = "relative";
      "editor.matchBrackets" = "near";
      "editor.renderLineHighlight" = "none";
      "editor.tabSize" = 2;
      "explorer.confirmDelete" = false;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "github.copilot.enable" = {
        "*" = false;
      };
      "github.copilot.nextEditSuggestions.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.currentLine.pullRequests.enabled" = false;
      "json.schemaDownload.enable" = true;
      "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
      "vscord.app.privacyMode.enable" = true;
      "window.commandCenter" = true;
      "window.menuBarVisibility" = "hidden";
      "window.titleBarStyle" = "native";
      "workbench.iconTheme" = "vs-trae-seti";
      "workbench.layoutControl.enabled" = false;
      "workbench.navigationControl.enabled" = false;
      "workbench.sideBar.location" = "right";
      "workbench.secondarySideBar.showLabels" = false;
      "amp.permissions" = [
        {
          "tool" = "Bash";
          "action" = "ask";
          "matches" = {
            "cmd" = "*git*push*";
          };
        }
        {
          "tool" = "mcp__*";
          "action" = "allow";
        }
        {
          "tool" = "read_mcp_resource";
          "action" = "allow";
        }
        {
          "tool" = "tb__*";
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^(.*\\s+)?(bazel|ibazel)\\s+.*\\/\\/[^\\s]*.*$/";
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "ls"
              "ls *"
              "dir"
              "dir *"
              "cat *"
              "head *"
              "tail *"
              "less *"
              "more *"
              "grep *"
              "egrep *"
              "fgrep *"
              "tree"
              "tree *"
              "file *"
              "wc *"
              "pwd"
              "stat *"
              "du *"
              "df *"
              "ps *"
              "top"
              "htop"
              "echo *"
              "printenv *"
              "id"
              "which *"
              "whereis *"
              "date"
              "cal *"
              "uptime"
              "free *"
              "ping *"
              "dig *"
              "nslookup *"
              "host *"
              "netstat *"
              "ss *"
              "lsof *"
              "ifconfig *"
              "ip *"
              "man *"
              "info *"
              "mkdir *"
              "touch *"
              "uname *"
              "whoami"
              "go version"
              "go env *"
              "go help *"
              "cargo version"
              "cargo --version"
              "cargo help *"
              "rustc --version"
              "rustc --help"
              "rustc --explain *"
              "javac --version"
              "javac -version"
              "javac -help"
              "javac --help"
              "dotnet --info"
              "dotnet --version"
              "dotnet --help"
              "dotnet help *"
              "gcc --version"
              "gcc -v"
              "gcc --help"
              "gcc -dumpversion"
              "g++ --version"
              "g++ -v"
              "g++ --help"
              "g++ -dumpversion"
              "clang --version"
              "clang --help"
              "clang++ --version"
              "clang++ --help"
              "python -V"
              "python --version"
              "python -h"
              "python --help"
              "python3 -V"
              "python3 --version"
              "python3 -h"
              "python3 --help"
              "ruby -v"
              "ruby --version"
              "ruby -h"
              "ruby --help"
              "node -v"
              "node --version"
              "node -h"
              "node --help"
              "npm --help"
              "npm --version"
              "npm -v"
              "npm help *"
              "yarn --help"
              "yarn --version"
              "yarn -v"
              "yarn help *"
              "pnpm --help"
              "pnpm --version"
              "pnpm -v"
              "pnpm help *"
              "pytest -h"
              "pytest --help"
              "pytest --version"
              "jest --help"
              "jest --version"
              "mocha --help"
              "mocha --version"
              "make --version"
              "make --help"
              "docker --version"
              "docker --help"
              "docker version"
              "docker help *"
              "git --version"
              "git --help"
              "git help *"
              "git version"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "go test *"
              "go run *"
              "go build *"
              "go vet *"
              "go fmt *"
              "go list *"
              "cargo test *"
              "cargo run *"
              "cargo build *"
              "cargo check *"
              "cargo fmt *"
              "cargo tree *"
              "make -n *"
              "make --dry-run *"
              "mvn test *"
              "mvn verify *"
              "mvn dependency:tree *"
              "gradle tasks *"
              "gradle dependencies *"
              "gradle properties *"
              "dotnet test *"
              "dotnet list *"
              "python -c *"
              "ruby -e *"
              "node -e *"
              "npm list *"
              "npm ls *"
              "npm outdated *"
              "npm test*"
              "npm run*"
              "npm view *"
              "npm info *"
              "yarn list*"
              "yarn ls *"
              "yarn info *"
              "yarn test*"
              "yarn run *"
              "yarn why *"
              "pnpm list*"
              "pnpm ls *"
              "pnpm outdated *"
              "pnpm test*"
              "pnpm run *"
              "pytest --collect-only *"
              "jest --listTests *"
              "jest --showConfig *"
              "mocha --list *"
              "git status*"
              "git show *"
              "git diff*"
              "git grep *"
              "git branch *"
              "git tag *"
              "git remote -v *"
              "git rev-parse --is-inside-work-tree *"
              "git rev-parse --show-toplevel *"
              "git config --list *"
              "git log *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "./gradlew *"
              "./mvnw *"
              "./build.sh *"
              "./configure *"
              "cmake *"
              "./node_modules/.bin/tsc *"
              "./node_modules/.bin/eslint *"
              "./node_modules/.bin/prettier *"
              "prettier *"
              "./node_modules/.bin/tailwindcss *"
              "./node_modules/.bin/tsx *"
              "./node_modules/.bin/vite *"
              "bun *"
              "tsx *"
              "vite *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              ".venv/bin/activate *"
              ".venv/Scripts/activate *"
              "source .venv/bin/activate *"
              "source venv/bin/activate *"
              "pip list *"
              "pip show *"
              "pip check *"
              "pip freeze *"
              "uv *"
              "poetry show *"
              "poetry check *"
              "pipenv check *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "asdf list *"
              "asdf current *"
              "asdf which *"
              "mise list *"
              "mise current *"
              "mise which *"
              "mise use *"
              "rbenv version *"
              "rbenv versions *"
              "rbenv which *"
              "nvm list *"
              "nvm current *"
              "nvm which *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "./test*"
              "./run_tests.sh *"
              "./run_*_tests.sh *"
              "vitest *"
              "bundle exec rspec *"
              "bundle exec rubocop *"
              "rspec *"
              "rubocop *"
              "swiftlint *"
              "clippy *"
              "ruff *"
              "black *"
              "isort *"
              "mypy *"
              "flake8 *"
              "bandit *"
              "safety *"
              "biome check *"
              "biome format *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "rails server *"
              "rails s *"
              "bin/rails server *"
              "bin/rails s *"
              "flask run *"
              "django-admin runserver *"
              "python manage.py runserver *"
              "uvicorn *"
              "streamlit run *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "bin/rails db:status"
              "bin/rails db:version"
              "rails db:rollback *"
              "rails db:status *"
              "rails db:version *"
              "alembic current *"
              "alembic history *"
              "bundle exec rails db:status"
              "bundle exec rails db:version"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "docker ps *"
              "docker images *"
              "docker logs *"
              "docker inspect *"
              "docker info *"
              "docker stats *"
              "docker system df *"
              "docker system info *"
              "podman ps *"
              "podman images *"
              "podman logs *"
              "podman inspect *"
              "podman info *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "aws --version *"
              "aws configure list *"
              "aws sts get-caller-identity *"
              "aws s3 ls *"
              "gcloud config list *"
              "gcloud auth list *"
              "gcloud projects list *"
              "az account list *"
              "az account show *"
              "kubectl get *"
              "kubectl describe *"
              "kubectl logs *"
              "kubectl version *"
              "helm list *"
              "helm status *"
              "helm version *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "swift build *"
              "swift test *"
              "zig build *"
              "zig build test*"
              "kotlinc *"
              "scalac *"
              "javac *"
              "javap *"
              "clang *"
              "jar *"
              "sbt *"
              "gradle *"
              "bazel build *"
              "bazel test *"
              "bazel run *"
              "mix *"
              "lua *"
              "ruby *"
              "php *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "mkdir -p *"
              "chmod +x *"
              "dos2unix *"
              "unix2dos *"
              "ln -s *"
            ];
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = [
              "for *"
              "while *"
              "do *"
              "done *"
              "if *"
              "then *"
              "else *"
              "elif *"
              "fi *"
              "case *"
              "esac *"
              "in *"
              "function *"
              "select *"
              "until *"
              "{ *"
              "} *"
              "[[ *"
              "]] *"
            ];
          };
          "action" = "ask";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^find(?!.*(-delete|-exec|-execdir)).*$/";
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^(echo|ls|pwd|date|whoami|id|uname)\\s.*[&|;].*\\s*(echo|ls|pwd|date|whoami|id|uname)($|\\s.*)/";
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^(cat|grep|head|tail|less|more|find)\\s.*\\|\\s*(grep|head|tail|less|more|wc|sort|uniq)($|\\s.*)/";
          };
          "action" = "allow";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^rm\\s+.*(-[rf].*-[rf]|-[rf]{2,}|--recursive.*--force|--force.*--recursive).*$/";
          };
          "action" = "ask";
        }
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^find.*(-delete|-exec|-execdir).*$/";
          };
          "action" = "ask";
        } 
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^(ls|cat|grep|head|tail|file|stat)\\s+[^/]*$/";
          };
          "action" = "allow";
        } 
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/^(?!.*(rm|mv|cp|chmod|chown|sudo|su|dd)\\b).*/dev/(null|zero|stdout|stderr|stdin).*$/";
          };
          "action" = "allow";
        } 
        {
          "tool" = "Bash";
          "matches" = {
            "cmd" = "/(^|\\s)(\\/(?!dev\\/(null|zero|stdout|stderr|stdin))[^\\s]*|\\.\\.\\/)(?![^\\s]*\\.(log|txt|md|json|yml|yaml)$)/";
          };
          "action" = "ask";
        } 
        {
          "tool" = "Bash";
          "action" = "ask";
        } 
        {
          "tool" = "Glob";
          "action" = "allow";
        } 
        {
          "tool" = "Task";
          "action" = "allow";
        } 
        {
          "tool" = "task_list";
          "action" = "allow";
        } 
        {
          "tool" = "finder";
          "action" = "allow";
        } 
        {
          "tool" = "get_diagnostics";
          "action" = "allow";
        } 
        {
          "tool" = "Bash";
          "action" = "allow";
        } 
        {
          "tool" = "oracle";
          "action" = "allow";
        } 
        {
          "tool" = "painter";
          "action" = "allow";
        } 
        {
          "tool" = "mermaid";
          "action" = "allow";
        } 
        {
          "tool" = "walkthrough";
          "action" = "allow";
        } 
        {
          "tool" = "walkthrough_diagram";
          "action" = "allow";
        } 
        {
          "tool" = "todo_read";
          "action" = "allow";
        } 
        {
          "tool" = "todo_write";
          "action" = "allow";
        } 
        {
          "tool" = "read_web_page";
          "action" = "allow";
        } 
        {
          "tool" = "create_file";
          "action" = "allow";
        } 
        {
          "tool" = "glob";
          "action" = "allow";
        } 
        {
          "tool" = "Glob";
          "action" = "allow";
        } 
        {
          "tool" = "undo_edit";
          "action" = "allow";
        } 
        {
          "tool" = "Read";
          "action" = "allow";
        } 
        {
          "tool" = "read_file";
          "action" = "allow";
        } 
        {
          "tool" = "delete_file";
          "action" = "allow";
        } 
        {
          "tool" = "format_file";
          "action" = "allow";
        } 
        {
          "tool" = "web_search";
          "action" = "allow";
        } 
        {
          "tool" = "Grep";
          "action" = "allow";
        } 
        {
          "tool" = "search_documents";
          "action" = "allow";
        } 
        {
          "tool" = "get_document";
          "action" = "allow";
        } 
        {
          "tool" = "Check";
          "action" = "allow";
        } 
        {
          "tool" = "code_review";
          "action" = "allow";
        } 
        {
          "tool" = "kraken";
          "action" = "allow";
        } 
        {
          "tool" = "look_at";
          "action" = "allow";
        } 
        {
          "tool" = "librarian";
          "action" = "allow";
        } 
        {
          "tool" = "bookkeeper";
          "action" = "allow";
        } 
        {
          "tool" = "read_thread";
          "action" = "allow";
        } 
        {
          "tool" = "find_thread";
          "action" = "allow";
        } 
        {
          "tool" = "skill";
          "action" = "allow";
        } 
        {
          "tool" = "read_github";
          "action" = "allow";
        } 
        {
          "tool" = "search_github";
          "action" = "allow";
        } 
        {
          "tool" = "commit_search";
          "action" = "allow";
        } 
        {
          "tool" = "list_directory_github";
          "action" = "allow";
        } 
        {
          "tool" = "list_repositories";
          "action" = "allow";
        } 
        {
          "tool" = "glob_github";
          "action" = "allow";
        } 
        {
          "tool" = "diff";
          "action" = "allow";
        } 
        {
          "tool" = "describe_workbook";
          "action" = "allow";
        } 
        {
          "tool" = "execute_query";
          "action" = "allow";
        } 
        {
          "tool" = "handoff";
          "action" = "allow";
        }
      ];
    };
  };
}
