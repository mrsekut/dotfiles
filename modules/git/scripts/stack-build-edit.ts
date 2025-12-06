#!/usr/bin/env bun
import { $ } from 'bun';
import { unlinkSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

main();

async function main(): Promise<void> {
  const args = parseArgs();
  if (!args.from) {
    showUsage();
    process.exit(1);
  }

  const base = args.base ?? (await getCurrentBranch());

  const commits = await getCommits(args.from, base);
  if (commits.length === 0) {
    console.log('No commits to cherry-pick');
    process.exit(0);
  }

  const groups = await editAndParseGroups(commits);
  if (groups.size === 0) {
    console.log('No groups defined');
    process.exit(0);
  }

  const branchNames = await askBranchNames(groups);

  await createBranches(groups, branchNames, base);

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
    'Usage: git stack-build-edit --from <source-branch> [--base <base-branch>]',
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

async function editAndParseGroups(
  commits: string[],
): Promise<Map<number, string[]>> {
  const tmpFile = join(tmpdir(), `stack-build-${Date.now()}.txt`);

  const content = `# Separate groups with blank lines
# Delete lines to exclude commits
# Save and close to continue
#
# Example:
#   a1b2c3d feat: add auth
#   b2c3d4e feat: add login
#
#   c3d4e5f feat: add api
#
#   d4e5f6g feat: add tests
#

${commits.join('\n')}
`;

  await Bun.write(tmpFile, content);

  const editor = process.env.EDITOR || 'vim';
  const proc = Bun.spawn([editor, tmpFile], {
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit',
  });
  await proc.exited;

  const edited = await Bun.file(tmpFile).text();

  try {
    unlinkSync(tmpFile);
  } catch {
    // ignore
  }

  return parseGroups(edited);
}

function parseGroups(content: string): Map<number, string[]> {
  const groups = new Map<number, string[]>();
  let currentGroup = 1;
  let hasCommitsInCurrentGroup = false;

  for (const line of content.split('\n')) {
    const trimmed = line.trim();

    // Skip comments
    if (trimmed.startsWith('#')) continue;

    // Empty line = new group (if current group has commits)
    if (!trimmed) {
      if (hasCommitsInCurrentGroup) {
        currentGroup++;
        hasCommitsInCurrentGroup = false;
      }
      continue;
    }

    // Parse commit hash
    const match = trimmed.match(/^([a-f0-9]+)/);
    if (match) {
      const hash = match[1];

      if (!groups.has(currentGroup)) {
        groups.set(currentGroup, []);
      }
      groups.get(currentGroup)!.push(hash);
      hasCommitsInCurrentGroup = true;
    }
  }

  return groups;
}

async function askBranchNames(
  groups: Map<number, string[]>,
): Promise<Map<number, string>> {
  const branchNames = new Map<number, string>();
  const sortedGroups = [...groups.keys()].sort((a, b) => a - b);

  console.log('');
  for (const groupNum of sortedGroups) {
    const commits = groups.get(groupNum)!;
    const name = await prompt(
      `Branch for group ${groupNum} (${commits.length} commits): `,
    );
    if (!name) {
      console.log(`No name for group ${groupNum}, skipping`);
      continue;
    }
    branchNames.set(groupNum, name);
  }

  return branchNames;
}

async function createBranches(
  groups: Map<number, string[]>,
  branchNames: Map<number, string>,
  initialBase: string,
): Promise<void> {
  const sortedGroups = [...groups.keys()].sort((a, b) => a - b);
  let currentBase = initialBase;

  console.log('\nCreating branches...');

  for (const groupNum of sortedGroups) {
    const branchName = branchNames.get(groupNum);
    if (!branchName) continue;

    const hashes = groups.get(groupNum)!;

    try {
      await $`git checkout -b ${branchName} ${currentBase}`.quiet();
      console.log(`\n✓ Created branch '${branchName}' from '${currentBase}'`);

      for (const hash of hashes) {
        await $`git cherry-pick ${hash}`;
        console.log(`  ✓ Cherry-picked: ${hash}`);
      }

      currentBase = branchName;
    } catch (error) {
      console.error(`✗ Failed at branch '${branchName}'`);
      console.error('  Resolve conflicts and continue manually');
      process.exit(1);
    }
  }
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
