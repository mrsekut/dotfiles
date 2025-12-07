#!/usr/bin/env bun
import { $ } from 'bun';
import { unlinkSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

type Args = { from: string | null; base: string | null };
type Group = { groupNum: number; hashes: string[] };
type BranchDef = { groupNum: number; branchName: string; hashes: string[] };

main();

/**
 * git stack-branch --from <source-branch> [--base <base-branch>]
 *
 * --from: ソースブランチ
 * --base: ベースブランチ (省略時は現在のブランチ)
 *
 * コミットをグループ化し、各グループごとにブランチを作成する
 */
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
  if (groups.length === 0) {
    console.log('No groups defined');
    process.exit(0);
  }

  const branchDefs = await askBranchNames(groups);

  await createBranches(branchDefs, base);

  console.log('\nDone!');
}

function parseArgs(): Args {
  const args = Bun.argv.slice(2);

  const findArg = (flag: string) => {
    const index = args.indexOf(flag);
    return index !== -1 && args[index + 1] ? args[index + 1] : null;
  };

  return {
    from: findArg('--from'),
    base: findArg('--base'),
  };
}

function showUsage(): void {
  console.log(
    'Usage: git stack-branch --from <source-branch> [--base <base-branch>]',
  );
}

async function getCurrentBranch(): Promise<string> {
  return (await $`git rev-parse --abbrev-ref HEAD`.quiet().text()).trim();
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

async function editAndParseGroups(commits: string[]): Promise<Group[]> {
  const tmpFile = join(tmpdir(), `stack-${Date.now()}.txt`);

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

function parseGroups(content: string): Group[] {
  const lines = content.split('\n');

  const isComment = (line: string) => line.trim().startsWith('#');
  const isEmpty = (line: string) => !line.trim();
  const extractHash = (line: string) => line.trim().match(/^([a-f0-9]+)/)?.[1];

  type State = { groups: Group[]; current: string[] };

  const initialState: State = { groups: [], current: [] };

  const finalState = lines
    .filter(line => !isComment(line))
    .reduce<State>((state, line) => {
      if (isEmpty(line)) {
        return state.current.length > 0
          ? {
              groups: [
                ...state.groups,
                { groupNum: state.groups.length + 1, hashes: state.current },
              ],
              current: [],
            }
          : state;
      }

      const hash = extractHash(line);
      return hash ? { ...state, current: [...state.current, hash] } : state;
    }, initialState);

  // Don't forget the last group
  return finalState.current.length > 0
    ? [
        ...finalState.groups,
        {
          groupNum: finalState.groups.length + 1,
          hashes: finalState.current,
        },
      ]
    : finalState.groups;
}

async function askBranchNames(groups: Group[]): Promise<BranchDef[]> {
  console.log('');

  const results = await groups.reduce<Promise<BranchDef[]>>(
    async (accPromise, group) => {
      const acc = await accPromise;
      const name = await prompt(
        `Branch for group ${group.groupNum} (${group.hashes.length} commits): `,
      );

      if (!name) {
        console.log(`No name for group ${group.groupNum}, skipping`);
        return acc;
      }

      return [...acc, { ...group, branchName: name }];
    },
    Promise.resolve([]),
  );

  return results;
}

async function createBranches(
  branchDefs: BranchDef[],
  initialBase: string,
): Promise<void> {
  console.log('\nCreating branches...');

  await branchDefs.reduce<Promise<string>>(async (basePromise, def) => {
    const currentBase = await basePromise;

    try {
      await $`git checkout -b ${def.branchName} ${currentBase}`.quiet();
      console.log(
        `\n✓ Created branch '${def.branchName}' from '${currentBase}'`,
      );

      await def.hashes.reduce<Promise<void>>(async (prev, hash) => {
        await prev;
        await $`git cherry-pick ${hash}`;
        console.log(`  ✓ Cherry-picked: ${hash}`);
      }, Promise.resolve());

      return def.branchName;
    } catch {
      console.error(`✗ Failed at branch '${def.branchName}'`);
      console.error('  Resolve conflicts and continue manually');
      process.exit(1);
    }
  }, Promise.resolve(initialBase));
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
