require "bundler/gem_tasks"

require "rake/extensiontask"
Rake::ExtensionTask.new("native", eval(File.read("brick_pi.gemspec"))) do |ext|
  ext.ext_dir = "ext/brick_pi"
  ext.lib_dir = "lib/brick_pi"
  ext.source_pattern = "*.{c,h}"
end
