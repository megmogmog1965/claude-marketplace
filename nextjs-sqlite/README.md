# nextjs-sqlite

Next.js + SQLite アーキテクチャでの開発を支援する Claude Code プラグインです。

```bash
~/ % npx create-next-app@latest

✔ What is your project named? … {project_name}
✔ Would you like to use TypeScript? … Yes
✔ Which linter would you like to use? › ESLint
✔ Would you like to use Tailwind CSS? … Yes
✔ Would you like your code inside a `src/` directory? … No
✔ Would you like to use App Router? (recommended) … Yes
✔ Would you like to use Turbopack? (recommended) … No
✔ Would you like to customize the import alias (`@/*` by default)? … No
```

## マーケットのインストール

```bash
/plugin marketplace add https://github.com/megmogmog1965/claude-marketplace
```

## プラグインのインストール

```bash
/plugin install nextjs-sqlite
```

## プラグインの構成

本プラグインでは、後述する `Slash Commands`, `Subagents`, `Agent Skills`, `Hooks`, `MCP Servers` によって、Next.js + SQLite アーキテクチャのWebアプリケーション開発を支援する。

```
nextjs-sqlite/
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
        - CLAUDE.md（docs/*.md へのリンク参照あり）
        - docs/*.md
            - software-development-lifecycle.md（開発プロセス・手順の指定）
            - coding-rule.md（コーディングルール）
            - architecture.md（利用技術・アーキテクチャ指定）
            - test-rule.md（ユニットテストコード生成のルール）
            - ui-design-rule.md（フロントエンドコード、UIデザインのルール）
- /req (❌️未実装)
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

Claude Agent に実行させたい一連の処理（能力, Subroutine）を定義します。

- update-req (❌️未実装)
    - 実装計画書の変更内容に基づいて、要件定義書の記述に不足があれば（開発工程を戻って）追記修正します。
- update-prisma-schema
    - Prisma で定義された DB Schema の修正変更と、マイグレーション適用を実行します。
- run_dev
    - 開発環境を起動します。既に起動していれば再起動するし、終わったらきちんと後片付けもします。

### Hooks

Claude Agent の判断に依存せず、ルールベースで必ず実行が保証される処理です。

- lint
    - ソースコードの修正が発生した場合に Subagent `lint` を自動的に実行します。

### MCP Servers

> 現時点では MCP Server は導入しません。
