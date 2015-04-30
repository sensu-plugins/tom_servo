require 'fileutils'

# Load our rake configuration
require File.expand_path('config/rake')

# Load our helper files
Dir[File.join(File.dirname(__FILE__), 'tasks', 'helpers', '*.rb')].sort.each do |h|
  require h
end

# Load our tasks
Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')].sort.each do |t|
  load t
end
