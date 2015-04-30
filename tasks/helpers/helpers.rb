def define_plugin
  File.basename(File.expand_path('.'))
end

def load_specs
  Gem::Specification.load("#{ PROJECT_ROOT }/#{ define_plugin }.gemspec")
end

def deploy_setup
  FileUtils.chdir(PROJECT_ROOT)
  `git checkout master`
  `git fetch origin "+refs/heads/*:refs/remotes/origin/*"`
  `git remote add repo git@github.com:sensu-plugins/#{ define_plugin }.git`
  `git config --global user.email #{ DEPLOY_EMAIL }`
  `git config --global user.name #{ DEPLOY_USER }`
end

# Decode the files in the repo.  This is not done for security purposes, it's
# so I don't have to worry about my keys getting invalidated by github
# upon commit.
#
def decode(file)
  t = '/tmp/t'
  `cat #{ file } | tr '[A-Za-z]' '[N-ZA-Mn-za-m]' > #{ t }`
  t
end
