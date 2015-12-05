require "./tap/*"

T.begin
at_exit do
  exit T.end
end
