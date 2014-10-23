all: cc test

cc:
	cd mcp; make

test:
	for test in *.test.coffee; do echo $$test; coffee $$test; done
