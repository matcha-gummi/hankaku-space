# Hankaku Space

[日本語](README.md) | [English](README_EN.md)

日本語入力中でも、普通に `Space` を押すだけで半角スペースを入力できるMac用メニューバーアプリです。

日本語入力と英数入力を切り替える手間を減らしつつ、修飾キー付きのSpaceや英数入力中のSpaceには介入しません。

## 主な機能

- 日本語入力中の、修飾キーなしの `Space` を半角スペースへ変換
- 英語・英数入力中のSpaceは変更しない
- Shift／Command／Option／Control／Fn付きSpaceは変更しない
- メニューバーから即座にON／OFF
- 現在の入力ソース、権限、監視状態を表示
- Macへのログイン時に自動起動
- Secure Input中は安全のため変換を停止

## プライバシー

Hankaku Spaceは、入力したキーの内容を保存・送信しません。

- ネットワーク通信なし
- キー入力内容の記録なし
- 外部ライブラリなし
- VirtualHID、カーネル拡張なし
- 状態ログは最大100件をメモリ上だけに保持

## 動作環境

- macOS 26 Tahoe以降
- Apple Silicon搭載Mac（M1以降、arm64）

Intel MacとmacOS 25以前には、現在対応していません。

## ダウンロード

[GitHub Releasesの最新版](https://github.com/matcha-gummi/hankaku-space/releases/latest)から `HankakuSpace.dmg` をダウンロードできます。

> 最新の配布版はDeveloper ID署名・Appleの公証済みです。DMGからApplicationsへドラッグして起動できます。初回はアクセシビリティ権限を許可してください。

## インストール

1. `HankakuSpace.dmg` をダブルクリックして開きます。
2. `HankakuSpace` を、同じ画面にある `Applications` フォルダへドラッグします。
3. コピーが終わったらDMGを取り出します。
4. Finderの「アプリケーション」からHankaku Spaceを起動します。

### macOSに起動を止められた場合

最新の公証済み版を公式のGitHub Releasesから取得したか確認してください。「破損している」などの警告が出る場合は、無理に解除せずIssueでお知らせください。

## 初回設定

Hankaku Spaceはキーボードイベントを変換するため、macOSのアクセシビリティ権限が必要です。

1. 初回案内画面で「権限を要求」を選びます。
2. 「システム設定 > プライバシーとセキュリティ > アクセシビリティ」を開きます。
3. Hankaku Spaceを許可します。
4. Hankaku Spaceを一度終了し、アプリケーションフォルダから再起動します。

正常に動作している場合、メニューバーに `H` が表示され、メニュー内に次の状態が表示されます。

- アクセシビリティ：許可済み
- 監視中

### 権限を許可しても動かない場合

アプリの更新後などは、以前の権限情報が残る場合があります。

1. Hankaku Spaceを終了します。
2. システム設定のアクセシビリティ一覧からHankaku Spaceを `−` で削除します。
3. `＋` を押し、アプリケーションフォルダの現在のHankaku Spaceを追加します。
4. Hankaku Spaceを許可して、アプリを再起動します。

## 使い方

Hankaku SpaceはDockに表示されず、メニューバーに常駐します。

- `H`：変換が有効
- `H–`：変換が無効
- `H!`：アクセシビリティ権限が必要

メニューバーの表示をクリックすると、変換のON／OFF、入力ソース、権限、監視状態、ログイン時起動、設定、終了を操作できます。

### 変換ルール

| 状態 | 動作 |
| --- | --- |
| 日本語入力＋修飾キーなしSpace | 半角スペースへ変換 |
| 英語・英数入力＋Space | 変更しない |
| Shift＋Space | 変更しない |
| Command／Option／Control／Fn＋Space | 変更しない |
| Secure Input中 | 変更しない |
| 変換OFF | すべて変更しない |

## アップデート

1. メニューバーのHankaku Spaceから「終了」を選びます。
2. 新しいDMGを開きます。
3. Hankaku SpaceをApplicationsへドラッグします。
4. 確認画面で「置き換える」を選びます。
5. アプリを起動します。

アップデート後に変換が動作しない場合は、アクセシビリティ一覧から古い登録を削除し、現在のアプリを追加し直してください。

## アンインストール

1. 「ログイン時に起動」がONの場合はOFFにします。
2. メニューバーからHankaku Spaceを終了します。
3. アプリケーションフォルダの `HankakuSpace.app` をゴミ箱へ移動します。
4. システム設定のアクセシビリティ一覧からHankaku Spaceを削除します。

保存設定も削除する場合は、ターミナルで次を実行します。

```zsh
defaults delete jp.local.HankakuSpace
```

## 既知の制限

- Apple純正日本語入力、および入力ソースIDにJapanese／Kotoeri／ATOK／GoogleJapaneseInputを含む一般的なIMEを判定対象にしています。
- 独自の入力ソースIDを使用するIMEでは、追加対応が必要になる場合があります。
- アプリの署名や配置場所が変わると、macOSがアクセシビリティ権限の再登録を求める場合があります。
- 旧版から署名済み版への移行時には、アクセシビリティ権限の再登録が必要になる場合があります。

## 開発者向け

### 必要な環境

- macOS 26以降
- Apple Silicon
- Xcode 26以降

### ローカル試用

```zsh
./scripts/build_release.sh local
./scripts/create_dmg.sh local
```

ローカル試用版はアドホック署名です。生成先は `${TMPDIR:-/tmp}/HankakuSpace-build/local/DerivedData/Build/Products/Release/HankakuSpace.app` と `build/HankakuSpace-local.dmg` で、公開用には使用しません。

署名対象のビルドは、Finderの拡張属性による署名失敗を避けるため一時領域に作成します。

### Developer ID署名と公証

1. Apple Developer Programの有効なアカウントで、秘密鍵を含むDeveloper ID Application証明書をこのMacのキーチェーンに用意します。
2. 公証用の認証情報を `xcrun notarytool store-credentials` の対話入力でキーチェーンに保存します。パスワードや秘密鍵をリポジトリに保存しないでください。
3. 証明書の名前を指定して署名済みDMGを作ります。

```zsh
export DEVELOPER_ID_APPLICATION='Developer ID Application: YOUR NAME (TEAMID)'
./scripts/create_dmg.sh
```

アプリはHardened Runtimeとセキュアタイムスタンプ付きで署名され、DMGにも署名します。生成先の `build/HankakuSpace-signed.dmg` は公証前なので配布しません。証明書がない場合は停止し、アドホック署名へ自動で切り替えません。

4. **以下はAppleへDMGを送信します。送信を承認したうえで実行してください。**

```zsh
export NOTARYTOOL_PROFILE='YOUR_KEYCHAIN_PROFILE'
./scripts/notarize_dmg.sh --submit-to-apple
```

AppleのAccepted結果、公証チケットのステープルと検証、署名・Gatekeeper・DMGの検査に成功した場合だけ、`dist/HankakuSpace.dmg` とSHA-256ファイルを生成・更新します。公証に失敗した場合は既存の配布成果物を置き換えません。公開アップロードは別操作です。

### 配布前確認

- GitHub ReleasesでのDMG配布とApplicationsへのドラッグ方式を継続します。
- 初回署名版への移行時は、アクセシビリティ権限の再登録が必要になる場合があります。Bundle IDは維持します。
- 別のMacでブラウザから取得し、初回起動・アクセシビリティ許可・Space変換・ログイン時起動を確認してください。
- 公開するDMGは必ず公証・Gatekeeper検証済みの `dist/HankakuSpace.dmg` を使用してください。

仕様の根拠：[Appleの公証ワークフロー](https://developer.apple.com/documentation/security/customizing-the-notarization-workflow)。

## ライセンス

このプロジェクトは [MIT License](LICENSE) のもとで公開されています。

Copyright (c) 2026 Matcha Gumii
