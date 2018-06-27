.PHONY: spec
spec:
	crystal run ./spec/test.cr | diff ./spec/expected.txt -
	crystal run ./spec/fizzbuzz.cr
	env CRYSTAL_TEST=yes crystal run ./spec/fizzbuzz.cr | diff ./spec/fizzbuzz.txt -
