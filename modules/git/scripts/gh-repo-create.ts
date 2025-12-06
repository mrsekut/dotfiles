#!/usr/bin/env bun
import { $ } from 'bun';
import { basename } from 'path';

type Visibility = '--public' | '--private';

main();

async function main(): Promise<void> {
  const visibility = parseArgs();
  if (!visibility) {
    showUsage();
  }

  const name = basename(process.cwd());

  try {
    await $`gh repo create ${name} ${visibility} --source=. --push`;
  } catch (error) {
    console.error('Failed to create repository');
    process.exit(1);
  }
}

function parseArgs(): Visibility | null {
  const arg = Bun.argv[2];
  if (arg === '--public' || arg === '--private') {
    return arg;
  }
  return null;
}

function showUsage(): void {
  console.log('Usage: ghrc [--public|--private]');
  process.exit(1);
}
