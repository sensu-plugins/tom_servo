namespace :test do

  desc 'standard tests for all repos'
  task :test do
    plugin = define_plugin
    spec = load_specs
    RUBY_VERSIONS.each do |r|
      `rvm use #{ r }`
      `bundle exec rake default`
      `gem build #{ plugin }.gemspec`
      `gem install #{ spec.full_name}.gem`
      test_gem_bin
    end
  end

end
