---
name: update-prisma-schema
description: Prisma で定義された DB Schema の修正変更と、マイグレーション適用を実行します。データベーススキーマの変更が必要なときに使用してください。
allowed-tools: Read, Edit, Bash, Grep, Glob
---

# Update Prisma Schema Skill

このスキルは、Prisma のデータベーススキーマを変更し、マイグレーションを適用します。

## 目的

- Prisma スキーマファイル (`schema.prisma`) の修正
- マイグレーションファイルの生成
- データベースへのマイグレーション適用
- Prisma Client の再生成
- スキーマ変更の検証

## 使用タイミング

このスキルは以下の状況で使用してください：

- 新しいテーブル（モデル）を追加するとき
- 既存テーブルにカラムを追加・削除・変更するとき
- リレーション（外部キー）を追加・変更するとき
- インデックスやユニーク制約を追加するとき
- データ型を変更するとき

## 実行手順

### 0. Prisma + SQLite の初期セットアップ（初回のみ）

プロジェクトに Prisma がまだセットアップされていない場合は、以下の手順で初期化してください：

**Prisma のインストール：**

```bash
npm install prisma --save-dev
npm install @prisma/client
```

**Prisma の初期化（SQLite 用）：**

```bash
npx prisma init --datasource-provider sqlite
```

このコマンドは以下を生成します：
- `prisma/schema.prisma` - Prisma スキーマファイル
- `.env` - データベース接続文字列を含む環境変数ファイル

**生成された `prisma/schema.prisma` の確認：**

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}
```

**`.env` ファイルの確認：**

```env
DATABASE_URL="file:./dev.db"
```

SQLite の場合、データベースファイルは `prisma/dev.db` に作成されます。

**.gitignore への追加：**

SQLite のデータベースファイルは Git で管理しないため、`.gitignore` に追加してください：

```
# Prisma
prisma/*.db
prisma/*.db-journal
```

### 1. 現在のスキーマを確認

`prisma/schema.prisma` ファイルを読み込んで現在のスキーマを確認してください：

Read ツールで `prisma/schema.prisma` ファイルを読み込んでください。

### 2. スキーマファイルの修正

Edit ツールを使用して `prisma/schema.prisma` を修正してください。

**Prisma スキーマの基本構文：**

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String?
  published Boolean  @default(false)
  authorId  Int
  author    User     @relation(fields: [authorId], references: [id])
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
}
```

**主要なデータ型：**
- `String` - 文字列
- `Int` - 整数
- `Float` - 浮動小数点数
- `Boolean` - 真偽値
- `DateTime` - 日時
- `Json` - JSON データ

**主要な修飾子：**
- `@id` - 主キー
- `@unique` - ユニーク制約
- `@default(value)` - デフォルト値
- `@updatedAt` - 自動更新タイムスタンプ
- `?` - NULL 許容
- `[]` - 配列・リレーション（1対多）

### 3. スキーマの検証

スキーマファイルを修正したら、まず構文チェックを実行してください：

```bash
npx prisma validate
```

エラーがある場合は、Edit ツールで修正してください。

### 4. マイグレーションの生成

スキーマが正しければ、マイグレーションを生成してください：

```bash
npx prisma migrate dev --name <migration_name>
```

`<migration_name>` は変更内容を説明する名前を付けてください（例：`add_user_table`, `add_email_to_user`, `create_post_model`）。

このコマンドは以下を実行します：
1. マイグレーションファイルを `prisma/migrations/` に生成
2. データベースにマイグレーションを適用
3. Prisma Client を再生成

### 5. マイグレーションの確認

生成されたマイグレーションファイルを確認してください：

Read ツールで `prisma/migrations/` 内の最新の SQL ファイルを確認し、意図した変更が反映されているか確認してください。

### 6. Prisma Client の再生成確認

マイグレーション適用後、Prisma Client が自動的に再生成されます。TypeScript の型定義が更新されたことを確認してください：

Prisma Client の型定義は `node_modules/.prisma/client/` に生成されます。TypeScript のビルドで型が正しく認識されることを確認してください。

## 重要な注意事項

⚠️ **データ損失の危険性**: カラム削除やデータ型変更はデータ損失を引き起こす可能性があります。重要なデータがある場合は、ユーザーに確認してください。

⚠️ **マイグレーション名**: わかりやすい名前を付けてください。後から変更履歴を追跡できるようにします。

⚠️ **SQLite の制約**: SQLite は一部の ALTER TABLE 操作をサポートしていません（カラム削除、カラム型変更など）。このような変更が必要な場合、Prisma は自動的にテーブルを再作成します。

## マイグレーションのベストプラクティス

### 安全なスキーマ変更

✅ **安全な変更**:
- 新しいテーブルの追加
- 新しいカラムの追加（NULL 許容またはデフォルト値あり）
- インデックスの追加
- オプショナルフィールドの追加

⚠️ **注意が必要な変更**:
- カラムの削除（データ損失）
- NOT NULL 制約の追加（既存データに影響）
- データ型の変更（互換性の問題）
- ユニーク制約の追加（重複データがあると失敗）

### マイグレーションのロールバック

マイグレーションに問題があった場合、以下でリセットできます：

```bash
# マイグレーションをリセット
npx prisma migrate reset
```

**警告**: このコマンドは SQLite データベースファイルを削除し、すべてのマイグレーションを再適用します。データはすべて失われます。

## トラブルシューティング

### マイグレーションが失敗する

```bash
# マイグレーションの状態を確認
npx prisma migrate status

# 失敗したマイグレーションを解決
npx prisma migrate resolve --applied <migration_name>
```

### スキーマとデータベースが同期していない

```bash
# データベースをスキーマに合わせる（マイグレーション履歴を残さない方法）
npx prisma db push
```

**注意**: `db push` はマイグレーション履歴を作成せず、直接データベースを変更します。プロトタイピング時には便利ですが、通常は `migrate dev` を使用してください。

### Prisma Client が古い

```bash
# Prisma Client を手動で再生成
npx prisma generate
```

## 実行後の確認事項

スキーマ変更後は、以下を確認してください：

1. ✅ マイグレーションが正常に適用された
2. ✅ Prisma Client が再生成された
3. ✅ TypeScript のビルドエラーがない（`npm run build` で確認）
4. ✅ 関連するテストが通過する（`npm run test` で確認）
5. ✅ 既存の機能が動作する

必要に応じて、build や test の Subagent を呼び出してください。
