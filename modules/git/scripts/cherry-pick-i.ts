#!/usr/bin/env bun
import { $ } from 'bun';

main();

async function main(): Promise<void> {
  const source = parseArgs();
  if (!source) {
    showUsage();
    process.exit(1);
  }

  const commits = await getCommits(source);
  if (commits.length === 0) {
    console.log('No commits to cherry-pick');
    process.exit(0);
  }

  const selected = await selectWithFzf(commits);
  if (selected.length === 0) {
    console.log('No commits selected');
    process.exit(0);
  }

  await cherryPick(selected);
}

function parseArgs(): string | null {
  const args = Bun.argv.slice(2);
  const baseIndex = args.indexOf('--base');

  if (baseIndex !== -1 && args[baseIndex + 1]) {
    return args[baseIndex + 1];
  }

  // 位置引数としても受け付ける
  if (args.length > 0 && !args[0].startsWith('-')) {
    return args[0];
  }

  return null;
}

function showUsage(): void {
  console.log('Usage: git cherry-pick-i --base <source-branch>');
  console.log('       git cherry-pick-i <source-branch>');
}

async function getCommits(source: string): Promise<string[]> {
  try {
    const result = await $`git log --oneline HEAD..${source}`.quiet().text();
    return result
      .split('\n')
      .filter(line => line.trim())
      .reverse(); // 古い順にする
  } catch {
    console.error(`Failed to get commits from ${source}`);
    process.exit(1);
  }
}

async function selectWithFzf(commits: string[]): Promise<string[]> {
  const input = commits.join('\n');

  const proc = Bun.spawn(
    [
      'fzf',
      '--multi',
      '--reverse',
      '--ansi',
      '--header',
      'Ctrl-I: select, Enter: confirm',
      '--bind',
      'ctrl-i:toggle',
    ],
    {
      stdin: new Response(input),
      stdout: 'pipe',
      stderr: 'inherit',
    },
  );

  const output = await new Response(proc.stdout).text();
  const exitCode = await proc.exited;

  // fzf returns 130 on Ctrl-C
  if (exitCode === 130) {
    process.exit(0);
  }

  return output
    .split('\n')
    .filter(line => line.trim())
    .map(line => line.split(' ')[0]); // hashだけ抽出
}

async function cherryPick(hashes: string[]): Promise<void> {
  for (const hash of hashes) {
    try {
      await $`git cherry-pick ${hash}`;
      console.log(`✓ Cherry-picked: ${hash}`);
    } catch {
      console.error(`✗ Failed to cherry-pick: ${hash}`);
      console.error('  Resolve conflicts and run: git cherry-pick --continue');
      process.exit(1);
    }
  }

  console.log(`\n✓ Successfully cherry-picked ${hashes.length} commit(s)`);
}
