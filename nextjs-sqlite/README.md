# nextjs-sqlite

Next.js + SQLite アーキテクチャでの開発を支援する Claude Code プラグインです。

## マーケットのインストール

```bash
/marketplace add megmogmog1965/claude-marketplace
```

## プラグインのインストール

```bash
/plugin install nextjs-sqlite
```

## プラグインの構成

本プラグインでは、後述する `Slash Commands`, `Subagents`, `Agent Skills`, `Hooks`, `MCP Servers` によって、Next.js + SQLite アーキテクチャのWebアプリケーション開発を支援する。

```
my-first-plugin/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── commands/                 # Custom slash commands (optional)
│   └── {command_name}.md
├── agents/                   # Custom agents (optional)
│   └── {agent_name}.md
├── skills/                   # Agent Skills (optional)
│   └── {skill_name}/
│       └── SKILL.md
└── hooks/                    # Event handlers (optional)
    └── hooks.json
```

### Slash Commands

開発者（人間）向けの特定処理のショートカットコマンドです。

- /init
    - 本プラグインを導入したプロジェクトに、次の Claude Code 向けのファイルを導入します。
        - CLAUDE.md
- /req
    - 要件定義書の作成を開始する Slash command です。
- /spec
    - 実装計画書の作成を開始する Slash command です。引数に要件定義書の要件定義番号を入力します。

### Subagents

不要なコンテキスト汚染・占有を回避する目的で、頻繁に実施される＆テキスト出力の多い処理を Subagent として実行します。

- lint
    - description: ESLint 及び各種 Linter を実行し、ソースコードの静的解析を行います。違反が検出された場合は修正を行います。
    - command: `npm run lint`
- build
    - description: TypeScript のビルドを実行します。ビルドエラーが検出された場合は修正を行います。
    - command: `npm run build`
- test
    - description: Vitest によるユニットテストを実行します。テストのエラーが検出された場合は修正を行います。
    - command: `npm run test`

### Agent Skills

Claude Agent に実行させたい処理を定義します。

- update-req
    - 実装計画書の変更内容に基づいて、要件定義書の記述に不足があれば（開発工程を戻って）追記修正します。
- update-prisma-schema
    - Prisma で定義された DB Schema の修正変更と、マイグレーション適用を実行します。
- run_dev
    - 開発環境を起動します。

### Hooks

Claude Agent の判断に依存せず、ルールベースで必ず実行が保証される処理です。

- lint
    - ソースコードの修正が発生した場合に Subagent `lint` を自動的に実行します。

### MCP Servers

> 現時点では MCP Server は導入しません。
