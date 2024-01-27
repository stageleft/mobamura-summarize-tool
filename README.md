# mobamura-tool
（自分用）わかめてモバマス村・集計ツール

アイドルマスターのキャラクター（以下、アイドル）をCNに用いているプレイヤーの一覧および、
使用回数を集計したもの。

https://mobamura-summarize-tool.azurewebsites.net/

にアクセスして利用する。

仕様や重要事項などは、上記ツールより、「はじめに、こちらのリンクをお読みください」を参照すること。

## 開発・運用にかかる参考情報

### キャラクター名リスト・データ表記法

本ツールは、内部データとして、キャラクター名リスト、および、（必要に応じて）別名一覧を持つ。
表記ルールは schema.json を参照。

記載したデータファイルのチェックは、以下を利用すること。
https://www.jsonschemavalidator.net/

データの種類は以下。原則として、 https://idollist.idolmaster-official.jp/search のアイドルを表示対象とする。

* デレマス・Cu - https://imascg-slstage.boom-app.wiki/entry/idol-typelist より（モバ村Wikiの参照元と判断）
* デレマス・Co - 同上
* デレマス・Pa - 同上
* デレマス・他 - 個別判断
* ミリマス（オールスターズ１３名、スターリットシーズンのライバルキャラを含む） - https://idollist.idolmaster-official.jp/search より、「THE IDOLM@STER」「ミリオンライブ！」で各々フィルタ。つまりは、ここまで五十音順。その後、「その他」から未登録キャラを順次登録。
* SideM（DearlyStars２名を含む） - https://idollist.idolmaster-official.jp/search より、「SideM」＆「その他」でフィルタ、。つまりは各カテゴリ五十音順。
* シャニマス

https://idollist.idolmaster-official.jp/search 未登録のアイドル、アイドル以外のアイマスキャラは、必要に応じて上記の各項目に追加する。（原則、新規の「データの種類」は作成はしない）
公式クリーチャーの取り扱いも上記に準ずる。シンデレラガールズ関連公式クリーチャーの名簿順は、アイドル→クリーチャーの順とし、クリーチャー内は可能な限りアイドルの名簿順に合わせる。
同人クリーチャーは取り扱わない。
声優を含む製作者は取り扱わない。

※未登録のアイドル、アイドル以外のアイマスキャラ、公式クリーチャーでのモバマス村プレイ記録があったら教えてください。

エイリアスについては、もとのキャラクター名が一意かつ明確である場合は対応する。（ほぼ後付対応にはる）
アイマス公式の別名がある場合は、村の状況を確認せず一意かつ明確とみなす。
それ以外の場合はケースバイケースとする。

### 処理

1. アイドル名でAPIをコールする処理を繰り返し、API呼び出し結果データを作成する。 （出力α）
   1. アイドル名一覧のため、キャラクター名リストが必要。
   1. アイドル名で、上記 result.php をAPIコールし、結果を得る。 （手順A）
   1. アイドルのエイリアスも、CNをアイドル名として手順Aと同じようにする。 （手順B）
   1. 手順Aの結果と、手順Bの結果を配列にして出力データを作成する。（手順C）
   1. 別のアイドル名にて、手順A、手順B、手順Cを繰り返す。
1. 出力αから、「アイドル」と「プレイヤー（トリップ）」の対応リストを作成する。 （出力β）
   1. ここで、アイドルのエイリアスをアイドルにまとめる。このために、ひきつづきキャラクター名リストが必要。
   1. プレイヤー（村のプレイヤー名）を、プレイヤー（トリップ）ごとに参考情報として持つ。
   1. 出力形式はJSONとする。
1. 出力βから、「アイドル」と「プレイヤー（プレイヤー名）」と「回数」のリストを作成する。（出力γ）
   1. 村のプレイヤー名がある場合は、村のプレイヤー名を全体プレイヤー名として扱う。
   1. 村のプレイヤー名がない場合（「-」の場合）は、トリップを全体プレイヤー名として扱う。
   1. 出力形式はJSONとする。
1. 出力γを形式変換し、「アイドル」と「プレイヤー（プレイヤー名）」と「回数」と「順位」のリストを作成する。（出力δ）
   1. 出力形式は、配列とする。
1. 出力δを、フリーソフト Tabulator の機能を用いてHTML出力する。同ツールは、HTMLの書式によってそのままCSVファイルのダウンロード機能を持つ。

### 言語、開発プラットフォーム

ruby言語のスクリプトにて、小規模なWebサービスを構築する。スクリプト・WebサービスはDocker CE にてコンテナを作成・提供する。
rubygems にて、sinatra, thin のモジュールを入れる。

### （開発専用）コマンドラインによる実行

#### result.rb （全体）の実行

```sh
ruby test/index.rb data/some_character_list.json output.csv
```

some_character_list.json output.csv は任意のファイル名。
output.csv は省略可能（本当に output.csv に出力される）。

#### get_player_trip.rb の実行

以下のとおり実行する。

```sh
ruby test/triplist.rb
```

以下が順に出力される。

1. 非公開API http://mobajinro.s178.xrea.com/mobajinrolog/api/getPlayer.php をコールした応答
1. data/triplist.json を読み込んだ結果
1. 上記２つをマージした結果（GetResult すなわち APIで本当に使うリスト）

#### get_player_list.rb の実行

CNを一人指定して実行する場合、以下のとおり実行する。

```sh
ruby test/player_single.rb "character-name"
```

指定した character-name のキャラについて、
公開API http://mobajinro.s178.xrea.com/mobajinrolog/api/searchLog.php をコールした応答の結果をJSON出力する。

上記出力結果を p.json ファイルに落とし込んでいるとして、一次解析の確認には以下のとおり実行する。

```sh
ruby test/player_single_parse.rb p.json
```

CN一覧のJSONに則って実行する場合、以下のとおり実行する。

```sh
ruby test/playerlist.rb data/any-csv-data.json 
```

指定した any-csv-data.json のキャラ各々について、
公開API http://mobajinro.s178.xrea.com/mobajinrolog/api/searchLog.php をコールした応答の結果全体をJSON形式で出力する。

#### calc_play_count.rb の実行

※あらかじめ、上記 get_player_list.rb の実行として得られた結果を、ファイルに落としておく。たとえば以下。

```sh
ruby test/playerlist.rb data/shinycolors.json | jq -c . > test/data.json
```

同じ data/any-csv-data.json を用いて、以下のとおり実行する。

```sh
ruby test/summarize.rb data/triplist.json data/shinycolors.json test/data.json
```

テストスクリプト未定義。

### （開発専用）ローカル sinatra による実行

ruby myapp.rb -p 80

### ローカル docker-CE によるコンテナビルド

service docker start
docker build . -t shogosugano/mobamura-tool:latest

### （開発専用）ローカル docker-CE による実行

docker run --name mobamura-tool -p 80:80 shogosugano/mobamura-tool ; docker rm mobamura-tool

docker run -d --name mobamura-tool -p 127.0.0.1:80:80 --restart=always shogosugano/mobamura-tool
docker stop mobamura-tool && docker rm mobamura-tool

### （開発専用）ローカル docker-CE でのコンテナ調査
docker run --rm -it shogosugano/mobamura-tool bash

### docker コンテナをサービスデプロイ

* docker hub （プライベートリポジトリ）へのアップロード

docker login -u shogosugano -p <XXX>
docker push shogosugano/mobamura-tool:latest

* azure App Service の再起動（docker hub -> azure は設定済み）

### エンドポイントへの定期アクセスの実装

アプリのスリープを防ぐため、一定間隔ごとに Health Check Path を呼び出す。
手元で常時動作する Linux PC を準備し、以下の手順にて5分ごとのアクセスを実装する。

$ crontab -e
$ crontab -l
*/5 * * * * curl 'https://mobamura-summarize-tool.azurewebsites.net/'
