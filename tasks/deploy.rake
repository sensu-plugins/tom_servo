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

  # deployment task for plugins documentation
  #
  # The documentation lives in a seperate repo and when it gets commited to by
  # a committer this will pull the site repo, copy the new docs into it and
  # then push it back up, causing Travis to rebuild the site.
  #
  desc 'deploy the documentation'
  task :deploy_docs do
    if ENV['CI_MESSAGE'] == 'deploy'
      docs = File.join(PROJECT_ROOT, 'docs', '*')
      deploy_setup
      FileUtils.chdir(HOMEDIR)
      `git clone git@github.com:sensu-plugins/#{ SITE_REPO }.git`
      FileUtils.cp_r(Dir.glob(docs), "#{ SITE_REPO }/documentation")
      Rake::Task['github:push_site_repo'].invoke
    end
  end
end
