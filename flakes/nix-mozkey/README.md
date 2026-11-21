# nix-mozkey

[Mozkey（もずきー）](https://github.com/koyasi777/mozkey) を NixOS の [fcitx5](https://fcitx-im.org/) で使うための Nix flake です。

Mozkey は [google/mozc](https://github.com/google/mozc) をベースにした非公式フォークです。この flake では、Mozkey の Mozc サーバ・設定ツールと、[fcitx/mozc](https://github.com/fcitx/mozc) 由来の fcitx5 エンジンを組み合わせてパッケージ化しています。

## 収録内容

- `mozc_server` / `mozc_tool`（Mozkey 本体）
- `fcitx5-mozc.so` と fcitx5 アドオン設定・翻訳・アイコン
- Mozkey の **daily 辞書**（UT 辞書・地名・SudachiDict・nico/pixiv・人名を統合した拡張辞書）
- overlay、NixOS モジュール、Home Manager モジュール

daily 辞書はビルド時に Mozkey 公式の生成パイプライン（PowerShell + Python）を実行して作成します。入力は `tools/dictionary/locks/daily_sources.json` でピン留めされており、生成物は固定出力ハッシュで再現可能です。

## 注意事項

- **Zenz 補正は含まれません。** Zenz のローカル推論ランタイムは Windows / macOS 向けで、Linux では未対応です。通常の Mozc 変換と Mozkey の辞書・UI 拡張は利用できます。
- **`fcitx5-mozc` と同時にインストールしないでください。** どちらも fcitx5 のアドオン名 `mozc` を使うため衝突します。
- 初回ビルドでは辞書生成（Wikipedia ダンプや UT 辞書の取得を含む）と Bazel の依存取得・コンパイルが走るため、それなりの時間とディスク容量を使います。
- Linux 向けは Mozkey 公式でも未検証の領域です。動作は保証されません。

## 使い方（NixOS モジュール）

flake input に追加し、モジュールを import します。

```nix
{
  inputs.nix-mozkey.url = "github:YOUR_ACCOUNT/nix-mozkey";

  outputs = { self, nixpkgs, nix-mozkey, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        nix-mozkey.nixosModules.default
        {
          i18n.inputMethod.fcitx5-mozkey.enable = true;
        }
      ];
    };
  };
}
```

モジュールは以下を行います。

- overlay を追加して `pkgs.fcitx5-mozkey` を提供
- `i18n.inputMethod` を fcitx5 に設定（`mkDefault` なので既存設定が優先されます）
- `i18n.inputMethod.fcitx5.addons` にパッケージを追加

再ビルド後、`fcitx5-configtool` の「入力メソッド」で **Mozc** を追加してください。既存の `fcitx5-mozc` が入っている場合は外しておく必要があります。

## 使い方（Home Manager）

Home Manager の `i18n.inputMethod.fcitx5` モジュールと組み合わせて使えます。`homeModules.default` はパッケージの指定と fcitx5 アドオンの登録だけを行い、セッション変数・systemd ユーザーサービス・`fcitx5-with-addons` の構築は Home Manager 側に任せます。

```nix
{
  inputs.nix-mozkey.url = "github:YOUR_ACCOUNT/nix-mozkey";

  outputs = { self, nixpkgs, home-manager, nix-mozkey, ... }: {
    homeConfigurations.me = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        nix-mozkey.homeModules.default
        {
          home.username = "me";
          home.homeDirectory = "/home/me";
          home.stateVersion = "26.05";

          i18n.inputMethod.fcitx5-mozkey.enable = true;
        }
      ];
    };
  };
}
```

Home Manager 側の既定値として、fcitx5 の systemd ユーザーサービスが有効になり、`GTK_IM_MODULE` / `QT_IM_MODULE` / `XMODIFIERS` などが設定されます。Wayland の text-input を使う場合は `i18n.inputMethod.fcitx5.waylandFrontend = true` を指定してください。

NixOS の `nixosModules.default` と Home Manager の `homeModules.default` は、どちらか一方だけを使うことを推奨します。両方有効にすると同じアドオンがシステム側とユーザー側の両方に入ります（動作はしますが冗長です）。

## 使い方（overlay のみ）

```nix
{
  nixpkgs.overlays = [ inputs.nix-mozkey.overlays.default ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozkey ];
  };
}
```

## ビルド

```sh
nix build .#fcitx5-mozkey
```

結果は `result/` に現れます。

```text
result/
├── lib/fcitx5/fcitx5-mozc.so
├── lib/mozkey/mozc_server
├── lib/mozkey/mozc_tool
└── share/fcitx5/...
```

## バージョンの切り替え

既定では `mozkey-src` は `main` を追跡します。リリースタグに固定する場合は次のように上書きします。

```nix
inputs.mozkey-src.url = "github:koyasi777/mozkey/v1.1.0";
inputs.mozkey-src.flake = false;
```

```sh
nix flake update mozkey-src
```

パッケージのバージョンはソース中の `src/version.bzl`（`MOZKEY_RELEASE_VERSION_*`）から自動で読み取ります。

### ソース更新時の注意

`mozkey-src` を別のリビジョンに変えると、次の 2 つの固定出力ハッシュが一致しなくなり、ビルドは失敗します。

- `nix/package.nix` の `dictionary` の `outputHash`（daily 辞書）
- `nix/package.nix` の `vendorDeps` の `outputHash`（Bazel 依存）

どちらも一度 `lib.fakeHash` に戻して `nix build .#fcitx5-mozkey` を実行すると、Nix が実際のハッシュをエラーに表示します。その値に更新して再ビルドしてください。`fcitx-mozc-src` を 3.33 系から大きく外れた Mozc に合わせる場合は、fcitx5 エンジンのコミットも更新が必要です。

## 実装メモ

- fcitx5 エンジンは fcitx/mozc の `src/unix/fcitx5` を Mozc 3.33 系のコミットから取得して Mozkey のツリーに追加しています。
- fcitx/mozc の fcitx5 エンジンはサーバが要求する遅延コールバック（`Output::Callback`）を実行しないため、Mozkey のデバウンス付きライブ変換が動作しません。`nix/patches/fcitx5-live-conversion.patch` でクライアント側のスケジューラを追加しています。
- Qt 6.12 の `uic` が `::` で始まるカスタムウィジェット名を受け付けないため、上流の修正と同じ置換を適用しています。
- Bazel の依存は `bazel vendor` で固定出力に取り込み、サンドボックス内ではオフラインでビルドします。
- サーバのインストール先は `/usr/lib/mozkey` から `$out/lib/mozkey` に置換しています。

## 確認済み環境

- NixOS 26.11（nixos-unstable）、x86_64-linux、fcitx5 5.1.23
- Xvfb 上の fcitx5 でアドオン `mozc` がロードされ、`mozc_server` が `$out/lib/mozkey/mozc_server` から起動することを確認
- Home Manager の `homeModules.default` で `i18n.inputMethod.fcitx5.addons` に追加され、`fcitx5-with-addons`・セッション変数・systemd ユーザーサービスが生成されることを eval で確認
- 実機の Wayland / X11 セッションでの日本語入力は未検証です

## ライセンス

Mozkey 本体は BSD 3-Clause ライセンスです。パッケージ内の `share/licenses/fcitx5-mozkey/LICENSE` と `THIRD_PARTY_NOTICES.md` を参照してください。fcitx5 エンジン部分も同じ Mozc のライセンスに従います。
