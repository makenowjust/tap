require "crake/global"

task "spec" do
  sh "crystal run ./spec/test.cr | diff ./spec/expected.txt -"
  sh "crystal run ./spec/fizzbuzz.cr"
  sh "env CRYSTAL_TEST=yes crystal run ./spec/fizzbuzz.cr | diff ./spec/fizzbuzz.txt -"
end
