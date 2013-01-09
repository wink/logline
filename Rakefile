#!/usr/bin/env rake
require 'bundler'
require 'rake'
require 'spec/rake/spectask'

Bundler::GemHelper.install_tasks

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

