require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :environment do
  require File.join(File.dirname(__FILE__),'config','environment')
end
