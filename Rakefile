require 'rubygems/package_task'

def gemspec
  @spec ||= Gem::Specification.load('beantool.gemspec')
end

task :default => :test

desc "Build #{gemspec.file_name} into the pkg directory"
task :gem  do
  FileUtils.mkdir_p 'pkg'
  Gem::Package.build(gemspec)
  FileUtils.mv gemspec.file_name, 'pkg'
end
task :build => :gem

desc "Build and install #{gemspec.file_name}"
task :install => :gem do
  sh "gem install pkg/#{gemspec.file_name}"
end

desc 'Run the tests'
task :test do
  Dir.glob('./test/**/*test*.rb').each { |file| require file }
end

desc "Generate SimpleCov test coverage and open in your browser"
task :coverage do
  require 'simplecov'
  FileUtils.rm_rf("./coverage")
  SimpleCov.add_filter 'test/'
  SimpleCov.add_filter 'rakefile'
  SimpleCov.at_exit do
    SimpleCov.result.format!
    sh "open #{SimpleCov.coverage_path}/index.html"
  end
  SimpleCov.start
  Rake::Task[:test].execute
end

desc 'Remove generated files and directories'
task :clean do
  %w(coverage doc pkg tmp).each { |file| FileUtils.rm_rf(file) }
end

desc "Open an irb session preloaded with this library"
task :irb do
  sh "irb -Ilib -r#{gemspec.name}"
end

desc "Open a pry session preloaded with this libary"
task :pry do
  sh "pry -Ilib -r#{gemspec.name}"
end

desc "Look for TODO and other tags in the code"
task :todo do
  FileList["**/*.rb"].egrep /#.*(FIXME|TODO|TBD|OPTIMIZE|HACK|REVIEW)/
end
