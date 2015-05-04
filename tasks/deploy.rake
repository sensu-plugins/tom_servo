namespace :deploy do
  # main deployment task
  #
  # This is the task that is run via Codeship, anything here will be run.
  # No changes should be made to Codeship deployments, you should modify
  # these tasks
  #
  desc 'deploy'
  task :deploy do
    if ENV['CI_MESSAGE'] == 'deploy'
      deploy_setup
      Rake::Task['deploy:make_bin_executable'].invoke
      Rake::Task['gem:create_gem'].invoke
      Rake::Task['gem:push_gem'].invoke
      Rake::Task['github:create_github_release'].invoke
    end
  end

  desc 'Make all plugins executable'
  task :make_bin_executable do
    `chmod -R +x bin/*`
  end
end
