lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hayrick/version'

Gem::Specification.new do |spec|
  spec.name          = 'hayrick'
  spec.version       = Hayrick::VERSION
  spec.authors       = ['Pedro Lambert']
  spec.email         = ['pedrolambert@gmail.com']

  spec.summary       = %q{Create Query Objects without a hitch.}
  spec.description   = %q{Create Query Objects without a hitch.}
  spec.homepage      = 'https://github.com/p-lambert/hayrick'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sequel', '~> 4.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'pry'
end
