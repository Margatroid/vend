# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ['lib']
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/*.rb']
end

task :start do
  lib = File.expand_path('./lib', __dir__)
  $LOAD_PATH.unshift(lib)

  require 'prompt'
  prompt = Prompt.new
  prompt.start
end

task default: :test
