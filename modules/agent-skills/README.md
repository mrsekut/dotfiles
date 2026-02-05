# Agent Skills

Claude Code等のAIエージェント向けスキルを管理するモジュール。

## 構造

```
modules/agent-skills/
├── flake.nix      # スキルソースの定義 + 有効化するスキルの選択
├── flake.lock     # スキルソースのバージョン固定（自動生成）
├── default.nix    # agent-skillsの有効化とインストール先設定
└── README.md
```

- `flake.nix` - child flakeとして独立したinputsを持つ。スキルソースの追加・スキルの有効化はここ
- `default.nix` - メインのhome-manager.nixからインポートされる。基本的に編集不要

## インストール先

- `~/.claude/skills/` - Claude Code用
- `~/.agents/skills/` - その他エージェント用（Codex等）

## コマンド

```bash
# 適用 （通常これだけで良い）
just nix-apply

# スキルソースを最新に更新したい時
just skills-update
just nix-apply
```

## 確認方法

```bash
# インストールされたスキル一覧
ls ~/.claude/skills/

# 特定のスキルが存在するか
ls ~/.claude/skills/skill-creator/

# SKILL.mdの内容を確認
cat ~/.claude/skills/skill-creator/SKILL.md
```

## スキルの追加・変更

`flake.nix` の `skills.enable` を編集:

```nix
skills.enable = [
  "skill-creator"
  "frontend-design"  # 追加
];
```

## 新しいスキルソースの追加

`flake.nix` を編集:

```nix
inputs = {
  anthropic-skills = { url = "github:anthropics/skills"; flake = false; };
  my-skills = { url = "github:someone/my-skills"; flake = false; };  # 追加
};

outputs = { self, anthropic-skills, my-skills, ... }: {
  homeManagerModules.default = {
    programs.agent-skills = {
      sources.anthropic = { path = anthropic-skills; subdir = "skills"; };
      sources.mine = { path = my-skills; };  # 追加

      skills.enable = [ "skill-creator" "some-skill-from-mine" ];
    };
  };
};
```

## 参考

- [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix)
