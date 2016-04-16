NAME="the-cat"
PUBLISH_CHANNEL="#bnb"
SEND_CHANNEL="bnb"
OPERATION_CHANNEL="#test"
ICON=":thecat:"

WEBHOOK_URL="${URL}"

#author="nghuubaotrung"

# 毎週の月曜日実行する場合
#CHECK_DAY="$(date -v+2d +'%d')"
# 当日実行場合
#CHECK_DAY="$(date +'%d')"

WUNDERLIST="airbnb"

## wunderlistからデータ取得する
if [ -z $CHECK_DAY ]; then
    todo=`wunderline list $WUNDERLIST 2>&1`
else
    todo=`wunderline list $WUNDERLIST | grep $CHECK_DAY 2>&1`
fi

#### 通知
publish_data=`cat << EOF
    payload={
        "channel": "$PUBLISH_CHANNEL",
        "username": "$NAME",
        "icon_emoji": "$ICON",
        "attachments": [{
            "color": "#008000",
            "title": "Wunderlist Task Weekly Check" ,
            "text": "お疲れ様です。残っているタスクは、以下となります！\n\n $todo\n\n\n Binさん、Junさん、ご確認よろしくお願いいたします！"
        }]
    }
EOF`

## 通知送る
curl -X POST --data-urlencode "$publish_data" $WEBHOOK_URL

