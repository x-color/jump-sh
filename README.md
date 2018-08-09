# jump-sh

ディレクトリにタグをつけ、指定したタグに移動するためのスクリプト。

![demo](https://github.com/x-color/jump-sh/blob/master/imgs/demo.gif)

## 使用例

```bash
# タグ付け (このコマンドを実行したディレクトリにタグが付く)
$ jump -a testtag
# 移動
$ jump testtag
# タグ削除
$ jump -d testag
# タグの一覧表示
$ jump -l
```

## 準備

動作させる前に、以下を実行する必要がある。
1. 空ファイル(`~/.jump_tags`)を作成
2. `~/.bashrc`などに`source`コマンドを用いたスクリプトファイルの読み込み処理を記述
