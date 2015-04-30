namespace :gem do

  desc 'Create a gem'
  task :create_gem do
    spec = load_specs
    plugin = define_plugin
    `gem build #{ plugin }.gemspec`
  end

  desc 'Push to rubygems'
  task :push_gem do
    spec = load_specs
    plugin = define_plugin
    `gem push #{ spec.full_name }.gem`
  end
end
