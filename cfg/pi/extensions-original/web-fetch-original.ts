/**
 * Web Fetch Extension
 *
 * Adds a `web_fetch` tool that the LLM can use to make HTTP requests.
 * Backed by curl — no extra deps needed.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { StringEnum } from "@earendil-works/pi-ai";
import { Type } from "typebox";

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "web_fetch",
		label: "Web Fetch",
		description:
			"Fetch content from a URL. Returns the response body as text. Use for reading web pages, API endpoints, or downloading files.",
		promptSnippet: "Fetch and read content from URLs",
		promptGuidelines: [
			"Use web_fetch when you need to read a web page, API response, or remote file.",
			"For search queries, prefer web_search if available; use web_fetch for known URLs.",
		],
		parameters: Type.Object({
			url: Type.String({ description: "The URL to fetch" }),
			method: Type.Optional(
				StringEnum(["GET", "POST", "PUT", "DELETE"] as const, {
					description: "HTTP method",
					default: "GET",
				}),
			),
			headers: Type.Optional(
				Type.Record(Type.String(), Type.String(), { description: "Optional HTTP headers" }),
			),
			body: Type.Optional(Type.String({ description: "Optional request body" })),
			maxLength: Type.Optional(
				Type.Number({ description: "Max characters to return (default 50000)", default: 50000 }),
			),
		}),

		async execute(_toolCallId, params, signal, onUpdate, ctx) {
			const args = ["-sS", "-L", "--max-time", "30"];

			// Method
			const method = params.method || "GET";
			if (method !== "GET") {
				args.push("-X", method);
			}

			// Headers
			if (params.headers) {
				for (const [key, value] of Object.entries(params.headers)) {
					args.push("-H", `${key}: ${value}`);
				}
			}

			// Body
			if (params.body) {
				args.push("-d", params.body);
			}

			// URL
			args.push(params.url);

			onUpdate?.({
				content: [{ type: "text", text: `Fetching ${params.url}...` }],
			});

			const result = await pi.exec("curl", args, { signal });
			const maxLen = params.maxLength ?? 50000;

			if (result.code !== 0) {
				return {
					content: [
						{
							type: "text",
							text: `HTTP request failed (exit code ${result.code}): ${result.stderr.trim() || "unknown error"}`,
						},
					],
					isError: true,
				};
			}

			let body = result.stdout;
			const truncated = body.length > maxLen;
			if (truncated) {
				body = body.slice(0, maxLen);
			}

			let text = body;
			if (truncated) {
				text += `\n\n... (truncated at ${maxLen} chars, full response was ${result.stdout.length} chars)`;
			}

			return {
				content: [{ type: "text", text }],
				details: { url: params.url, method: params.method || "GET", truncated },
			};
		},
	});
}
