require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

task :default do 
  sh "rspec"
end

task :cane do
  sh "cane --style-glob 'lib/**/*.rb'" rescue nil
end

task :reek do
  sh "reek . 2>&1 | grep '(LongMethod)'" rescue nil
end

task :style => [:cane, :reek]

task :gem do
  sh "gem build sales_engine.gemspec"
end

task :harness => :gem do
  harness_path = File.expand_path("../../sales_engine_spec_harness", __FILE__)

  unless File.exist?(harness_path)
    sh "git clone https://github.com/JumpstartLab/sales_engine_spec_harness.git '#{harness_path}'"
  end

  Dir.chdir(harness_path) do
    sh "git pull"
    sh "bundle exec rspec"
  end
end

task :harness_extensions => :gem do
  harness_path = File.expand_path("../../sales_engine_spec_harness", __FILE__)

  unless File.exist?(harness_path)
    sh "git clone https://github.com/JumpstartLab/sales_engine_spec_harness.git '#{harness_path}'"
  end

  Dir.chdir(harness_path) do
    sh "git pull"
    sh "bundle exec rspec:extensions"
  end
end
