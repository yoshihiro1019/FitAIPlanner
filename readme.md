■サービス概要
筋トレアプリ。
トレーニング内容を自動で考えてくれる上に、普通のトレーニングアプリと違ってジム探しまで手伝ってくれるものにしたいと思ってます。さらにトレーニングの記録帳機能や鍛えたい部位に関してのおすすめのトレーニング法を教えてくれるものにしたいと思ってます。

■ このサービスへの思い・作りたい理由
筋トレを挫折せず継続していけるようなアプリを作りたいと思って考案しました。

■ ユーザー層について
筋トレに興味がある人は多いと思うのですが、なかなかモチベーションを維持できる人は限られているため、何とかモチベーションを維持したいという人をユーザー層としてます

■サービスの利用イメージ
目的に応じた無理のないトレーニングを提案し継続に貢献するようなサービスにしたいと思ってます。

■ ユーザーの獲得について
モチベーションを維持するために、理想の体像やテンションが上がるBGMを聴ける機能などを導入していきたいと思ってます。

■ サービスの差別化ポイント・推しポイント
トレーニングを提案してくれるアプリはよくあると思うのですがBGMを流せる機能やジム探しやまで手伝ってくれるアプリは無いと思ったので製作しようと思いました。

■ 機能候補
トレーニング提案機能(MVP)、BGM機能(本リリース)、周辺のジム検索機能(MVP)、記録帳機能(MVP)、部位別トレーニング検索機能(MVP)

■ 機能の実装方針予定
トレーニング提案機能(MVP)：過去のトレーニングデータ（実施したトレーニングの種類、強度、時間、頻度など）を収集し、これに加えてユーザーが設定した目標（体重減少、筋力アップ、持久力向上など）を活用します。使うAPIはGoogle Fit APIや Fitbit APIなどを考えてます。

BGM機能(本リリース)：Spotify APIやApple Music APIを使用して、ユーザーが選んだプレイリストをアプリ内で再生できるようにする

周辺のジム検索機能(MVP)：Google Maps APIやFoursquare APIを利用して、ユーザーの現在位置情報を元に近隣のジムを検索

記録帳機能(MVP)：データベースにユーザーごとのトレーニング記録を保存

部位別トレーニング検索機能(MVP)：トレーニング種目のデータベースを部位ごとに分類し、ユーザーが部位を選択すると、該当するトレーニングをフィルタリングして表示