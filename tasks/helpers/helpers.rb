
#
# define_plugin
#
# acquire the plugin name
#
# @return [String] the plugin name
#
def define_plugin
  File.basename(File.expand_path('.'))
end

#
# load_specs
#
# load the current gem spec for parsing
#
# @return [String] a gemspec object
#
def load_specs
  Gem::Specification.load("#{ PROJECT_ROOT }/#{ define_plugin }.gemspec")
end

#
# deploy_setup
#
# This is needed for codeship as we want to ensure that we commit back
# up to master.
# The user.name and email maps to a Github machine user
#
def deploy_setup
  FileUtils.chdir(PROJECT_ROOT)
  `git checkout master`
  `git fetch origin "+refs/heads/*:refs/remotes/origin/*"`
  `git remote add repo git@github.com:sensu-plugins/#{ define_plugin }.git`
  `git config --global user.email #{ DEPLOY_EMAIL }`
  `git config --global user.name #{ DEPLOY_USER }`
end

#
# decode
#
# Decode the files in the repo.  This is not done for security purposes, it's
# so I don't have to worry about my keys getting invalidated by github
# upon commit.
#
# @param [String] the file to decode
#
# @return [String] the unencoded file
#
def decode(file)
  t = '/tmp/t'
  `cat #{ file } | tr '[A-Za-z]' '[N-ZA-Mn-za-m]' > #{ t }`
  t
end

def test_gem_bin
  bin_list = load_specs.executables

  bin_list.each do |b|
    `which |b|`
    if ! $?.success?
      puts "#{ b } was not a binstub"
      exit
    end
  end
