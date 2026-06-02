#!/usr/bin/env bun
// cosenseコマンドの認証ルーター
// 渡された引数から scrapbox の project 名を取り出し、~/.config/cosense-cli/config.json の
// 対応表(default + overrides)でどの profile(=PAT) を使うか決め、COSENSE_PAT を注入して
// 公式 cosense CLI(COSENSE_OFFICIAL_CLI) をそのまま起動する。
//
// 寛容に振る舞う: config や token が無くても落とさず、認証無しで公式に素通しする
// (--version / --help / public プロジェクト等を透過させるため)。

import { homedir } from "node:os";
import { join } from "node:path";

type Config = {
	profiles: Record<string, { token: string }>;
	default: string;
	overrides: Record<string, string>; // project名 -> profile名
};

const CONFIG_PATH = join(homedir(), ".config", "cosense-cli", "config.json");

await main();

async function main(): Promise<void> {
	const officialCli = process.env["COSENSE_OFFICIAL_CLI"];
	if (!officialCli) {
		console.error("cosense(router): COSENSE_OFFICIAL_CLI is not set");
		process.exit(1);
	}

	const args = process.argv.slice(2);
	const config = await loadConfig();

	const project = extractProject(args);
	const profileName = (project && config.overrides[project]) || config.default;
	const token = config.profiles[profileName]?.token?.trim();
	const isOverridden = !!(project && config.overrides[project]);

	const env = { ...process.env };
	if (token) {
		env["COSENSE_PAT"] = token;
	} else if (isOverridden) {
		// 例外マッピング対象なのに token 未設定 → 認証無しでは失敗する可能性
		console.error(
			`cosense(router): warning: project "${project}" maps to profile "${profileName}" but it has no token`,
		);
	}

	const proc = Bun.spawn(["bun", "run", officialCli, ...args], {
		env,
		stdout: "inherit",
		stderr: "inherit",
		stdin: "inherit",
	});
	process.exit(await proc.exited);
}

async function loadConfig(): Promise<Config> {
	try {
		const raw = (await Bun.file(CONFIG_PATH).json()) as Partial<Config>;
		return {
			profiles: raw.profiles ?? {},
			default: raw.default ?? "",
			overrides: raw.overrides ?? {},
		};
	} catch {
		return { profiles: {}, default: "", overrides: {} };
	}
}

// 引数群から scrapbox.io の project 名を取り出す。origin だけなら undefined。
function extractProject(args: string[]): string | undefined {
	for (const a of args) {
		const m = a.match(/scrapbox\.io\/([^/\s#?]+)/);
		if (m && m[1]) return decodeURIComponent(m[1]);
	}
	return undefined;
}
