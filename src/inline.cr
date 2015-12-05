require "./tap/*"

{% if env("CRYSTAL_TEST") %}

  def inline_test(name = "")
    ::T.test name do
      yield
    end
  end

  T.begin
  at_exit do
    exit T.end
  end
{% else %}
  macro inline_test(name = ""); end
{% end %}
