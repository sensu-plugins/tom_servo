namespace :testing do

  desc 'Run all necessary tests'
  task :execute_all_tests do
    Rake::Task['testing:execute_rake_tests'].invoke
    Rake::Task['testing:execute_gem_tests'].invoke
  end


  desc 'Run tests'
  task :execute_rake_tests do
    SUPPORTED_RUBIES.each do |r|
      # `rvm use #{ r }`
      `chruby  #{ r }`
      `bundle exec rake default`
    end
  end

  desc 'Build and install a gem'
  task :execute_gem_tests do
    Rake::Task['gem:create_gem'].invoke
    `gem install *.gem`
  end
end
