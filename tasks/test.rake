namespace :test do

  desc 'standard tests for all repos'
  task :ts_tests do
    Rake::Task['keys:test_binstubs'].invoke
    # plugin = define_plugin
    # spec = load_specs
    # FileUtils.chdir(PROJECT_ROOT)
    # RUBY_VERSIONS.each do |r|
    #   `rvm use #{ r }`
    #   `bundle exec rake default`
    #   `gem build #{ plugin }.gemspec`
    #   `gem install #{ spec.full_name}.gem`
    #   test_gem_bin
    end

  desc 'test for binstubs'
  task :test_binstubs do
    FileUtils.chdir(PROJECT_ROOT)
    test_gem_bin
    end
  end
