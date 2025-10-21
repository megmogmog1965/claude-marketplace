---
name: run_dev
description: 動作検証のために開発サーバーを起動・停止します。既に起動している場合は再起動します。検証完了後は必ずサーバーを停止してください。
allowed-tools: Bash, Read, Grep
---

# Run Dev Server Skill

このスキルは、Next.js の開発サーバーを動作検証のために起動・停止します。

## 目的

- Claude が実装した機能の動作検証を行うために開発サーバーを起動する
- 検証完了後はサーバーを停止し、ユーザーの手動操作を阻害しない
- 既に起動中のサーバーがあれば、それを停止してから新しく起動する

## 使用タイミング

このスキルは以下の状況で使用してください：

- 実装した機能の動作確認が必要なとき
- ブラウザでの表示確認が必要なとき
- API エンドポイントの動作テストが必要なとき

## 重要な注意事項

⚠️ **必ずサーバーを停止する**: 検証が完了したら、必ず開発サーバーを停止してください。ユーザーが自分で `npm run dev` を実行できるようにするためです。

## 実行手順

### 1. 既存サーバーの確認と停止

まず、既に開発サーバーが起動しているか確認してください：

```bash
# Next.js の開発サーバープロセスを確認
ps aux | grep -E "next dev|next-server" | grep -v grep
```

既に起動している場合は停止してください：

```bash
# Next.js 開発サーバーのプロセスを停止
pkill -f "next dev" || pkill -f "next-server"
```

### 2. 開発サーバーの起動

バックグラウンドで開発サーバーを起動してください：

```bash
cd $CLAUDE_PROJECT_DIR && npm run dev > /tmp/nextjs-dev.log 2>&1 &
```

起動確認：

```bash
# サーバーが起動するまで待機（最大30秒）
for i in {1..30}; do
  if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "Development server is ready at http://localhost:3000"
    break
  fi
  sleep 1
done
```

### 3. 動作検証の実行

- ブラウザで http://localhost:3000 にアクセスして動作を確認してください
- API エンドポイントをテストする場合は `curl` コマンドを使用してください
- 必要に応じてログを確認してください：`tail -f /tmp/nextjs-dev.log`

### 4. 検証完了後の停止（必須）

検証が完了したら、**必ず**以下のコマンドでサーバーを停止してください：

```bash
# Next.js 開発サーバーのプロセスを停止
pkill -f "next dev" || pkill -f "next-server"

# 停止確認
ps aux | grep -E "next dev|next-server" | grep -v grep
```

停止を確認したら、ユーザーに以下を伝えてください：
「開発サーバーを停止しました。必要に応じて `npm run dev` で再起動できます。」

## ベストプラクティス

- サーバー起動後、実際にアクセス可能になるまで数秒待ってください
- エラーが発生した場合は `/tmp/nextjs-dev.log` を確認してください
- ポート 3000 が既に使用されている場合は、別のプロセスが原因の可能性があります
- 検証が長引く場合でも、完了したら必ずサーバーを停止してください

## トラブルシューティング

### ポートが既に使用されている

```bash
# ポート 3000 を使用しているプロセスを確認
lsof -i :3000

# 必要に応じて停止
kill -9 <PID>
```

### サーバーが起動しない

```bash
# ログを確認
cat /tmp/nextjs-dev.log

# package.json に dev スクリプトがあるか確認
grep "\"dev\"" $CLAUDE_PROJECT_DIR/package.json

# node_modules が存在するか確認
ls $CLAUDE_PROJECT_DIR/node_modules
```
