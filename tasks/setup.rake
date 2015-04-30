namespace :setup do

  #
  # main setup task
  #
  #
  desc 'setup an environment for testing'
  task :setup_env do
    Rake::Task['keys:key_drop'].invoke
