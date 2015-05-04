require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'github/markup'
require 'redcarpet'
require 'yard'
require 'yard/rake/yardoc_task'

namespace :testing do

  desc 'Run all necessary tests'
  task :execute_all_tests do
    YARD::Rake::YardocTask.new do |t|
      OTHER_PATHS = %w()
      t.files = ['lib/**/*.rb', 'bin/**/*.rb', OTHER_PATHS]
      t.options = %w(--markup-provider=redcarpet --markup=markdown --main=README.md --files CHANGELOG.md,CONTRIBUTING.md)
    end
    if RUBY_VERSION >= '2.0.0'
      RuboCop::RakeTask.new
    end
    # Rake::Task['testing:execute_rake_tests'].invoke
    RSpec::Core::RakeTask.new(:spec) do |r|
      r.pattern = FileList['**/**/*_spec.rb']
    end
    Rake::Task['testing:execute_gem_tests'].invoke
    # Rake::Task['testing:execute_gem_tests'].invoke
    # Rake::Task['testing:execute_gem_tests'].invoke

  end

  # desc 'Run tests'
  # task :execute_rake_tests do
  #   SUPPORTED_RUBIES.each do |r|
  #     `rvm use #{ r }`
  #     `bundle exec rake default`
  #   end
  # end

  desc 'Build and install a gem'
  task :execute_gem_tests do
    Rake::Task['gem:create_gem'].invoke
    `gem install *.gem`
  end
end
