namespace :version do
  desc 'bump the patch level of a plugin'
  task :bump_patch do
    plugin = define_plugin
    version_file = "lib/#{plugin}/version.rb"

    # Read the file, bump the PATCH version
    contents = File.read(version_file).gsub(/(PATCH = )(\d+)/) { |_| Regexp.last_match[1] + (Regexp.last_match[2].to_i + 1).to_s }

    # Write the new contents of the file
    File.open(version_file, 'w') { |file| file.puts contents }
    Rake::Task['github:create_github_commit'].invoke
  end
end
