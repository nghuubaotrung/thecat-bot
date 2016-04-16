NAME="the-cat-rsu14"
PUBLISH_CHANNEL="#test" #reward_system
SEND_CHANNEL="test"
OPERATION_CHANNEL="#test" #14appdriver
ICON=":man_in_business_suit_levitating:"
#ICON=":gentle:"
ICON=":thecat:"

## テスト用
#WEBHOOK_URL="${URL}"

## 本番
WEBHOOK_URL="${URL}"

#author="nghuubaotrung"

## Publicフォルダーからファイル（markdown, pdf, powerpointなど）取得し、ロカールに保存する
### 日付に紐付けるフォルダー名を作ればもっと楽かな？
### ファイルが存在しない場合はどうする？
PUBLIC_PATH=/Volumes/personal/system/nguyen_huubaotrung/test_rakurakuslider
INPUT_PATH=/Users/nguyen_huubaotrung/Source-code/thecat-bot/
cp $PUBLIC_PATH/* $INPUT_PATH

## 発表スライド作成(markdownファイルのみ)
cleaver_error_flag=0
send_file_error_flag=0

cd $INPUT_PATH

for file in *.md
do
    ## cleaverでhtmlビルド
    cleaver $file

    ## コマンドチェック
    if [ $? -ne 0 ]; then
        echo 'ERROR: cleaver build failed'
        cleaver_error_flag=1
    else
        echo $file
    fi
done

#### cleaverでhtmlビルド失敗した場合
cleaver_error_data=`cat << EOF
    payload={
        "channel": "$OPERATION_CHANNEL",
        "username": "$NAME",
        "icon_emoji": "$ICON",
        "attachments": [{
            "color": "#FF0000",
            "title": "新機能共有会" ,
            "text": "ごめんなさい、新機能共有会のスライド作成失敗しましました！\n 杉山さん、堀田さん、グエンさん、ご確認よろしくお願い致します！@here"
        }]
    }
EOF`

if [ $cleaver_error_flag == 1 ]; then
    curl -X POST --data-urlencode "$cleaver_error_data" $WEBHOOK_URL
    exit 1
fi

#### 通知
publish_data=`cat << EOF
    payload={
        "channel": "$PUBLISH_CHANNEL",
        "username": "$NAME",
        "icon_emoji": "$ICON",
        "attachments": [{
            "color": "#008000",
            "title": "新機能共有会" ,
            "text": "お疲れ様です。今週の新機能共有会の発表内容は以下となります！\n ご確認よろしくお願い致します @here"
        }]
    }
EOF`

## 通知送る
curl -X POST --data-urlencode "$publish_data" $WEBHOOK_URL


## 発表資料送る
for file in *.pdf *.html
do
    slackcat --channel $SEND_CHANNEL --filename $file $file
    ## コマンドチェック
    if [ $? -ne 0 ]; then
        echo 'ERROR: send file failed'
        send_file_error_flag=1
    else
        echo $file
    fi
done

#### 発表資料の送信失敗した場合
send_file_error_data=`cat << EOF
    payload={
        "channel": "$PUBLISH_CHANNEL",
        "username": "$NAME",
        "icon_emoji": "$ICON",
        "attachments": [{
            "color": "#FF0000",
            "title": "新機能共有会" ,
            "text": "ごめんなさい、発表資料を送れませんでした！\n 杉山さん、堀田さん、グエンさん、ご確認よろしくお願い致します！"
        }]
    }
EOF`

if [ $send_file_error_flag == 1 ]; then
    curl -X POST --data-urlencode "$send_file_error_data" $WEBHOOK_URL
fi
