lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'jossh/version'

Gem::Specification.new do |s|
  s.name        = 'jossh'
  s.version     = Jossh::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Easier and Prettier SSH for Ruby (CLI + Library)"
  s.description = "Jossh is a wrapper around Ruby Net::SSH with a simpler interface and prettier output"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.rb', 'lib/jossh/templates/*']
  s.executables = ["jossh"]
  s.homepage    = 'https://github.com/DannyBen/jossh'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'colsole', '~> 0.5'
  s.add_runtime_dependency 'net-ssh', '~> 4.0'
  s.add_runtime_dependency 'docopt', '~> 0.5'
end
