def define_plugin
  File.basename(File.expand_path('.'))
end

def load_specs
  puts Gem::Specification.load("#{ PROJECT_ROOT }/#{ define_plugin }.gemspec")
end

def deploy_setup
  FileUtils.chdir(PROJECT_ROOT)
  `git checkout master`
  `git fetch origin "+refs/heads/*:refs/remotes/origin/*"`
  `git remote add repo git@github.com:sensu-plugins/#{ define_plugin }.git`
  `git config --global user.email #{ DEPLOY_EMAIL }`
  `git config --global user.name #{ DEPLOY_USER }`
end
