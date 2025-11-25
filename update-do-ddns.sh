#!/bin/sh

# requires environment vars set in .zshrc
# export ACCESS_TOKEN=thistoken
# export DOMAIN=this.com
# export ID=do_record_id

RECORD_IDS=($ID)	# multiple ids (RECORD_ID_1 RECORD_ID_n)
IP=$(curl -s http://checkip.amazonaws.com/)
REMOTE_IP=$(	curl -s \
  		-H "Authorization: Bearer $ACCESS_TOKEN" \
  		"https://api.digitalocean.com/v2/domains/$DOMAIN/records/$ID" \
  		| sed -n 's/.*"data":"\([^"]*\)".*/\1/p')

echo $(date)
echo "Current Local IP : $IP"
echo "Current Remote IP : $REMOTE_IP"

if [[ "$REMOTE_IP" != "$IP" ]]; then
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
	echo $IP > $HOME/do-ddns/ip.txt
else
	echo "Local IP unchanged. Exiting ... "
fi

echo "** Done. **"
exit
