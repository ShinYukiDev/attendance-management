---
name: create-issue
description: GitHub.comにIssueを作成します。
argument-hint: "背景・目的・依頼内容を簡潔に記載してください。"
tools: [github/issue_write]
---

# 目的

GitHub.com上に、最適なテンプレートに沿ったIssueを1件作成する。

# 前提

- リポジトリ内のテンプレートは以下の3種類を利用する。
  - `.github/ISSUE_TEMPLATE/bug_report.yml`
  - `.github/ISSUE_TEMPLATE/feature_request.yml`
  - `.github/ISSUE_TEMPLATE/task.yml`

# 実行手順

1. ユーザー入力（背景・目的・依頼内容）を読み取り、Issue種別を以下で判定する。
   - bug_report: 不具合報告、再現手順、期待値と実際値の差分が中心
   - feature_request: 新機能・改善提案、価値や目的、提案内容が中心
   - task: 実施作業の整理、運用・調査・準備・更新などの実務タスクが中心
2. 情報不足がある場合のみ、最小限の追加質問を行う（最大5問）。
3. 選んだテンプレートファイル（`.github/ISSUE_TEMPLATE/*.yml`）を参照し、`body`定義の項目順・ラベル名に合わせてIssue本文を日本語で作成する。
4. タイトルとラベルをテンプレート定義に合わせる。
   - bug_report: タイトル接頭辞 `[Bug] `、ラベル `bug`
   - feature_request: タイトル接頭辞 `[Feature] `、ラベル `enhancement`
   - task: タイトル接頭辞 `[Task] `、ラベル `task`
5. GitHub MCPでIssueを作成する。
   - `method`: `create`
   - `owner`: 現在のリポジトリオーナー
   - `repo`: 現在のリポジトリ名
   - `title`: 接頭辞付きタイトル
   - `body`: テンプレート準拠の本文
   - `labels`: 上記ラベル
6. 実行後、作成結果を簡潔に報告する（Issue番号、タイトル、URL、使用テンプレート）。

# 本文生成ルール

- 常に選択したテンプレートYAMLを一次情報として参照し、見出し・項目順・必須項目を反映して本文を構成する。
- テンプレートに項目が追加・削除・改名されている場合は、その最新定義を優先する。
- `textarea` は複数行、`input` は1行で簡潔に記載する。
- `validations.required: true` の項目は、未確定のまま作成しない。

# 出力ルール

- すべて日本語で回答する。
- 推測で断定せず、曖昧な点は短く確認してから作成する。
- 本文は簡潔かつ再利用しやすい構成にする。
