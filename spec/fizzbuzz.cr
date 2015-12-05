require "../src/inline"

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
