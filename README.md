# isucon-helper

ここに書いてあるのはメモ

## 準備

- `scripts/setup.bash` は `isucon` user かつ `/home/isucon` で実行されることを前提としている
- `scripts/setup.bash` は実行後 `/` ディレクトリ以下を git で管理するので、アップロード先の GitHub リポジトリを用意しておく
- `keys/` ディレクトリ以下に GitHub リポジトリの Deploy keys を `private_key`, `public_key` という名前で保存しておく

## 使い方

```shell
$ ./scripts/setup.bash
```
