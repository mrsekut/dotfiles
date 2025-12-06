#!/usr/bin/env bun
import { $ } from 'bun';

// fzfを使って`git branch -d`を実行
// ctrl-iで選択し、ctrl-dで削除を実行
// developにmerge済みのものは`M`を付ける

main();

async function main(): Promise<void> {
  const merged = await getMergedBranches();
  const unmerged = await getUnmergedBranches();
  const allBranches = [...merged, ...unmerged];

  if (allBranches.length === 0) {
    console.log('No branches to delete');
    return;
  }

  const result = await selectBranchesWithFzf(allBranches);

  if (!result || result.key !== 'ctrl-d') {
    return;
  }

  await deleteBranches(result.branches);
}

async function getMergedBranches(): Promise<string[]> {
  try {
    const result = await $`git branch --merged develop`.quiet().text();
    return result
      .split('\n')
      .filter(b => !b.includes('*'))
      .filter(b => !b.match(/develop|master/))
      .filter(b => b.trim())
      .map(b => ` M ${b.trim()}`);
  } catch {
    return [];
  }
}

async function getUnmergedBranches(): Promise<string[]> {
  try {
    const result = await $`git branch --no-merged develop`.quiet().text();
    return result
      .split('\n')
      .filter(b => !b.includes('*'))
      .filter(b => b.trim())
      .map(b => `   ${b.trim()}`);
  } catch {
    return [];
  }
}

async function selectBranchesWithFzf(
  branches: string[],
): Promise<{ key: string; branches: string[] } | null> {
  const input = branches.join('\n');

  const proc = Bun.spawn(
    ['fzf', '--multi', '--reverse', '--print-query', '--expect=ctrl-d'],
    {
      stdin: new Response(input),
      stdout: 'pipe',
      stderr: 'inherit',
    },
  );

  const output = await new Response(proc.stdout).text();
  const exitCode = await proc.exited;

  if (exitCode !== 0 && exitCode !== 130) {
    return null;
  }

  const lines = output.split('\n');
  if (lines.length < 2) return null;

  return {
    key: lines[1],
    branches: lines.slice(2).filter(Boolean),
  };
}

async function deleteBranches(branches: string[]): Promise<void> {
  for (const line of branches) {
    const branch = extractBranchName(line);
    if (!branch) continue;

    try {
      await $`git branch -D ${branch}`.quiet();
      console.log(`Deleted: ${branch}`);
    } catch {
      console.error(`Failed to delete: ${branch}`);
    }
  }
}

function extractBranchName(line: string): string {
  // " M branch-name" or "   branch-name" -> "branch-name"
  return line.replace(/^ M |   /, '').trim();
}
