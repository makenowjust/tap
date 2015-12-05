require "./output"
require "./util"

module T
  extend self

  @@count = 0
  @@pass_count = 0
  @@fail_count = 0

  @@output = Tap::Output.new STDOUT

  @@in_group = nil

  def begin
    @@output.version
  end

  # Shows test results and returns exit code.
  def end
    @@output.count @@count

    @@output.comment "tests #{@@count}"
    @@output.comment "pass #{@@pass_count}"
    @@output.comment "fail #{@@fail_count}" if @@fail_count != 0

    @@fail_count == 0 ? 0 : 1
  end

  # Passes a test with *message*.
  def pass(message)
    unless @@in_group == nil || @@in_group == true
      raise "Don't assert out of test group"
    end

    @@count += 1
    @@pass_count += 1
    @@output.result true, @@count, message.to_s
  end

  # Fails a test with *message* and *info*.
  def fail(message, info = nil)
    unless @@in_group == nil || @@in_group == true
      raise "Don't assert out of test group"
    end

    @@count += 1
    @@fail_count += 1
    @@output.result false, @@count, message.to_s
    @@output.info info if info
  end

  # Defines new test group.
  def test(name = "")
    @@output.comment name.to_s
    @@in_group = true
    begin
      yield
    rescue ex
      ::T.fail name, [
        {"error", ex.inspect_with_backtrace},
      ]
    end
    @@in_group = false
  end

  # Skips a test group.
  def skip(name = "", &block)
    @@count += 1
    @@pass_count += 1
    @@in_group = false
    @@output.result true, @@count, "# skip #{name}"
  end

  # Checks *test* is truthy.
  macro ok(test, message = nil, file = __FILE__, line = __LINE__)
    %test = {{ test }}
    if %test
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s {{ test }}},
        {"operator", "ok"},
        {"expected", true.inspect},
        {"actual", %test.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *test* is falsely.
  macro not_ok(test, message = nil, file = __FILE__, line = __LINE__)
    %test = {{ test }}
    if !%test
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s !({{ test }})},
        {"operator", "not_ok"},
        {"expected", false.inspect},
        {"actual", %test.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* equals to *expected*. (`expected == actual`)
  macro eq(actual, expected, message = "should equal", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if %expected == %actual
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test"    , ::Tap::Util.expr_to_s {{ expected }} == {{ actual }}},
        {"operator", "eq"},
        {"expected", %expected.inspect},
        {"actual"  , %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* does not equal to *expected*. (`expected != actual`)
  macro not_eq(actual, expected, message = "should not equal", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if %expected != %actual
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test"    , ::Tap::Util.expr_to_s {{ expected }} != {{ actual }}},
        {"operator", "not_eq"},
        {"expected", %expected.inspect},
        {"actual"  , %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* is `nil`. (`nil == actual`)
  macro eq_nil(actual, message = "should be nil", file = __FILE__, line = __LINE__)
    ::T.eq {{ actual }}, nil, {{ message }}, {{ file }}, {{ line }}
  end

  # Checks *actual* is not `nil`. (`nil != actual`)
  macro not_eq_nil(actual, message = "should not be nil", file = __FILE__, line = __LINE__)
    ::T.not_eq {{ actual }}, nil, {{ message }}, {{ file }}, {{ line }}
  end

  # Checks *actual* is `true`. (`true == actual`)
  macro eq_true(actual, message = "should be true", file = __FILE__, line = __LINE__)
    ::T.eq {{ actual }}, true, {{ message }}, {{ file }}, {{ line }}
  end

  # Checks *actual* is `false`. (`false == actual`)
  macro eq_false(actual, message = "should be false", file = __FILE__, line = __LINE__)
    ::T.eq {{ actual}}, false, {{ message }}, {{ file }}, {{ line }}
  end

  # Checks *actual* and *expected* are same instance. (`actual.same? expected`)
  macro same(actual, expected, message = "should be same", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if %actual.same? %expected
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s {{ actual }}.same?({{ expected }})},
        {"operator", "same"},
        {"expected_object_id", %expected.object_id.inspect},
        {"expected", %expected.inspect},
        {"actual_object_id", %actual.object_id.inspect},
        {"actual", %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* and *expected* are not same instance. (`!actual.same? expected`)
  macro not_same(actual, expected, message = "should not be same", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if !%actual.same? %expected
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s !({{ actual }}.same?({{ expected }}))},
        {"operator", "not_same"},
        {"expected_object_id", %expected.object_id.inspect},
        {"expected", %expected.inspect},
        {"actual_object_id", %actual.object_id.inspect},
        {"actual", %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* is instance of *expected_class*. (`actual.is_a? expected_class`)
  macro is(actual, expected_class, message = "should be instance of", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    if %actual.is_a?({{ expected_class }})
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s {{ actual }}.is_a?({{ expected_class }})},
        {"operator", "is"},
        {"expected_class", {{ expected_class }}.to_s},
        {"actual", %actual.inspect},
        {"actual_class", %actual.class.to_s},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* is not instance of *expected_class*. (`!actual.is_a? expected_class`)
  macro is_not(actual, expected_class, message = "should not be instance of", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    if !%actual.is_a?({{ expected_class }})
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s !({{ actual }}.is_a?({{ expected_class }}))},
        {"operator", "is_not"},
        {"expected_class", {{ expected_class }}.to_s},
        {"actual", %actual.inspect},
        {"actual_class", %actual.class.to_s},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* matches with *expected*. (`expected === actual`)
  macro match(actual, expected, message = "should match", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if %expected === %actual
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s {{ expected }} === {{ actual }}},
        {"operator", "match"},
        {"expected", %expected.inspect},
        {"actual", %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks *actual* does not match with *expected*. (`!(expected === actual)`)
  macro not_match(actual, expected, message = "should not match", file = __FILE__, line = __LINE__)
    %actual = {{ actual }}
    %expected = {{ expected }}
    if !(%expected === %actual)
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"test", ::Tap::Util.expr_to_s !({{ expected }} === {{ actual }})},
        {"operator", "not_match"},
        {"expected", %expected.inspect},
        {"actual", %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks given block raises the *expected* exception.
  macro raises(expected = Exception, message = "should raise", file = __FILE__, line = __LINE__)
    begin
      {{ yield }}
      %actual = nil
    rescue %error
      %actual = %error
    end

    %expected = {{ expected }}
    if %expected === %actual || %actual.is_a?(Exception) && %expected === %actual.message
      ::T.pass {{ message }}
    else
      ::T.fail {{ message }}, [
        {"operator", "raises"},
        {"expected", {{ expected }}.inspect},
        {"actual", %actual.is_a?(Exception) ? %actual.inspect_with_backtrace : %actual.inspect},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end

  # Checks given block does not raise an exception.
  macro not_raises(message = "should not raise", file = __FILE__, line = __LINE__)
    begin
      {{ yield }}
      ::T.pass {{ message }}
    rescue %actual
      ::T.fail {{ message }}, [
        {"operator", "not_raises"},
        {"error", %actual.inspect_with_backtrace},
        {"at", "#{ ::Tap::Util.fix_path {{ file }} } - line at #{ {{ line }} }"},
      ]
    end
  end
end
