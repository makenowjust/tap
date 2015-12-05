# :nodoc:
module Tap::Util
  extend self

  macro expr_to_s(expr)
    {{ expr.stringify }}
  end

  def fix_path(path)
    cwd = Dir.working_directory
    if path.starts_with?(cwd)
      path.sub(cwd, ".")
    else
      path
    end
  end
end
