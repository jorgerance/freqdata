#!/bin/bash

download_ftx() {
	source /mnt/freqdata/freqtrade/.env/bin/activate
	cd /mnt/freqdata/freqtrade
	/mnt/freqdata/pythonlib/ftx_usd_pairs.py > ./user_data/ftx_usd_pairs.json
	freqtrade download-data -c user_data/ftx_usd_pairs.json --exchange ftx --days 100 --timeframes {1m,5m,15m,1h,4h,1d}
}

update_git() {
	cp -Rp /mnt/freqdata/freqtrade/user_data/data/* /mnt/freqdata/tickersdata/.
	cd /mnt/freqdata/tickersdata/.
	git add -A
	git commit -m 'auto update tickers'
	git push
}

download_ftx
update_git
