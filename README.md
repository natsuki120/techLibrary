# 自己紹介

東京都内の専門学校に通っています。
Flutter に興味を持ち、個人開発したものを載せました。
これからも新しい技術を好奇心の赴くまま勉強していきたいと思います。

# 概要

本の貸出状況を管理、把握できるアプリ。学校に置いてある本が既に貸出されているのか否かをすぐ判別できたり、自分が何を借りているか一目でわかる。
リアルタイムで描画されるため、いちいちリロードしなくてもよい。検索機能も実装されているのでどの本が置いてあるのか調べることができる。

# 機能
- ログイン機能、新規登録機能
  - FirebaseAuth を使ったメールアドレス認証
  - どれか一つでも未入力のものがあったらエラー通知がくる
- ブックギャラリー
  - 置いてある本を表示
  - 貸出中の本は赤いマークがつくので、どの本が貸出中かすぐわかる
  - ジャンルごとに整理
- 本一覧画面
  - ジャンルごとの全ての本を表示
  - こちらもどの本が貸出中なのかすぐわかる
- 貸出画面、返却画面、貸出中画面
  - その本の状態（貸出中なのか否か）によって画面が変化する
  - お気に入り登録機能も実装
- 検索画面
  - like 検索をすることでどの本が置いてあるかすぐわかる
- マイページ
  - 現在自分が借りている本とお気に入りした本を表示する
-　ログアウト、退会機能
  -　 本当にログアウトないし退会するのか確認するダイアログを実装した
  -　 ログアウトないし退会したら全てのアプリ情報を切断し、ログイン画面に戻る（pushReplacementだとスワイプバックできてしまう）
# 作成の背景
私が在籍している専門学校では本の貸出が行われている。プログラミングに限らず自己啓発本や学術的な本もある。
しかし、どの本が貸出中なのか、そもそもどの本があるのか把握しづらく、とても不便に感じていた。
そこで、どんな本があるのか、どの本が借りられているのかを把握するアプリを作ろうと思い、このアプリを作成した。
# 達成したいこと
とりあえず Flutter でなにかしら作ってみる。
人の需要を満たすようなアプリを作ってみたい。
期間は特に設けず、途中ペースは落ちても良のでアプリ制作を完走したい。
# 特に力を入れた点
- リアルタイム下での状態変化
  -　いちいちリロードしなくてもいいように、かつ負荷をがかからないようにproviderを使用した。 
- 退会機能  
  - 確認するためにメールアドレスとパスワードをユーザーに入力してもらう。間違いがあればエラーダイアログが出る。
- デザイン
  - pinterestで気に入ったデザインをまとめ、自分なりにアレンジした。
- 貸出中のマーク
  -　　リアルタイムかつわかりやすいように実装した。 

# 反省点
- 車輪の再開発をしすぎた
  - Flutterに慣れていない状態でがむしゃらに実装したので多大な時間浪費をしてしまった。
- 要件定義を怠った
  - もともとポートフォリオを作る、というより自分のアウトプット用のアプリ制作という意識だったので何一つ要件定義をしておらず、大幅な時間浪費をした。
- データ取得の知識が乏しかった
  - 取得のみならず、streamなどの型やそれを出力する際の決まり事(try文でFirebaseのエラーハンドリングする際、参照する関数にawaitをつけないとハンドリングされない等)を知らなかったので、こちらも大幅な時間浪費をした。
