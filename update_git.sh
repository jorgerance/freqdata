#!/bin/bash

days_to_download=200
timeframes='1m 5m 15m 1h 4h 1d'
freqtrade_path='/mnt/freqdata/freqtrade'
binance_pairs='binance_usd_pairs.json'
ftx_pairs='ftx_usd_pairs.json'

download_binance() {
	cd ${freqtrade_path}
	python /mnt/freqdata/pythonlib/binance_usd_pairs.py > ./user_data/${binance_pairs}
	freqtrade download-data -c user_data/${binance_pairs} --exchange binance --days ${days_to_download} -t ${timeframes}
}

download_ftx() {
	cd ${freqtrade_path}
	python /mnt/freqdata/pythonlib/ftx_usd_pairs.py > ./user_data/${ftx_pairs}
	freqtrade download-data -c user_data/${ftx_pairs} --exchange ftx --days ${days_to_download} -t ${timeframes}
}

update_git() {
	cp -Rp ${freqtrade_path}/user_data/data/* /mnt/freqdata/tickersdata/.
	cd /mnt/freqdata/tickersdata/.
	git add -A
	git commit -m 'auto update OHLC freqtrade data'
	git push
}

generate_readme() {
	README='/mnt/freqdata/tickersdata/README.md'
	> ${README}
	cd ${freqtrade_path}
	date && echo -e '\n\n' >> ${README}
	echo -e "## Binance pairs\n" >> ${README}
	echo -e "Timeframes: ${timeframes}\n" >> ${README}
	freqtrade list-data --userdir ./user_data/ -c ./config.json -c ./user_data/${binance_pairs}  --exchange binance >> ${README}
	echo -e "\n\n## FTX pairs\n" >> ${README}
	echo -e "Timeframes: ${timeframes}\n" >> ${README}
	freqtrade list-data --userdir ./user_data/ -c ./config.json -c ./user_data/f${ftx_pairs}  --exchange ftx >> ${README}
	sed s/\+--*+-*-\+$//g -i ${README}
	sed s/---\+---/---\|---/g -i ${README}
}

cd /mnt/freqdata/pythonlib && git pull
source ${freqtrade_path}/.env/bin/activate

download_binance
download_ftx
generate_readme
update_git
