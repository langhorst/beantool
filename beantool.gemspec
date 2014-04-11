require File.expand_path('lib/beantool', File.dirname(__FILE__))

Gem::Specification.new do |gem|
  gem.name        = 'beantool'
  gem.description = %q{}
  gem.summary     = %q{}

  gem.version     = Beantool::VERSION
  gem.platform    = Gem::Platform::RUBY

  gem.authors     = ['Justin Langhorst']
  gem.email       = ['the@justinlanghorst.com']
  gem.homepage    = ''
  gem.license     = 'MIT'

  gem.files                      = Dir.glob('{bin,lib,test}/**/*') + %w(LICENSE.md README.md)
  gem.executables                = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files                 = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths              = ['lib']

  gem.required_ruby_version      = '~> 2.0'

  gem.add_runtime_dependency     'beanstalk-client' 

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-reporters'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'pry'
end
