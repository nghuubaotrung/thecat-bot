NAME="the-cat-rsu14"
PUBLISH_CHANNEL="#14appdriver" #reward_system
SEND_CHANNEL="test"
OPERATION_CHANNEL="#test" #14appdriver
ICON=":thecat:"

## テスト用
#WEBHOOK_URL="${URL}"

## 本番
WEBHOOK_URL="${URL}"

#author="nghuubaotrung"

# 毎週の月曜日実行する場合
#CHECK_DAY="$(date -v+2d +'%d')"
# 当日実行場合
#CHECK_DAY="$(date +'%d')"

#WUNDERLIST="Bin: Personal Task"
WUNDERLIST="新機能共有会"

## wunderlistからデータ取得する
if [ -z $CHECK_DAY ]; then
    todo=`wunderline list $WUNDERLIST 2>&1`
else
    todo=`wunderline list $WUNDERLIST | grep $CHECK_DAY 2>&1`
fi

### 通知
publish_data=`cat << EOF
    payload={
        "channel": "$PUBLISH_CHANNEL",
        "username": "$NAME",
        "icon_emoji": "$ICON",
        "attachments": [{
            "color": "#FF0000",
            "title": "新機能共有会" ,
            "text": "お疲れ様です。まだ発表されないテーマは、以下となります！\n\n $todo\n\n\n ご確認よろしくお願いいたします！"
        }]
    }
EOF`

## 通知送る
curl -X POST --data-urlencode "$publish_data" $WEBHOOK_URL

