# Conventional Commits コミットルール

このプロジェクトのコミットメッセージは、Conventional Commits に従う。

## 0. 適用範囲

- 適用対象: 全ブランチ・全コミット。
- 例外: `Merge branch ...` などGitが自動生成するマージコミットメッセージは許容する。
- 例外: `Revert "..."` などGitが自動生成する取り消しコミットメッセージは許容する。

## 1. 基本フォーマット

```text
<type>(<scope>): <subject>

<body>

<footer>
```

- `scope` は任意。
- `body` と `footer` は必要な場合のみ記載する。
- 1コミット1目的を守る。

### 1.1 自動検証可能な最小条件

- ヘッダー形式は `type(scope): subject` または `type: subject` とする。
- `type` は本書で定義した値のみ使用する。
- `subject` は1行で記載し、末尾に句点 `。` を付けない。

## 2. ヘッダー記述ルール

- `type` は小文字で記述する。
- `subject` は日本語で簡潔に書く（句点 `。` は付けない）。
- 主語は省略し、何を変更したかを明確に書く。
- 先頭文字のスタイルは統一する（本プロジェクトでは通常文で可）。

## 3. 使用する type

- `feat`: ユーザー向け機能追加・変更
- `fix`: バグ修正
- `docs`: ドキュメント追加・修正
- `test`: テスト追加・修正
- `refactor`: 挙動を変えない内部改善
- `perf`: パフォーマンス改善
- `style`: フォーマットやスタイルのみの変更（ロジック変更なし）
- `build`: ビルド設定・依存関係の変更
- `ci`: CI/CD設定の変更
- `chore`: 雑多な保守作業（設定、補助ファイルなど）
- `revert`: 既存コミットの取り消し

## 4. scope の指針

以下から変更箇所に近いものを選ぶ。

- `ui` (Blazor / MudBlazor)
- `api`
- `data` (EF Core / SQLite)
- `auth`
- `test`
- `docs`
- `build`
- `standards`
- `service`
- `git`

例:

- `feat(ui): 社員一覧画面に検索欄を追加`
- `fix(data): 社員更新時の同時更新競合を修正`
- `docs(standards): 開発標準書にTDD方針を追記`

## 5. BREAKING CHANGE

互換性を壊す変更は以下のいずれかで明示する。

1. `type` の直後に `!` を付ける
2. `footer` に `BREAKING CHANGE:` を記載する

例:

```text
feat(api)!: 社員取得APIのレスポンス形式を変更

BREAKING CHANGE: /employees のレスポンスから legacyCode を削除
```

## 6. body / footer の使い分け

- `body`: 背景・理由・補足を記述する。
- `footer`: Issue番号や破壊的変更を記述する。

例:

```text
fix(auth): ログイン時のNull参照を修正

再現条件:
- 外部認証プロバイダーからメール未返却のユーザー

Refs: #123
```

```text
chore(docs): イシューテンプレートを追加

理由：イシュー作成の効率化

詳細：
- バグ報告テンプレート
- 機能追加テンプレート
- タスクテンプレート
```

## 7. NG例

- `update`
- `fix bug`
- `WIP`
- `いろいろ修正`

上記のような曖昧なコミットメッセージは禁止する。

## 8. 推奨ルール（運用）

- 次のいずれかに該当する場合はコミットを分割する。
  - 機能追加とリファクタが同時に含まれる。
  - 変更理由が2種類以上ある。
  - レビュー観点が別になる変更を同時に含む。
- `feat` と `refactor` を同一コミットに混在させない。
- 自動整形のみの変更は `style` または `chore` を使用する。
- リリースノート生成を意識し、`subject` は機能単位で明確に書く。

## 9. 本プロジェクトで使う実例

- `feat(ui): 社員登録フォームに部署選択を追加`
- `fix(data): 退職日がNullのとき一覧表示で落ちる問題を修正`
- `test(service): EmployeeServiceの作成失敗ケースを追加`
- `docs(standards): DB命名規約を複数形に更新`
- `chore(git): .gitignore を追加`
