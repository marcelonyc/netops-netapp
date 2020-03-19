echo "http://$MANAGER/occm/api/occm/system/support-services"
curl -X GET http://$MANAGER/occm/api/occm/system/support-services |jq -r .portalService.auth0Information > info.txt
echo "INFO"
cat info.txt
echo "INFO END"

clientId=`cat info.txt|jq -r .clientId`
domain=`cat info.txt|jq -r .domain`
audience=`cat info.txt|jq -r .audience`
curl  https://$domain/oauth/token -X POST --header "Content-Type:application/json" --data "{\"grant_type\": \"password\",\"username\": \"$email\",\"password\": \"$password\",\"audience\": \"$audience\",\"scope\": \"profile\",\"client_id\": \"$clientId\"}" | jq -r .access_token > token.txt

token=`cat token.txt`

curl http://$MANAGER/occm/api/vsa/volumes/$weid/$svm/$volume/snapshot -X POST --header "Content-Type:application/json" --header "Authorization: $token"  --data "{\"snapshotName\": \"$snapshotName\"}"
if [ $? -ne 0 ]
then
    echo "Failed to create snapshot or it is taking too long"
    exit 2
fi

#rm -fr ${NETAPP_MOUNT_PATH}/.snapshot/kfp*

echo "Waiting for volume creating"
echo "Max 60 seconds"
cnt = 0
echo "${NETAPP_MOUNT_PATH}/.snapshot/$snapshotName"
ls -lt ${NETAPP_MOUNT_PATH}/.snapshot/$snapshotName
while [ 1 ]
do
    ls -lt ${NETAPP_MOUNT_PATH}/.snapshot/$snapshotName
    if [ $? -eq 0 ]
    then 
        break
    fi
    echo "Waiting..."
    sleep 10
    let cnt=${cnt}+1
    if [ $cnt -gt 10 ]
    then
        echo "Failed to create snapshot or it is taking too long. Wait count $cnt"
        exit 3
    fi
done

#curl http://$MANAGER/occm/api/working-environments -X GET --header "Content-Type:application/json" --header "Authorization: $token"  --data "{\"snapshotName\": [\"$snapshotName\"]}"
