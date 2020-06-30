#!/bin/sh

ACCESS_TOKEN=thistoken
DOMAIN=this.com
# () allow multiple ids (RECORD_ID_1 RECORD_ID_2 RECORD_ID_n)
RECORD_IDS=()

IP=$(curl -s http://checkip.amazonaws.com/)

echo $(date)
echo "Current Public IP : $IP"
echo "Updating Digital Ocean DNS record ... "

for ID in "${RECORD_IDS[@]}"
do
  curl \
    -fs -o /dev/null \
    -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d "{\"data\":\"$IP\"}" \
    "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$ID"
done

echo "** Done. **"
exit
