# Agent Skills

Claude Code等のAIエージェント向けスキルを管理するモジュール。

## 構造

```
modules/
├── agent-skills.nix       # スキルソースの定義 + 有効化するスキルの選択
├── agent-skills/
│   ├── default.nix        # agent-skillsの有効化とインストール先設定
│   ├── skills/            # ローカルスキル
│   └── README.md
```

- `agent-skills.nix` - スキルソースの追加・スキルの有効化はここ
- `agent-skills/default.nix` - メインのhome-manager.nixからインポートされる。基本的に編集不要
- スキルソースのinputsはroot `flake.nix` で管理

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

`modules/agent-skills.nix` の `skills.enable` を編集:

```nix
skills.enable = [
  "skill-creator"
  "frontend-design"  # 追加
];
```

## 新しいスキルソースの追加

1. root `flake.nix` の inputs に追加:

```nix
inputs = {
  my-skills = { url = "github:someone/my-skills"; flake = false; };  # 追加
};
```

2. root `flake.nix` の outputs と extraSpecialArgs に追加:

```nix
outputs = { ..., my-skills, ... }:
  # ...
  extraSpecialArgs = {
    inherit ... my-skills;  # 追加
  };
```

3. `modules/agent-skills.nix` で source と enable を設定:

```nix
{ ..., my-skills, ... }:
{
  programs.agent-skills = {
    sources.mine = { path = my-skills; };  # 追加
    skills.enable = [ "skill-creator" "some-skill-from-mine" ];
  };
}
```

## 参考

- [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix)
