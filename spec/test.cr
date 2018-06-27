require "../src/tap"

T.ok 1 == 1
T.ok 1 == 1, "one is one"
T.ok 1 == 2
T.ok 1 == 2, "one is two"

T.not_ok 1 == 1
T.not_ok 1 == 1, "one is one"
T.not_ok 1 == 2
T.not_ok 1 == 2, "one is two"

T.eq 1, 1
T.eq 1, 1, "one is one"
T.eq 1, 2
T.eq 1, 2, "one is two"

T.not_eq 1, 1
T.not_eq 1, 1, "one is one"
T.not_eq 1, 2
T.not_eq 1, 2, "one is two"

T.eq_nil nil
T.eq_nil :not_nil

T.not_eq_nil nil
T.not_eq_nil :not_nil

T.eq_true true
T.eq_true "true"

T.eq_false false
T.eq_false "false"

class Cheat
  def initialize(@object_id : Int32); end

  def inspect(io)
    io << "Cheat.new(#{object_id.inspect})"
  end

  getter object_id
end

cheat_one = Cheat.new 1
cheat_two = Cheat.new 2

T.same cheat_one, cheat_one
T.same cheat_one, cheat_one, "one is one"
T.same cheat_one, cheat_two
T.same cheat_one, cheat_two, "one is two"

T.not_same cheat_one, cheat_one
T.not_same cheat_one, cheat_one, "one is one"
T.not_same cheat_one, cheat_two
T.not_same cheat_one, cheat_two, "one is two"

T.is cheat_one, Cheat
T.is cheat_one, String
T.is cheat_two, Cheat, "cheat object"
T.is cheat_two, String, "cheat object"
T.is [cheat_one, cheat_two], Array(Cheat)
T.is [cheat_one, cheat_two], Array
T.is "cheat", Cheat
T.is "cheat", String
T.is "cheat", Cheat, "string object"
T.is "cheat", String, "string object"

T.is_not cheat_one, Cheat
T.is_not cheat_one, String
T.is_not cheat_two, Cheat, "cheat object"
T.is_not cheat_two, String, "cheat object"
T.is_not [cheat_one, cheat_two], Array(Cheat)
T.is_not [cheat_one, cheat_two], Array
T.is_not "cheat", Cheat
T.is_not "cheat", String
T.is_not "cheat", Cheat, "string object"
T.is_not "cheat", String, "string object"

T.match "hello", "hello"
T.match "hello", "Hello"
T.match "hello", /hello/
T.match "Hello", /hello/i
T.match "Hello", /hello/i, "match regex"
T.match 1, 1..3
T.match 5, 1..3

T.not_match "hello", "hello"
T.not_match "hello", "Hello"
T.not_match "hello", /hello/
T.not_match "Hello", /hello/i
T.not_match "Hello", /hello/i, "match regex"
T.not_match 1, 1..3
T.not_match 5, 1..3

class Ex < Exception
  def inspect(io)
    io << "Ex.new(#{message.inspect})"
  end

  def inspect_with_backtrace(io)
    inspect io
    io.puts
    io.puts "no backtrace..."
  end
end

T.raises { raise Ex.new "error" }
T.raises(message: "raise an exception") { raise Ex.new "error" }
T.raises { nil }
T.raises(message: "not raise an exception") { nil }
T.raises("error", "raise an exception") { raise Ex.new "error" }
T.raises("exception", "raise an exception") { raise Ex.new "error" }
T.raises(/error/, "raise an exception") { raise Ex.new "error" }
T.raises(/exception/, "raise an exception") { raise Ex.new "error" }

T.not_raises { raise Ex.new "error" }
T.not_raises("raise an exception") { raise Ex.new "error" }
T.not_raises { nil }
T.not_raises("not raise an exception") { nil }

T.test do
  T.ok true, "in unnamed group"
  T.ok false, "in unnamed group"
end

T.test "named" do
  T.ok true, "in named group"
  T.ok false, "in named group"
end

T.test "catch an exception in test group" do
  T.ok true
  T.ok false
  raise Ex.new "error"
  T.ok true
  T.ok false
end

T.skip "catch an exception in test group" do
  T.ok true
  T.ok false
  raise Ex.new "error"
  T.ok true
  T.ok false
end
