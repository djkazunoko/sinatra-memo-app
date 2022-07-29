# sinatra-memo-app

`sinatra-memo-app`はSinatraで作成したシンプルなメモアプリです。

## バージョン

- Bundler：2.3.12
- Ruby：3.1.0

## インストール

1. 以下のコマンドを実行して、Gemfileを作成します。
```
$ mkdir my-app
$ cd my-app
$ bundle init
```

2. Gemfileに以下を追加します。
```
gem 'sinatra'
gem 'sinatra-contrib'
gem 'webrick'
```

3. 以下のコマンドを実行して、Gemをインストールします。
```
$ bundle install
```

## 使い方

1. 以下のコマンドを実行して、メモアプリを起動します。
```
$ ruby memo.rb
```

2. ブラウザから以下のURLにアクセスします。

```
http://localhost:4567
```
