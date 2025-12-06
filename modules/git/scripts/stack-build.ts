#!/usr/bin/env bun
import { $ } from 'bun';

main();

async function main(): Promise<void> {
  const args = parseArgs();
  if (!args.from) {
    showUsage();
    process.exit(1);
  }

  const base = args.base ?? (await getCurrentBranch());
  let currentBase = base;

  console.log(`Building stack from '${args.from}' (base: ${base})\n`);

  while (true) {
    const commits = await getCommits(args.from, currentBase);
    if (commits.length === 0) {
      console.log('No more commits to cherry-pick');
      break;
    }

    const selected = await selectWithFzf(commits);
    if (selected.length === 0) {
      console.log('No commits selected');
      break;
    }

    const branchName = await prompt('Branch name: ');
    if (!branchName) {
      console.log('No branch name provided');
      break;
    }

    await createBranch(branchName, currentBase);
    await cherryPick(selected);

    currentBase = branchName;

    const continueAnswer = await prompt('\nContinue? (y/n): ');
    if (continueAnswer?.toLowerCase() !== 'y') {
      break;
    }
    console.log('');
  }

  console.log('\nDone!');
}

function parseArgs(): { from: string | null; base: string | null } {
  const args = Bun.argv.slice(2);
  let from: string | null = null;
  let base: string | null = null;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--from' && args[i + 1]) {
      from = args[i + 1];
      i++;
    } else if (args[i] === '--base' && args[i + 1]) {
      base = args[i + 1];
      i++;
    }
  }

  return { from, base };
}

function showUsage(): void {
  console.log(
    'Usage: git stack-build --from <source-branch> [--base <base-branch>]',
  );
}

async function getCurrentBranch(): Promise<string> {
  const result = await $`git rev-parse --abbrev-ref HEAD`.quiet().text();
  return result.trim();
}

async function getCommits(source: string, base: string): Promise<string[]> {
  try {
    const result = await $`git log --oneline ${base}..${source}`.quiet().text();
    return result
      .split('\n')
      .filter(line => line.trim())
      .reverse();
  } catch {
    return [];
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

  if (exitCode === 130) {
    process.exit(0);
  }

  return output
    .split('\n')
    .filter(line => line.trim())
    .map(line => line.split(' ')[0]);
}

async function prompt(message: string): Promise<string | null> {
  process.stdout.write(message);

  const proc = Bun.spawn(
    ['bash', '-c', 'read -r line < /dev/tty && echo "$line"'],
    {
      stdout: 'pipe',
      stderr: 'inherit',
    },
  );

  const output = await new Response(proc.stdout).text();
  await proc.exited;

  const trimmed = output.trim();
  return trimmed || null;
}

async function createBranch(name: string, base: string): Promise<void> {
  try {
    await $`git checkout -b ${name} ${base}`.quiet();
    console.log(`✓ Created branch '${name}' from '${base}'`);
  } catch {
    console.error(`✗ Failed to create branch '${name}'`);
    process.exit(1);
  }
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
}
