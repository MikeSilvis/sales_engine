# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Charles Strahan", "Mike Silvis"]
  s.email       = ["charles.strahan@hungrymachine.com", "mike.silvis@hungrymachine.com"]
  s.homepage    = "http://tutorials.jumpstartlab.com/projects/sales_engine.html"
  s.summary     = "SalesEngine - A project for practicing TDD."
  s.description = "Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably"

  s.required_rubygems_version = ">= 1.3.6"
  s.required_ruby_version = '~> 1.9.2'

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{bin,lib}/**/*")
  s.require_path = 'lib'
end
