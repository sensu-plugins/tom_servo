#! /usr/bin/env ruby

# Set the paths.
HOMEDIR = Dir.home
Dir.chdir("#{ HOMEDIR }/clone")

plugin = File.basename(File.expand_path('.'))
lib = File.expand_path(File.join(Dir.home, 'clone/lib'))
version_file = "#{ lib }/#{ plugin }.rb"
github_token = File.read('/home/rof/.ssh/git_token')

# Load what we need
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "#{ HOMEDIR }/clone/lib/#{ plugin }"
require 'fileutils'

#
# Build a gem and deploy it to rubygems
#
def deploy_rubygems(spec, plugin)
  puts " this is the version string #{ SensuPluginsApache::Version::VER_STRING }"
  puts " this is the version string #{ `cat /home/rof/clone/lib/sensu-plugins-apache.rb` }"
  puts "this is the deploy gem stuff"
  puts `rm *.gem`
  puts `gem build #{ plugin }.gemspec`
  puts "this is the ls inside the gem loop"
  puts `ls`
  puts `gem push #{ spec.full_name }.gem`
end

#
# Create Github tag and release
#
def create_github_release(spec, plugin, github_token)
  puts " this is the git log"
  puts `curl -H "Authorization: token #{ github_token }" -d '{ "tag_name": "#{ spec.version }", "target_commitish": "#{ ENV['CI_COMMIT_ID'] }", "name": "#{ spec.version }", "body": "#{ ENV['CI_MESSAGE'] }", "draft": "#{ spec.metadata['release_draft']}", "prerelease": "#{ spec.metadata['release_prerelease']}" }' https://api.github.com/repos/sensu-plugins/#{ plugin }/releases` # rubocop:disable all
end

#
# Bump the patch version of the plugin
#
# def version_bump(version_file)
#     Dir.chdir(acquire_chdir_path)
#     text = File.read("lib/#{@gem_root}.rb")
#     File.write("lib/#{@gem_root}.rb", text.gsub(/\d+\.\d+\.\d+/, new_version(text, bump)))
#
# end

def version_bump(version_file)
  bump = 'patch'
  ver = File.read(version_file).match(/\d+\.\d+\.\d+/).to_s.split('.')
  major = ver[0].to_i
  minor = ver[1].to_i
  patch = ver[2].to_i
  case bump
  when 'patch'
    patch += 1
  when 'minor'
    minor += 1
  when 'major'
    major += 1
  end
  major.minor.patch
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
  spec = Gem::Specification.load("#{ plugin }.gemspec")
  puts " this is the full name of the gem #{ spec.full_name }"
  puts " this is the file name of the gem #{ spec.file_name }"
  puts " this is the spec name of the gem #{ spec.spec_name }"
  puts "this is the version #{ spec.version }"
  puts `ls`
  deploy_rubygems(spec, plugin)
  create_github_release(spec, plugin, github_token)
end
