require File.expand_path('lib/beantool', File.dirname(__FILE__))

Gem::Specification.new do |gem|
  gem.name        = 'beantool'
  gem.description = %q{Beantool is a command line utility for monitoring and adminstering a Beanstalkd pool.}
  gem.summary     = %q{CLI tool for Beanstalkd}

  gem.version     = Beantool::VERSION
  gem.platform    = Gem::Platform::RUBY

  gem.authors     = ['Justin Langhorst']
  gem.email       = ['the@justinlanghorst.com']
  gem.homepage    = 'http://rubygems.org/gems/beantool'
  gem.license     = 'MIT'

  gem.files                      = Dir.glob('{bin,lib,test}/**/*') + %w(LICENSE.md README.md)
  gem.executables                = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files                 = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths              = ['lib']

  gem.required_ruby_version      = '~> 2.0'

  gem.add_runtime_dependency     'beaneater', '~> 0.3'

  gem.add_development_dependency 'bundler', '~> 1.5'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'simplecov', '~> 0.8'
  gem.add_development_dependency 'pry', '~> 0.9'
end
