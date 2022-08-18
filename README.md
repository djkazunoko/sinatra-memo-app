# sinatra-memo-app

`sinatra-memo-app`はSinatraで作成したシンプルなメモアプリです。

## 要件

- Bundler：2.3.12
- Ruby：3.1.0
- PostgreSQL：14.3

## インストール

1. Gemfileを作成します。
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

3. Gemをインストールします。
```
$ bundle install
```

## 使い方

1. PostgreSQLを起動します。
```
$ brew services start postgresql
```

2. アプリケーションを起動します。
```
$ ruby memo.rb
```

3. ブラウザから以下のURLにアクセスします。

```
http://localhost:4567
```
