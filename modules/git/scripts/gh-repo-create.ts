#!/usr/bin/env bun
import { $ } from 'bun';
import { basename } from 'path';
import { parseArgs } from 'util';

main();

async function main(): Promise<void> {
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      public: { type: 'boolean' },
      private: { type: 'boolean' },
    },
  });

  const visibility = (() => {
    if (values.public) return '--public';
    if (values.private) return '--private';
    return null;
  })();

  if (!visibility) {
    console.log('Usage: ghrc [--public|--private]');
    process.exit(1);
  }

  const name = basename(process.cwd());

  try {
    await $`gh repo create ${name} ${visibility} --source=. --push`;
  } catch {
    console.error('Failed to create repository');
    process.exit(1);
  }
}
