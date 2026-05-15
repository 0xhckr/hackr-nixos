/**
 * Hackr UI — Makes pi look like Charm's Crush (Charmtone Pantera palette).
 *
 * What it does:
 *   • Custom header with "3.14159" gradient wordmark + model + cwd
 *   • Custom footer with token stats, cost, git branch, model
 *   • Gradient-animated working indicator (charple → dolly)
 *   • Hackr-style editor: `xoxo` prompt prefix, no visible borders
 *   • YOLO mode indicator: ` ! ` badge in prompt + status bar
 *   • Cmd mode (Alt+C): run commands in login shell with expandable output
 *
 * Commands:
 *   /hackr-ui        Toggle Hackr UI on/off
 *   /yolo            Toggle YOLO mode (auto-accept all permissions)
 *
 * Shortcuts:
 *   Alt+C            Toggle /cmd mode
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import {
  CustomEditor,
  type ExtensionAPI,
  type ExtensionContext,
  type Theme,
  keyHint,
} from "@earendil-works/pi-coding-agent";
import type {
  EditorTheme,
  KeybindingsManager,
  TUI,
} from "@earendil-works/pi-tui";
import { Text, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { spawn } from "node:child_process";

// ── Charmtone Pantera palette ──────────────────────────────────────────────

const C = {
  charple: "#6B50FF",
  dolly: "#FF60FF",
  bok: "#68FFD6",
  blush: "#FF84FF",
  ash: "#DFDBDD",
  squid: "#858392",
  smoke: "#BFBCC8",
  oyster: "#605F6B",
  pepper: "#201F26",
  bbq: "#2D2C35",
  charcoal: "#3A3943",
  iron: "#4D4C57",
  sriracha: "#EB4268",
  malibu: "#00A4FF",
  julep: "#00FFB2",
  mustard: "#F5EF34",
  citron: "#E8FF27",
  butter: "#FFFAF1",
  sardine: "#4FBEFE",
  guac: "#12C78F",
  coral: "#FF577D",
};

// ── ANSI helpers ───────────────────────────────────────────────────────────

function fg(color: string, text: string): string {
  const r = parseInt(color.slice(1, 3), 16);
  const g = parseInt(color.slice(3, 5), 16);
  const b = parseInt(color.slice(5, 7), 16);
  return `\x1b[38;2;${r};${g};${b}m${text}\x1b[39m`;
}

function bg(color: string, text: string): string {
  const r = parseInt(color.slice(1, 3), 16);
  const g = parseInt(color.slice(3, 5), 16);
  const b = parseInt(color.slice(5, 7), 16);
  return `\x1b[48;2;${r};${g};${b}m${text}\x1b[49m`;
}

function bold(text: string): string {
  return `\x1b[1m${text}\x1b[22m`;
}

function dim(text: string): string {
  return `\x1b[2m${text}\x1b[22m`;
}

function reset(text: string): string {
  return `\x1b[0m${text}\x1b[0m`;
}

/** Blend two hex colors at t=[0..1] */
function blend(c1: string, c2: string, t: number): string {
  const r1 = parseInt(c1.slice(1, 3), 16),
    g1 = parseInt(c1.slice(3, 5), 16),
    b1 = parseInt(c1.slice(5, 7), 16);
  const r2 = parseInt(c2.slice(1, 3), 16),
    g2 = parseInt(c2.slice(3, 5), 16),
    b2 = parseInt(c2.slice(5, 7), 16);
  const r = Math.round(r1 + (r2 - r1) * t);
  const g = Math.round(g1 + (g2 - g1) * t);
  const b = Math.round(b1 + (b2 - b1) * t);
  return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
}

/** Render text with a horizontal color gradient */
function gradient(text: string, from: string, to: string): string {
  const chars = [...text];
  return chars
    .map((ch, i) => {
      const t = chars.length <= 1 ? 0 : i / (chars.length - 1);
      return fg(blend(from, to, t), ch);
    })
    .join("");
}

function boldGradient(text: string, from: string, to: string): string {
  return bold(gradient(text, from, to));
}

// ── Hackr icons ────────────────────────────────────────────────────────────

const ICON = {
  model: "◇",
  dot: "•",
  arrow: "→",
  separator: "─",
  diagonal: "╱",
  toolPending: "●",
  toolSuccess: "✓",
  toolError: "×",
};

// ── Header ─────────────────────────────────────────────────────────────────

// Digits sourced from the `pi` npm package's data file.
// (The JS API is broken — require("./pi") won't resolve pi.txt — but the data
// file at node_modules/pi-decimals/lib/pi.txt has 1M digits.)
const { readFileSync } = require("node:fs") as typeof import("node:fs");
const { join } = require("node:path") as typeof import("node:path");

let _piDigits = "";
try {
  // pi.txt: "3.14159265..." (1M+ digits, single line)
  _piDigits = readFileSync(
    join(__dirname, "node_modules/pi-decimals/lib/pi.txt"),
    "utf8",
  ).trim();
} catch {
  // Fallback if the package isn't installed
  _piDigits =
    "3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196";
}

function renderHackrHeader(
  width: number,
  model?: string,
  cwd?: string,
): string[] {
  const modelIcon = fg(C.malibu, ICON.model);
  const modelText = model ? ` ${modelIcon} ${fg(C.squid, model)}` : "";
  const cwdText = cwd
    ? ` ${fg(C.oyster, ICON.dot)} ${fg(C.oyster, cwd.split("/").slice(-2).join("/"))}`
    : "";

  const right = `${modelText}${cwdText}`;
  const rightW = visibleWidth(right);

  const maxDiags = 8;
  const paddingW = 2; // space before + after pi digits
  const maxPiLen = Math.max(0, width - paddingW - maxDiags - rightW);

  const piStr = maxPiLen > 0 ? _piDigits.slice(0, maxPiLen) : "";
  const wordmark = boldGradient(piStr, C.charple, C.dolly);
  const left = ` ${wordmark} `;
  const leftW = visibleWidth(left);

  const diagCount = Math.min(maxDiags, Math.max(0, width - leftW - rightW));
  const diagFill = fg(C.charcoal, ICON.diagonal.repeat(diagCount));

  return ["", truncateToWidth(left + diagFill + right, width)];
}

// ── Footer ─────────────────────────────────────────────────────────────────

function renderHackrFooter(
  width: number,
  model?: string,
  branch?: string | null,
  inputTokens?: number,
  outputTokens?: number,
  cost?: number,
  cwd?: string,
): string[] {
  const fmt = (n: number) => (n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`);

  const inStr = inputTokens ? `↑${fmt(inputTokens)}` : "";
  const outStr = outputTokens ? ` ↓${fmt(outputTokens)}` : "";
  const costStr = cost ? ` $${cost.toFixed(3)}` : "";
  const leftParts = [inStr, outStr, costStr].filter(Boolean).join(" ");
  const left = fg(C.oyster, leftParts);

  const branchStr = branch
    ? ` ${fg(C.charcoal, ICON.dot)} ${fg(C.squid, branch)}`
    : "";
  const modelName = model ?? "no-model";
  const cwdStr = cwd
    ? ` ${fg(C.charcoal, ICON.dot)} ${fg(C.oyster, cwd.split("/").slice(-2).join("/"))}`
    : "";
  const right = `${fg(C.charple, ICON.model)} ${fg(C.squid, modelName)}${branchStr}${cwdStr}`;

  const pad = " ".repeat(
    Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
  );
  return [truncateToWidth(left + pad + right, width)];
}

// ── Working indicator frames ───────────────────────────────────────────────

const WORKING_FRAMES = [
  fg(C.charple, "x"),
  fg(blend(C.charple, C.dolly, 0.25), "o"),
  fg(blend(C.charple, C.dolly, 0.5), "x"),
  fg(blend(C.charple, C.dolly, 0.75), "o"),
  fg(C.dolly, "x"),
  fg(blend(C.charple, C.dolly, 0.75), "o"),
  fg(blend(C.charple, C.dolly, 0.5), "x"),
  fg(blend(C.charple, C.dolly, 0.25), "o"),
];

// ── Hackr-style Editor ─────────────────────────────────────────────────────

class HackrEditor extends CustomEditor {
  private ctx: ExtensionContext;
  private yoloMode: boolean;
  private cmdMode: boolean;
  private showExitHint: boolean;
  private tui: TUI;
  private isWorking: boolean;

  constructor(
    tui: TUI,
    theme: EditorTheme,
    keybindings: KeybindingsManager,
    ctx: ExtensionContext,
    yoloMode: boolean,
    cmdMode: boolean,
  ) {
    super(tui, theme, keybindings, { paddingX: 0 });
    this.ctx = ctx;
    this.yoloMode = yoloMode;
    this.cmdMode = cmdMode;
    this.showExitHint = false;
    this.tui = tui;
    this.isWorking = false;
  }

  setYolo(on: boolean) {
    this.yoloMode = on;
  }

  setCmd(on: boolean) {
    this.cmdMode = on;
  }

  setWorking(on: boolean) {
    this.isWorking = on;
    this.tui.requestRender();
  }

  setExitHint(on: boolean) {
    this.showExitHint = on;
    this.tui.requestRender();
  }

  handleInput(data: string): void {
    // On ctrl+c, show exit hint immediately
    if (data === "\x03") {
      if (this.isWorking) {
        this.setExitHint(true);
      }
    }
    super.handleInput(data);
  }

  render(width: number): string[] {
    const lines = super.render(width);
    if (lines.length === 0) return lines;

    // Build the prompt prefix
    let promptPrefix: string;
    if (this.cmdMode) {
      promptPrefix = fg(C.charple, bold("/cmd")) + " " + fg(C.squid, "❯") + " ";
    } else if (this.yoloMode) {
      promptPrefix = fg(C.citron, bold("yolo")) + " " + fg(C.squid, "❯") + " ";
    } else {
      promptPrefix = fg(C.bok, bold("xoxo")) + " " + fg(C.squid, "❯") + " ";
    }
    const prefixWidth = visibleWidth(promptPrefix);

    // Remove top border
    lines.splice(0, 1);

    if (lines.length === 0) return lines;

    // Find the bottom border to separate editor content from autocomplete popup.
    // The bottom border is a line of "─" characters (or "─── ↓ N more ───" scroll
    // indicator). Everything after it is autocomplete lines that must not be modified.
    let borderIdx = lines.length - 1;
    if (this.isShowingAutocomplete()) {
      for (let i = lines.length - 1; i >= 0; i--) {
        const stripped = lines[i]!.replace(/\x1b\[[0-9;]*m/g, "");
        if (/^─+$/.test(stripped) || /^─── ↓ \d+ more/.test(stripped)) {
          borderIdx = i;
          break;
        }
      }
    }

    // Split: lines = content, acLines = [border, ...autocomplete]
    const acLines = lines.splice(borderIdx);

    // Indent content lines
    const indent = " ".repeat(prefixWidth);
    for (let i = 0; i < lines.length; i++) {
      const contentLine = lines[i]!;
      const stripped = contentLine.replace(/^\s/, "");
      const pad = i === 0 ? promptPrefix : indent;
      const available = width - prefixWidth;
      const truncated = truncateToWidth(stripped, Math.max(0, available));
      lines[i] = pad + truncated;
    }

    // Replace bottom border with hint (left) + context stats (right)
    const hintText = this.showExitHint
      ? fg(C.oyster, "ctrl+c again to exit")
      : "";

    const usage = this.ctx.getContextUsage();
    const ctxWindow = usage?.contextWindow ?? this.ctx.model?.contextWindow;
    const fmt = (n: number) =>
      n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`;

    let statsText = "";
    if (usage?.percent != null && ctxWindow) {
      const pct = Math.round(usage.percent);
      const ctxColor = pct >= 80 ? C.sriracha : pct >= 50 ? C.mustard : C.julep;
      statsText = fg(
        ctxColor,
        fmt(usage.tokens) + "/" + (ctxWindow / 1000).toFixed(0) + "k",
      );
    }

    if (hintText || statsText) {
      const hw = visibleWidth(hintText);
      const sw = visibleWidth(statsText);
      const gap = Math.max(1, width - hw - sw);
      acLines[0] = truncateToWidth(
        hintText + " ".repeat(gap) + statsText,
        width,
      );
    } else {
      acLines.splice(0, 1);
    }

    // Append autocomplete lines unchanged
    lines.push(...acLines);

    return lines;
  }
}

// ── Extension ──────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
  let enabled = false;
  let yoloMode = false;
  let cmdMode = false;
  let hackrEditor: HackrEditor | undefined;
  let exitHintTimer: ReturnType<typeof setTimeout> | undefined;

  function showExitHint() {
    hackrEditor?.setExitHint(true);
    clearTimeout(exitHintTimer);
    exitHintTimer = setTimeout(() => {
      hackrEditor?.setExitHint(false);
    }, 4000);
  }

  // Clear hint and set working state on lifecycle events
  pi.on("agent_start", async (_event, _ctx) => {
    clearTimeout(exitHintTimer);
    hackrEditor?.setExitHint(false);
    hackrEditor?.setWorking(true);
  });

  pi.on("agent_end", async (_event, _ctx) => {
    hackrEditor?.setWorking(false);
  });

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;
    enabled = true;
    applyHackrUI(ctx);
  });

  function applyHackrUI(ctx: ExtensionContext) {
    const ui = ctx.ui;

    // ── Header ──
    ui.setHeader((_tui: TUI, _theme: Theme) => ({
      render(width: number): string[] {
        return renderHackrHeader(width, ctx.model?.id, ctx.cwd);
      },
      invalidate() {},
    }));

    // ── Footer ──
    ui.setFooter((_tui: TUI, _theme: Theme, footerData: any) => {
      const unsub = footerData.onBranchChange(() => _tui.requestRender());

      return {
        dispose: unsub,
        invalidate() {},
        render(width: number): string[] {
          let input = 0,
            output = 0,
            cost = 0;
          for (const e of ctx.sessionManager.getBranch()) {
            if (e.type === "message" && e.message.role === "assistant") {
              const m = e.message as AssistantMessage;
              input += m.usage.input;
              output += m.usage.output;
              cost += m.usage.cost.total;
            }
          }
          return renderHackrFooter(
            width,
            ctx.model?.id,
            footerData.getGitBranch(),
            input,
            output,
            cost,
            ctx.cwd,
          );
        },
      };
    });

    // ── Working indicator (charple→dolly gradient pulse) ──
    ui.setWorkingIndicator({
      frames: WORKING_FRAMES,
      intervalMs: 100,
    });

    // ── Working message ──
    ui.setWorkingMessage(fg(C.squid, "⋯ thinking"));

    // ── Hackr-style editor ──
    ui.setEditorComponent((tui, theme, keybindings) => {
      hackrEditor = new HackrEditor(tui, theme, keybindings, ctx, yoloMode, cmdMode);
      return hackrEditor;
    });

    // Apply initial yolo status
    applyYoloStatus(ctx);
  }

  function applyYoloStatus(ctx: ExtensionContext) {
    if (yoloMode) {
      ctx.ui.setStatus("yolo", bg(C.citron, fg(C.pepper, bold(" ! YOLO "))));
    } else {
      ctx.ui.setStatus("yolo", undefined);
    }
  }

  function applyCmdStatus(ctx: ExtensionContext) {
    if (cmdMode) {
      ctx.ui.setStatus("cmd", bg(C.charple, fg(C.butter, bold(" /cmd "))));
    } else {
      ctx.ui.setStatus("cmd", undefined);
    }
  }

  // ── Cmd output renderer (expandable) ──
  pi.registerMessageRenderer("cmd-output", (message, options, theme) => {
    const { expanded } = options;
    const details = message.details as {
      command: string;
      fullOutput: string;
      exitCode: number;
      truncated: boolean;
    } | undefined;

    const exitOk = details?.exitCode === 0;
    const icon = exitOk ? fg(C.julep, "✓") : fg(C.sriracha, "✗");
    const cmdLabel = fg(C.charple, bold(details?.command ?? "?"));
    const exitLabel =
      details?.exitCode !== 0
        ? " " + fg(C.sriracha, `[exit ${details.exitCode}]`)
        : "";

    let body = message.content as string;
    if (expanded && details?.fullOutput) {
      body = details.fullOutput;
    }

    const expandHint =
      !expanded && details?.truncated
        ? " " + fg(C.oyster, `(${keyHint("app.tools.expand", "expand")})`)
        : "";

    const text = `${icon} ${cmdLabel}${exitLabel}\n${body}${expandHint}`;
    return new Text(text, 0, 0);
  });

  // ── Cmd mode: intercept input and run via login shell ──
  let cmdRunning = false;

  pi.on("input", async (event, ctx) => {
    if (!cmdMode) return { action: "continue" };
    if (event.source === "extension") return { action: "continue" };
    if (cmdRunning) {
      ctx.ui.notify("A command is already running", "warning");
      return { action: "handled" };
    }

    const command = event.text.trim();
    if (!command) return { action: "handled" };

    cmdRunning = true;

    try {
      // Mutable state shared between widget and process handlers
      let liveOutput = "";
      let tuiRef: TUI | undefined;
      const liveText = new Text("", 1, 0);

      // Set up a live streaming widget
      ctx.ui.setWidget("cmd-live", (tui, theme) => {
        tuiRef = tui;
        const header = fg(C.charple, bold(`/cmd ${command}`)) + " " + fg(C.oyster, "⏳");
        liveText.setText(header + "\n" + liveOutput);
        return liveText;
      });

      const shell = process.env.SHELL ?? "/bin/bash";
      const child = spawn(shell, ["-l", "-c", command], {
        cwd: ctx.cwd,
        env: {
          ...process.env,
          HACKR_UI_CMD: "1",
          FORCE_COLOR: "1",
          COLORTERM: "truecolor",
          TERM: "xterm-256color",
        },
        stdio: ["ignore", "pipe", "pipe"],
      });

      const updateWidget = () => {
        const header = fg(C.charple, bold(`/cmd ${command}`)) + " " + fg(C.oyster, "⏳");
        liveText.setText(header + "\n" + liveOutput);
        tuiRef?.requestRender();
      };

      child.stdout.on("data", (data: Buffer) => {
        liveOutput += data.toString();
        updateWidget();
      });
      child.stderr.on("data", (data: Buffer) => {
        liveOutput += data.toString();
        updateWidget();
      });

      // Timeout
      const timer = setTimeout(() => {
        child.kill("SIGTERM");
        setTimeout(() => child.kill("SIGKILL"), 3000);
      }, 60_000);

      const code = await new Promise<number>((resolve) => {
        child.on("close", (c: number | null) => {
          clearTimeout(timer);
          resolve(c ?? 0);
        });
      });

      // Clear the live widget
      ctx.ui.setWidget("cmd-live", undefined);

      const output = liveOutput.trim() || "(no output)";
      const fullOutput = output;
      let truncated = false;
      let displayOutput = output;
      if (output.length > 3000) {
        displayOutput = output.slice(0, 3000) + "\n... (truncated)";
        truncated = true;
      }

      pi.sendMessage({
        customType: "cmd-output",
        content: displayOutput,
        display: true,
        details: {
          command,
          fullOutput,
          exitCode: code,
          truncated,
        },
      });
    } catch (err: any) {
      ctx.ui.setWidget("cmd-live", undefined);
      ctx.ui.notify(`Failed: ${err.message}`, "error");
    } finally {
      cmdRunning = false;
    }

    return { action: "handled" };
  });

  // ── Alt+C: toggle cmd mode ──
  pi.registerShortcut("alt+c", {
    description: "Toggle /cmd mode (run commands in login shell)",
    handler: async (ctx) => {
      cmdMode = !cmdMode;
      hackrEditor?.setCmd(cmdMode);
      applyCmdStatus(ctx);

      if (cmdMode) {
        ctx.ui.notify(
          bg(C.charple, fg(C.butter, bold(" /cmd "))) + " Cmd mode ON — input runs in $SHELL",
          "info",
        );
      } else {
        ctx.ui.notify("Cmd mode OFF — input goes to LLM", "info");
      }
    },
  });

  function removeHackrUI(ctx: ExtensionContext) {
    ctx.ui.setHeader(undefined);
    ctx.ui.setFooter(undefined);
    ctx.ui.setWorkingIndicator(undefined);
    ctx.ui.setWorkingMessage();
    ctx.ui.setEditorComponent(undefined);
    ctx.ui.setStatus("yolo", undefined);
    ctx.ui.setStatus("cmd", undefined);
    hackrEditor = undefined;
  }

  // ── YOLO mode command (visual + auto-accept) ──
  // duplicates. hackr-ui's /yolo handles both the visual indicator AND
  // the permission bypass.
  //
  // State is shared via pi.events so other extensions can query it.
  const YOLO_EVENT = "hackr-ui:yolo";

  pi.events.on(YOLO_EVENT, (state: boolean) => {
    yoloMode = state;
    hackrEditor?.setYolo(yoloMode);
  });

  pi.registerCommand("yolo", {
    description:
      "Toggle YOLO mode (auto-accept all permissions + visual indicator)",
    handler: async (_args, ctx) => {
      yoloMode = !yoloMode;
      hackrEditor?.setYolo(yoloMode);
      applyYoloStatus(ctx);
      pi.events.emit(YOLO_EVENT, yoloMode);

      if (yoloMode) {
        ctx.ui.notify(
          bg(C.citron, fg(C.pepper, bold(" ! "))) +
            " YOLO mode ON — all permissions auto-accepted",
          "warning",
        );
      } else {
        ctx.ui.notify("YOLO mode OFF — permission gates restored", "info");
      }
    },
  });

  // ── Auto-accept tool calls in YOLO mode ──
  const dangerousPatterns = [
    /\brm\s+(-rf?|--recursive)/i,
    /\bsudo\b/i,
    /\b(chmod|chown)\b.*777/i,
  ];

  pi.on("tool_call", async (event, ctx) => {
    if (yoloMode) return undefined;

    if (event.toolName === "bash") {
      const command = event.input.command as string;
      const isDangerous = dangerousPatterns.some((p) => p.test(command));

      if (isDangerous) {
        if (!ctx.hasUI) {
          return {
            block: true,
            reason: "Dangerous command blocked (no UI for confirmation)",
          };
        }

        const choice = await ctx.ui.select(
          `⚠️  Dangerous command:\n\n  ${command}\n\nAllow?`,
          ["Allow", "Block", "Block with reason"],
        );

        if (choice === "Allow") return undefined;

        if (choice === "Block with reason") {
          const reason = await ctx.ui.input("Reason for blocking:", "");
          if (reason?.trim()) {
            return { block: true, reason: `Blocked by user: ${reason.trim()}` };
          }
        }

        return { block: true, reason: "Blocked by user" };
      }
    }

    return undefined;
  });

  // ── Toggle Hackr UI ──
  pi.registerCommand("hackr-ui", {
    description:
      "Toggle Hackr-style UI (header, footer, editor, working indicator)",
    handler: async (_args, ctx) => {
      enabled = !enabled;
      if (enabled) {
        applyHackrUI(ctx);
        ctx.ui.notify("Hackr UI enabled ✨", "info");
      } else {
        removeHackrUI(ctx);
        ctx.ui.notify("Hackr UI disabled (default restored)", "info");
      }
    },
  });
}
