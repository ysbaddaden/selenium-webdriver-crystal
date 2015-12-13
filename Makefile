.PHONY: test

test_files = $(shell find test -iname "*_test.cr")
test:
	crystal $(test_files)
