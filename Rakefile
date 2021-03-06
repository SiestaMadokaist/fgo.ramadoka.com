#!/usr/bin/env rake
require 'rubygems'
require 'bundler'
Bundler.setup :default, :test, :development, :spec
Bundler.require
# require File.expand_path("../../core/init.rb", __FILE__)
# require 'rspec/core/rake_task'


# RSpec::Core::RakeTask.new(:spec) do |spec|
  # ENV["RACK_ENV"] = "spec"
  # spec.pattern = ENV["SPECS"] || 'spec/**/*spec.rb'
  # spec.rspec_opts = "--format documentation"
# end

task :rails_env do
end

task :environment do
end

task :console do
  require File.expand_path("../application", __FILE__)
  require 'pry'; binding.pry
end

task :airborne, :entity, :prefix do |t, args|
  require File.expand_path("../application", __FILE__)
  include API::Entities
  entity = eval(args[:entity])
  prefix = args[:prefix]
  puts(entity.airborne_expect(prefix))
  puts
  exit!
end

task default:  :spec

require File.expand_path("../environment", __FILE__)
module Rails

  def self.application
    Struct.new(:config, :paths) do
      def load_seed
        require File.expand_path('../application', __FILE__)
        require File.expand_path('../db/seeds', __FILE__)
      end
    end.new(config, paths)
  end

  def self.config
    require 'erb'
    # db_config = YAML.load(ERB.new(File.read("config/database.yml")).result)
    Struct.new(:paths).new(paths)
  end

  def self.paths
    Hash[
      'db/migrate' => ["#{root}/db/migrate"],
      'db' => ["#{root}/db"],
    ]
  end

  def self.env
    env = ENV['RACK_ENV'] || "development"
    ActiveSupport::StringInquirer.new(env)
  end

  def self.root
    File.dirname(__FILE__)
  end

  def self.production?
    env  == "production"
  end

  def self.development?
    env  == "development"
  end
end

namespace :wiki do
  task :material do
    require File.expand_path("../application", __FILE__)
    Material.all.each do |m|
      dir = ENV["DIR"] || raise("Specifiy FGO_MATS_DIR rake wiki:material DIR=../")
      begin
        m.wiki.save!(dir)
      rescue => e
        puts("failed: #{m.name} #{m.wiki_url}")
      else
        puts("done: #{m.name} #{m.wiki_url}")
      end
    end
  end
end
namespace :g do
  desc "Generate migration. Specify name in the NAME variable"
  task :migration => :environment do
    name = ENV['NAME'] || raise("Specify name: rake g:migration NAME=create_users")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration
  def change
  end
end
      EOF
    end

    puts "DONE"
    puts path
  end
end

Rake.load_rakefile "active_record/railties/databases.rake"
# Rake.load_rakefile "../core/rake_tasks/component.rake"
