require 'github/markup'
require 'redcarpet'
require 'yard'
require 'yard/rake/yardoc_task'

namespace :yard do

  desc 'Compile Yardocs'
  task :compile_docs do
    YARD::Rake::YardocTask.new do |t|
      OTHER_PATHS = %w()
      t.files = ['lib/**/*.rb', 'bin/**/*.rb', OTHER_PATHS]
      t.options = %w(--markup-provider=redcarpet --markup=markdown --main=README.md --files CHANGELOG.md,CONTRIBUTING.md)
    end
  end
end
