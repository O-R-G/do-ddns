#!/bin/sh

# requires ENV variables TOKEN, DOMAIN, ID
# loaded by .zshrc

ACCESS_TOKEN=$TOKEN
DOMAIN=$DOMAIN
RECORD_IDS=($ID)	# multiple ids (RECORD_ID_1 RECORD_ID_n)

IP=$(curl -s http://checkip.amazonaws.com/)

echo $(date)
echo "Current Public IP : $IP"

if [[ $(< do-ddns/ip.txt) != "$IP" ]]; then
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
	echo $IP > do-ddns/ip.txt
else
	echo "Public IP unchanged. Exiting ... "
fi

echo "** Done. **"
exit
