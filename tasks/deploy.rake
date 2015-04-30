namespace :deploy do

  desc 'deploy'
  task :deploy do
    if ENV['CI_MESSAGE'] == 'deploy'
      deploy_setup
      #Rake::Task['gem:create_gem'].invoke
      #Rake::Task['gem:push_gem'].invoke
      Rake::Task['github:create_github_release'].invoke
    end
  end
end
