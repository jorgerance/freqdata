#!/bin/bash

download_binance() {
	cd /mnt/freqdata/freqtrade
	python /mnt/freqdata/pythonlib/binance_usd_pairs.py > ./user_data/binance_usd_pairs.json
	freqtrade download-data -c user_data/binance_usd_pairs.json --exchange binance --days 100 --timeframes {1m,5m,15m,1h,4h,1d}
}

download_ftx() {
	cd /mnt/freqdata/freqtrade
	python /mnt/freqdata/pythonlib/ftx_usd_pairs.py > ./user_data/ftx_usd_pairs.json
	freqtrade download-data -c user_data/ftx_usd_pairs.json --exchange ftx --days 100 --timeframes {1m,5m,15m,1h,4h,1d}
}

update_git() {
	cp -Rp /mnt/freqdata/freqtrade/user_data/data/* /mnt/freqdata/tickersdata/.
	cd /mnt/freqdata/tickersdata/.
	git add -A
	git commit -m 'auto update tickers'
	git push
}

generate_readme() {
	README='/mnt/freqdata/tickersdata/README.md'
	> ${README} 
	cd /mnt/freqdata/freqtrade
	echo -e "## Binance pairs\n" >> ${README}
	freqtrade list-data --userdir ./user_data/ -c ./config.json -c ./user_data/binance_usd_pairs.json  --exchange binance >> ${README}
	echo -e "\n\n## FTX pairs\n" >> ${README}
	freqtrade list-data --userdir ./user_data/ -c ./config.json -c ./user_data/ftx_usd_pairs.json  --exchange ftx >> ${README}
}

cd /mnt/freqdata/pythonlib && git pull
source /mnt/freqdata/freqtrade/.env/bin/activate

download_binance
download_ftx
generate_readme
update_git
