all: docs do

do:
	coffee index.coffee

docs:
	-mkdir doc
	# 斜陽, ダスゲマイネ, 女生徒
	curl http://www.aozora.gr.jp/cards/000035/files/1565_8559.html | nkf > doc/d_a
	curl http://www.aozora.gr.jp/cards/000035/files/42945_14904.html | nkf > doc/d_b
	curl http://www.aozora.gr.jp/cards/000035/files/275_13903.html | nkf > doc/d_c
	# 嵐, 朝飯, 食堂
	curl http://www.aozora.gr.jp/cards/000158/files/1511_20470.html | nkf > doc/s_a
	curl http://www.aozora.gr.jp/cards/000158/files/2949_48819.html | nkf > doc/s_b
	curl http://www.aozora.gr.jp/cards/000158/files/47172_34186.html | nkf > doc/s_c
	touch docs

clean:
	rm -rf doc docs
