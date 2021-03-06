#!/bin/sh

# requires environment vars set in .zshrc
# export ACCESS_TOKEN=thistoken
# export DOMAIN=this.com
# export ID=do_record_id

RECORD_IDS=($ID)	# multiple ids (RECORD_ID_1 RECORD_ID_n)

IP=$(curl -s http://checkip.amazonaws.com/)

echo $(date)
echo "Current Public IP : $IP"

if [[ $(< $HOME/do-ddns/ip.txt) != "$IP" ]]; then
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
	echo "Public IP unchanged. Exiting ... "
fi

echo "** Done. **"
exit
