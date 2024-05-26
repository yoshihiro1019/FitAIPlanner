## 1.git clone後、cdコマンドを使用してcloneしたディレクトリに移動してください。
```
$ cd xxxx_xxxx_basic_rails_basic
```

<br /><br />

## 2.Docker Desktopアプリを立ち上げる
Docker Desktopアプリを立ち上げてください。

■ Windowsを使用している方
ディスクトップに表示されている検索欄に「Dokcer Desktop」と打ち込んで、検索結果に表示された項目をクリックしてください。
[![Image from Gyazo](https://t.gyazo.com/teams/startup-technology/7ed4318805455ba0056ab6bd8b6d869d.gif)](https://startup-technology.gyazo.com/7ed4318805455ba0056ab6bd8b6d869d)

■ Macを使用している方
commandキー + スペースバー で Spotlight を表示したら、『docker」と打ち込んで、検索結果に表示された Docker.app をクリックしてください。
[![Image from Gyazo](https://t.gyazo.com/teams/startup-technology/e0744c7e3a010fddc4ba1057e36e89bb.gif)](https://startup-technology.gyazo.com/e0744c7e3a010fddc4ba1057e36e89bb)

<br /><br />

## 3.コンテナの立ち上げ
以下のコマンドを順番に実行してコンテナを立ち上げてください。
```
$ docker compose build

$ docker compose up
```

<br /><br />

## 4.gem・JavaScriptパッケージをインストールする
docker compose up が実行されているターミナルとは別のターミナルを立ち上げて、以下のコマンドを順番に実行してください。
```
$ docker compose run web bundle install

$ docker compose run web yarn install
```

<br /><br />

## 5.データベースの初期化・マイグレーションファイル適応
docker compose up が実行されているターミナルとは別のターミナル上で、以下のコマンドを順番に実行してください。
```
$ docker compose exec web rails db:drop

$ docker compose exec web rails db:create

$ docker compose exec web rails db:migrate
```

<br /><br />

## 6.CSS, JavaScript用のサーバー起動
docker compose up が実行されているターミナルとは別のターミナル上で、以下のコマンドを実行してください。
```
$ docker compose exec web bin/dev
```

<br /><br />

## 7.新しくターミナルを立ち上げる
docker compose up が実行されているターミナル、docker compose exec web bin/dev が実行されているターミナルとは別のターミナルを立ち上げてください。
（7にて新しく立ち上げたターミナルにてGit操作やコマンドを実行してください）

※課題を進めていく上で、以下の3ターミナルが揃っている状態で開発を進めてください。
- docker compose up：コンテナを立ち上げた状態にする
- docker compose exec web bin/dev：.CSS, JavaScript用のサーバーを立ち上げ状態にする
- （入力受付状態のターミナル）：Git操作やコマンドを実行できる用のターミナル

<br /><br />

## 8.ブラウザにて画面が表示されるか確認する
http://localhost:3000/ にアクセスして、以下の画面が表示されるかを確認してください。

[![Image from Gyazo](https://t.gyazo.com/teams/startup-technology/1de760c38b456f97de809369b3a77e79.png)](https://startup-technology.gyazo.com/1de760c38b456f97de809369b3a77e79)

<br /><br /><br /><br />

### Dockerコンテナを終了する際の操作

```bash
$ docker compose down
```

