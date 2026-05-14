/**
 * JJ Describe Extension
 *
 * Adds /jj-desc command that generates a jj commit description from the current diff
 * using the active model, then sets it with `jj describe`.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "jj_describe",
		label: "JJ Describe",
		description:
			"Generate a concise jj commit description from the current working copy diff. Reads the diff, summarizes it, and sets it via `jj describe`.",
		promptSnippet: "Generate and set a jj commit description from the current diff",
		promptGuidelines: [
			"Use jj_describe when the user asks to generate or set a commit message for jj.",
			"Do NOT run `jj describe` or `jj commit` directly — always use jj_describe to respect user approval.",
		],
		parameters: Type.Object({
			message: Type.String({ description: "The commit description to set via jj describe" }),
		}),

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			// Set the description
			const result = await pi.exec("jj", ["describe", "-m", params.message], {
				cwd: ctx.cwd,
			});

			if (result.code !== 0) {
				return {
					content: [
						{
							type: "text",
							text: `Failed to set description: ${result.stderr.trim() || result.stdout.trim()}`,
						},
					],
					isError: true,
				};
			}

			return {
				content: [
					{
						type: "text",
						text: `✓ Description set: ${params.message.split("\n")[0]}`,
					},
				],
			};
		},
	});

	pi.registerCommand("jj-desc", {
		description: "Generate a jj commit description from the current diff",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) {
				ctx.ui.notify("/jj-desc requires interactive mode", "error");
				return;
			}

			// Get the diff
			const diffResult = await pi.exec("jj", ["diff"], { cwd: ctx.cwd });
			if (diffResult.code !== 0) {
				ctx.ui.notify(`Failed to get diff: ${diffResult.stderr}`, "error");
				return;
			}

			const diff = diffResult.stdout.trim();
			if (!diff) {
				ctx.ui.notify("No changes to describe", "info");
				return;
			}

			// Get current description
			const descResult = await pi.exec("jj", ["log", "-r", "@", "-T", "description"], {
				cwd: ctx.cwd,
			});
			const currentDesc = descResult.stdout.trim();

			// Send to the model as a steering message
			pi.sendUserMessage(
				[
					{
						type: "text",
						text: `Generate a concise jj commit description for the current working copy changes.

Rules:
- First line is a short summary (imperative mood, no period, under 72 chars)
- Optionally followed by a blank line and bullet points for details
- Do NOT include the diff in the output
- Just output the description text, nothing else

Current description: ${currentDesc || "(none)"}

Diff:
\`\`\`
${diff.slice(0, 30000)}${diff.length > 30000 ? "\n... (truncated)" : ""}
\`\`\`

Once you have the description, use the jj_describe tool to set it.`,
					},
				],
				{ deliverAs: "followUp" },
			);
		},
	});
}
