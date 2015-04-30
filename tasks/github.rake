namespace :github do

  desc 'Create a Github tag and release'
  task :create_github_release do
    spec = load_specs
    plugin = define_plugin
    github_token = File.read("#{ Dir.home }/.ssh/git_token")
    puts `curl -H "Authorization: token #{ github_token }" -d '{ "tag_name": "#{ spec.version }", "target_commitish": "#{ ENV['CI_COMMIT_ID'] }", "name": "#{ spec.version }", "body": "#{ ENV['CI_MESSAGE'] }", "draft": "#{ spec.metadata['release_draft']}", "prerelease": "#{ spec.metadata['release_prerelease']}" }' https://api.github.com/repos/sensu-plugins/#{ plugin }/releases` # rubocop:disable all
  end

  desc 'Create a Github commit'
  task :create_github_commit do
    plugin = define_plugin
    `git add lib/#{ plugin }/version.rb`
    `git commit -m 'version bump --skip-ci'`
    `git push repo master`
  end
end
