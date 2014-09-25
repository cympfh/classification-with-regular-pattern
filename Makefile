author:
	coffee author.coffee

test:
	for test in *.test.coffee; do echo $$test; coffee $$test; done
