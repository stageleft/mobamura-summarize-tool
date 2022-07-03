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

データの種類は以下。

* デレマス・Cu
* デレマス・Co
* デレマス・Pa
* デレマス・他
* ミリマス（オールスターズ１３名、スターリットシーズンのライバルキャラを含む）
* SideM（DearlyStars２名を含む）
* シャニマス

アイドル以外のキャラは、必要に応じて追加する。
公式クリーチャーの取り扱いはT.B.D.。同人クリーチャーは取り込まない。

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
rubygems にて、sinatra, thin, nokogiri のモジュールを入れる。

### （開発専用）コマンドラインによる実行

ruby index.rb some_character_list.json output.csv

some_character_list.json output.csv は任意のファイル名。
output.csv は省略可能（本当に output.csv に出力される。

### （開発専用）ローカル sinatra による実行

ruby myapp.rb -p 80

### （開発専用）ローカル docker-CE による実行

docker build . -t mobamura-tool:latest
docker run --rm -it mobamura-tool bash

docker run --name mobamura-tool -p 80:80 mobamura-tool ; docker rm mobamura-tool

docker run -d --name mobamura-tool -p 127.0.0.1:80:80 --restart=always mobamura-tool
docker stop mobamura-tool && docker rm mobamura-tool

### docker コンテナをサービスデプロイ

* docker hub （プライベートリポジトリ）へのアップロード

docker tag mobamura-tool:latest shogosugano/mobamura-tool:latest
docker push shogosugano/mobamura-tool:latest

* azure App Service の再起動（docker hub -> azure は設定済み）
