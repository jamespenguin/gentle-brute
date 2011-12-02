Gem::Specification.new do |s|
  s.name = 'gentle_brute'
  s.version = '0.0.2'
  s.summary = 'The better brute force algorithm'
  s.description = 'A heuristic brute forcing algorithm for Ruby that generates brute force passphrases that adhere to the rules of English-like words and phrases.'
  s.authors = ["Brandon Smith"]
  s.email = 'brandon.smith@studiobebop.net'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/jamespenguin/gentle-brute'
  s.executables << 'GentleBrute'
  s.requirements << 'slop >= 2.3.1'
end