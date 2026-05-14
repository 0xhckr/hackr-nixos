/**
 * Permission Gate Extension
 *
 * Prompts for confirmation before running potentially dangerous bash commands.
 * Patterns checked: rm -rf, sudo, chmod/chown 777
 *
 * Options:
 *   - "Allow" — let it through
 *   - "Block" — deny
 *   - "Block with reason" — deny and provide feedback so the LLM can adjust
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const dangerousPatterns = [/\brm\s+(-rf?|--recursive)/i, /\bsudo\b/i, /\b(chmod|chown)\b.*777/i];
	let yoloMode = false;

	pi.registerCommand("yolo", {
		description: "Toggle YOLO mode (skip all permission gates)",
		handler: async (_args, ctx) => {
			yoloMode = !yoloMode;
			if (yoloMode) {
				ctx.ui.setStatus("yolo", ctx.ui.theme.fg("warning", "🔥 YOLO"));
				ctx.ui.notify("YOLO mode ON — all dangerous commands bypass confirmation", "warning");
			} else {
				ctx.ui.setStatus("yolo", undefined);
				ctx.ui.notify("YOLO mode OFF — permission gates restored", "info");
			}
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;
		if (yoloMode) return undefined;

		const command = event.input.command as string;
		const isDangerous = dangerousPatterns.some((p) => p.test(command));

		if (isDangerous) {
			if (!ctx.hasUI) {
				return { block: true, reason: "Dangerous command blocked (no UI for confirmation)" };
			}

			const choice = await ctx.ui.select(
				`⚠️ Dangerous command:\n\n  ${command}\n\nAllow?`,
				["Allow", "Block", "Block with reason"],
			);

			if (choice === "Allow") {
				return undefined;
			}

			if (choice === "Block with reason") {
				const reason = await ctx.ui.input("Reason for blocking:", "");
				if (reason?.trim()) {
					return { block: true, reason: `Blocked by user: ${reason.trim()}` };
				}
			}

			return { block: true, reason: "Blocked by user" };
		}

		return undefined;
	});
}
