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
      Rake::Task['gem:create_gem'].invoke
      Rake::Task['gem:push_gem'].invoke
      Rake::Task['github:create_github_release'].invoke
    end
  end

  desc 'deploy the documentation'
  task deploy_docs do
    if ENV['CI_MESSAGE'] == 'deploy'
      deploy_setup
      FileUtils.chdir(HOMEDIR)
      `git clone git@github.com:sensu-plugins/#{ SITE_REPO }.git`
      # FileUtils.chdir(SITE_REPO)
      FileUtils.cp_r("#{ PROJECT_ROOT }/*", "#{ SITE_REPO }/documentation")
      # Rake::Task['github:push_repo'].invoke
    end
  end
end
