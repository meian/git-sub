# Git Utilities Collection

Git操作を効率化するためのユーティリティスクリプト集です。

## 📁 プロジェクト構造

```
.
├── .github/
│   └── instructions/        # 開発ガイドライン
├── .devcontainer/           # 開発コンテナ設定
├── git-*                    # Gitユーティリティスクリプト
├── common.sh                # 共通関数
├── install.sh               # インストールスクリプト
├── install-alias.sh         # エイリアスのインストール
├── refresh-completions.sh   # 補完更新スクリプト
└── README.md                # このファイル
```

## 🛠️ 利用可能なスクリプト

| スクリプト名 | 説明 |
|---|---|
| `git-fixup` | fixup対象をコミットIDでなくメッセージからインタラクティブに選択してコミットを作成 |
| `git-last` | 最後のコミットの差分を表示 |
| `git-latest` | 指定したブランチの最新情報をリモートから取得 |
| `git-local-branch` | ローカルに作成済のブランチをインタラクティブに選択 |
| `git-select-cherry-pick` | インタラクティブなcherry-pickツール |

## エイリアス

追加サブコマンドを `.git-alias` に定義することで、Gitコマンドを簡略化できます。  
`.git-alias` は `install-alias.sh` を実行することで生成されます。

## 🚀 インストール

```bash
# bashに対してインストール
./install.sh --bash

# zshに対してインストール
./install.sh --zsh

# エイリアスをインストール
./install-alias.sh

# 補完設定の更新
./refresh-completions.sh
```

## 🤖 開発環境

このプロジェクトは以下の開発環境をサポートしています：

### 開発コンテナ
- `.devcontainer/` - 統一された開発環境設定
- VS Code Dev Containers対応

### 設定ファイル
- `.github/instructions/` - 開発ガイドラインと指示

### スクリプト開発
新しいGitスクリプトを作成する際は：
- スクリプト名: `git-<subcommmand>`
- `common.sh`の関数を活用
- インタラクティブな選択機能を実装する場合は fzf を使う
- 適切なエラーハンドリングを含める

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

新しいスクリプトを開発する際は、`.github/instructions/` の開発ガイドラインを参考にしてください。

devcontainer上で開発する場合、`initializeCommand` と `postCreateCommand` をカスタマイズすることで、開発環境を最適化できます。
詳細はそれぞれの example (.devcontainer/commands 配下) を参照してください。

## 📄 ライセンス

このプロジェクトは [MIT](LICENSE) ライセンスの下で配布されています。
