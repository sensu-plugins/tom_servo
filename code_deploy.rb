#! /usr/bin/env ruby

# Set the paths.
HOMEDIR = Dir.home
Dir.chdir("#{ HOMEDIR }/clone")
plugin = File.basename(File.expand_path('.'))
spec = Gem::Specification.load("#{ plugin }.gemspec")
lib = File.expand_path(File.join(Dir.home, 'lib'))
version_file = "#{ lib }/#{ plugin }/version.rb"

# Load what we need
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "#{ HOMEDIR }/clone/lib/#{ plugin }"
require 'fileutils'

#
# Build a gem and deploy it to rubygems
#
def deploy_rubygems(spec, plugin)
  `gem build #{ plugin }.gemspec`
  `gem push #{ spec.full_name }.gem`
end

#
# Create Github tag and release
#
def create_github_release(spec, plugin, github_token)
  `curl -H "Authorization: token #{ github_token }" -d '{ "tag_name": "#{ spec.version }", "target_commitish": "#{ ENV['CI_COMMIT_ID'] }", "name": "#{ spec.version }", "body": "#{ ENV['CI_MESSAGE'] }", "draft": "#{ spec.metadata['release_draft']}", "prerelease": "#{ spec.metadata['release_prerelease']}" }' https://api.github.com/repos/#{ github_org }/#{ plugin }/releases` # rubocop:disable all
end

#
# Bump the patch version of the plugin
#
def version_bump(version_file)
  # Read the file, bump the PATCH version
  contents = File.read(version_file).gsub(/(PATCH = )(\d+)/) { |_| Regexp.last_match[1] + (Regexp.last_match[2].to_i + 1).to_s }

  # Write the new contents of the file
  File.open(version_file, 'w') { |file| file.puts contents }
end

# create a github commit for the version bump
# the skip-ci flag is specific to codeship to prevent this from being run as a test
# Travis-CI will still run it though to be on the safe side
#
def create_github_commit(plugin)
  `git add lib/#{ plugin }/version.rb`
  `git commit -m 'version bump --skip-ci'`
  `git push repo master`
end

# Drop the needed keys and certs
`ruby key_deploy.rb`

# This is needed for codeship as we want to ensure that we commit back
# up to master.
# The user.name maps to a Github machine user and the email is not necessary
FileUtils.chdir(File.join(HOMEDIR, 'clone'))
`git checkout master`
`git fetch origin "+refs/heads/*:refs/remotes/origin/*"`
`git remote add repo git@github.com:sensu-plugins/#{ plugin }.git`
`git config --global user.email 'sensu-plugin@sensu-plugins.io'`
`git config --global user.name 'sensu-plugin'`

if ENV['CI_MESSAGE'] == 'deploy'
  version_bump(version_file)
  create_github_commit(plugin)
  deploy_rubygems(spec, plugin)
  create_github_release(spec, plugin, github_token)
end
