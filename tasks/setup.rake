namespace :setup do
  #
  # main setup task
  #
  #
  desc 'setup an environment for testing'
  task :setup_env do
    Rake::Task['keys:key_drop'].invoke
    Rake::Task['setup:setup_ruby_env'].invoke
  end

  desc 'setup the necessary rubies for testing'
  FileUtils.chdir(PROJECT_ROOT)
  task :setup_ruby_env do
    RUBY_VERSIONS.each do |r|
      `rvm use #{ r } --install`
      `gem install bundler`
      `bundle install`
    end
  end
end
