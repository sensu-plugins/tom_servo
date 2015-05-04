namespace :setup do
  #
  # main setup task
  #
  desc 'setup an environment for testing'
  task :setup_env do
    Rake::Task['keys:key_drop'].invoke
    Rake::Task['setup:install_ruby'].invoke
  end

  desc 'install and configure ruby environments'
  task :install_ruby do
    FileUtils.chdir(PROJECT_ROOT)
    SUPPORTED_RUBIES.each do |r|
      `#{ HOMEDIR }/tmp/ruby-install-0.5.0/bin/ruby-install --install-dir #{ HOMEDIR }/.rubies ruby #{ r }`
      # `rvm use #{ r } --install`
      `gem install bundler`
      `bundle install`
    end
  end
end
