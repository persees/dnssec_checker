
len=$(wc -l list.txt | cut -f1 -d' ')
mapfile -t pubs < list.txt


current=0
echo "servico,flag AD,status,DS,DNSKEY,RRSIG" > results.csv

while [ $current -lt $len ]
do
	result=$(dig ${pubs[${current}]} +dnssec)
	flag_result=$(echo "$result" | grep -q " ad;" && echo "YES")
	status_result=$(echo "$result" | grep -o "status: \w*" | sed 's/status: //')
	ds_results=$(dig DS ${pubs[${current}]} +short)
	dnskey_result=$(dig DNSKEY ${pubs[${current}]} +short)
	rrsig_result=$(dig ${pubs[${current}]} +dnssec +short)

	echo ${flag_result}
	echo ${status_result}
	echo ${ds_results}
	echo ${dnskey_result}
	echo ${rrsig_result}

	echo ${pubs[${current}]},${flag_result},${status_result},${ds_results},${dnskey_result},${rrsig_result} >> results.csv
	current=$(( $current + 1 ))
	done

