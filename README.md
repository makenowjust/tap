# tap

[TAP](https://testanything.org/) test framework for Crystal.


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tap:
    github: MakeNowJust/tap
```


## Usage

```crystal
require "tap"

T.test "awesome test name 1" do
  T.ok 1 == 1, "one is one"
  T.ok 1 == 2, "one is two"
end

T.test "awesome test name 2" do
  T.is "I am", String
  T.eq 1, 1, "one is one again"
end
```

then run it:

```console
$ crystal run ./test.cr
TAP Version 13
# awesome test name 1
ok 1 one is one
not ok 2 one is two
  ---
  test: 1 == 1
  operator: ok
  expected: true
  actual: false
  at: test.cr - line at 5
  ...
# awesome test name 2
ok 3
ok 4 one is one again

1..4
# tests 4
# pass 3
# fail 1
```

You can use inline specs:

```crystal
require "tap/inline"

def fizzbuzz(n)
  return :FizzBuzz if n % 15 == 0
  return :Fizz if n % 3 == 0
  return :Buzz if n % 5 == 0
  n
end

inline_test :fizzbuzz do
  T.eq fizzbuzz(1), 1
  T.eq fizzbuzz(2), 2
  T.eq fizzbuzz(3), :Fizz
  T.eq fizzbuzz(4), 4
  T.eq fizzbuzz(5), :Buzz
  T.eq fizzbuzz(6), :Fizz
  T.eq fizzbuzz(7), 7
  T.eq fizzbuzz(8), 8
  T.eq fizzbuzz(9), :Fizz
  T.eq fizzbuzz(10), :Buzz
  T.eq fizzbuzz(11), 11
  T.eq fizzbuzz(12), :Fizz
  T.eq fizzbuzz(13), 13
  T.eq fizzbuzz(14), 14
  T.eq fizzbuzz(15), :FizzBuzz

  T.eq fizzbuzz(100), :Buzz
  T.eq fizzbuzz(100), :FizzBuzz
  T.eq fizzbuzz(111), :Fizz
  T.eq fizzbuzz(222), :Fizz
  T.eq fizzbuzz(333), :Fizz
  T.eq fizzbuzz(444), :Fizz
  T.eq fizzbuzz(555), :FizzBuzz
  T.eq fizzbuzz(1515), :Fizz
  T.eq fizzbuzz(1515), :Buzz
  T.eq fizzbuzz(1515), :FizzBuzz
end
```

then run it:

```console
$ env CRYSTAL_TEST=yes crystal run fizzbuzz.cr
TAP Version 13
# fizzbuzz
ok 1 - should equal
ok 2 - should equal
ok 3 - should equal
ok 4 - should equal
ok 5 - should equal
ok 6 - should equal
ok 7 - should equal
ok 8 - should equal
ok 9 - should equal
ok 10 - should equal
ok 11 - should equal
ok 12 - should equal
ok 13 - should equal
ok 14 - should equal
ok 15 - should equal
ok 16 - should equal
not ok 17 - should equal
  ---
  test: :-
    (:FizzBuzz) == fizzbuzz(100)
  operator: eq
  expected: :-
    :FizzBuzz
  actual: :-
    :Buzz
  at: :-
    fizzbuzz.cr - line at 28
  ...
ok 18 - should equal
ok 19 - should equal
ok 20 - should equal
ok 21 - should equal
ok 22 - should equal
not ok 23 - should equal
  ---
  test: :-
    (:Fizz) == fizzbuzz(1515)
  operator: eq
  expected: :-
    :Fizz
  actual: :-
    :FizzBuzz
  at: :-
    fizzbuzz.cr - line at 34
  ...
not ok 24 - should equal
  ---
  test: :-
    (:Buzz) == fizzbuzz(1515)
  operator: eq
  expected: :-
    :Buzz
  actual: :-
    :FizzBuzz
  at: :-
    fizzbuzz.cr - line at 35
  ...
ok 25 - should equal

1..25
# tests 25
# pass 22
# fail 3
```

## Development

```console
$ crystal make.cr -- spec
```


## Contributing

1. Fork it ( https://github.com/MakeNowJust/tap/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer
