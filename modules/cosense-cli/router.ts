#!/usr/bin/env bun
// cosenseコマンドの認証ルーター
//
// 公式 cosense CLI は一度に 1 つの認証情報 (COSENSE_PAT) しか扱えない。
// 複数の Cosense プロジェクトを使い分けたいので、この router を
// PATH 上の `cosense` として噛ませ、引数から対象 project を判定して
// ~/.config/cosense-cli/config.json から使う PAT を解決し、
// COSENSE_PAT を注入したうえで公式 CLI 本体 (COSENSE_OFFICIAL_CLI) を起動する。
//
// 寛容に振る舞う: config や token が無くても落とさず、認証無しで公式に素通しする
// (--version / --help / public プロジェクト等を透過させるため)。
//
// config.json の形式
//   {
//     "default": "<どの project でも使う PAT>",
//     "<project名>": "<その project だけで使う PAT>", ...
//   }

import { homedir } from "node:os";
import { join } from "node:path";

type Config = Record<string, string>;

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
	const token = resolveToken(config, project)?.trim();

	const env = { ...process.env };
	if (token) {
		env["COSENSE_PAT"] = token;
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
		const raw: unknown = await Bun.file(CONFIG_PATH).json();
		return raw !== null && typeof raw === "object" ? (raw as Config) : {};
	} catch {
		return {};
	}
}

// 引数群から scrapbox.io の project 名を取り出す。origin だけなら undefined。
function extractProject(args: string[]): string | undefined {
	for (const a of args) {
		const captured = /scrapbox\.io\/([^/\s#?]+)/.exec(a)?.[1];
		if (captured !== undefined && captured !== "") {
			return decodeURIComponent(captured);
		}
	}
	return undefined;
}

// project 固有の PAT → default → どちらも無ければ undefined (無認証で素通し)。
// "default" は予約キーなので project 名としては引かない。
function resolveToken(
	config: Config,
	project: string | undefined,
): string | undefined {
	if (project !== undefined && project !== "default" && project in config) {
		return config[project];
	}
	return config["default"];
}
