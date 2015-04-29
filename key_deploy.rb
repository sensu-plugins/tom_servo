#! /usr/bin/env ruby

# Set the paths.
HOMEDIR = Dir.home

require 'fileutils'

# Decode the files in the repo.  This is not done for security purposes, it's
# so I don't have to worry about my keys getting invalidated by github
# upon commit.
#
def decode(file)
  t = '/tmp/t'
  `cat #{ file } | tr '[A-Za-z]' '[N-ZA-Mn-za-m]' > #{ t }`
  t
end

# Drop the necessary keys into the build environment.
# Environment variables are not used due to the design of codeship, each project
# has its own set of variables so a key would need to be added or changed
# in ~160 repos and that's just unpleasent to think about.
FileUtils.mkdir(File.join(HOMEDIR, 'tmp'))
FileUtils.chdir(File.join(HOMEDIR, 'tmp'))
`git clone --depth 1 git@github.com:sensu-plugins/hack_the_gibson.git`
FileUtils.chdir('hack_the_gibson')

file_list = ["#{ FileUtils.pwd }/keys/credentials #{ HOMEDIR }/.gem/credentials",
             "#{ FileUtils.pwd }/keys/gem-private_key.pem #{ HOMEDIR }/.ssh/gem-priv
ate_key.pem",
             "#{ FileUtils.pwd }/keys/git_token #{ HOMEDIR }/.ssh/git_token"]

file_list.each do |f|
  FileUtils.mv(decode(f.split[0]), f.split[1])
  FileUtils.chmod(0600, f.split[1])
end
