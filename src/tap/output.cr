require "json"

module Tap
  TAP_VERSION = 13

  class Output
    def initialize(@io); end

    def version
      @io.puts "TAP Version #{Tap::TAP_VERSION}"
    end

    # Output 1..count
    def count(count)
      @io.puts "\n1..#{count}"
    end

    def comment(comment)
      if comment.empty?
        @io.puts "#"
      end
      comment.lines.each do |line|
        @io.puts "# #{line.chomp}"
      end
    end

    def info(info : Array({String, String}))
      @io.puts "  ---"
      info.each do |name_and_value|
        name, value = name_and_value

        if value =~ /[-:?\n\r\t]/
          value = ":-\n#{value.lines.map{ |l| "    #{l}" }.join "\n"}\n"
        end

        @io.puts "  #{name}: #{value}"
      end
      @io.puts "  ..."
    end

    def result(ok, count, message)
      @io.puts "#{ok ? "ok" : "not ok"} #{count} - #{message}"
    end
  end
end
